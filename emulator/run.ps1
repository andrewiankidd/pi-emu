param(
    $machine = "raspi3b",
    $cpu = "cortex-a53",
    $mem = "1G",
    $dtb = "bcm2710-rpi-3-b.dtb",
    $kernel = "kernel8.img",
    $Image = "2023-12-11-raspios-bookworm-armhf-lite"
)

# Check if image exists locally
if (-not (Test-Path -Path "$PWD\emulator\images\$Image")) {
    Write-Warning "Image '$Image' not found! Downloading."
    & $PWD\emulator\builder\build.ps1 -Image $Image
}

# Run Qemu
& "C:\Program Files\qemu\qemu-system-aarch64.exe" `
    -machine $machine `
    -cpu $cpu `
    -m $mem `
    -smp 4 `
    -drive "file=$PWD\emulator\images\$($image)\image.img,if=sd,index=0,media=disk,format=raw,id=disk0" `
    -dtb "$PWD\emulator\images\$($image)\$($dtb)" `
    -kernel "$PWD\emulator\images\$($image)\$($kernel)" `
    -append 'rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1' `
    -serial mon:stdio `
    -usb `
    -device usb-mouse `
    -device usb-kbd `
    -device usb-net,netdev=net0 `
    -netdev user,id=net0,hostfwd=tcp::5555-:22 `
    -no-reboot