$ModuleRoot = Split-Path -Parent $PSScriptRoot
$ModuleFile = (Split-Path -Leaf $PSCommandPath) -replace '\.tests\.ps1$', '.psm1'
Import-Module "$ModuleRoot\$ModuleFile"

$TestFile = [System.IO.Path]::GetTempFileName()
$TestCred = New-Object pscredential 'pestertester', (ConvertTo-SecureString 'TopSecret' -AsPlainText -Force)
if (Test-Path -Path $TestFile) {Remove-Item -Path $TestFile}

Describe 'PSCredentialFile Module' {

  Context 'Running New-PSCredentialFile without PassThru switch' {
    It 'creates credential file' {
      New-PSCredentialFile -Path $TestFile -Credentials $TestCred | Should BeNullOrEmpty
      $TestFile | Should Exist
    }
  }
  Context 'Running New-PSCredentialFile with PassThru switch' {
    It 'additionally returns credential object' {
      New-PSCredentialFile -Path $TestFile -Credentials $TestCred -PassThru | Should Be $TestCred
    }
  }
  Context 'Running Import-PSCredentialFile' {
    It 'returns credential object' {
      $ImportedCred = Import-PSCredentialFile -Path $TestFile
      $ImportedCred.UserName | Should Be $TestCred.UserName
      $ImportedCred.GetNetworkCredential().Password | Should Be $TestCred.GetNetworkCredential().Password
    }
  }
}
