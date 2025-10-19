@echo off
title VGC.SERVICES --> PASTE NO 1
cls

timeout 2 > nul
echo BACI COKERTEN TARAFINDAN BURALAR KULLANICI DOSTU SEKILDE DUZENLENMISTIR
timeout 2 > nul
echo AMIDEWIN OLANLARI SILDIM ANAKARTINIZ SIKILMESIN BU BOKTAN SPOOFERDAN KAYNAKLI
timeout 2 > nul
echo ONUN DISINDA BASKA BIR SEY YOK
timeout 2 > nul
echo VANGUARD BYPASSINIZDA GELECEK CRPYTAUTH KURTARMAZ
timeout 2 > nul



:: Yönetici yetkisi kontrolü
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] Bu script'i YONETICI olarak calistir!
    pause
    exit /b
)

powershell -WindowStyle Hidden -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c move /Y \"%~dp0wdwifi.sys\" \"C:\Windows\System32\drivers\wdwifi.sys\"'"
powershell -WindowStyle Hidden -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c move /Y \"%~dp0servicesler.sys\" \"C:\Windows\System32\drivers\servicesler.sys\"'"

setlocal
set SCRIPT_DIR=%~dp0

:: TPM ayarları
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command Disable-TpmAutoProvisioning'"
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command Clear-Tpm'"

:: Reg ve hosts script'lerini çalıştır
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-ExecutionPolicy Bypass -File \"%SCRIPT_DIR%create_reg_key_1745182231.ps1\"'"
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-ExecutionPolicy Bypass -File \"%SCRIPT_DIR%update_hosts.ps1\"'"

:: Dosyaları gizleme (opsiyonel)
set FILES=^
 bootx64.efi startup.nsh MAC.bat mapper.efi ^
 nvddlkop.dll popup.bat WinDivert.dll WinDivert64.sys

for %%F in (%FILES%) do (
    powershell -Command "attrib +h +s \"%SCRIPT_DIR%%%F\""
)

:: Ek script çalıştırma
powershell -WindowStyle Hidden -Command "Start-Process -WindowStyle Hidden -Verb RunAs \"%SCRIPT_DIR%MAC.bat\""
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -ArgumentList '-Command \"New-NetFirewallRule -DisplayName \\\"Block Intel TPM Servers\\\" -Direction Outbound -Action Block -RemoteAddress 13.91.91.243,40.83.185.143,52.173.85.170,52.173.23.9 -Enabled True\"'"
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -ArgumentList '-Command \"New-NetFirewallRule -DisplayName \\\"Block ftpm.amd.com\\\" -Direction Outbound -Protocol TCP -RemoteAddress \\\"52.173.170.80\\\" -Action Block\"'"

:: VBS script'leri çalıştır
if exist "%SCRIPT_DIR%reg.vbs" cscript "%SCRIPT_DIR%reg.vbs"
if exist "%SCRIPT_DIR%disk.vbs" cscript "%SCRIPT_DIR%disk.vbs"

:: Windows servisleri oluştur
powershell -WindowStyle Hidden -Command "Start-Process -WindowStyle Hidden -Verb RunAs cmd -ArgumentList '/c sc create Crypto binPath= \"C:\\Windows\\System32\\drivers\\wdwifi.sys\" type= kernel start= boot DisplayName= \"kse\"'"
sc start Crypto
sc  create servicesler binPath= "C:\Windows\System32\drivers\servicesler.sys" DisplayName= "servicesler" start= boot tag= 2 type= kernel group="System Reserved" && sc.exe start servicesler


:: Registry ayarları
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v RegisteredOrganization /t REG_SZ /d FS31893 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v RegisteredOwner /t REG_SZ /d FS30412 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /v ComputerName /t REG_SZ /d 27651 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName /t REG_SZ /d 31849 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\IDConfigDB\Hardware Profiles\0001" /v GUID /t REG_SZ /d {26253-49967-12476-34950-33625} /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SystemInformation" /v ComputerHardwareId /t REG_SZ /d {53608-59973-64780-50360-93619} /f
reg add "HKLM\SYSTEM\HardwareConfig" /v LastConfig /t REG_SZ /d {57387} /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientId /t REG_SZ /d {29376-64945-24336-32260-56293} /f

timeout /t 2 >nul

:: Temizlik – script dizinindeki dosyaları sil
del "%SCRIPT_DIR%MAC.bat" >nul 2>&1
del "%SCRIPT_DIR%disk.vbs" >nul 2>&1
del "%SCRIPT_DIR%create_reg_key_1745182231.ps1" >nul 2>&1
del "%SCRIPT_DIR%bootx64.efi" >nul 2>&1
del "%SCRIPT_DIR%mapper.efi" >nul 2>&1
del "%SCRIPT_DIR%nvddlkop.dll" >nul 2>&1
del "%SCRIPT_DIR%popup.bat" >nul 2>&1
del "%SCRIPT_DIR%reg.vbs" >nul 2>&1
del "%SCRIPT_DIR%startup.nsh" >nul 2>&1
del "%SCRIPT_DIR%update_hosts.ps1" >nul 2>&1
del "%SCRIPT_DIR%volumeid.exe" >nul 2>&1
del "%SCRIPT_DIR%WinDivert.dll" >nul 2>&1
del "%SCRIPT_DIR%WinDivert64.sys" >nul 2>&1

powershell.exe [console]::beep(1000, 2000)




echo [+] TUM ISLEMLER TAMAMLANDI.

pause
