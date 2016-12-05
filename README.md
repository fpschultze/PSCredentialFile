[![Build status](https://ci.appveyor.com/api/projects/status/f3cl7slwdhpv573q?svg=true)](https://ci.appveyor.com/project/fpschultze/pscredentialfile)

# PSCredentialFile PowerShell Module
Save credentials in and read credentials from a file, securely.

It uses the Windows Data Protection API (DPAPI) to encrypt the standard string representation of the password.

Actually, the module simplifies saving/restoring credentials with Export-CliXml and Import-CliXml