#!/usr/bin/env bash

#UAE4arm raspberry pi2 buildscript for RetroPie by amigagamer.
#UAE4arm by tomb (pandora), ported to android by lubomyr, raspberry pi enhancements by Chips
#based on exobuzz uae4all2 script
# This script is not an official part of retropie
#Retropie information and licensing follows

# 
# (c) Copyright 2012-2015  Florian Müller (contact@petrockblock.com)
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/petrockblog/RetroPie-Setup/master/LICENSE.md.
#

rp_module_id="uae4arm"
rp_module_desc="Amiga emulator RPI2 with JIT support"
rp_module_menus="4+"

function depends_uae4arm() {
    getDepends libsdl1.2-dev libsdl-mixer1.2-dev libsdl-image1.2-dev libsdl-gfx1.2-dev libsdl-ttf2.0-dev libguichan-dev libguichan-0.8.1-1 libguichan-sdl-0.8.1-1
}

function sources_uae4arm() {
    gitPullOrClone "$md_build" https://github.com/Chips-fr/uae4arm-rpi/
}

function build_uae4arm() {
    make
    md_ret_require="$md_build/uae4arm"

}
function install_uae4arm() {
 	cp data "$md_inst" -r
	md_ret_files=(
        'uae4arm'
  #      'uae4all'
  #      'Readme.txt'
    )
}

function configure_uae4arm() {
    mkRomDir "amiga"

    mkdir -p "$md_inst/conf"
   #   echo "path=$romdir/amiga" >"$md_inst/conf/adfdir.conf"
    chown -R $user:$user "$md_inst/conf"

	mkdir -p "$md_inst/kickstarts"
	chown -R $user:$user "md_inst/conf"
	
    # symlinks to optional kickstart roms in our BIOS dir
    for rom in kick12.rom kick13.rom kick20.rom kick31.rom; do
        ln -sf "$biosdir/$rom" "$md_inst/kickstarts/$rom"
    done

    rm -f "$md_inst/uae4all.sh" "$romdir/amiga/Start.txt"
    cat > "$romdir/amiga/+Start UAE4Arm.sh" << _EOF_
#!/bin/bash
pushd "$md_inst"
$rootdir/supplementary/runcommand/runcommand.sh 0 ./uae4arm "$md_id"
popd
_EOF_
    chmod a+x "$romdir/amiga/+Start UAE4Arm.sh"
    chown $user:$user "$romdir/amiga/+Start UAE4Arm.sh"

    #setDispmanx "$md_id" 1

    addSystem 1 "$md_id" "amiga" "$romdir/amiga/+Start\ UAE4Arm.sh" "AmigaARM" ".sh"
}
