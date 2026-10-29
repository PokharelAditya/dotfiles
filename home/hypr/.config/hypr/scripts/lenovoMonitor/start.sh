#!/bin/bash

hyprctl output create auto lenovoMonitor 
sleep 1 
systemctl --user restart skwd-walld.service
