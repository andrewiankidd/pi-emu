param(
    $machine = "raspi3b",
    $cpu = "cortex-a53",
    $mem = "1G",
    $dtb = "bcm2710-rpi-3-b.dtb",
    $kernel = "kernel8.img",
    [ValidateSet(
        # buster, wont boot
        "2021-05-07-raspios-buster-armhf-lite",
        # bullseye, working
        "2023-05-03-raspios-bullseye-armhf-lite",
        # bookworm, works in UI, but not in console
        "2023-12-11-raspios-bookworm-armhf-lite"
    )]
    [string]
    $Image = "2023-12-11-raspios-bookworm-armhf-lite"
)

while (-not $Image) {
    $Images = Get-ChildItem -Path "$PWD\emulator\images" -Directory | ForEach-Object { $_.Name }
    $Images | ForEach-Object { "> $($_)" }
    Read-Host "Please select an image"
}

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