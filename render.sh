#! /bin/sh

openscad --camera 0,0,0,60,0,135,150 --imgsize 800,800 \
  --view axes,crosshairs,scales -o mount-short.png mount-short.scad && \
openscad --camera 0,0,0,60,0,135,150 --imgsize 800,800 \
  --view axes,crosshairs,scales -o mount-long.png mount-long.scad
