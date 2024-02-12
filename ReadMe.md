
# Raspios Arm64 Emulation Scripts

This repository contains scripts for automating setup of arm64 emulation of Raspios using QEMU. Emulating arm64 architecture is useful for testing and development on systems that do not natively support the ARM architecture.

## Prerequisites

- [QEMU](https://www.qemu.org/) installed on your system, and available in PATH


## Setup
1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/andrewiankidd/raspios-arm64-emulation.git
   ```

2. From the terminal execute the builder script

   ```bash
   .\emulator\builder\build-win.ps1
   ```

3. Files should be generated in the 'images' directory

## Usage

1. Run the emulation script:

   ```bash
   ./emulator/windows.ps1
   ```

   This script sets up QEMU with the necessary parameters to emulate arm64 architecture using the Raspios image.

## Configuration

You can customize the emulation settings by modifying the `run_emulation.sh` script. Adjust parameters such as memory allocation, CPU architecture, and additional QEMU options based on your requirements.

## Contributing

If you find issues or have suggestions for improvements, feel free to open an [issue](https://github.com/andrewiankidd/raspios-arm64-emulation/issues) or submit a [pull request](https://github.com/andrewiankidd/raspios-arm64-emulation/pulls).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.