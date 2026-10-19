#!/bin/bash

hyprctl output create auto huaweiTab
sleep 1 
systemctl --user restart skwd-walld.service
