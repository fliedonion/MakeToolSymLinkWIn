@ECHO OFF
@rem http://stackoverflow.com/questions/7044985/how-can-i-auto-elevate-my-batch-file-so-that-it-requests-from-uac-administrator

if "%1"=="" (
  echo "** opt symlink helper **"
  echo "usage: %f0 [tool's target version dir]"
  echo;
  echo "   ex) %f0 C:\opt\_files\nginx\nginx-1.7.1"
  echo "     will same as: "
  echo "     rmdir nginx"
  echo "     mklink /d nginx c:\opt\_files\nginx-1.7.1"
  pause
  goto :eof
)


setlocal EnableDelayedExpansion

NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto START ) else ( goto getPrivileges ) 

:getPrivileges
if '%1'=='ELEV' ( goto START )

set "batchPath=%~f0"
set "batchArgs=ELEV"

:ArgLoop
IF '%1'=='' ( GOTO EndArgLoop ) else ( GOTO AddArg )
    :AddArg
    set "arg=%1"
    set arg=%arg:"=%
    IF '%1'=='!arg!' ( GOTO NoQuotes )
        set "batchArgs=%batchArgs% "%1""
        GOTO QuotesDone
        :NoQuotes
        set "batchArgs=%batchArgs% %1"
    :QuotesDone
    shift
    GOTO ArgLoop
:EndArgLoop

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
ECHO UAC.ShellExecute """!batchPath!""", "!batchArgs!", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs" 
exit /B

:START
::Remove the elevation tag and set the correct working directory
IF '%1'=='ELEV' ( shift /1 )
REM type "%temp%\OEgetPrivileges.vbs" 
cd /d %~dp0
powershell "%~dp0makeSymLink.ps1" -targetPath:%1
pause
