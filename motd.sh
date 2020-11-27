#!/bin/bash
install () {
        # install lsb-release
      	sudo apt install lsb-release
      	# install figlet to enable ASCII art
      	sudo apt install figlet
      	# create directory
      	DIRECTORY=/etc/update-motd.d
      	if [ -d "$DIRECTORY" ]; then
          		echo ":::::: $DIRECTORY exists. ::::::"
			sudo rm -r /etc/update-motd.d/10-uname
      	else
	          	mkdir /etc/update-motd.d
      	fi
      	# create dynamic files
      	sudo touch /etc/update-motd.d/00-header
      	sudo touch /etc/update-motd.d/10-sysinfo
      	sudo touch /etc/update-motd.d/90-footer
      	# make files executable
      	sudo chmod +x /etc/update-motd.d/*
      	# remove MOTD file
      	rm -r /etc/motd
}

header () {
sudo cat << 'EOF' > /etc/update-motd.d/00-header
#!/bin/sh 
[ -r /etc/lsb-release ] ; /etc/lsb-release
 
if [ -z "$DISTRIB_DESCRIPTION" ] ; [ -x /usr/bin/lsb_release ]; then
        # Fall back to using the very slow lsb_release utility
        DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi
 
figlet $(hostname)
printf "\n"
 
printf "Welcome to %s (%s).\n" "$DISTRIB_DESCRIPTION" "$(uname -r)"
printf "\n"
EOF
}

sysinfo () {
sudo cat << 'EOF' > /etc/update-motd.d/10-sysinfo
#!/bin/bash
date=`date`
load=`cat /proc/loadavg | awk '{print $1}'`
root_usage=`df -h / | awk '/\// {print $(NF-1)}'`
memory_usage=`free -m | awk '/Mem:/ { total=$2; used=$3 } END { printf("%3.1f%%", used/total*100)}'`
 
swap_usage=`free -m | awk '/Swap/ { printf("%3.1f%%", $3/$2*100) }'`
users=`users | wc -w`
time=`uptime | grep -ohe 'up .*' | sed 's/,/\ hours/g' | awk '{ printf $2" "$3 }'`
processes=`ps aux | wc -l`
ip=`hostname -I | awk '{print $1}'`
 
echo "System information as of: $date"
echo
printf "System Load:\t%s\tIP Address:\t%s\n" $load $ip
printf "Memory Usage:\t%s\tSystem Uptime:\t%s\n" $memory_usage "$time"
printf "Usage On /:\t%s\tSwap Usage:\t%s\n" $root_usage $swap_usage
printf "Local Users:\t%s\tProcesses:\t%s\n" $users $processes
echo
EOF
}

footer () {
sudo cat << 'EOF' > /etc/update-motd.d/90-footer
#!/bin/sh
[ -f /etc/motd.tail ] ; cat /etc/motd.tail || true
EOF
}

makeinstall () {
	install
	header
	sysinfo
	footer
}
makeinstall

