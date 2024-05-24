#!/bin/bash
# Compiles specified Quake map and places in Keep maps directory.
MAP_BASE_NAME=test_ai
MAPSRC_DIR=/home/qmaster/QUAKE/keep/mapsrc
MAPS_DIR=/home/qmaster/QUAKE/keep/maps
COMPILE_DIR=/home/qmaster/QUAKE/Other/Compiling
$COMPILE_DIR/qbsp -bsp2 -noverbose -splitturb -subdivide 512 -maxNodeSize 2048 $MAP_BASE_NAME.map $MAP_BASE_NAME.bsp
$COMPILE_DIR/vis -fast $MAP_BASE_NAME.bsp
$COMPILE_DIR/light_mj -gate 1.5 -lit $MAP_BASE_NAME.bsp
mv $MAPSRC_DIR/$MAP_BASE_NAME.bsp $MAPS_DIR/$MAP_BASE_NAME.bsp
mv $MAPSRC_DIR/$MAP_BASE_NAME.lit $MAPS_DIR/$MAP_BASE_NAME.lit
/home/qmaster/QUAKE/ironwail -basedir /home/qmaster/QUAKE -game keep +developer 1 +map $MAP_BASE_NAME
