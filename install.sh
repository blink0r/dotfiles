#!/bin/bash

dotfiles=(".dircolors" ".vimrc" ".bashrc" ".xinitrc" ".Xresources")

i3_conf = "config"
ranger_conf = "rc.conf"
rifle_conf = "rifle.conf"
i3blocks_conf = "i3blocks.conf"

dir="${PWD}"
backup_dir = "${dir}/backup"

for dotfile in "${dotfiles[@]}"
do
	cp "${HOME}/${dotfile}" "${backup_dir}/"
	ln -sf "${dir}/${dotfile}" "${HOME}/${dotfile}"
done

ln -sf "${dir}/${ranger_conf}" "${HOME}/${dotfile}"
