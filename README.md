# GRUB Customization

This repository contains scripts and instructions to customize the GRUB menu font size and colors.

## Script: `customize_grub.sh`

The `customize_grub.sh` script modifies your GRUB configuration to:
- Increase the font size.
- Change the menu text color to fluorescent green on a black background.
- Change the GRUB terminal box text color to red.

### Instructions

1. **Download the Script**

    Download the script from this repository to your home directory.

    ```sh
    cd ~
    wget https://raw.githubusercontent.com/jose-litium/grub-customization/main/customize_grub.sh
    ```

2. **Make the Script Executable**

    Make the script executable by running:

    ```sh
    sudo chmod +x customize_grub.sh
    ```

3. **Run the Script**

    Run the script with superuser permissions:

    ```sh
    sudo ./customize_grub.sh
    ```

4. **Restart Your System**

    After running the script, restart your system to apply the changes:

    ```sh
    sudo reboot
    ```

### Summary of Commands

```sh
cd ~
wget https://raw.githubusercontent.com/jose-litium/grub-customization/main/customize_grub.sh
sudo chmod +x customize_grub.sh
sudo ./customize_grub.sh
sudo reboot
