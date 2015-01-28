#! /bin/bash
echo "${count}"
cat ./hostlist | while read line
do
	arr="${line}"
	list=($arr)
	count=10
	cat /etc/hosts | while read hostline
	do
		arr2="${hostline}"
		list2=($arr2)
		A="${list[0]}"
		B="${list2[0]}"
		if [ "$A" = "$B" ]; then
#			sed -i "s/${list2[1]}/${list[1]}/" ./testfile
			sed -i "/${list2[0]}/d" /etc/hosts
		fi
	done
	echo "${line}" |cat >> /etc/hosts
done
