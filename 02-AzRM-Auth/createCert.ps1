$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\LocalMachine\My -Subject "CN=terraform" -KeySpec KeyExchange
$pwd = ConvertTo-SecureString -String 'P0wer$hell' -Force -AsPlainText

$path = 'Cert:\LocalMachine\My\' + $cert.thumbprint
Export-PfxCertificate -Cert $path -FilePath C:\certs\cert.pfx -Password $pwd

Export-Certificate -FilePath C:\certs\cert.cer -Cert $path -Type CERT

az ad sp create-for-rbac --name terrafrom4mCli --cert @C:/certs/cert.cer