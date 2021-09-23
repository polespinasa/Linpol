# Linpol - Linux Privilege Escalation Script

Linpol is a small script that search for possible ways to escalate privileges on Linux.

Just execute `linpol.sh` in a Linux system and the script will be automatically executed.

## Quick start

Just clone the repo in your victim machine and run the script.

## Basic information

The script search for the most common ways of privilege escalation.
### What the script search
- SUID permissions
- Linux Groups
- Vulnerable writable files
- Cron process
- Capabilities


#### Extra
The script looks for cron process in a short time of one minute.
You can change the time by modifying the cronMon function parameter in main function, just change the number "1" with the amount of minutes that you want.
```
function main(){
	tput civis
	clear
	scanSuid
	scanGroups
	scanWritable
	cronMon "1"
	searchCap
	tput cnorm
}
```
