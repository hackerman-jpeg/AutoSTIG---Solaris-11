#!/bin/bash

##################################
##
##	TITLE: SOLARIS 11 MANUAL STIG SCRIPT
##
##	DESCRIPTION: Automating the MANUAL checks from DISA
##
##	AUTHOR: hackerman.jpeg
##
##	VERSION: 20181024
##
##################################
##
##		TO DO:
##			1.
##			2.
##			3.
##
##################################
##
##  Output and GREP file
##
##################################
##
# Current Date
##
today=`date '+%Y-%m-%d'`
##
##################################
##
# Get the hostname
##
hostname=$(uname -n)
##
##################################
##
# Get the current timestamp
##
timestamp=$(date '+%m:%Y-%H:%M')
##
##################################
##
# Ouput file creation
##
GrepFile="Results_${hostname}_${today}_${timestamp}.txt"
##
#################################
##
#	What is the zone?
##
	MainZone=$(zonename)
##
############################################################################################################################
##
##															BEGIN MAIN CHECK CONTENT
##
############################################################################################################################

echo  '
__        __   _
\ \      / /__| | ___ ___  _ __ ___   ___
 \ \ /\ / / _ \ |/ __/ _ \| \_ \ _ \ / _ \
	\ V  V /  __/ | (_| (_) | | | | | |  __/
	 \_/\_/ \___|_|\___\___/|_| |_| |_|\___|'

sleep 1
clear

echo '
 ____        _            _
/ ___|  ___ | | __ _ _ __(_)___
\___ \ / _ \| |/ _` | |__| / __|
__ _) | (_) | | (_| | |  | \__ \
|____/ \___/|_|\__,_|_|  |_|___/
	 / \  _   _| |_ ___
  / _ \| | | | __/ _ \
 / ___ \ |_| | || (_) |
 /_/__ \_\__,_|\__\___/
 / ___|_   _|_ _/ ___|
 \___ \ | |  | | |  _
  ___) || |  | | |_| |
 |____/ |_| |___\____|
 '

sleep 2

################# Progress Bar ################

prog() {
    local w=80 p=$1;  shift
    # create a string of spaces, then change them to dots
    printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /.};
    # print those dots on a fixed-width space plus the percentage etc.
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*";
}
# test loop
for x in {1..100} ; do
    prog "$x" still working...
    sleep .5   # do some work here
done ; echo

##################################################	V-49621  ##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-49621 - Cat I - The operating system must configure auditing to reduce the likelihood of storage capacity being exceeded" | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null


# Main check contents

if [ "$MainZone" = "global" ]; then
{
	if [[ $(pfexec auditconfig -getplugin | grep "p_fsize=4M") ]]; then
		echo "PASS" >> $GrepFile
	else
		echo "FINDING" >> $GrepFile
	fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi


##################################################	V-47875  ##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47875 - Cat I - The operating system must protect audit information from unauthorized modification." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
for filename in /var/*/audit/* ;
do
    if (( $(stat -c "%a" "$filename") < "640" ))
    then
        perm640="FALSE"
    else
        perm640="TRUE"
    fi
done
    if [ $perm640 = FALSE ]; then
        echo "FINDING" >> $GrepFile
    else
        echo "PASS" >> $GrepFile
    fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi
##################################################	V-47879  ##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47879 - Cat I - The operating system must protect audit information from unauthorized deletion." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
for filename in /var/*/audit/*
do
    if (( $(stat -c "%a" "$filename") > "640" ))
    then
        echo "FINDING" >> $GrepFile
    else
        echo "PASS" >> $GrepFile
    fi
done
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-61025  ##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-61025 - Cat I - X displays must not be exported to the world." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
if (xhost | grep enabled > /dev/null);
then
	echo "PASS" >> $GrepFile
else
	echo "FINDING" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-47995  ##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47995 - Cat I - SNMP communities, users, and passphrases must be changed from the default." | tee -a $GrepFile  > /dev/null

echo | tee -a $GrepFile  > /dev/null

# Main check contents


if [ "$MainZone" = "global" ]; then
{
if grep -v '#' /etc/net-snmp/snmp/snmpd.conf | grep 'community' | egrep 'public|private|0|0392a0|1234|2read|4changes|ANYCOM|Admin|C0de|CISCO|CR52401|IBM|ILMI|Intermec|NoGaH$@!|OrigEquipMfr|PRIVATE|PUBLIC|Private|Public|SECRET|SECURITY|SNMP|SNMP_trap|SUN|SWITCH|SYSTEM|Secret|Security|Switch|System|TENmanUFactOryPOWER|TEST|access|adm|admin|agent|agent_steal|all|all private|all public|apc|bintec|blue|c|cable-d|canon_admin|cc|cisco|community|core|debug|default|dilbert|enable|field|field-service|freekevin|fubar|guest|hello|hp_admin|ibm|ilmi|intermec|internal|l2|l3|manager|mngt|monitor|netman|network|none|OPENview|pass|password|pr1v4t3|proxy|publ1c|read|read-only|read-write|readwrite|red|regional|rmon|rmon_admin|ro|root|router|rw|rwa|s!a@m#n$p%c|san-fran|sanfran|scotty|secret|security|seri|snmp|snmpd|snmptrap|solaris|sun|superuser|switch|system|tech|test|test2|tiv0li|tivoli|trap|world|write|xyzzy|yellow|default' > /dev/null ;
then
 	echo "FINDING" >> $GrepFile
 else
 	echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

#change path to the find variable

##################################################	V-47805	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47805 - Cat II - The audit system must be configured to audit file deletions." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command1=$(pfexec auditconfig -getnaflags | grep active | sed s/'active user default audit flags ='// | grep fd)
command2=$(pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep fd)
command3=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command1}" ] || [ -z "${command2}" ] || [ -z "${command3}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi


##################################################	V-47807	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47807 - Cat II - The audit system must be configured to audit account creation." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command4=$(pfexec auditconfig -getflags | grep active | sed s/'active user default audit flags ='// | grep ps)
command5=$(pfexec auditconfig -getnaflags | grep active | sed s/'active user default audit flags ='// | grep ps)
command6=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command4}" ] || [ -z "${command5}" ] || [ -z "${command6}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-47809	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47809 - Cat II - The audit system must be configured to audit account modification." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command7=$(pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep ps)
command8=$(pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep ps)
command9=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command7}" ] || [ -z "${command8}" ] || [ -z "${command9}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-47811	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47811 - Cat II - The operating system must automatically audit account disabling actions." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command10=$(pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep ps)
command11=$(pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep ps)
command12=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command10}" ] || [ -z "${command11}" ] || [ -z "${command12}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-47813	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47813 - Cat II - The operating system must automatically audit account termination." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command13=$(pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep ps)
command14=$(pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep ps)
command15=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command13}" ] || [ -z "${command14}" ] || [ -z "${command15}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-47815	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47815 - Cat II - The operating system must ensure unauthorized, security-relevant configuration changes detected are tracked." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command16=$(pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep as)
command17=$(pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep as)
command18=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command16}" ] || [ -z "${command17}" ] || [ -z "${command18}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-47817	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47817 - Cat II - The audit system must be configured to audit all administrative, privileged, and security actions." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command19=$(pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep as)
command20=$(pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep as)
command21=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command19}" ] || [ -z "${command20}" ] || [ -z "${command21}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-47821	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47821 - Cat II - The audit system must be configured to audit all discretionary access control permission modifications." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command22=$(pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep fm)
command23=$(pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep fm)
command24=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command22}" ] || [ -z "${command23}" ] || [ -z "${command24}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

##################################################	V-47823	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47823 - Cat II - The audit system must be configured to audit the loading and unloading of dynamic kernel modules." | tee -a $GrepFile  > /dev/null

echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
command25=$(pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep as)
command26=$(pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep as)
command27=$(pfexec auditconfig -getpolicy | grep active | grep argv)

if [ -z "${command25}" ] || [ -z "${command26}" ] || [ -z "${command27}" ]; then
    echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi

##################################################	V-47863	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47863 - Cat II - The operating system must shut down by default upon audit failure (unless availability is an overriding concern)" | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
if pfexec auditconfig -getpolicy | grep ahlt > /dev/null;
then
	echo "PASS" >> $GrepFile
else
	echo "FINDING" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi
##################################################	V-47857	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47857 - Cat II - The operating system must allocate audit record storage capacity." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# Review the current audit file space limitations

if [ "$MainZone" = "global" ]; then
{
V47871=$(pfexec auditconfig -getplugin audit_binfile | grep "p_minfree" | awk -F';' '{print $5}'| awk -F'=' '{print $2}')
V47872=$(zfs get compression rpool/VARSHARE | grep -v "VALUE" | awk '{print $3}' )
V47873=$(zfs get quota rpool/VARSHARE | grep -v "VALUE" | awk '{print $3}')
V47874=$(zfs get reservation rpool/VARSHARE | grep -v "VALUE" | awk '{print $3}')

if [[ "${V47871}" >=*2* ]] || [["${V47872}" = "*off*" ]] || [["${V47873}" = "*none*" ]] || [[ "${V47874}" = "*none*" ]]; then
    echo "FINDING" >> $GrepFile && echo $V47871 >> $GrepFile && echo $V47872 >> $GrepFile && echo $V47873 >> $GrepFile && echo $V47874 >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi

##################################################	V-47869	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47869 - Cat II - The operating system must protect audit information from unauthorized read access." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# Check Directory perms

if [ "$MainZone" = "global" ]; then
{
V478691=$(stat -c %a /var/*/audit/)
V478692=$(stat -c %U /var/*/audit/)
V478693=$(stat -c %G /var/*/audit/)

if [ "$V478691" -gt "640" ] || [ "$V478692" != "root" ] || [ "$V478693" != "root" ]; then
    echo "FINDING" >> $GrepFile  && echo $V478691 >> $GrepFile && echo $V478692 >> $GrepFile  && echo $V478693 >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi
##################################################	V-47881	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47881 - Cat II - The System packages must be up to date with the most recent vendor updates and security fixes" | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

##################################################	V-47883	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47883 - Cat II - The system must verify that package updates are digitally signed." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(pkg property | grep signature-policy | awk '{print $2}') = "verify" ]]; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-47885	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47885 - Cat II - The operating system must protect audit tools from unauthorized access." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents


# use "pkg verify"
# Same as V-47925, V-47885, V-47889, V-47887. V-47891

echo "MANUAL" >> $GrepFile

##################################################	V-47887	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47887 - Cat II - The operating system must protect audit tools from unauthorized modification." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# use "pkg verify"
# Same as V-47925, V-47885, V-47889, V-47887. V-47891

echo "MANUAL" >> $GrepFile

##################################################	V-47889	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47889 - Cat II - The operating system must protect audit tools from unauthorized deletion." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# use "pkg verify"
# Same as V-47925, V-47885, V-47889, V-47887. V-47891

echo "MANUAL" >> $GrepFile

##################################################	V-47891	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47891 - Cat II - System packages must be configured with the vendor-provided files, permissions, and ownerships." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# use "pkg verify"
# Same as V-47925, V-47885, V-47889, V-47887. V-47891

echo "MANUAL" >> $GrepFile

##################################################	V-47919	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47919 - Cat II - The rpcbind service must be configured for local only services." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(svcprop -p config/local_only network/rpc/bind) = "true" ]]; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-47923	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47923 - Cat II - The operating system must employ automated mechanisms, per organization-defined frequency, to detect the addition of unauthorized components/devices into the operating system." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Check package like STIG says but also ask if they have automated software for detecting device plugin. Native solaris is a pain to try and detect USB insertion and
# have any meaningful data in audit logs, so more than likely not.

# use "pkg verify"

# Same as V-47925, V-47885, V-47889, V-47887. V-47891


echo "MANUAL" >> $GrepFile

##################################################	V-47925	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47925 - Cat II - The operating system must be configured to provide essential capabilities." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# use "pkg verify" and ensure they have no authorized software installed.

# Same as V-47925, V-47885, V-47889, V-47887. V-47891

# Echoing as not a finding, because if you are in the system and this check runs, then "essential capabilities" exist.

echo "PASS" >> $GrepFile

##################################################	V-47927	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47927 - Cat II - The operating system must employ automated mechanisms to prevent program execution in accordance with the organization-defined specifications" | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# Ask if there is an automated method required to prevent program execution, i.e. ACLS, etc.

echo "MANUAL" >> $GrepFile


##################################################	V-59829	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-59829 - Cat II - All run control scripts must have no extended ACLs." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (ls -lL /etc/rc* /etc/init.d | grep "+" > /dev/null) ; then
  echo "FINDING" >> $GrepFile
else
 echo "PASS" >> $GrepFile
fi

##################################################	V-59833	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-59833 - Cat II - Run control scripts library search paths must contain only authorized paths." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# Use find /etc/rc* /etc/init.d -type f -print | xargs grep LD_LIBRARY_PATH

# ??? What are we even looking for here.... why not echo LD variable to see if it's set because it shouldnt be set anyway...

echo "MANUAL" >> $GrepFile

##################################################	V-59835	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-59835 | - Cat II - Run control scripts lists of preloaded libraries must contain only authorized paths." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents


# find /etc/rc* /etc/init.d -type f -print | xargs grep LD_PRELOAD

# ???? I didn't know we used LD_preload anymore....not sure here either what we're looking for

echo "MANUAL" >> $GrepFile

##################################################	V-59837	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-59837 - Cat II - Run control scripts must not execute world writable programs or scripts." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

ls -l /etc/init.d/* /etc/rc* | tr '\011' ' ' | tr -s ' ' | cut -f 9,9 -d " " > RunScripts

find / -perm -002 -type f > WorldFiles

sort RunScripts > out1
sort WorldFiles > out2

join out1 out2 > joined3

if [[ -s joined3 ]] ; then
echo "FINDING" >> $GrepFile && cat joined3 >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

rm -r RunScripts
rm -r WorldFiles
rm -r out1
rm -r out2
rm -r joined3


##################################################	V-59843	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-59843 - Cat II - System start-up files must only execute programs owned by a privileged UID or an application." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (stat -c "%U" /etc/rc*/ | egrep -v 'root|sys|bin'); then
  echo "FINDING" >> $GrepFile
else
 echo "PASS" >> $GrepFile
fi

##################################################	V-61003	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-61003 - Cat II - Any X Windows host must write .Xauthority files." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# MANUAL check, use: echo $XAUTHORITY to view path for key, then cd into directory where they are stored for all users
# and ensure with SA that these are authorized users if xwindowing is used.

echo "MANUAL" >> $GrepFile

##################################################	V-61023	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-61023 - Cat II - The .Xauthority files must not have extended ACLs." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (ls -lL /tmp/gd*/* | grep "+" > /dev/nul) ; then
  echo "FINDING" >> $GrepFile
else
 echo "PASS" >> $GrepFile
fi

##################################################	V-61029	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-61029 - Cat II - The .Xauthority utility must only permit access to authorized hosts." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Same as check 61003. CD into the XAUTHORITY dir (usually /tmp/gdm...) and ensure users listed are authorized

echo "MANUAL" >> $GrepFile

##################################################	V-61031	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-61031 - Cat II - X Window System connections that are not required must be disabled." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Ask SA if xwindowing is requirement use: ps -ef | grep X to see if running.

echo "MANUAL" >> $GrepFile


##################################################	V-47929	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47929 - Cat II - The graphical login service provides the capability of logging into the system using an X-Windows type interface from the console. If graphical login access for the console is required, the service must be in local-only mode." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(svcprop -p options/tcp_listen svc:/application/x11/x11-server > /dev/null ) = "true" ]]; then
  echo "FINDING" >> $GrepFile
else
 echo "PASS" >> $GrepFile
fi

# If FINDING, Ask SA if requirement or not.


##################################################	V-61027	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-61027 - Cat II - .Xauthority or X*.hosts (or equivalent) file(s) must be used to restrict access to the X server." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (echo $XAUTHORITY); then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

# If path returned then appropriate files are being used.


##################################################	V-47935	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47935 - Cat II - TCP Wrappers must be enabled and configured per site policy to only allow access by approved hosts and services." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Check wrap status

V479351=$(inetadm -p | grep tcp_wrappers | awk -F'=' '{print $2}')
V479352=$(find / -name "cron.deny" | wc -l)
V479353=$(find / -name "cron.allow" | wc -l)

if [[ "${V479351}" = "FALSE" ]] || [[ "${V479352}" != "1" ]] || [[ "${V479353}" != "1" ]]; then
echo "FINDING" >> $GrepFile && echo $V479351 >> $GrepFile && echo $V479352 >> $GrepFile && echo $V479353 >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

##################################################	V-47943	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47943 - Cat II - User passwords must be changed at least every 56 days." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (grep "MAXWEEKS=" /etc/default/passwd | grep -v "#" |  grep "8"); then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-47953	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47953 - Cat II - The operating system must enforce minimum password lifetime restrictions." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (grep "MINWEEKS=" /etc/default/passwd | grep -v "#" |  grep "1"); then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-48079	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48079 - Cat II - User accounts must be locked after 35 days of inactivity." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(useradd -D | xargs -n 1 | grep inactive |awk -F= '{ print $2 }') = "35" ]] ; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-48083	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48083 - Cat II - The operating system must manage information system identifiers for users and devices by disabling the user identifier after 35 days of inactivity." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(useradd -D | xargs -n 1 | grep inactive | awk -F= '{ print $2 }') = "35" ]] ; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-48085	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48085 - Cat II - Emergency accounts must be locked after 35 days of inactivity." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(useradd -D | xargs -n 1 | grep inactive | awk -F= '{ print $2 }') ]] ; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-48125	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48125 - Cat II - Unauthorized use of the at or cron capabilities must not be permitted." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

V481251=$(wc -l /etc/cron.d/at.allow | awk '{ print $1 }')
V481252=$(find / -name "cron.deny" | wc -l )
V481253=$(find / -name "at.deny" | wc -l )

if [[ "${V481251}" != "0" ]] || [[ "${V481252}" = "1" ]] || [[ "${V481253}" = "1" ]]; then
echo "FINDING" >> $GrepFile && echo $V481251  && echo $V481252  && echo $V481253
else
echo "PASS"
fi


##################################################	V-48135	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48135 - Cat II - The operating system must provide the capability for users to directly initiate session lock mechanisms." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(gsettings get org.gnome.desktop.lockdown disable-lock-screen) = "false" ]]; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-48147	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48147 - Cat II - The operating system must prevent remote devices that have established a non-remote connection with the system from communicating outside of the communication path with resources in external networks." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v481471=$(profiles -p RestrictOutbound info | grep "name=" | awk -F'=' '{print $2}')
v481472=$(profiles -p RestrictOutbound info | grep "desc=" | awk -F'=' '{print $2}')
v481473=$(profiles -p RestrictOutbound info | grep "limitpriv=" | awk -F'=' '{print $2}')


if [[ "${v481471}" = "RestrictOutbound" ]] && [[ "${v481472}" = "Restrict Outbound Connections" ]] && [[ "${v481473}" = "zone,!net_access" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v481471 >> $GrepFile && echo $v481472 >> $GrepFile && echo $v481473 >> $GrepFile
fi

##################################################	V-48181	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48181 - Cat II -The system must not respond to broadcast ICMP echo requests." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _respond_to_echo_broadcast -co current ip) = "0" ]]; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

# fix text: ipadm set-prop -p _respond_to_echo_broadcast=0 ip

##################################################	V-48193	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48193 - Cat II -The system must set strict multihoming." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v481931=$(ipadm show-prop -p _strict_dst_multihoming -co current ipv4)
v481932=$(ipadm show-prop -p _strict_dst_multihoming -co current ipv6)


if [[ "${v481931}" = "1" ]] && [[ "${v481932}" = "1" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v481931 >> $GrepFile && echo $v481932 >> $GrepFile
fi

# Fix text:
# ipadm set-prop -p hostmodel=strong ipv4
# ipadm set-prop -p hostmodel=strong ipv6

##################################################	V-48207	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48207 - Cat II - The system must set maximum number of half-FINDING TCP connections to 4096." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _conn_req_max_q0 -co current tcp) = "4096" ]]; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

##################################################	V-48217	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48217 - Cat II - The system must disable network routing unless required." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (routeadm -p | egrep "routing |forwarding" | grep enabled); then
  echo "FINDING" >> $GrepFile
else
 echo "PASS" >> $GrepFile
fi

##################################################	V-48225	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48225 - Cat II - The operating system must configure the information system to specifically prohibit or restrict the use of organization-defined functions, ports, protocols, and/or services." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482251=$(svcs -x ipfilter | grep online)
v482252=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')


if [[ "${v482251}" ]] && [[ "${v482252}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482251 >> $GrepFile && echo $v482252 >> $GrepFile
fi

# Review firewall configs with the SA
#fix: svcadm enable ipfilter

##################################################	V-48231	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48231 - Cat II - The operating system must use organization-defined replay-resistant authentication mechanisms for network access to privileged accounts." | tee -a $GrepFile  > /dev/null

echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482311=$(svcs -x ipfilter | grep online)
v482312=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')


if [[ "${v482311}" ]] && [[ "${v482312}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482311 >> $GrepFile && echo $v482312 >> $GrepFile
fi

#################################################	V-48237	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48237 - Cat II - The operating system must use organization-defined replay-resistant authentication mechanisms for network access to non-privileged accounts." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482371=$(svcs -x ipfilter | grep online)
v482371=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')


if [[ "${v482371}" ]] && [[ "${v482372}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482371 >> $GrepFile && echo $v482372 >> $GrepFile
fi

#################################################	V-48239	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48239 - Cat II - The operating system must employ strong identification and authentication techniques in the establishment of non-local maintenance and diagnostic sessions." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482391=$(svcs -x ipfilter | grep online)
v482392=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')


if [[ "${v482391}" ]] && [[ "${v482392}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482391 >> $GrepFile && echo $v482392 >> $GrepFile
fi

#################################################	V-48241	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48241- Cat II - The operating system must employ cryptographic mechanisms to protect the integrity and confidentiality of non-local maintenance and diagnostic communications." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482411=$(svcs -x ipfilter | grep online)
v482412=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')

if [[ "${v482411}" ]] && [[ "${v482412}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482411 >> $GrepFile && echo $v482412 >> $GrepFile
fi

#################################################	V-48187	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48187 - Cat II - The operating system must use mechanisms for authentication to a cryptographic module meeting the requirements of applicable federal laws, Executive orders, directives, policies, regulations, standards, and guidance for such authentication." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
if [[ $(cryptoadm list fips-140 | grep -c "is disabled") = "0" ]]; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi
}
else "NOT APPLICABLE" >> $GrepFile
fi
#################################################	V-48235	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48235 - Cat II - The boundary protection system (firewall) must be configured to deny network traffic by default and must allow network traffic by exception (i.e., deny all, permit by exception)." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482351=$(svcs -x ipfilter | grep online)
v482352=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')

if [[ "${v482351}" ]] && [[ "${v482352}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482351 >> $GrepFile && echo $v482352 >> $GrepFile
fi

#################################################	V-48233	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48233 - Cat II - The boundary protection system (firewall) must be configured to only allow encrypted protocols to ensure that passwords are transmitted via encryption." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482331=$(svcs -x ipfilter | grep online)
v482332=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')

if [[ "${v482331}" ]] && [[ "${v482332}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482331 >> $GrepFile && echo $v482332 >> $GrepFile
fi


#################################################	V-48229	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48229 - Cat II - The operating system must implement host-based boundary protection mechanisms for servers, workstations, and mobile devices." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482291=$(svcs -x ipfilter | grep online)
v482292=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')

if [[ "${v482291}" ]] && [[ "${v482292}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482291 >> $GrepFile && echo $v482292 >> $GrepFile
fi

#################################################	V-48227	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48227 - Cat II - The operating system must disable the use of organization-defined networking protocols within the operating system deemed to be nonsecure except for explicitly identified components in support of specific operational requirements. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482271=$(svcs -x ipfilter | grep online)
v482272=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')

if [[ "${v482271}" ]] && [[ "${v482272}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482271 >> $GrepFile && echo $v482272 >> $GrepFile
fi


#################################################	V-48183	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48183 - Cat II - The operating system must employ FIPS-validate or NSA-approved cryptography to implement digital signatures. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
if [[ $(cryptoadm list fips-140 | grep -c "is disabled") = "0" ]]; then
  echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi
#################################################	V-48179	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48179 - Cat II - The operating system must protect the integrity of transmitted information. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask how they are encrypting network traffic.

#################################################	V-48175	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48175 - Cat II - The operating system must employ cryptographic mechanisms to recognize changes to information during transmission unless otherwise protected by alternative physical measures. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask how they are encrypting network traffic.

#################################################	V-48171	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48171 - Cat II - The operating system must maintain the integrity of information during aggregation, packaging, and transformation in preparation for transmission. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask how they are encrypting network traffic.

#################################################	V-48167	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48167 - Cat II - The operating system must protect the confidentiality of transmitted information. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask how they are encrypting network traffic.

#################################################	V-48223	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48223 - Cat II - The operating system must use cryptography to protect the integrity of remote access sessions. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482231=$(svcs -x ipfilter | grep online)
v482232=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')

if [[ "${v482231}" ]] && [[ "${v482232}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482231 >> $GrepFile && echo $v482232 >> $GrepFile
fi

#################################################	V-48219	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48219 - Cat II - The operating system must block both inbound and outbound traffic between instant messaging clients, independently configured by end users and external service providers. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482=$(svcs -x ipfilter | grep online)
v482192=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')

if [[ "${v482}" ]] && [[ "${v482192}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482 >> $GrepFile && echo $v482192 >> $GrepFile
fi

#################################################	V-48215	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48215 - Cat II - The operating system must enforce requirements for remote connections to the information system. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

v482151=$(svcs -x ipfilter | grep online)
v482152=$(ipfstat -io | egrep 'block out log all keep state keep frags|pass in log quick proto tcp from any to any port = ssh keep state|block in log all|block in log from any to 255.255.255.255/32|block in log from any to 127.0.0.1/32')

if [[ "${v482151}" ]] && [[ "${v482152}" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile && echo $v482151 >> $GrepFile && echo $v482152 >> $GrepFile
fi

#################################################	V-48191	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48191 - Cat II - The operating system must prevent internal users from sending out packets which attempt to manipulate or spoof invalid IP addresses. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

if [ "$MainZone" = "global" ]; then
{
if [[ $(dladm show-linkprop -p protection -o VALUE | grep "mac-nospoof") ]] && [[ $(dladm show-linkprop -p protection -o possible | grep "restricted") ]] && [[ $(dladm show-linkprop -p protection -o possible | grep "ip-nospoof") ]] && [[ $(dladm show-linkprop -p protection -o possible | grep "dhcp-nospoof") ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi

#################################################	V-48163	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48163 - Cat II - The operating system must employ cryptographic mechanisms to prevent unauthorized disclosure of information during transmission unless otherwise protected by alternative physical measures. " | tee -a $GrepFile  > /dev/nulll
echo | tee -a $GrepFile  > /dev/null

# could be MANUAL...but these are the big ones. Unencrypted or insecure FTP maybe too...?

ps -ef | egrep 'telnet|smb|rsh|rlogin|vsftp|FTP' | grep -v grep

if [ $?  -eq "0" ] ; then
 echo "FINDING" >> $GrepFile
else
 echo "PASS" >> $GrepFile
fi

# these processes should be behind firewall or controlled...check for:

#ps -ef | egrep 'finger|authd|netdump|netdump-server|nfs|rwhod|sendmail|yppasswdd|ypserv|ypxfrd' | grep -v grep

#if [ $?  -eq "0" ] ; then
# echo "FINDING" >> $GrepFile
#else
# echo "PASS" >> $GrepFile
#fi

#################################################	V-48161	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48161 - Cat II - The operating system must maintain the confidentiality of information during aggregation, packaging, and transformation in preparation for transmission. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# could be MANUAL...but these are the big ones. Unencrypted or unsecure FTP maybe too...?

ps -ef | egrep 'telnet|smb|rsh|rlogin|vsftp|FTP' | grep -v grep

if [ $?  -eq "0" ] ; then
 echo "FINDING" >> $GrepFile
else
 echo "PASS" >> $GrepFile
fi

# these processes should be behind firewall or controlled...check for:

#ps -ef | egrep 'finger|authd|netdump|netdump-server|nfs|rwhod|sendmail|yppasswdd|ypserv|ypxfrd' | grep -v grep

#if [ $?  -eq "0" ] ; then
# echo "FINDING" >> $GrepFile
#else
# echo "PASS" >> $GrepFile
#fi


#################################################	V-72827	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-72827 - Cat II - Wireless network adapters must be disabled. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(dladm show-wifi) = "" ]]; then
echo "NOT APPLICABLE" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

# Turn to MANUAL instead of FINDING?

#################################################	V-48159	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48159 - Cat II - The operating system must use cryptography to protect the confidentiality of remote access sessions. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

ps -ef | egrep 'telnet|rsh|rlogin|vsftp|FTP' | grep -v grep

if [ $?  -eq "0" ] ; then
 echo "FINDING" >> $GrepFile
else
 echo "PASS" >> $GrepFile
fi

# these processes should be behind firewall or controlled...check for:

#ps -ef | egrep 'finger|authd|netdump|netdump-server|nfs|rwhod|sendmail|yppasswdd|ypserv|ypxfrd' | grep -v grep

#if [ $?  -eq "0" ] ; then
# echo "FINDING" >> $GrepFile
#else
# echo "PASS" >> $GrepFile
#fi

#################################################	V-48157	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48157 - Cat II - The operating system must use cryptographic mechanisms to protect and restrict access to information on portable digital media. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents
# TODO: enhance check with removable device variables if possible.

if [ "$MainZone" = "global" ]; then
{
	if (rmformat | grep "No removables" > /dev/null); then
	echo "PASS" >> $GrepFile
	elif (rmformat | grep "logical node" > /dev/null); then
		echo "MANUAL" >> $GrepFile
	fi
}
else echo "MANUAL" >> $GrepFile
fi
#################################################	V-48141	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48141 - Cat II - The operating system must protect the integrity of transmitted information. " | tee -a $GrepFile  > /dev/null\
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (svcs svc:/network/ipsec/policy:default | grep "online"); then
echo "PASS" >> $GrepFile
else echo "FINDING" >> $GrepFile
fi

#################################################	V-48137	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48137 - Cat II -    The sticky bit must be set on all world writable directories. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

find / \( -fstype nfs -o -fstype cachefs -o -fstype autofs \
   -o -fstype ctfs -o -fstype mntfs -o -fstype objfs \
   -o -fstype proc \) -prune -o -type d \( -perm -0002 \
   -a ! -perm -1000 \) -ls > sbitOUT

sbitOUT=(cat sbitOUT)

if [[ -s sbitOUT ]]; then
	echo "FINDING" >> $GrepFile && cat sbitOUT >> $GrepFile
else
	echo "PASS" >> $GrepFile
fi

rm -r sbitOUT

#################################################	V-48129	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48129 - Cat II - Permissions on user . (hidden) files must be 750 or less permissive. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

for dir in \
`logins -ox | awk -F: '($8 == "PS") { print $6 }'`; do
find ${dir}/.[A-Za-z0-9]* \! -type l \
\( -perm -20 -o -perm -02 \) -ls > 750OUT
done

if [[ -s 750OUT ]]; then
	echo "FINDING" >> $GrepFile && cat 750OUT >> $GrepFile
else
	echo "PASS" >> $GrepFile
fi

rm -r 750OUT

#################################################	V-48097	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48097 - Cat II - All home directories must be owned by the respective user assigned to it in /etc/passwd. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

export IFS=":"; logins -uxo | while read user uid group gid gecos home rest;
	do result=$(find ${home} -type d -prune \! -user $user -print 2>/dev/null);
if [ ! -z "${result}" ]; then
echo "FINDING" >> $GrepFile
else echo "PASS" >> $GrepFile
fi
done

#################################################	V-48095	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48095 - Cat II - Duplicate User IDs (UIDs) must not exist for users within the organization. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

dupLogin=$( logins -d)

if [[ -z "$dupLogin" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48091	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48091 - Cat II - Duplicate UIDs must not exist for multiple non-organizational users. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

dupLogin=$( logins -d)

if [[ -z "$dupLogin" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48081	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48081 - Cat II - Duplicate Group IDs (GIDs) must not exist for multiple groups. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

var48081=$(awk -F: '{print $3}' /etc/group | sort | uniq -d)

if [ -z $var48081 ]; then
 echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile echo $var48081 >> $GrepFile
fi

#################################################	V-48073	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48073 - Cat II - Duplicate user names must not exist. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

var48073=$(awk -F: '{print $1}' /etc/passwd | sort | uniq -d)

if [ -z $var48073]; then
 echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile && echo $var48073 >> $GrepFile
fi

#################################################	V-48069	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48069 - Cat II - Duplicate group names must not exist. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

var48069=$(awk -F: '{print $1}' /etc/group | sort | uniq -d)

if [ -z $var48069 ]; then
 echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile && echo $var48069 >> $GrepFile
fi
#################################################	V-48063	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48063 - Cat II - World-writable files must not exist. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

find / \( -fstype nfs -o -fstype cachefs -o -fstype autofs \
-o -fstype ctfs -o -fstype mntfs -o -fstype objfs \
-o -fstype proc \) -prune -o -type f -perm -0002 -print > WWFout

WWFout=(cat WWFout)

 if [[ -z "$WWFout" ]]; then
 echo "PASS" >> $GrepFile
 else
echo "FINDING" >> $GrepFile && cat WWFout >> $GrepFile
fi

rm -r WWFout

#################################################	V-48039	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48039 - Cat II - The operating system must have no unowned files." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

 find / \( -fstype nfs -o -fstype cachefs -o -fstype autofs \
-o -fstype ctfs -o -fstype mntfs -o -fstype objfs \
-o -fstype proc \) -prune \( -nouser -o -nogroup \) -ls > UNLISTED

UNLISTED=(cat UNLISTED)

if [ -s UNLISTED ]; then
	echo "FINDING" >> $GrepFile && cat UNLISTED
else
	echo "PASS" >> $GrepFile
fi

rm -r UNLISTED


#################################################	V-48031	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48031 - Cat II - The operating system must protect the audit records resulting from non-local accesses to privileged accounts and the execution of privileged functions. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
	if [[ $(find /var/*/audit/*  ! -perm 640) ]]; then

	        echo "FINDING" >> $GrepFile
	    else
	        echo "PASS" >> $GrepFile
	    fi
}
else echo "NOT APPLICABLE" >> $GrepFile
fi
#################################################	V-48029	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48029 - Cat II - The operator must document all file system objects that have non-standard access control list settings. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

find / \( -fstype nfs -o -fstype cachefs -o -fstype autofs \
-o -fstype ctfs -o -fstype mntfs -o -fstype objfs \
-o -fstype proc \) -prune -o -acl -ls > PROBLEMacl

UNLPROBLEMaclISTED=(cat PROBLEMacl)

if [ -s PROBLEMacl ]; then
	echo "FINDING" >> $GrepFile && cat PROBLEMacl >> $GrepFile
else
	echo "PASS" >> $GrepFile
fi

rm -r PROBLEMacl

#################################################	V-48021	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48021 - Cat II - Process core dumps must be disabled unless needed. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

coreadm | grep enabled | grep -v "logging" > LOGGINGout

LOGGINGout=(cat LOGGINGout)

if [[ -s LOGGINGout ]]; then
	echo "FINDING" >> $GrepFile && cat LOGGINGout >> $GrepFile
else
	echo "PASS" >> $GrepFile
fi

rm -r LOGGINGout

# fix text:
# coreadm -d global
# coreadm -d process
# coreadm -d global-setid
# coreadm -d proc-setid
# coreadm -e log

#################################################	V-48019	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48019 - Cat II - The centralized process core dump data directory must be owned by root. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(coreadm | grep "global core file pattern" | awk '{print $5}') ]]; then
coread48019=$(coreadm | grep "global core file pattern" | awk '{print $5}')
else
coread48019="FAIL"
fi

if [ ${coread48019} != "FAIL" ]; then
{
if [[ $(stat -c %U $coread48019) = "root" ]]; then
 echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi
}
else echo "FINDING" >> $GrepFile
fi

#################################################	V-48017	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48017 - Cat II - The centralized process core dump data directory must be group-owned by root, bin, or sys. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(coreadm | grep "global core file pattern" | awk '{print $5}') ]]; then
coread48017=$(coreadm | grep "global core file pattern" | awk '{print $5}')
else
coread48017="FAIL"
fi

if [ ${coread48017} != "FAIL" ]; then
{
if [[ -z $(stat -c %U $coread48017 | egrep -v 'root|sys|bin') ]]; then
 echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi
}
else echo "FINDING" >> $GrepFile
fi

#################################################	V-48015	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48015 - Cat II - The centralized process core dump data directory must have mode 0700 or less permissive. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(coreadm | grep "global core file pattern" | awk '{print $5}') ]]; then
coread48015=$(coreadm | grep "global core file pattern" | awk '{print $5}')
else
coread48015="FAIL"
fi

if [ ${coread48015} != "FAIL" ]; then
{
if [[ $(stat -c %a $coread48015) -le "700" ]]; then
 echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi
}
else echo "FINDING" >> $GrepFile
fi

#################################################	V-48025	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48025 - Cat II - The system must implement non-executable program stacks. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
	if [[ $(sxadm status -p nxstack | cut -d: -f2) = "enabled.all" ]]; then
	v480251="PASS"
	else
	v480251="FINDING"
	fi

	cat /etc/system | grep "noexec_user_stack=1" >/dev/null 2>&1
	if [ "$?" != "0" ] ; then
	   v480252="FINDING"
	else
	   v480252="PASS"
	fi

	if [[ "${v480251}" = "PASS" ]] && [[ "${v480252}" = "PASS" ]]; then
	echo "PASS" >> $GrepFile
	else
		echo "FINDING" >> $GrepFile
	fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi

# fix text: set noexec_user_stack=1 >>/etc/system

#################################################	V-48013	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48013 - Cat II - Kernel core dumps must be disabled unless needed. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
if [[ $(dumpadm | grep "Savecore enabled") = "Savecore enabled  : yes" ]]; then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi

#################################################	V-48011	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48011 - Cat II - The kernel core dump data directory must be owned by root." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
dumpadm | grep directory > dumpadmOUT.txt

dumpadmOUT=$(awk '{print $3}' dumpadmOUT.txt)

if [[ $(stat -c %U $dumpadmOUT) = "root" ]]; then
 echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi
rm -r dumpadmOUT*



#################################################	V-48009	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48009 - Cat II - The kernel core dump data directory must be group-owned by root. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

dumpadm | grep directory > dumpadmOUT.txt

dumpadmOUT=$(awk '{print $3}' dumpadmOUT.txt)

if [[ $(stat -c %G $dumpadmOUT) = "root" ]]; then
 echo "PASS" >> $GrepFile
else
 echo "FINDING" >> $GrepFile
fi

rm -r dumpadmOUT*

#################################################	V-48007	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48007 - Cat II - The kernel core dump data directory must have mode 0700 or less permissive. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ $(coreadm | grep "global core dumps" | awk '{print $4}') = "enabled" ]; then
{
corevar2=$(coreadm | grep "global core file pattern" | awk '{print $5}')
    if (( $(stat -c "%a" "$corevar2") > "0700" )); then
        echo "FINDING" >> $GrepFile
    else
        echo "PASS" >> $GrepFile
    fi
}
else echo "FINDING" >> $GrepFile
fi

#################################################	V-47977	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47977 - Cat II - The operating system must conduct backups of user-level information contained in the operating system per organization-defined frequency to conduct backups consistent with recovery time and recovery point objectives. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask SA if conducting regular backups of data

#################################################	V-47975	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47975 - Cat II - The operating system must conduct backups of system-level information contained in the information system per organization-defined frequency to conduct backups that are consistent with recovery time and recovery point objectives." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask SA if conducting regular backups of data

#################################################	V-47987	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47987 - Cat II - A file integrity baseline must be created, maintained, and reviewed on at least weekly to determine if unauthorized changes have been made to important system files located in the root file system. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ -d "/var/adm/log/bart*" ]; then
	echo "PASS" >> $GrepFile
else
	echo "FINDING" >> $GrepFile
fi

# The reason I am not doing the rest is because this is an SA task for cont. monitoring. Not for an SCA.
## bart create > /var/adm/log/bartlogs/[new manifest filename]
#Compare the new report to the previous report to identify any changes in the system baseline.
## bart compare /var/adm/log/bartlogs/[baseline manifest filename> /var/adm/log/bartlogs/[new manifest filename]
#Examine the BART report for changes. If there are changes to system files in /etc that are not approved, this is a finding.

#################################################	V-47985	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47985 - Cat II - The operating system must synchronize internal information system clocks with a server that is synchronized to one of the redundant United States Naval Observatory (USNO) time servers or a time server designated for the appropriate DoD network (NIPRNet/SIPRNet), and/or the Global Positioning System (GPS). " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

# If Global zone, NTP must be on.

if  [[ $(svcs -Ho state ntp) = "disabled" ]]; then
		NTPstatus="NTP-Off"
	else
		NTPstatus="NTP-On"
fi

grep_on_file () {
if (cat /etc/inet/ntp.conf | grep -v "*" | egrep -i '.gov|.mil' > /dev/nul); then
echo "PASS" >> $GrepFile
elif (cat /etc/inet/ntp.conf | grep -v "*" | grep "maxpoll" > /dev/nul); then
echo "FINDING" >> $GrepFile
else echo "FINDING" >> $GrepFile
fi
}

if [[ "$MainZone" = "global" ]] && [[ "$NTPstatus" = "NTP-Off" ]]; then
	echo "FINDING" >> $GrepFile
else
	grep_on_file

fi


#################################################	V-47983	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47983 - Cat II - Direct logins must not be permitted to shared, default, application, or utility accounts. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask SA if they have service accounts and if so ensure they are documented. No root direct login, must use SU, etc.

#################################################	V-47973	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47973 - Cat II - The operating system must conduct backups of operating system documentation including security-related documentation per organization-defined frequency to conduct backups that is consistent with recovery time and recovery point objectives. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask about backup procedures and ensure they are backing up?

#################################################	V-47969	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47969 - Cat II - The operating system must prevent the execution of prohibited mobile code. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents
# Check Java plugin state (0=disabled, 1=enabled per usual)

if [ $(cat /export/home/*/.mozilla/firefox/*/prefs.js | grep "user" | grep "javascript" | grep "false")] && [ $(cat /export/home/*/.mozilla/firefox/*/prefs.js | grep "user" | grep "java" | grep "0") ]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi


#################################################	V-49625	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-49625 - Cat II - The operating system must employ PKI solutions at workstations, servers, or mobile computing devices on the network to create, manage, distribute, use, store, and revoke digital certifiCates. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# If PKI certs generated nativly, # pktool list  command may produce finding and if certs active then not finding, otherwise FINDING.

#################################################	V-47963	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47963 - Cat II - The operating system must prevent non-privileged users from circumventing malicious code protection capabilities. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents


# McAfee is only approved antivirus, others don't matter. If it's not running, it is a finding regardless.
# The below commented out check is simply a note to see if the folder exists. Merely for notes sake
# https://kc.mcafee.com/resources/sites/MCAFEE/content/live/PRODUCT_DOCUMENTATION/26000/PD26745/en_US/readme_vscl_UNIX_for_Engine.pdf

#if [ -d "/opt/mcafee" ]; then
#echo "exists"
#else
#echo "Not exists"
#fi

if (ps aux | egrep 'mcafee|uvscan'); then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-47959	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47959 - Cat II - The operating system must employ malicious code protection mechanisms at workstations, servers, or mobile computing devices on the network to detect and eradicate malicious code transported by electronic mail, electronic mail attachments, web accesses, removable media, or other common means. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

#if [ -d "/opt/mcafee" ]; then
#echo "exists"
#else
#echo "Not exists"
#fi

if (ps aux | egrep 'mcafee|uvscan'); then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-47955	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47955 - Cat II -    The operating system must have malicious code protection mechanisms at system entry and exit points to detect and eradicate malicious code transported by electronic mail, electronic mail attachments, web accesses, removable media, or other common means." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

#if [ -d "/opt/mcafee" ]; then
#echo "exists"
#else
#echo "Not exists"
#fi

if (ps aux | egrep 'mcafee|uvscan'); then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-47965	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/nul
echo "V-47965 - Cat II - The operating system must employ automated mechanisms to determine the state of system components with regard to flaw remediation using the following frequency: continuously, where HBSS is used; 30 days, for any additional internal network scans not covered by HBSS; and annually, for external scans by Computer Network Defense Service Provider (CNDSP). " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask SA if HBSS is installed and running and applied to this box

#################################################	V-47941	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47941 - Cat II - The operating system must back up audit records at least every seven days onto a different system or system component than the system or component being audited. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask SA if they backup the audit records and ensure there is documentation of how, when, where, etc.

#################################################	V-47907	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47907 - Cat II - The operating system must verify the correct operation of security functions in accordance with organization-defined conditions and in accordance with organization-defined frequency (if periodic verification). " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ -z "$(ls -A /opt/scc/Results/)" ]; then
   echo "FINDING" >> $GrepFile
else
   echo "PASS" >> $GrepFile
fi

# This could be MANUAL as well...Ask to see most recent SCAP reports for the systems if FINDING. Many groups output results in different folders.

#################################################	V-47903	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47903 - Cat II - The operating system must identify potentially security-relevant error conditions. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null


# Main check contents

if [ -z "$(ls -A /opt/scc/Results/)" ]; then
   echo "FINDING" >> $GrepFile
else
   echo "PASS" >> $GrepFile
fi

# This could be MANUAL as well...Ask to see most recent SCAP reports for the systems if FINDING. Many groups output results in different folders.

#################################################	V-47899	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47899 - Cat II - The operating system must manage excess capacity, bandwidth, or other redundancy to limit the effects of information flooding types of denial of service attacks. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Memory Capping / thread

if [[ $(rcapstat | grep "not active") ]] || [[ $(rctladm zone.max-processes | grep "deny") ]] || [[ $(dladm show-linkprop -p max-bw | awk '{print $5}' | grep "-") ]]; then
   echo "FINDING" >> $GrepFile
else
   echo "PASS" >> $GrepFile
fi

#################################################	V-47841	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47841 - Cat II - The systems physical devices must not be assigned to non-global zones. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (zonecfg -z global info | grep dev > /dev/nul); then
   echo "FINDING" >> $GrepFile
else
   echo "PASS" >> $GrepFile
fi

#################################################	V-47831	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47831 - Cat II - The auditing system must not define a different auditing level for specific users. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
	for i in $(compgen -u); do
	   if (userattr audit_flags $i > /dev/nul); then
	auditSTATUS="FINDING"
	else
	audiSTATUS="PASS"
	fi
	done

	if [[ $(echo $auditSTATUS) = "FINDING" ]]; then
	echo "FINDING" >> $GrepFile
	else
	echo "PASS" >> $GrepFile
	fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi

#################################################	V-47819	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47819 - Cat II - The audit system must be configured to audit login, logout, and session initiation." | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
if (pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep lo) &&  (pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep lo) && (pfexec auditconfig -getpolicy | grep active | grep argv); then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi

#################################################	V-47825	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47825 - Cat II - The audit system must be configured to audit failed attempts to access files and programs. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
if (pfexec auditconfig -getflags | grep active |sed s/'active user default audit flags ='// | grep fa) &&  (pfexec auditconfig -getnaflags | grep active |sed s/'active user default audit flags ='// | grep fa) && (pfexec auditconfig -getpolicy | grep active | grep argv); then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi

#################################################	V-47827	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47827 - Cat III - The operating system must protect against an individual falsely denying having performed a particular action. In order to do so the system must be configured to send audit records to a remote audit server. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [ "$MainZone" = "global" ]; then
{
if (pfexec auditconfig -getplugin | grep audit_syslog | grep "inactive") &&  (grep audit.notice /etc/syslog.conf) && (grep audit.notice /etc/rsyslog.conf); then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi
}
else echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile
fi
#################################################	V-47931	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47931 - Cat III - Generic Security Services (GSS) must be disabled. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(svcs -Ho state svc:/network/rpc/gss) = "online" ]]; then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

#################################################	V-47933	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47933 - Cat III - Systems services that are not required must be disabled. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Cont. Monitoring check. Ensure services are documented. Because this check is written neutrally, there can be no finding given.

#################################################	V-47949	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47949 - Cat III - The operating system must automatically terminate temporary accounts within 72 hours. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# "Temporary Account" is ambiguous, and thus impossible to script definitely. Making MANUAL.

# ASK FOR TEMP ACCOUNT NAMES:
#  logins -aox |awk -F: '($14 != "0") {print}' | $TEMPACCOUNTNAME

#################################################	V-48075	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48075 - Cat II - The value mesg n must be configured as the default setting for all users. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (grep "^mesg" /etc/.login) || (grep "^mesg" /etc/profile) || [[ $(mesg) = "is y" ]]; then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

#################################################	V-48151	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48151 - Cat III - The operating system must limit the number of concurrent sessions for each account to an organization-defined number of sessions. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Is there a max amount of sessions for users? If no, then swell.
# If yes, then ensure being enforced: # projects -l  | grep "attribs" | grep "project.max-tasks="

#################################################	V-48165	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48165- Cat III - The system must disable directed broadcast packet forwarding. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _forward_directed_broadcasts -co current ip) = "0" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48169	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48169 - Cat III- The system must not respond to ICMP timestamp requests. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _respond_to_timestamp -co current ip) = "0" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48173	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48173 |- Cat III - The system must not respond to ICMP broadcast timestamp requests. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _respond_to_timestamp -co current ip) = "0" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48177	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48177 - Cat III - The system must not respond to ICMP broadcast netmask requests." | tee -a $GrepFile  > /dev/nul
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _respond_to_address_mask_broadcast -co current ip) = "0" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48185	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48185 - Cat II - The system must not respond to multicast echo requests. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _respond_to_echo_multicast -co current ipv4) = "0" ]] && [[ $(ipadm show-prop -p _respond_to_echo_multicast -co current ipv6) = "0" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48189	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48189 - Cat III - The system must ignore ICMP redirect messages. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _ignore_redirect -co current ipv4) = "1" ]] && [[ $(ipadm show-prop -p _ignore_redirect -co current ipv6) = "1" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48197	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48197 - Cat III - The system must disable ICMP redirect messages. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p send_redirects -co current ipv4) = "on" ]] || [[ $(ipadm show-prop -p send_redirects -co current ipv6) = "on" ]] || [[ $(ipadm show-prop -p send_redirects -co current ipv4) > "0" ]] || [[ $(ipadm show-prop -p send_redirects -co current ipv6) > "0" ]]; then
   echo "FINDING" >> $GrepFile
else
   echo "PASS" >> $GrepFile
fi


#################################################	V-48201	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48201 - Cat III - The system must disable TCP reverse IP source routing. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _rev_src_routes -co current tcp) = "0" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48211	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48211 - Cat III - The system must set maximum number of incoming connections to 1024. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if [[ $(ipadm show-prop -p _conn_req_max_q -co current tcp) < "1024" ]]; then
echo "PASS" >> $GrepFile
else
echo "FINDING" >> $GrepFile
fi

#################################################	V-48221	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48221 - Cat III - The system must implement TCP Wrappers. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

for svc in `inetadm | awk '/svc:\// { print $NF }'` ; do
val=`inetadm -l ${svc} | grep -c tcp_wrappers=TRUE`
if [ ${val} -eq 1 ]; then
tcpWRAP=1
fi
done

if [ -d "/etc/hosts.deny" ]; then
  hostDENY=1
fi

if [ -d "/etc/hosts.allow" ]; then
  hostALLOW=1
fi

if [[ $(inetadm -p | grep tcp_wrappers) = "tcp_wrappers=FALSE" ]] || [[ $(echo $tcpWRAP) != "1" ]] || [[ $(echo $hostDENY) != "1" ]] || [[ $(echo $hostALLOW) != "1" ]]; then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

#################################################	V-48213	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48213 - Cat III - The system must prevent local applications from generating source-routed packets. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "NOT APPLICABLE" >> $GrepFile >> $GrepFile

# Old, and not solaris applicable,  and checked with previous checks in this STIG.

#################################################	V-48155	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48155 - Cat III - The operating system must employ cryptographic mechanisms to protect information in storage. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Is file system encryption required? If yes...do check below (This check does not apply to the root, var, share, swap or dump datasets):

# zfs list
# zfs get encryption [filesystem]

#################################################	V-48153	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48153 - Cat III - The operating system must protect the confidentiality and integrity of information at rest. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Is file system encryption required? If yes...do check below (This check does not apply to the root, var, share, swap or dump datasets):

# zfs list
# zfs get encryption [filesystem]

#################################################	V-48149	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48149 - Cat III - The operating system must employ cryptographic mechanisms to prevent unauthorized disclosure of information at rest unless otherwise protected by alternative physical measures. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Is file system encryption required? If yes...do check below (This check does not apply to the root, var, share, swap or dump datasets):

# zfs list
# zfs get encryption [filesystem]

#################################################	V-48145	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48145 - Cat III - The operating system must use cryptographic mechanisms to protect the integrity of audit information. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (zfs get encryption rpool/VARSHARE | grep "off" > /dev/nul ); then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

#################################################	V-48105	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48105 - Cat III- All user accounts must be configured to use a home directory that exists. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# pwck issues, check MANUALly.
#################################################	V-48059	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48059 - Cat III - All valid SUID/SGID files must be documented. " | tee -a $GrepFile  > /dev/null

echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Check and ensure with SA all are approved/documented...this check is ambiguous:
# find / \( -fstype nfs -o -fstype cachefs -o -fstype autofs \
#-o -fstype ctfs -o -fstype mntfs -o -fstype objfs \
#-o -fstype proc \) -prune -o -type f -perm -4000 -o \
#-perm -2000 -print

#################################################	V-48037	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48037 - Cat III - The operating system must have no files with extended attributes. " | tee -a $GrepFile  > /dev/null

echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (find / \( -fstype nfs -o -fstype cachefs -o -fstype autofs \
-o -fstype ctfs -o -fstype mntfs -o -fstype objfs \
-o -fstype proc \) -prune -o -xattr -ls > /dev/nul ); then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

#################################################	V-48023	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48023 - Cat III - Address Space Layout Randomization (ASLR) must be enabled. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (sxadm info -p | grep aslr | grep enabled > /dev/nul ); then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

#################################################	V-48005	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-48005 - Cat III - System BIOS or system controllers supporting password protection must have administrator accounts/passwords configured, and no others. (Intel) " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# check with SA for BIOS password.
#################################################	V-47979	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47979- Cat III - The system must not have any unnecessary accounts. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (getent passwd | egrep -i 'games|news|goher|ftp|lp' > /dev/nul ); then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi

#################################################	V-47951	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47951 - Cat III - Intrusion detection and prevention capabilities must be architected and implemented to prevent non-privileged users from circumventing such protections. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask SA about IDS if installed and running

#################################################	V-47947	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47947 - Cat III - The operating system must protect information obtained from intrusion-monitoring tools from unauthorized access, modification, and deletion. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask SA about IDS if installed and running

#################################################	V-47945	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47945 - Cat III - The operating system must employ automated mechanisms to alert security personnel of any organization-defined inappropriate or unusual activities with security implications. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Ask SA about IDS if installed and running

#################################################	V-47937	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47937 - Cat II - All MANUAL editing of system-relevant files shall be done using the pfedit command, which logs changes made to the files. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

echo "MANUAL" >> $GrepFile

# Advise SA to use pfedit instead of normal methods. THis check too is dumb.

#################################################	V-47839	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47839 - Cat III - The audit system must identify in which zone an event occurred. " | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (pfexec auditconfig -getpolicy | grep active | grep $(echo zonename) > /dev/nul ); then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi


#################################################	V-47837	##################################

# Echo check and description into both output files

echo | tee -a $GrepFile  > /dev/null
echo "V-47837 - Cat III - The audit system must maintain a central audit trail for all zones" | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Main check contents

if (pfexec auditconfig -getpolicy | grep active | grep perzone > /dev/nul ); then
echo "FINDING" >> $GrepFile
else
echo "PASS" >> $GrepFile
fi


################################################ THE END OF CHECKS ############################
echo | tee -a $GrepFile  > /dev/null
echo "############################################### The End - Here are you Tallied Results ###############################################" | tee -a $GrepFile  > /dev/null
echo | tee -a $GrepFile  > /dev/null

# Tally up total FINDINGS

totalOPEN=$(grep -c -w "FINDING" $GrepFile)
	echo "Total FINDINGS:" $totalOPEN >> $GrepFile
	echo | tee -a $GrepFile  > /dev/null
# Tally up total PASSed checks

totalPASS=$(grep -c -w "PASS" $GrepFile)
	echo "Total FINDINGS:" $totalPASS >> $GrepFile
	echo | tee -a $GrepFile  > /dev/null
# Tally up total NA checks

totalNA=$(grep -c -w "NOT APPLICABLE" $GrepFile)
	echo "Total FINDINGS:" $totalNA >> $GrepFile
	echo | tee -a $GrepFile  > /dev/null
# Tally up total MANUAL checks

totalMANUAL=$(grep -c -w "MANUAL" $GrepFile)
	echo "Total FINDINGS:" $totalMANUAL >> $GrepFile
	echo | tee -a $GrepFile  > /dev/null


#########
clear

echo
echo "All Done"
echo
echo "Output file is located in the directory you ran this script from."
echo
echo "Have a swell day!"
echo


##############################################################################################################################
#
#															THE END
#
##############################################################################################################################
exit()
