cls
$ErrorActionPreference = "Stop"

$ParentDirectory = Split-Path -Path $PSScriptRoot -Parent

# build ubuntu dockerfile with dependencies for build
Write-Host "Building Dockerfile: docker build -q $($ParentDirectory)"
$image = $(docker build -q "$($ParentDirectory)\builder").split(' ')[-1]
if (-not $image)
{
    throw "Build failed"
}

# run build
Write-Host "Executing Image: docker run --rm --name rpibuilder -it --privileged -v `"$($ParentDirectory):/home`" $image"
docker run --rm --name rpibuilder -it --privileged -v "$($ParentDirectory):/home" $image