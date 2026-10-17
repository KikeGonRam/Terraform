$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI no está disponible.' }
if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) { throw 'Terraform no está disponible.' }
$account = az account show --output json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or -not $account.id) { throw 'Inicia sesión con az login.' }
$admin = az ad signed-in-user show --output json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0 -or -not $admin.id) { throw 'No fue posible consultar el administrador Entra.' }
$publicKeyPath = Join-Path $PSScriptRoot '.local\worker_rsa.pub'
if (-not (Test-Path -LiteralPath $publicKeyPath)) {
    throw 'Falta .local\worker_rsa.pub. Genera un par RSA para la práctica y guarda la clave privada en .local\worker_rsa.'
}
$env:TF_VAR_subscription_id = $account.id
$env:TF_VAR_entra_admin_object_id = $admin.id
$env:TF_VAR_entra_admin_name = $admin.userPrincipalName
$env:TF_VAR_ssh_public_key = Get-Content -LiteralPath $publicKeyPath -Raw
Write-Host "Entorno preparado para la suscripción $($account.name)."
Write-Host 'La clave privada permanece en .local\worker_rsa; no la subas a Git.'
Write-Host 'Siguiente paso: terraform plan -out=".local/practica3.tfplan"'
