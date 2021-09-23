#!/bin/bash


#Colours
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c() {
	tput cnorm
	echo -e "[!] Exiting... \n"
	exit 1
}


function scanSuid() {
	echo -e "${red}[!] Listing suid perms... \n"
	echo -e "  Most common interesting suid bins will appear in a green color \n ${end}"
	
	actualDir=$(pwd)	
	cd /	
	arr=($(find \-perm -4000 2>/dev/null))
	
	for i in "${arr[@]}"
	do	
		suid=$(echo "$i" | sed 's/[/]/ /g' | awk '{print $NF}')
		reps=$(grep "^$suid$" $actualDir/resources/suid.txt | wc -l)
		if [[ $reps  -gt 0 ]]
		then
			echo -e "${green}  [\xE2\x9C\x94]  $suid${end}"
		else
			echo "  [x]  $suid"
		fi
	done
	cd $actualDir
	echo -e "\n${red}  [*] TIP --> You can use ${green}https://gtfobins.github.io/#+suid${red} to see how to abuse this suid binaries\n ${end}"
}

function scanGroups(){
	echo -e "${red}[!] Listing user groups... \n"
	echo -e "  Most common interesting groups will appear in a green color \n ${end}"
	
	arr=($(id | sed 's/ /,/g' | sed 's/,/\n/g' | sed 's/(/ /g' | sed 's/)//g'))
	declare -a arrAux
	counter=1
	actualDir=$(pwd)
	
	for i in "${arr[@]}"; do
		valid=1
		if [[ 'counter % 2' -eq 0 ]]; then
			for j in "${arrAux[@]}"; do
				if [[ $i == $j ]]; then
					valid=0
				fi
			done
			
			reps=$(grep "^$i$" $actualDir/resources/groups.txt | wc -l)
			if [[ $valid -eq 1 ]]; then
				if [[ $reps -gt 0 ]]; then
					echo -e "${green}  [\xE2\x9C\x94]  $i${end}"	
				else
					echo -e "  [x]  $i "
				fi
				arrAux=("${arrAux[@]}" $i)
			fi
		fi
		counter=$(( $counter + 1 ))
	done

}

function scanWritable(){
        echo -e "\n\n\n"
	echo -e "${red}[!] Listing interesting writable files in ${blue}./etc${red} directory... \n${end}"
	
	actualDir=$(pwd)
	cd /
	arr=($(find \-writable 2>/dev/null | grep "^./etc"))
	for i in "${arr[@]}"
	do
		noSpaces=$(echo "$i" | sed 's/[/]/ /g')
		count=$(echo "$noSpaces" | grep 'passwd\|shadow' -w | wc -l)	
		
		if [[ $count -gt 0 ]]
		then
			echo -e "${green}  [\xE2\x9C\x94] $i${end}"
			exit 1
		else
			echo -e "  [x] $i "
		fi
	done

	echo -e "\n${red}  [!] Critic directories and files with the name ${blue}passwd${red} or ${blue}shadow${red} will appear in green color \n ${end}"
}



function cronMon(){
	echo -e "\n\n\n"
	echo -e "${red}[!] Listing interesting CRONE process in a ${blue}$1 mins ${red}period... \n${end}"
	counter=$(( $1 * 60 + 1))
	old_process=$(ps -eo command)
	while [ $counter -gt 0 ]; do
		new_process=$(ps -eo command)
		diff <(echo "$old_process") <(echo "$new_process") | grep "[\>\]" | grep -v "kworker" | grep -v "linpol"
		old_process=$new_process
		sleep 1
		counter=$(( $counter - 1 ))
	done
}

function searchCap(){
	echo -e "\n\n\n"
	echo -e "${red}[!] Listing interesting capabilities... \n${end}"
	caps=($(getcap -r / 2>/dev/null))
	counter=1
	for i in "${caps[@]}"; do
		if [[ 'counter % 2' -eq 0 ]]; then
			echo -e "       --> $i"
		else
			echo -e "  [x]  $i "
		fi
		counter=$(( $counter + 1 ))
	done
}


function main(){
	clear
	echo -e "      ${turquoise} _       _       ______   _____  _       ${end}"
	echo -e "      ${turquoise}| |     (_)     (_____ \ / ___ \| |      ${end}"
	echo -e "      ${turquoise}| |      _ ____  _____) ) |   | | |      ${end}"
	echo -e "      ${turquoise}| |     | |  _ \|  ____/| |   | | |      ${end}"
	echo -e "      ${turquoise}| |_____| | | | | |     | |___| | |_____ ${end}"
	echo -e "      ${turquoise}|_______)_|_| |_|_|      \_____/|_______)${end}"
	echo -e "\n\n"	
	if [ -n "$1" ]; then
		scanSuid
		scanGroups
		scanWritable
		cronMon $1
		searchCap
		tput cnorm
	else                                         
		echo -e
		echo -e " ${red}    [!]  You must give us the Cron lapsus time using --> ${green}./linpol${purple} time${red}"
		echo -e "           Changing time word for the number of minutes that you want${end}"
		exit 1
	fi
}


main $1
