# Importar Módulos
Import-Module ".\modulos\usuarios.psm1"
Import-Module ".\modulos\impressoras.psm1"
Import-Module ".\modulos\aplicativos.psm1"
Import-Module ".\modulos\relatorios.psm1"
Import-Module ".\modulos\default.psm1"

# ===============================================
# 🛠️ Menu Interativo CLI - PowerShell
# ===============================================
#if ((Get-ExecutionPolicy -Scope Process) -ne "Bypass") {
#    Set-ExecutionPolicy Bypass -Scope Process -Force
#}


# Forçar codificação UTF-8
# Define a codificação UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001


# Ativar logs do script com UTF-8
try {
    Start-Transcript -Path "$env:USERPROFILE\Desktop\log_windows10.txt" -Append -NoClobber
    Write-Host "Log Ativado on $env:USERPROFILE\Desktop\log_execution_script_windows10.txt"
} catch {
    Write-Host "Falha ao iniciar log de transcript: $_" -ForegroundColor Red
}

Clear-Host

$host.UI.RawUI.WindowTitle = "🧩 Menu de San-CLI - Awake Studio"
$continue = $true

# Menu Principal
function ShowMenu {
 
    Clear-Host

    # Obtém a largura da janela do PowerShell
    $larguraJanela = $Host.UI.RawUI.WindowSize.Width

    # Cria o menu como array para facilitar o alinhamento
    $menu = @(
        "=====================================================================================",
        "% MENU DE OPERAÇÕES %",
        "=====================================================================================",

        "[1] Gerenciar usuários padrões (user / sanemar)",
        "[2] Inativar usuários",
        "[3] Criar novo usuário",
        "[4] Instalar aplicativos",
        "[5] Gerenciar Impressoras",
        "[6] Gerar relatório de sistema",
        "[7] Padronizar Sistema",
        "[0] Sair",

        "=====================================================================================",
        "====================================================================================="
    )

    foreach ($linha in $menu) {
        # Calcula o espaço necessário para centralizar
        $espacos = [Math]::Floor(($larguraJanela - $linha.Length) / 2)
        
        # Exibe a linha centralizada com cores
        switch ($linha) {
            {$_ -match 'MENU DE OPERAÇÕES'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Cyan
                continue
            }
            {$_ -match 'Gerenciar usuários padrões'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Green
                continue
            }
            {$_ -match 'Inativar usuários'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Yellow
                continue
            }
            {$_ -match 'Criar novo usuário'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Magenta
                continue
            }
            {$_ -match 'Instalar aplicativos'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Blue
                continue
            }
            {$_ -match 'Gerenciar Impressoras'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor DarkYellow
                continue
            }
            {$_ -match 'Gerar relatório de sistema'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor DarkCyan
                continue
            }
            {$_ -match 'Padronizar Sistema'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor White
                continue
            }
            {$_ -match 'Sair'} {
                Write-Host (" " * $espacos) $linha -ForegroundColor Red
                continue
            }
            default {
                Write-Host (" " * $espacos) $linha -ForegroundColor Cyan
            }
        }
    }

}
    
    do {
        ShowMenu
        $opcao = Read-Host "Escolha uma opção (0-6)"
        
        switch ($opcao) {
            "1" { GerenciarUsuarios }
            "2" { InativarUsuarios }
            "3" { CriarUsuario }
            "4" { InstalarAplicativos }
            "5" { GerenciarImpressoras }
            "6" { GerarRelatorio }
            "7" { PadronizarSO }
        "0" { Write-Host "`nSaindo... Obrigado por utilizar o script!" -ForegroundColor Green; $continue = $false }
        default { Write-Host "Opção inválida. Por favor, selecione uma opção entre 0 e 6." -ForegroundColor Red }
    }
    
    if ($continue) {
        Write-Host "`nPressione Enter para continuar..."
        [void][System.Console]::ReadLine()
        Clear-Host
    }
    
} while ($continue)