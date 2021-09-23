# Linpol - Linux Privilege Escalation Script

Linpol is a small script that search for possible ways to escalate privileges on Linux.

Just execute `linpol.sh` in a Linux system and the script will be automatically executed.

## Quick start

Clone the repo in your victim machine and run the script using the following command.

`./linpol.sh time`

Changing time with the amount of minutes you want to evaluate the cron process.

## Basic information

The script search for the most common ways of privilege escalation.
### What the script is looking for
- SUID permissions
- Linux Groups
- Vulnerable writable files
- Cron process
- Capabilities


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
