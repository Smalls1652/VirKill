@setlocal enableextensions
@cd /d "%~dp0"
@echo off
title VirKill Downloader

powershell.exe -ExecutionPolicy Bypass -File virkill.ps1

exit