#!/bin/bash

flatpak-builder --repo=repo-dir --disable-rofiles-fuse --force-clean build-dir com.example.irssi.yaml

flatpak build-bundle repo-dir irssi.flatpak com.example.irssi

mv ./*.flatpak /out
