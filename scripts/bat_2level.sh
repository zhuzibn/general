#!/bin/sh
#nodelist:FLTSTT sweep
nodelist1="$(seq 0 1 30)"
#nodelist="2"
#echo $nodelist
submi=0;process=1;collect=0;tmp=0;
#nodelist2:FLTSHE sweep
nodelist2="$(seq 0 1 30)"
	beginndir=$(pwd)
	selgpu=1;
	#echo "$beginndir"
for ct1 in $nodelist1; do
	for ct2 in $nodelist2; do
		cd $beginndir
		if [ $process -eq 1 ]; then
			mkdir flt$ct1\_$ct2
			cp sample/* flt$ct1\_$ct2
			cd flt$ct1\_$ct2
			sed -i "s/stt77/"$ct1"e-2/g" ConfigParams.m
			sed -i "s/she77/"$ct2"e-1/g" ConfigParams.m
			sed -i "s/final/"final$ct1\_$ct2"/g" main.m
			sed -i "s/runn/flt$ct1\_$ct2/g" PBSScript
			echo "done flt$ct1\_$ct2"
		elif [ $submi -eq 1 ]; then
			cd $beginndir
			cd flt$ct1\_$ct2
			qsub PBSScript
			echo "submitted flt$ct1\_$ct2"
		elif [ $tmp -eq 1 ]; then
			cd $beginndir
			rm -rf hext$ct1/norelax/
		else
			true
		fi
	if [ $collect -eq 1 ]; then
                cd $beginndir
                if [ -d "results" ]; then
                echo "folder result already exist"
                else
                mkdir results
                fi
                cp flt$ct1\_$ct2/final* results
                echo "move result flt$ct1\_$ct2 done"
        else
                true
        fi

	done
done
