#!/bin/bash
#
#

#Make sure the script is run as root

if [ $(whoami) != "root" ];then
echo "Only root can run this script."
  exit 1
fi


BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
CLEAR='\033[0m'
#########################
#########################
#########################

# Get a list of all users
users=$(cut -d: -f1 /etc/passwd) 

#########################
#########################

getent passwd > /tmp/all_users.txt


grep -v "/nologin\|/false"  /tmp/all_users.txt | cut -d: -f1 > /tmp/valid_users.txt 

echo
echo " second level data is pulled from sudoers using the user name\n, possibility of irrelevant garbage with untested names"
echo
echo "these are the users not marked as nologin or /false"


while read -r user;do
  echo  "#############################################################################################################################"
  echo
  grep --color='always' $user /etc/passwd | grep -v "/nologin\|/false" 
  echo
  echo -n  "   "
  printf "$(id $user)"
  echo 
  echo -n  "     " 
  grep $user /etc/sudoers| grep -v "This file MUST be edited with the 'visudo' command as root.\|This preserves proxy settings from user environments of root\|While you shouldn't normally run git as root, you need to with etckeeper\|Per-user preferences; root won't have sensible values for them."
  echo 
  echo "check permission of /etc/passwd :"
  ls -ld /etc/passwd
  echo
  echo "check permission of /etc/shadow :"
  ls -ld /etc/shadow
  echo
  echo "check permission of /var/log :"
  ls -ld /var/log
  echo
  permissions=$(ls -ld /home/$user)
  echo "Home directory permissions: $permissions"


done < /tmp/valid_users.txt
  echo "###############################################################################################################################"


  ################################################
  #
  #
  #  reading all other users that do not belong to the previous criteria
  #
  #  checking if they are disabled users or not
  #
  #
  #  #####probobly should expire accounts but idk if tht will break them, 
  #  some might still be able to be logged into if ssh keys are set,
  #
  #  ^^^^^^^^^^^^^^^^^^^^^^^
  #
  #
  #################################################
  

echo
echo 
echo " these users bo not belong to /bin/bash /bin/zsh /bin/csh"
echo " they probobly should all be locked or expired"
echo "probobly"
echo 

grep -v "/bin/bash\|/bin/zsh\|/bin/csh"  /tmp/all_users.txt | cut -d: -f1 > /tmp/invalid_users.txt

while read -r user; do
  echo
  printf "$BLUE $user $CLEAR"
  echo
  echo -n "   "
  echo $(passwd -S $user) 
  if [ "$(passwd -S "$user" | cut -d " " -f2)" = "P" ]
  then
     declare -u disabled='Disabled : False'
      echo -n "  "
      printf "$RED $disabed $CLEAR"
  else
     declare -u  disabled='Disabled : True'
      echo -n "  "
      printf "$GREEN $disabled $CLEAR"
  fi
echo   
done < /tmp/invalid_users.txt
