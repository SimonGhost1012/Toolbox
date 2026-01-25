@echo off
cd /d "%~dp0"

git add .
git diff --cached --quiet || git commit -m "Auto-Update"
git pull --rebase origin main
git push origin main