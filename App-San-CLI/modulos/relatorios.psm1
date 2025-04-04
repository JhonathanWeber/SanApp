function GerarRelatorio {
      # Write-Host "`n[📊] Função de geração de relatório em construção..." -ForegroundColor Yellow
        
    # 🔄 8. Atualização da lista de usuários
    Write-Host "Usuários configurados com sucesso!"
    Start-Sleep -Seconds 2
    Get-LocalUser | Format-Table -AutoSize | Out-File -FilePath "$env:USERPROFILE\Desktop\usuarios.txt" -Encoding utf8

    # Finaliza logs
    Stop-Transcript
}



Export-ModuleMember -Function *