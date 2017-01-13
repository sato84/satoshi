#!/usr/bin/sh
################################################
#                                              #
#  Usage: ./permconvert.sh Directory           #
#                                              #
#  Code by syuu.satoshi@gmail.com  1/13/2017   #
#                                              #
################################################
i=0
j=2
pre=
set -x
while [[ $j -le 10 ]]
do
	##check if it's a directory or a file
	if [[ -d "$1" ]]
	then
		list[$i]=`ls -ld $1 | awk '{print $1}' | cut -c $j`
	elif [[ -f "$1" ]]
	then
		list[$i]=`ls -l $1 | awk '{print $1}' | cut -c $j`
	else
		print "Usage: ./permconvert.ksh Directory"
		exit 1		
	fi

	##check every character of the permission
	#    if [[ ${list[$i]} == "-" ]]
	#	 then
	#       echo "-"
	#    else
	#        echo ${list[$i]}
	#    fi

	##convert to digit
	case ${list[$i]} in
		r ) perm[$i]=`expr 2 \* 2` ;;
		w ) perm[$i]=`expr 2 \* 1` ;;
		- ) perm[$i]=0 ;;
		* ) perm[$i]=1 ;;
	esac

	(( i=i+1 ))
	(( j=j+1))
done
set +x
##deal with the special permission
if [[ ${list[2]} == s ]]
then
	pre=4
fi
if [[ ${list[5]} == s ]]
then
	pre=2
fi
if [[ ${list[8]} == t ]]
then
	pre=1
fi

##give a shit
u=`expr ${perm[0]} + ${perm[1]}	+ ${perm[2]}`
g=`expr ${perm[3]} + ${perm[4]}	+ ${perm[5]}`
o=`expr ${perm[6]} + ${perm[7]}	+ ${perm[8]}`

##this is the permission it have
perm=`echo $pre$u$g$o`
print $perm
exit 0
