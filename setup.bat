@echo off

:: RSYSLOG SERVER:
set /p RSYSLOG_SERVER="ENTER IP RSYSLOG SERVER:: "


C:\wget.exe -OC:\Windows\System32 https://github.com/linuxbuh/eventlog-to-syslog/raw/main/evtsys.exe
@pause 10
evtsys.exe -i -h %RSYSLOG_SERVER%
@pause 10
net start evtsys

exit