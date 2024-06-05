#!/bin/sh
prime-offload;


optimus-manager --switch hybrid --no-confirm;


xrandr --output HDMI-1-0 --primary --mode 2560x1080 --rate 74.99 --output DP-1 --left-of HDMI-1-0 --mode 1920x1080 --rate 74.97 --rotate left --output eDP-1 --left-of DP-1 --mode 1920x1080 --rate 60;

awesome;

# xrandr --output DP1 --primary --mode 2560x1080 --rate 74.99 --output eDP1 --left-of DP1 --mode 1920x1080 --rate 74.97;
