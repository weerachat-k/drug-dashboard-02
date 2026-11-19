# =========================================================
# publish.ps1 — ส่งการแก้ไขทั้งหมดขึ้น GitHub ด้วยคำสั่งเดียว
# วิธีใช้ (ในโฟลเดอร์นี้):  .\publish.ps1 "ข้อความอธิบายการแก้ไข"
# ถ้าไม่ใส่ข้อความ จะใช้วันที่-เวลาปัจจุบันแทน
# =========================================================
param([string]$Message = "อัปเดต dashboard $(Get-Date -Format 'yyyy-MM-dd HH:mm')")

Set-Location $PSScriptRoot

# ไม่มีอะไรเปลี่ยน → ไม่ต้องทำอะไร
if (-not (git status --porcelain)) {
    Write-Host "ไม่มีไฟล์ที่เปลี่ยนแปลง" -ForegroundColor Yellow
    exit 0
}

git add -A
git commit -m $Message
if ($LASTEXITCODE -ne 0) { Write-Host "commit ไม่สำเร็จ" -ForegroundColor Red; exit 1 }

git push
if ($LASTEXITCODE -ne 0) { Write-Host "push ไม่สำเร็จ" -ForegroundColor Red; exit 1 }

# แสดงลิงก์หน้าเว็บ GitHub Pages
$url = gh api "repos/{owner}/{repo}/pages" --jq .html_url 2>$null
Write-Host "ส่งขึ้น GitHub แล้ว" -ForegroundColor Green
if ($url) { Write-Host "หน้าเว็บ (อัปเดตภายใน 1-2 นาที): $url" }
