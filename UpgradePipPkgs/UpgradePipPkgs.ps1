[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $PythonCmdName = 'python'
)

if ($PythonCmdName -ne 'python' -and $PythonCmdName -ne 'python3') {
    Write-Output '$PythonCmdName should be ''python'' or ''python3'''
    return
}

$file = '.\outdated.txt'

Write-Host '----Removing previous outdated packages list----'
if (Test-Path $file) {
    Remove-Item $file
}

Write-Host '----Upgrading pip----'
if ($PythonCmdName -eq 'python') {
    python -m pip install --upgrade pip
}
else {
    python3 -m pip install --upgrade pip
}

Write-Host '----Getting outdated packages list----'
$outdatedPkgsList = $null
if ($PythonCmdName -eq 'python') {
    $outdatedPkgsList = python -m pip list --outdated
}
else {
    $outdatedPkgsList = python3 -m pip list --outdated
}
$fileContent = $outdatedPkgsList -join "`n"
$fileContent | Tee-Object -FilePath $file

Write-Host '----Upgrading outdated packages----'
for ($i = 2; $i -lt $outdatedPkgsList.Count; $i++) {
    $pkg = -split $outdatedPkgsList[$i]
    $pkg = $pkg[0]
    Write-Host "----Upgrading $pkg----"
    if ($PythonCmdName -eq 'python') {
        python -m pip install --upgrade $pkg
    }
    else {
        python3 -m pip install --upgrade $pkg
    }
}
