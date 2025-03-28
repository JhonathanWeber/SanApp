function GerenciarImpressoras {
    function MenuImpressoras {
        Clear-Host

    $larguraJanela = $Host.UI.RawUI.WindowSize.Width

    $menuImpressoras = @(
        "====================================",
        "# GERENCIAR IMPRESSORAS #",
        "====================================",
        "[1] Listar impressoras instaladas",
        "[2] Remover impressora instalada",
        "[3] Instalar impressora da rede",
        "[0] Voltar ao menu principal",
        "===================================="
    )

    foreach ($linha in $menuImpressoras) {
        $espacos = [Math]::Floor(($larguraJanela - $linha.Length) / 2)

        switch ($linha) {
            {$_ -match "GERENCIAR IMPRESSORAS"} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Cyan
                continue
            }
            {$_ -match "\[1\]"} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Green
                continue
            }
            {$_ -match "\[2\]"} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Red
                continue
            }
            {$_ -match "\[3\]"} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Blue
                continue
            }
            {$_ -match "\[0\]"} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Magenta
                continue
            }
            default {
                Write-Host (" " * $espacos) $linha -ForegroundColor Cyan
            }
        }
    }

    }
    
    # Listar impressoras locais
    function ListarImpressoras {
        Write-Host "`nImpressoras instaladas:" -ForegroundColor Green
        $printers = Get-Printer
        $i = 1
        foreach ($printer in $printers) {
            Write-Host "$i. $($printer.Name) | Porta: $($printer.PortName) | Status: $($printer.PrinterStatus)"
            $i++
        }
        return $printers
    }
    
    # Remover impressora local
    function RemoverImpressora {
        $printers = ListarImpressoras
        $escolha = Read-Host "`nDigite o número da impressora que deseja REMOVER"
        
        if ([int]$escolha -le $printers.Count -and [int]$escolha -gt 0) {
            $printerSelecionada = $printers[$escolha - 1]
            Write-Host "`nRemovendo impressora: $($printerSelecionada.Name)" -ForegroundColor Yellow
            try {
                Remove-Printer -Name $printerSelecionada.Name -Confirm:$false
                Write-Host "Impressora '$($printerSelecionada.Name)' removida com sucesso!" -ForegroundColor Green
            } catch {
                Write-Host "Erro ao remover impressora: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "Opção inválida!" -ForegroundColor Red
        }
    }
    
    # Instalar impressora de rede
    function InstalarImpressoraRede {
            
            # Coletar informações iniciais do usuário
            $ipImpressora = Read-Host "Digite o IP da impressora"
            $nomeImpressora = Read-Host "Digite o nome que deseja dar à impressora (ex.: HP Recepção)"
        
            # Checar se a porta já existe
            if (-not (Get-PrinterPort -Name "IP_$ipImpressora" -ErrorAction SilentlyContinue)) {
                Write-Host "🔸 Criando porta IP para impressora $ipImpressora..." -ForegroundColor Cyan
                Add-PrinterPort -Name "IP_$ipImpressora" -PrinterHostAddress "$ipImpressora"
            } else {
                Write-Host "✅ Porta IP já existe." -ForegroundColor Green
            }
        
            # Verificar se o driver já está instalado
            $driverImpressora = Read-Host "Digite o nome EXATO do driver da impressora (Ex: 'HP Universal Printing PCL 6')"
            $driverInstalado = Get-PrinterDriver | Where-Object { $_.Name -eq $driverImpressora }
        
            if (-not $driverInstalado) {
                Write-Host "⚠️ Driver não encontrado! Vamos instalar agora." -ForegroundColor Yellow
                $caminhoDriver = Read-Host "Informe o caminho completo do arquivo .inf do driver (ex.: E:\Drivers\hp_universal.inf)"
        
                try {
                    Write-Host "📂 Instalando driver..." -ForegroundColor Cyan
                    pnputil.exe /add-driver $caminhoDriver /install
                    Write-Host "✅ Driver instalado com sucesso!" -ForegroundColor Green
                } catch {
                    Write-Host "❌ Erro na instalação do driver: $_" -ForegroundColor Red
                    return
                }
            } else {
                Write-Host "✅ Driver já instalado no sistema." -ForegroundColor Green
            }
        
            # Adicionar a impressora
            try {
                Add-Printer -Name "$nomeImpressora" -DriverName "$driverImpressora" -PortName "IP_$ipImpressora"
                Write-Host "✅ Impressora '$nomeImpressora' instalada com sucesso!" -ForegroundColor Green
            } catch {
                Write-Host "❌ Falha ao instalar impressora: $_" -ForegroundColor Red
            }
    }
    
    # Loop Principal Menu Impressoras
    do {
        MenuImpressoras
        $opcao = Read-Host "`nEscolha uma opção (0-3)"
    
        switch ($opcao) {
            "1" { ListarImpressoras; pause }
            "2" { RemoverImpressora; pause }
            "3" { InstalarImpressoraRede; pause }
            "0" { Write-Host "`nVoltando ao menu principal..." -ForegroundColor Magenta }
            Default { Write-Host "`nOpção inválida! Tente novamente." -ForegroundColor Red; pause }
        }
    } while ($opcao -ne "0")
}

Export-ModuleMember -Function *