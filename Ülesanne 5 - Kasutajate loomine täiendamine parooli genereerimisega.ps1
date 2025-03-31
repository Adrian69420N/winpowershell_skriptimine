<#
.SYNOPSIS
    Creates a new Active Directory user account with a random password.
.DESCRIPTION
    Prompts for first and last name, creates AD user with a secure random password,
    and logs credentials to a CSV file.
.NOTES
    Requires Active Directory module
#>

# Import module
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
if (-not (Get-Module -Name ActiveDirectory)) {
    Write-Host "ERROR: Active Directory module could not be loaded." -ForegroundColor Red
    exit 1
}

# Connect to domain
try {
    $domain = Get-ADDomain
    Write-Host "Connected to domain: $($domain.DNSRoot)" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Cannot connect to Active Directory domain." -ForegroundColor Red
    exit 1
}

# Generate secure random password
function New-RandomPassword {
    $length = 12
    $upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $lower = 'abcdefghijklmnopqrstuvwxyz'
    $digits = '0123456789'
    $special = '!@#$%&*()-_=+?'

    $allChars = ($upper + $lower + $digits + $special).ToCharArray()
    $password = @(
        ($upper.ToCharArray() | Get-Random)
        ($lower.ToCharArray() | Get-Random)
        ($digits.ToCharArray() | Get-Random)
        ($special.ToCharArray() | Get-Random)
    )

    for ($i = $password.Count; $i -lt $length; $i++) {
        $password += $allChars | Get-Random
    }

    return ($password | Sort-Object { Get-Random }) -join ''
}

# Initialize CSV file
function Initialize-CsvFile {
    param ([string]$filePath)
    if (-not (Test-Path $filePath)) {
        "Username,Password" | Out-File -FilePath $filePath -Encoding utf8
    }
}

# --- User input ---
Write-Host "`n=== Active Directory User Creation Tool ===" -ForegroundColor Cyan
$firstName = Read-Host -Prompt "Enter first name"
$lastName = Read-Host -Prompt "Enter last name"

if ([string]::IsNullOrWhiteSpace($firstName) -or [string]::IsNullOrWhiteSpace($lastName)) {
    Write-Host "ERROR: Names cannot be empty." -ForegroundColor Red
    exit 1
}

# Generate username
$username = ($firstName.Substring(0, 1) + $lastName).ToLower()
$username = $username -replace '[^a-z0-9]', '' 

Write-Host "Generated username: $username" -ForegroundColor Cyan

# Check if user exists
try {
    if (Get-ADUser -Filter { SamAccountName -eq $username }) {
        Write-Host "User '$username' already exists in AD." -ForegroundColor Yellow
        exit 0
    }
} catch {
    Write-Host "Username is available." -ForegroundColor Green
}

# Generate password
$password = New-RandomPassword
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force

# Build UPN and path
$email = "$username@$($domain.DNSRoot)"
$upn = "$username@$($domain.DNSRoot)"
$ouPath = "CN=Users,$($domain.DistinguishedName)"

# Create user
try {
    New-ADUser -Name "$firstName $lastName" `
               -GivenName $firstName `
               -Surname $lastName `
               -SamAccountName $username `
               -UserPrincipalName $upn `
               -EmailAddress $email `
               -AccountPassword $securePassword `
               -Enabled $true `
               -ChangePasswordAtLogon $true `
               -Path $ouPath `
               -PassThru | Out-Null

    Write-Host "User '$username' created successfully." -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Failed to create user." -ForegroundColor Red
    Write-Host "Details: $_" -ForegroundColor Red
    exit 1
}

# Log to CSV
$csvPath = Join-Path -Path $PSScriptRoot -ChildPath "kasutanimi.csv"
Initialize-CsvFile -filePath $csvPath

try {
    "$username,$password" | Out-File -FilePath $csvPath -Encoding utf8 -Append
    Write-Host "Credentials saved to CSV: $csvPath" -ForegroundColor Green
}
catch {
    Write-Host "WARNING: Could not save to CSV file." -ForegroundColor Yellow
}

# Summary
Write-Host "`n--- User Summary ---" -ForegroundColor Cyan
Write-Host "Username : $username"
Write-Host "Password : $password"
Write-Host "Email    : $email"
Write-Host "UPN      : $upn"
Write-Host "Saved to : $csvPath"
Write-Host "`nUser must change password at first logon." -ForegroundColor Yellow
