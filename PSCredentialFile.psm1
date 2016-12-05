<#
  .SYNOPSIS
    Save credentials in a file.

  .DESCRIPTION
    The New-PSCredentialFile saves the given credentials in a file.

    It uses the Windows Data Protection API (DPAPI) to encrypt the standard string representation of the password.

  .EXAMPLE
    New-PSCredentialFile -Path .\cred.xml

  .EXAMPLE
    $cred = New-PSCredentialFile -Path .\cred.xml -PassThru
#>
function New-PSCredentialFile
{
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCredential])]
  Param
  (
    # The credentials file (will be overwritten)
    [Parameter(Mandatory=$true)]
    [String]
    $Path
    ,
    # The credentials
    [Parameter(Mandatory=$true)]
    [pscredential]
    $Credentials
    ,
    # Return the given credentials as System.Management.Automation.PSCredential object.
    [Switch]
    $PassThru
  )
  $ErrorActionPreference = 'Stop'
  try
  {
    $Credentials | Export-Clixml -Path $Path -Force
    if ($PassThru -and (Test-Path -Path $Path))
    {
      $Credentials
    }
  }
  catch
  {
    $_.Exception.Message | Write-Error
  }
}

<#
  .SYNOPSIS
    Read credentials from file.

  .DESCRIPTION
    The Import-PSCredentialFile reads credentials from a file that was created with New-PSCredentialFile.

    It converts the username and the encrypted standard string representation of the password to a System.Management.Automation.PSCredential object.

  .EXAMPLE
    $cred = Import-PSCredentialFile -Path .\cred.xml
#>
function Import-PSCredentialFile
{
  [CmdletBinding()]
  [OutputType([System.Management.Automation.PSCredential])]
  Param
  (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [String]
    $Path
  )
  $ErrorActionPreference = 'Stop'
  try
  {
    [pscredential](Import-Clixml -Path $Path)
  }
  catch
  {
    $_.Exception.Message | Write-Error
  }
}
