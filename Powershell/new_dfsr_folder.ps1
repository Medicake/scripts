New-DfsReplicatedFolder -FolderName $FolderName -GroupName $GroupName -Description $FolderName -DomainName $DomainName
   Set-DfsrMembership -ComputerName $PriServer -FolderName $FolderName -GroupName $GroupName -ContentPath $ContentPath -Primary $True -Force
   Set-DfsrMembership -ComputerName $SecServer -FolderName $FolderName -GroupName $GroupName -ContentPath $ContentPath -Force