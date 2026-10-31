@echo off
call npm install
if errorlevel 1 exit /b %errorlevel%
call npm run build
if errorlevel 1 exit /b %errorlevel%
if not exist "dist\hello.js" exit /b 1
call npm test
if errorlevel 1 exit /b %errorlevel%
