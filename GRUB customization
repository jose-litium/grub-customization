#!/bin/bash

# Ensure the script is run as superuser
if [ "$EUID" -ne 0 ]; then
  echo "Please run as superuser"
  exit 1
fi

# Create the new font
FONT_SIZE=36
FONT_NAME="DejaVuSansMono"
FONT_PATH="/usr/share/fonts/truetype/dejavu/${FONT_NAME}.ttf"
OUTPUT_FONT="/boot/grub/fonts/myfont.pf2"

if [ ! -f "$FONT_PATH" ]; then
  echo "The font ${FONT_NAME} was not found in ${FONT_PATH}"
  exit 1
fi

echo "Generating the font with size ${FONT_SIZE}..."
grub-mkfont -s $FONT_SIZE -o $OUTPUT_FONT $FONT_PATH

# Check if the font was created successfully
if [ ! -f "$OUTPUT_FONT" ]; then
  echo "Error creating the font ${OUTPUT_FONT}"
  exit 1
fi

# Edit the /etc/default/grub file
echo "Editing /etc/default/grub..."
GRUB_CONFIG="/etc/default/grub"

# Backup the configuration file
cp $GRUB_CONFIG ${GRUB_CONFIG}.bak

# Add the font configuration line if it doesn't exist
if ! grep -q "GRUB_FONT=" "$GRUB_CONFIG"; then
  echo "GRUB_FONT=${OUTPUT_FONT}" >> $GRUB_CONFIG
else
  sed -i "s|^GRUB_FONT=.*|GRUB_FONT=${OUTPUT_FONT}|" $GRUB_CONFIG
fi

# Add custom colors
echo "Configuring custom colors in /etc/grub.d/05_debian_theme..."
GRUB_THEME_FILE="/etc/grub.d/05_debian_theme"

# Set menu colors
sed -i "/^set menu_color_normal=/c\set menu_color_normal=light-green/black" $GRUB_THEME_FILE
sed -i "/^set menu_color_highlight=/c\set menu_color_highlight=green/black" $GRUB_THEME_FILE

# Set terminal box colors
sed -i "/^set color_normal=/c\set color_normal=red/black" $GRUB_THEME_FILE
sed -i "/^set color_highlight=/c\set color_highlight=red/black" $GRUB_THEME_FILE

# Ensure color lines exist, add them if they don't
grep -q "set menu_color_normal=light-green/black" $GRUB_THEME_FILE || echo "set menu_color_normal=light-green/black" >> $GRUB_THEME_FILE
grep -q "set menu_color_highlight=green/black" $GRUB_THEME_FILE || echo "set menu_color_highlight=green/black" >> $GRUB_THEME_FILE
grep -q "set color_normal=red/black" $GRUB_THEME_FILE || echo "set color_normal=red/black" >> $GRUB_THEME_FILE
grep -q "set color_highlight=red/black" $GRUB_THEME_FILE || echo "set color_highlight=red/black" >> $GRUB_THEME_FILE

# Update GRUB
echo "Updating GRUB..."
update-grub

echo "GRUB configuration complete. Restart your system to see the changes."
