function Get-ScriptRoot {
    $result = $PSScriptRoot
    if ($result.Length -eq 0) {
        $result = split-path -parent $MyInvocation.MyCommand.Definition
    }
    return $result
}

function Set-LuoPath {
    $test_path = ([System.Environment]::GetEnvironmentVariable('PATH') | findstr (Get-ScriptRoot)).Length
    if ($test_path -eq 0) {
        [System.Environment]::SetEnvironmentVariable('PATH', "${Env:PATH};" + (Get-ScriptRoot))
        $Env:PATH += ";" + (Get-ScriptRoot)
        Write-Host "=== PATH set for Luo ==="
    }
}

Set-LuoPath

if ($args[0] -eq "update") {
    Write-Host "Pulling the latest Docker image..."
    docker pull ghcr.io/mjason/luo:latest
}

Write-Host "Running the Docker container..."

docker run --rm -it `
    -p 8888:8888 `
    -v "${PWD}:/workdir" `
    ghcr.io/mjason/luo:latest `
    $args
