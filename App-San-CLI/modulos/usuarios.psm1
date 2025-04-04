function GerenciarUsuarios {
     # Write-Host "`n[🔧] Função de gerenciamento de usuários em construção..." -ForegroundColor Yellow
    # ===============================================
    # 🔄 Verificar e ajustar usuários 'user' e 'sanemar'
    # ===============================================

    Write-Host "Iniciando processo de verificação e ajustes nos usuários..." -ForegroundColor Cyan

    # Remover usuários com nomes fora do padrão
    $usuariosParaRenomear = @("User", "Sanemar", "USER", "SANEMAR")

    foreach ($usuario in $usuariosParaRenomear) {
        # Verifica se o usuário existe com o nome atual
        $usuarioEncontrado = Get-LocalUser -Name $usuario -ErrorAction SilentlyContinue

        if ($usuarioEncontrado) {
            # Define novo nome totalmente em minúsculas
            $novoNome = $usuario.ToLower()

            # Verifica se o novo nome já existe para evitar conflitos
            $usuarioJaExiste = Get-LocalUser -Name $novoNome -ErrorAction SilentlyContinue
            if ($usuarioJaExiste) {
                Write-Host "Não é possível renomear '$usuario' para '$novoNome' pois o usuário '$novoNome' já existe." -ForegroundColor Red
                continue
            }

            Write-Host "Renomeando usuário '$usuario' para '$novoNome'..." -ForegroundColor Cyan

            try {
                Rename-LocalUser -Name $usuario -NewName $novoNome -ErrorAction Stop
                Write-Host "Usuário '$usuario' renomeado com sucesso para '$novoNome'." -ForegroundColor Green
            }
            catch {
                Write-Host "Falha ao renomear usuário '$usuario': $_" -ForegroundColor Red
            }
        } else {
            Write-Host "Usuário '$usuario' não encontrado." -ForegroundColor Yellow
        }
    }


    # Usuário 'user' - remover senha caso exista
    $userExiste = Get-LocalUser -Name "user" -ErrorAction SilentlyContinue
    if ($userExiste) {
        Write-Host "Usuário 'user' existe, removendo senha..." -ForegroundColor Yellow
        try {
            Set-LocalUser -Name "user" -Password (ConvertTo-SecureString "" -AsPlainText -Force) -ErrorAction Stop
            Write-Host "Senha removida do usuário 'user'." -ForegroundColor Green
        } catch {
            Write-Host "Falha ao remover senha do usuário 'user': $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Usuário 'user' não encontrado, criando usuário sem senha..." -ForegroundColor Cyan
        try {
            New-LocalUser -Name "user" -NoPassword -FullName "user" -Description "Usuário padrão sem senha" -ErrorAction Stop
            Write-Host "Usuário 'user' criado com sucesso." -ForegroundColor Green
        } catch {
            Write-Host "Falha ao criar usuário 'user': $_" -ForegroundColor Red
        }
    }


    # Usuário 'sanemar' - aplicar senha se existir, caso contrário criar usuário
    $senhaSanemar = ConvertTo-SecureString "Sanemar@ti@" -AsPlainText -Force
    $sanemarExiste = Get-LocalUser -Name "sanemar" -ErrorAction SilentlyContinue
    if ($sanemarExiste) {
        Write-Host "Usuário 'sanemar' existe, aplicando senha..." -ForegroundColor Yellow
        try {
            Set-LocalUser -Name "sanemar" -Password $senhaSanemar -ErrorAction Stop
            Write-Host "Senha aplicada com sucesso no usuário 'sanemar'." -ForegroundColor Green
        } catch {
            Write-Host "Falha ao aplicar senha no usuário 'sanemar': $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Usuário 'sanemar' não encontrado, criando usuário com senha..." -ForegroundColor Cyan
        try {
            New-LocalUser -Name "sanemar" -Password $senhaSanemar -FullName "sanemar" -Description "Usuário administrador com senha padrão" -PasswordNeverExpires:$true -ErrorAction Stop
            Write-Host "Usuário 'sanemar' criado com sucesso." -ForegroundColor Green
        } catch {
            Write-Host "Falha ao criar usuário 'sanemar': $_" -ForegroundColor Red
        }
    }

     # ===============================================
    # 🏗️ Adicionar usuários ao grupo Administradores
    # ===============================================

    $grupoAdministradores = "Administradores"
    $usuariosParaAdicionar = @("user", "sanemar")

    Write-Host "Adicionando usuários ao grupo '$grupoAdministradores'..." -ForegroundColor Cyan

    foreach ($usuario in $usuariosParaAdicionar) {
        try {
            Add-LocalGroupMember -Group $grupoAdministradores -Member $usuario -ErrorAction Stop
            Write-Host "Usuário '$usuario' adicionado ao grupo '$grupoAdministradores'." -ForegroundColor Green
        }
        catch {
            Write-Host "Falha ao adicionar usuário '$usuario' ao grupo '$grupoAdministradores': $_" -ForegroundColor Red
        }
    }
}




function CriarUsuario {
    # ===============================================
    # ➕ Criar novo usuário (Opcional)
    # ===============================================

    $novoUsuario = Read-Host "Deseja criar um novo usuário? (S/N)"
    if ($novoUsuario -eq "s") {
        $nomeCompleto = Read-Host "Digite o nome completo do novo usuário"
        $nomeUsuario = $nomeCompleto.ToLower() -replace "\s", ""
        Write-Host "$nomeUsuario"
        Write-Host "$nomeCompleto"
        try {
        New-LocalUser -Name $nomeUsuario -NoPassword -FullName $nomeCompleto -Description "Usuário criado via script"

            Write-Host "Usuário '$nomeCompleto' criado com sucesso!" -ForegroundColor Green
            
            # Alterar nome e descrição do computador
            $novoNomePC = "SAN-$nomeUsuario"
            if ((hostname) -ne $novoNomePC) {
                Rename-Computer -NewName $novoNomePC -Force
                Set-ItemProperty -Path "HKLM:\\SYSTEM\\CurrentControlSet\\services\\LanmanServer\\Parameters" -Name "srvcomment" -Value "SAN-$nomeUsuario"
            }
        } catch {
            Write-Host "Falha ao criar usuário '$nomeCompleto' ou alterar configurações do computador: $_" -ForegroundColor Red
        }
}
}

function InativarUsuarios {
    # Write-Host "`n[⚙️] Função de otimização do sistema em construção..." -ForegroundColor Yellow
   
    # ===============================================
    # ❓ Pergunta sobre inativação de usuários ativos
    # ===============================================

    $resposta = Read-Host "Deseja inativar todos os usuários ativos exceto 'user' e 'sanemar'? (S/N)"

    if ($resposta -eq "s") {
        $usuariosAtivos = Get-LocalUser | Where-Object { $_.Enabled -eq $true -and $_.Name -notin @("user", "sanemar") }
        foreach ($usuario in $usuariosAtivos) {
            Write-Host "Inativando usuário ativo: $($usuario.Name)" -ForegroundColor Yellow
            try {
                Disable-LocalUser -Name $usuario.Name -ErrorAction Stop
                Write-Host "Usuário inativado: $($usuario.Name)" -ForegroundColor Green
            } catch {
                Write-Host "Falha ao inativar usuário '$($usuario.Name)': $_" -ForegroundColor Red
            }
        }
        Write-Host "Usuários ativos foram inativados com sucesso." -ForegroundColor Cyan
    } else {
        Write-Host "Nenhuma alteração feita nos usuários ativos." -ForegroundColor Cyan
    }
}

Export-ModuleMember -Function *