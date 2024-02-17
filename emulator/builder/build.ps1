param(
    $Image = "latest"
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ParentDirectory = Split-Path -Path $PSScriptRoot -Parent

# build ubuntu dockerfile with dependencies for build
$ContainerBuildCommand = "docker build -q `"$($ParentDirectory)\builder`""
Write-Host "Building Container Image: $ContainerBuildCommand"
$ContainerImage = $(Invoke-Expression -Command $ContainerBuildCommand).split(' ')[-1]
if (-not $ContainerImage)
{
    throw "Build failed"
}

# run build
$ImageBuildCommand = "docker run --rm --name rpibuilder -it --privileged -v `"$($ParentDirectory):/home`" -e IMAGE=$Image $ContainerImage"
Write-Host "Executing Container Image: $ImageBuildCommand"
Invoke-Expression -Command $ImageBuildCommand