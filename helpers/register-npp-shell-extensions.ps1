Write-Output "Checking for Scoop Notepad++"
$npp = scoop which notepad++
if($lastexitcode -ne 0) { 'notepad++ isn''t installed. run ''scoop install notepadplusplus notepadplusplus-pm'''; return }

Write-Output "Getting scoop helper functions..."
$core_url = 'https://raw.github.com/lukesampson/scoop/master/lib/core.ps1'
Write-Output 'Initializing...'
Invoke-Expression (new-object net.webclient).downloadstring($core_url)

$app_dir = appdir('notepadplusplus')
if(test-path $app_dir) {
    Write-Output "Found notepad++ app directory:\n$app_dir"
} else {
    Write-Output "Error: couldn't find notepadplusplus app directory"; return
}

$persist_dir = persistdir('notepadplusplus')
if(test-path $persist_dir) {
    Write-Output "Found notepad++ persist directory:\n$persist_dir"
} else {
    Write-Output "Error: couldn't find notepadplusplus persist directory"; return
}

Write-Output "Downloading notepad++ shell integration extension..."

Write-Output 'Downloading Scoop Zip...'
$zipurl = 'http://notepad-plus.sourceforge.net/commun/misc/NppShell.New.zip'
$zipfile = "$persist_dir\NppShell.New.zip"

dl $zipurl $zipfile
Write-Output 'Unzipping...'
unzip $zipfile "$persist_dir\_tmp"
Copy-Item "$persist_dir\_tmp\*" $persist_dir -r -force
Remove-Item "$persist_dir\_tmp" -r -force
Remove-Item $zipfile

#$persist_dir = "$(split-path $npp -resolve)\..\..\..\persist\notepadplusplus"
#$persist_dir = "$(Resolve-Path $conf)"
write-host "$persist_dir"

cd "$app_dir"

$shellExt = "NppShell.dll"
$shellExt64 = "NppShell64.dll"

Write-Output 'Enabling shell extension...'
if(test-path $persist_dir\$shellExt) {
    Write-Output "Making a link from $app_dir\current\$shellExt to $persist_dir\$shellExt"
    sudo cmd /c mklink $app_dir\current\$shellExt $persist_dir\$shellExt
    Write-Output "Registering $shellExt"
    regsvr32 /s /i "$shellExt"
} else {
    Write-Output "Error: couldn't find $shellExt"
}

if(test-path $persist_dir\$shellExt64) {
    Write-Output "Making a link from $app_dir\current\$shellExt64 to $persist_dir\$shellExt64"
    sudo cmd /c mklink $app_dir\current\$shellExt64 $persist_dir\$shellExt64
    Write-Output "Registering $shellExt64"
    regsvr32 /s /i "$shellExt64"
} else {
    Write-Output "Error: couldn't find $shellExt64"
}

Write-Output "Done"
