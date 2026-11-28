#!/usr/bin/env bash

asusctl aura effect static -c {{ colors.primary.default.hex_stripped | set_lightness: 50 | set_saturation: 100 }}
