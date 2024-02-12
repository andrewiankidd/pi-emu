param(
    ## buster, wont boot
    # $Image = "2021-05-07-raspios-buster-armhf-lite",
    # $machine = "raspi3b",
    # $cpu = "cortex-a53",
    # $dtb = "bcm2710-rpi-3-b.dtb",
    # $kernel = "kernel8.img"

    ## bullseye, working
    $Image = "2023-05-03-raspios-bullseye-armhf-lite",
    $machine = "raspi3b",
    $cpu = "cortex-a53",
    $dtb = "bcm2710-rpi-3-b.dtb",
    $kernel = "kernel8.img"

    ## bookworm, boots but no tty
    # $Image = "2023-12-11-raspios-bookworm-armhf-lite",
    # $machine = "raspi3b",
    # $cpu = "cortex-a53",
    # $dtb = "bcm2710-rpi-3-b.dtb",
    # $kernel = "kernel8.img"
)

while (-not $Image) {
    $Images = Get-ChildItem -Path "$PWD\emulator\images" -Directory | ForEach-Object { $_.Name }
    $Images | ForEach-Object { "> $($_)" }
    $Image = Read-Host "Please select an image"
}

& "C:\Program Files\qemu\qemu-system-aarch64.exe" `
    -machine $machine `
    -cpu $cpu `
    -m 1G `
    -net user,hostfwd=tcp::5022-:22 `
    -drive "file=$PWD\emulator\images\$($image)\image.img,if=sd,index=0,media=disk,format=raw,id=disk0" `
    -dtb "$PWD\emulator\images\$($image)\$dtb" `
    -kernel "$PWD\emulator\images\$($image)\$($kernel)" `
    -append 'rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1' `
    -serial mon:stdio `
    -no-reboot