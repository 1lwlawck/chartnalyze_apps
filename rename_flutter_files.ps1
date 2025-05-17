$oldName = "success_verification_email_view.dart"
$newName = "email_verification_success_view.dart"

# Rename file
Get-ChildItem -Recurse -Filter $oldName | Rename-Item -NewName $newName

# Update import references
Get-ChildItem -Recurse -Include *.dart | ForEach-Object {
  (Get-Content $_.FullName) -replace $oldName, $newName | Set-Content $_.FullName
}

Write-Host "✅ Renamed $oldName → $newName and updated imports"
