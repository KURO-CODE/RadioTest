#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~
# Pirate Radio Transmitter 
#~~~~~~~~~~~~~~~~~~~~~~~~~~
# Type: Radio FM Transmitter
# Name: PRT (Pirate Radio Transmitter)
# Dev: 1.0 beta
# Date: 07/14/2017
# Author: KURO-CODE

#~~~~ COLOR ~~~~
W="\033[1;37m"
G="\033[1;32m"
R="\033[1;31m"
Y="\033[1;33m"
EC="\033[0m"


#On="ON AIR"

FLAG() {
	Place="Flag"
	clear
	echo -e "${G}|¯¯¯¯|\¯¯¯\\\\${Y} |¯¯¯¯|\¯¯¯\\\\${R} |¯¯¯¯¯¯¯¯¯¯¯¯|
${G}|    | |   |${Y}|    | |   |${R}|___      ___|
${G}|    |/   /${Y} |    |/   /${R}     |    |
${G}|    |¯¯¯¯${Y}  |    |\   \ ${R}    |    |
${G}|____|${W}irate ${Y}|____| \___\\\\${W}adio${R}|____|${W}ransmitter$EC
"
}

BAN() {
	echo -e "${G} |¯¯|)¯¯)${Y}|¯¯|)¯¯)${R}|¯¯¯¯¯¯|  
${G} |__|¯¯¯${Y} |__|\__\\\\${R} ¯|__|¯$EC 
"
}

On_Air_Ban() {
	clear
	echo -e "$G ____  __  _      ____   _ _____ 
/ () \|  \| |    / () \ | || () )
\____/|_|\__|   /__/\__\|_||_|\_\

$W Canal:$G $MHZ\n$W Name:$G $RNAME"
	sleep 0.5
	clear
	echo -e "$W ____  __  _      ____   _ _____ 
/ () \|  \| |    / () \ | || () )
\____/|_|\__|   /__/\__\|_||_|\_\

$W Canal:$G $MHZ\n$W Name:$G $RNAME"
	sleep 0.5
	clear
	echo -e "$G ____  __  _      ____   _ _____ 
/ () \|  \| |    / () \ | || () )
\____/|_|\__|   /__/\__\|_||_|\_\

$W Canal:$G $MHZ\n$W Name:$G $RNAME"
	sleep 0.5
	clear
	echo -e "$W ____  __  _      ____   _ _____ 
/ () \|  \| |    / () \ | || () )
\____/|_|\__|   /__/\__\|_||_|\_\

$W Canal:$G $MHZ\n$W Name:$G $RNAME"
	sleep 0.5
	clear
	echo -e "$G ____  __  _      ____   _ _____ 
/ () \|  \| |    / () \ | || () )
\____/|_|\__|   /__/\__\|_||_|\_\ 

$W Canal:$G $MHZ\n$W Name:$G $RNAME $EC"
	sleep 1
}

function Main() {
	Place="MAIN"
	clear
	BAN
	echo -e "$Y      ~${G} Main menu$Y ~\n      -------------\n
     1$W) Default Freq 107.9
     ${Y}2$W) Choice Freq
#     ${Y}3$W)$G Transmission
     ${Y}9$W)$Y Stop FM
     ${R}0$W)$R Exit$W\n"
	read -p " Select: " SELECT
	case $SELECT in
		1) clear; FILE; RUN;;
		2) clear; FILE; RUN;;
#		3) clear;SELECT_FILE; RUN; Main;;
		9) clear; Kill_FM; Main;;
		0) RM_SAVE; Kill_FM; EXIT;;
		*) clear; BAN; echo -e "$R ERROR"; sleep 3; Main;;
	esac
}

FREQ() {
	clear
	BAN
	echo -e "$G Choice your Frequance emition$W\n"
	read -p " Freq: " MHZ
}

NAME() {
	Place="Name"
	clear
	BAN
	echo -e "your Radio name"
	read -p " Name: " RNAME
}

FILE() {
	Place="SF"
	clear
	BAN
	echo -e "$Y Enter your file(s)$G MP3$W"
	read -p " File(s): " MPNAME 
}

#SAVE() {
#	echo "$MHZ $RNAME" > save.txt
#}

function RUN() {
	Place="Run"
	if [ "$SELECT" -eq "1" ]; then
		MHZ="107.9"
		if [ -f "Default_save.txt" ]; then
#			MHZ="107.9"
                        RNAME=`cat Default_save.txt`
                else
                        NAME
                        echo "$RNAME" > Default_save.txt
		fi
		Kill_FM
		clear
		BAN
		sox -t mp3 $MPNAME -t wav - | sudo /home/pi/PiFmRds/src/pi_fm_rds -ps $RNAME -audio - &
		sleep 2
		clear
#		BAN
#		echo -e "$On"
		On_Air_Ban
#		sleep 3
		Main
	elif [ "$SELECT" -eq "2" ]; then
		if [ -f "save.txt" ]; then
			MHZ=`cat save.txt |awk '{print $1}'`
			RNAME=`cat save.txt |awk '{print $2}'`
		else
			FREQ
			NAME
			echo "$MHZ $RNAME" > save.txt
		fi
		Kill_FM
		clear
		BAN
		sox -t mp3 $MPNAME -t wav - | sudo /home/pi/PiFmRds/src/pi_fm_rds -ps $RNAME -freq $MHZ -audio - &
		sleep 2
		clear
#		BAN
		On_Air_Ban
#        	echo -e "$G On Air\n$W Canal:$G $MHZ\n$W Name:$G $RNAME"
		sleep 3
		Main
#	elif [ "$SELECT" -eq "3" ]; then
#        	sox -t mp3 $MPNAME -t wav - | sudo /home/pi/PiFmRds/src/pi_fm_rds -audio - &
#		sleep 2
#		clear
#		BAN
#        	echo -e "$G$On$EC"
#		Main
	fi
}

function Check_Process() {
	P0=`ps -C sox |awk '{print $4}'`
	P1=`echo $P0 |awk '{print $2}'`
}

function Kill_FM() {
	Check_Process
	if [ "$P1" = "sox" ]; then
		clear
		BAN
		echo -e "$W[$R-$W]$Y Kill FM Station$EC"
#		kill all xterm
#		sudo pkill pi_fm_rds
		pkill sox
		sleep 2
	fi
}

function cap_traps() {
	case $Place in
		"Flag") EXIT;;
		"MAIN") Kill_FM; EXIT;;
		"SF") EXIT;;
		"Run") Kill_FM; EXIT;;
	esac
}

RM_SAVE() {
	if [ -f "Default_save.txt" ]; then
		rm -f Default_save.txt
        fi
	if [ -f "save.txt" ]; then
                rm -f save.txt
        fi
}

EXIT() {
	RM_SAVE
	clear
	FLAG
	echo -e "     Thank for using ${G}P${Y}R${R}T$EC"
	sleep 3
	clear
	exit
}

for x in SIGINT SIGHUT INT SIGTSTP; do
	trap_cmd="trap \"cap_traps $x\" \"$x\""
	eval "$trap_cmd"
done
FLAG
sleep 4
Main
