@echo off
cd /d "%~dp0"

git add .
git diff --cached --quiet || git commit -m "Auto-Update"
git push origin main