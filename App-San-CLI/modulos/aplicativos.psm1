function InstalarAplicativos {
   # Write-Host "`n[📦] Função de instalação de aplicativos em construção..." -ForegroundColor Yellow
   
   # ===============================================
   # 🌮 Instalação de Aplicativos com Chocolatey
   # ===============================================
   
   # Instalar Chocolatey
   
   Write-Host "Verificando instalação do WinGet..." -ForegroundColor Cyan
        if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget --version
        Write-Host "winget instalado com sucesso!" -ForegroundColor Green
        
        $applications = @(
             @{ Name="Firefox"; Command="winget install --silent Mozilla.Firefox" },
             @{ Name="Chrome"; Command="winget install --silent Google.Chrome" },
             @{ Name="7-Zip"; Command="winget install --silent 7zip.7zip" },
             @{ Name="AnyDesk"; Command="winget install --silent AnyDesk.AnyDesk" }
             @{ Name="WinRar"; Command="winget install --silent RARLab.WinRAR" }
             @{ Name="AdobeReader"; Command="winget install --silent Adobe.Acrobat.Reader.64-bit" }
             @{ Name="Okular"; Command="winget install --silent KDE.Okular" }
             @{ Name="SumatraPDF"; Command="winget install --silent SumatraPDF.SumatraPDF" }
         )
     
         foreach ($app in $applications) {
             #$resposta = Read-Host "Deseja instalar $($app.Name)? (S/N)"
             #if ($resposta -eq "s") {
                 Write-Host "Instalando $($app.Name)..." -ForegroundColor Cyan
                 try {
                     Invoke-Expression $app.Command
                     Write-Host "$($app.Name) instalado com sucesso!" -ForegroundColor Green
                 } catch {
                     Write-Host "Falha ao instalar $($app.Name): $_" -ForegroundColor Red
                 }
             } 
             #else {
              #   Write-Host "Instalação de $($app.Name) ignorada." -ForegroundColor Yellow
            #}   
         #}

         Write-Host "Atualizando todos os pacotes disponiveis..."
         winget upgrade --all

        } else {
        Write-Host "Falha na instalação do Choco." -ForegroundColor Red
        Write-Host "Cancelado a instalação do aplicativos por falta do choco." -ForegroundColor Red
    }



}

Export-ModuleMember -Function *