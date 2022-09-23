@echo off

:: RSYSLOG SERVER:
set /p RSYSLOG_SERVER="ENTER IP RSYSLOG SERVER:: "


copy %~dp0\evtsys.exe C:\Windows\System32\evtsys.exe
@pause 10
C:\Windows\System32\evtsys.exe -i -h %RSYSLOG_SERVER%
@pause 10
net start evtsys

exit