Import-Module ".\modulos\usuarios.psm1"

function PadronizarSO {
    # Define caminho completo da imagem
    $WallpaperPath = Join-Path -Path $PSScriptRoot -ChildPath "\files\logo-sanemar.png"


# Verifica se o arquivo existe antes de prosseguir
if (-not (Test-Path $WallpaperPath)) {
    Write-Host "[ERRO] Arquivo não encontrado: $WallpaperPath" -ForegroundColor Red
    exit
}

try {
    # Aplica propriedades no Registro
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $WallpaperPath -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "10" -ErrorAction Stop
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value "0" -ErrorAction Stop

    # Carrega função nativa do Windows para aplicação imediata
    Add-Type @"
    using System.Runtime.InteropServices;

        public class Wallpaper {
            [DllImport("user32.dll", SetLastError = true)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        }
"@

    # Executa a aplicação imediata
    $result = [Wallpaper]::SystemParametersInfo(20, 0, $WallpaperPath, 3)

    if ($result) {
        Write-Host "[SUCESSO] Papel de parede aplicado com êxito." -ForegroundColor Green
    }
    else {
        throw "Falha ao aplicar o papel de parede através da API do Windows."
    }
}
catch {
    Write-Host "[ERRO] Um problema ocorreu: $_" -ForegroundColor Red
}

    #------------------------------------------------------------------------------------------------------

    Write-Host "Configurando Suporte de TI Sanemar..." -ForegroundColor White


    # Caminho do site desejado
    $Url = "http://sanemar-fts.vercel.app/support"

    # Caminho do Chrome
    $ChromePath = "${Env:ProgramFiles}\Google\Chrome\Application\chrome.exe"

    # Caminho do atalho na área de trabalho
    $ShortcutPath = "$([Environment]::GetFolderPath('Desktop'))\Sanemar Suporte.lnk"

    try {
        # Verifica se o Chrome está instalado
        if (-Not (Test-Path $ChromePath)) {
            throw "Google Chrome não encontrado em $ChromePath."
        }

        # Cria o objeto Shell
        $Shell = New-Object -ComObject WScript.Shell
        $Shortcut = $Shell.CreateShortcut($ShortcutPath)

        # Configurações do atalho
        $Shortcut.TargetPath = $ChromePath
        $Shortcut.Arguments = $Url
        $Shortcut.IconLocation = $ChromePath
        $Shortcut.Save()

        Write-Host "[SUCESSO] Ícone criado com sucesso na Área de Trabalho." -ForegroundColor Green
    }
    catch {
        Write-Host "[ERRO] Não foi possível criar o ícone: $_" -ForegroundColor Red
    }

    GerenciarUsuarios

}

Export-ModuleMember -Function *