#! /bin/bash

name=$(whoami)
date=$(date)
TODAY=$(date "+%Y-%m-%d")
GROUPNAME="live_group"
DIRPATH="/var/www/html/Live/"

option1() {
	zip -r "/WebBackups/backup_Intranet.$(date +"%m-%d-%Y %H:%M:%S").zip" /var/www/html/Intranet
	zip -r "/WebBackups/backup_Live.$(date +"%m-%d-%Y %H:%M:%S").zip" /var/www/html/Live
	echo "Intranet and Live directories backed up and stored as zip files in /WebBackups"
}

option2() {
	sudo cp -r -u /var/www/html/Intranet/* /var/www/html/Live
	echo "New content from the Intranet directory copied to the Live directory"
}

option3() {
	sudo bash -c 'ausearch -f /var/www/html/Intranet/ | aureport -f -i > /WebBackups/reportOnIntranet.$(date +"%m-%d-%Y").txt'
	echo "Report generated on changes made to Intranet, stored in /WebBackups using a dated file of type reportOnIntranet"
}

option4() {
	add_user_to_group() {
    	read -p "Enter the username of the person to be added: " username

		# Check if the user exists
        if id "$username"; then
            echo "User '$username' exists."
        else
            echo "User '$username' does not exist. Creating user ..."
            sudo useradd -m -s /bin/bash "$username"
        	sudo passwd "$username"
			echo "User '$username' created successfully."
        fi

    	sudo usermod -aG "$GROUPNAME" "$username"
        echo "User '$username' added to group '$GROUPNAME'."

        # Grant group ownership and permissions on the directory
        sudo chgrp -R "$GROUPNAME" "$DIRPATH"
        sudo chmod -R g+rwX "$DIRPATH"
        echo "Directory '$DIRPATH' is now accessible to group '$GROUPNAME'."
	}
	#call function
	add_user_to_group
}


while [ 1 == 1 ]
do
	echo "***** Menu *****"
	echo "Choose one of these options: "
	echo "1) Create an immediate backup of Intranet and Live"
	echo "2) Immediately transfer new content from Intranet to Live"
	echo "3) Display a log of changes to Intranet (identify users and changes, provide timestamps)"
	echo "4) Add a user (current or new) to the Live group to make changes to the Live directory"
	echo "5) Exit the menu"

	read userInput

	case $userInput in
		1) option1;;
		2) option2;;
		3) option3;;
		4) option4;;
		5) exit;;
		*) echo "Invalid option";;
	esac
done