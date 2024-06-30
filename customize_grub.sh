#!/bin/bash

# Asegúrate de que el script se ejecute como superusuario
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta como superusuario"
  exit 1
fi

echo "Configuración interactiva de GRUB"

# Función para seleccionar el tamaño de la fuente
configurar_tamano_fuente() {
  read -p "Introduce el tamaño de la fuente (por ejemplo, 36): " FONT_SIZE
  FONT_SIZE=${FONT_SIZE:-36}  # Valor por defecto 36 si no se proporciona

  FONT_NAME="DejaVuSansMono"
  FONT_PATH="/usr/share/fonts/truetype/dejavu/${FONT_NAME}.ttf"
  OUTPUT_FONT="/boot/grub/fonts/myfont.pf2"

  if [ ! -f "$FONT_PATH" ]; then
    echo "La fuente ${FONT_NAME} no se encontró en ${FONT_PATH}"
    return 1
  fi

  echo "Generando la fuente con tamaño ${FONT_SIZE}..."
  grub-mkfont -s $FONT_SIZE -o $OUTPUT_FONT $FONT_PATH

  # Verificar si la fuente se creó correctamente
  if [ ! -f "$OUTPUT_FONT" ]; then
    echo "Error al crear la fuente ${OUTPUT_FONT}"
    return 1
  fi

  # Editar el archivo /etc/default/grub
  echo "Editando /etc/default/grub..."
  GRUB_CONFIG="/etc/default/grub"

  # Hacer una copia de seguridad del archivo de configuración
  cp $GRUB_CONFIG ${GRUB_CONFIG}.bak

  # Añadir la línea de configuración de la fuente si no existe
  if ! grep -q "GRUB_FONT=" "$GRUB_CONFIG"; then
    echo "GRUB_FONT=${OUTPUT_FONT}" >> $GRUB_CONFIG
  else
    sed -i "s|^GRUB_FONT=.*|GRUB_FONT=${OUTPUT_FONT}|" $GRUB_CONFIG
  fi
}

# Función para seleccionar el tiempo de espera
configurar_timeout() {
  read -p "Introduce el tiempo de espera en segundos (por ejemplo, 10): " TIMEOUT
  TIMEOUT=${TIMEOUT:-10}  # Valor por defecto 10 si no se proporciona

  # Editar el archivo /etc/default/grub
  GRUB_CONFIG="/etc/default/grub"

  # Configurar el tiempo de espera
  if grep -q "^GRUB_TIMEOUT=" "$GRUB_CONFIG"; then
    sed -i "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$TIMEOUT/" "$GRUB_CONFIG"
  else
    echo "GRUB_TIMEOUT=$TIMEOUT" >> "$GRUB_CONFIG"
  fi
}

# Función para seleccionar los colores
configurar_colores() {
  # Solicitar colores para el menú
  read -p "Introduce el color normal del menú (por ejemplo, light-green/black): " MENU_COLOR_NORMAL
  MENU_COLOR_NORMAL=${MENU_COLOR_NORMAL:-light-green/black}  # Valor por defecto light-green/black si no se proporciona

  read -p "Introduce el color resaltado del menú (por ejemplo, green/black): " MENU_COLOR_HIGHLIGHT
  MENU_COLOR_HIGHLIGHT=${MENU_COLOR_HIGHLIGHT:-green/black}  # Valor por defecto green/black si no se proporciona

  # Solicitar colores para el terminal
  read -p "Introduce el color normal del terminal (por ejemplo, red/black): " TERM_COLOR_NORMAL
  TERM_COLOR_NORMAL=${TERM_COLOR_NORMAL:-red/black}  # Valor por defecto red/black si no se proporciona

  read -p "Introduce el color resaltado del terminal (por ejemplo, red/black): " TERM_COLOR_HIGHLIGHT
  TERM_COLOR_HIGHLIGHT=${TERM_COLOR_HIGHLIGHT:-red/black}  # Valor por defecto red/black si no se proporciona

  # Configurar los colores en /etc/grub.d/05_debian_theme
  echo "Configurando colores personalizados en /etc/grub.d/05_debian_theme..."
  GRUB_THEME_FILE="/etc/grub.d/05_debian_theme"

  # Colores del menú
  sed -i "/^set menu_color_normal=/c\set menu_color_normal=${MENU_COLOR_NORMAL}" $GRUB_THEME_FILE
  sed -i "/^set menu_color_highlight=/c\set menu_color_highlight=${MENU_COLOR_HIGHLIGHT}" $GRUB_THEME_FILE

  # Colores del terminal
  sed -i "/^set color_normal=/c\set color_normal=${TERM_COLOR_NORMAL}" $GRUB_THEME_FILE
  sed -i "/^set color_highlight=/c\set color_highlight=${TERM_COLOR_HIGHLIGHT}" $GRUB_THEME_FILE

  # Asegurar que las líneas de colores existen, agregarlas si no están presentes
  grep -q "set menu_color_normal=${MENU_COLOR_NORMAL}" $GRUB_THEME_FILE || echo "set menu_color_normal=${MENU_COLOR_NORMAL}" >> $GRUB_THEME_FILE
  grep -q "set menu_color_highlight=${MENU_COLOR_HIGHLIGHT}" $GRUB_THEME_FILE || echo "set menu_color_highlight=${MENU_COLOR_HIGHLIGHT}" >> $GRUB_THEME_FILE
  grep -q "set color_normal=${TERM_COLOR_NORMAL}" $GRUB_THEME_FILE || echo "set color_normal=${TERM_COLOR_NORMAL}" >> $GRUB_THEME_FILE
  grep -q "set color_highlight=${TERM_COLOR_HIGHLIGHT}" $GRUB_THEME_FILE || echo "set color_highlight=${TERM_COLOR_HIGHLIGHT}" >> $GRUB_THEME_FILE
}

# Mostrar el menú de opciones
while true; do
  echo ""
  echo "1. Configurar tamaño de la fuente"
  echo "2. Configurar tiempo de espera"
  echo "3. Configurar colores"
  echo "4. Actualizar GRUB y salir"
  echo "5. Salir sin actualizar"
  read -p "Elige una opción (1-5): " OPCION

  case $OPCION in
    1) configurar_tamano_fuente ;;
    2) configurar_timeout ;;
    3) configurar_colores ;;
    4) 
      echo "Actualizando GRUB..."
      update-grub
      echo "Configuración de GRUB completa. Reinicia tu sistema para ver los cambios."
      break
      ;;
    5) 
      echo "Saliendo sin actualizar GRUB."
      break
      ;;
    *)
      echo "Opción no válida, por favor elige una opción entre 1 y 5."
      ;;
  esac
done
