$ModuleRoot = Split-Path -Parent $PSScriptRoot
$ModuleFile = (Split-Path -Leaf $PSCommandPath) -replace '\.tests\.ps1$', '.psm1'
Import-Module "$ModuleRoot\$ModuleFile"

Describe 'PSCredentialFile Module' {

  $TestCred = New-Object pscredential 'foo\bar', (ConvertTo-SecureString 'foO!b4r' -AsPlainText -Force)
  $TestFile = 'TESTDRIVE:\cred.xml'

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

    New-PSCredentialFile -Path $TestFile -Credentials $TestCred

    It 'returns pscredential object' {
      Import-PSCredentialFile -Path $TestFile | Should BeOfType pscredential
    }
  }
}
