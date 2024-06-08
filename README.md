# Karl - Kaung's Arch Recovery Linux

Karl is a profile for archiso to create a live USB boot that is essentially bare Arch Linux with a pre-configured desktop environment to make your life  easier installating an Arch Linux system, complete with a firefox browser and Network Manager. No more looking at your phone or through secondary computer for guides, notes or googling around. Browse the internet while you chroot. You can treat this iso the same as offcial arch linux ISO to do installation via tty or fire `startx` away to spin up the awesome wm. o7 Archer.


## How to Build the ISO

Follow these steps to build the Karl ISO:

1. **Install Dependencies**:
    ```sh
    sudo pacman -S archiso git
    ```

2. **Clone the Repository**:
    ```sh
    git clone https://github.com/kgmyatthu/karl.git
    cd karl
    ```

3. **Build the ISO**:
    ```sh
    sudo mkarchiso -v .
    ```
   The built ISO will be located in the `out` directory.

## How to Burn the ISO to a USB Device

Once you have built the ISO, follow these steps to burn it to a USB device:

1. **Identify your USB Device**:
   Plug in your USB drive and identify its device name using the `lsblk` command. Look for your USB device (e.g., `/dev/sdX`).

   **Warning**: Be very careful to identify the correct device as the following steps will erase all data on the chosen device.

2. **Burn the ISO to the USB Device**:
    ```sh
    sudo dd if=out/karl.iso of=/dev/sdX bs=4M status=progress && sync
    ```
    Replace `/dev/sdX` with the correct device name for your USB drive.

3. **Boot from the USB Device**:
   - Insert the USB drive into the target computer.
   - Restart the computer and enter the BIOS/UEFI setup.
   - Select the USB drive as the boot device.
   - Save and exit BIOS/UEFI setup to boot from the USB drive.

## Troubleshooting

- **ISO Build Issues**: Ensure all dependencies are installed and you have sufficient permissions to run the build commands.
- **USB Boot Issues**: Double-check the `dd` command to ensure the correct device is used. Verify the BIOS/UEFI settings for USB boot.

## Contributing

Feel free to open issues and pull requests if you encounter any problems or have improvements.

## The Why

I often fiddle with things on my system without proper backup mesures (I'm lazy). I find myself having to rescue my arch linux more than i'd like to. And often googling stuff is inevitable. The offical archlinux ISO suck in that regard so there is karl. 

## License

This project is licensed under the MIT License.
