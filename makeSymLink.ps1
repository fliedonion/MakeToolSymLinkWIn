param (
  [string]$targetPath
)
echo $targetPath
Set-PSDebug -Strict

# sv ErrorTargetIsNotDirectory 1 -option constant -Scope "Local"
# sv ErrorUnSupportedDirectoryStructure 2 -option constant -Scope "Local"
sv ErrorTargetIsNotDirectory 1 -Scope "Script"
sv ErrorUnSupportedDirectoryStructure 2 -Scope "Script"

sv SymLinkRootPath "c:\opt\" -Scope "Script"
sv TargetPathMustContains ":\opt\_files\" -Scope "Script"


if ($targetPath -eq ''){
    echo "please specify target tool's version directory"
    exit $ErrorUnSupportedDirectoryStructure
}

$symlinkRoot = (gi $SymLinkRootPath)
$d = gi $targetPath

if( $d -isnot [System.IO.DirectoryInfo]){
    echo "target is not directory"
    exit $ErrorTargetIsNotDirectory
}
   
if(!$d.FullName.Substring(1).ToUpper().StartsWith($TargetPathMustContains.ToUpper())){
    echo "target directory not contains '${TargetPathMustBeContains}'"
    exit $ErrorUnSupportedDirectoryStructure
}
   
$symlinkName = $d.Parent.Name

$cmd = @'
@echo off
cd "{0}"
rmdir "{0}\{1}"
if "%ERRORLEVEL%"=="0" (
   mklink {2} "{3}" "{4}"
) else (
   exit /b 4
)
'@

$cmd = [String]::Format( $cmd ,$symlinkRoot.FullName , $symlinkName, "/D", $symlinkRoot.FullName + $symlinkName, $d.FullName )
$tmpfilename = [System.IO.Path]::GetTempFileName() + ".cmd"
$cmd | Out-File -LiteralPath:$tmpfilename -Force -Encoding ascii
iex -Command:$tmpfilename

# # invoke single command sample
# $cmd = @'
# cmd.exe /C echo "Hello World"
# '@
# iex -Command:"cmd.exe /c "

echo $env:ERRORLEVEL
