#!/bin/sh
nodelist="$(seq 5 2 21)"
#nodelist="2"
#echo $nodelist
submi=0;process=0;collect=1;tmp=0;

	beginndir=$(pwd)
	selgpu=1;
	#echo "$beginndir"
	for ct1 in $nodelist; do
		#echo "in node Landauer$ct1"
		#pbsnodes Landauer$ct1
		cd $beginndir
		if [ $process -eq 1 ]; then
			mkdir tk$ct1
			cp sample/* tk$ct1
			cd tk$ct1
			sed -i "s/1e-9/"$ct1"e-10/g" 2010Ikeda.mx3
			sed -i "s/#PBS -N 2010Ikeda/#PBS -N tk$ct1/g" template_gpu.sh
			sed -i "s/table_out/table_tk$ct1/g" template_gpu.sh	
			if (( $selgpu % 3 == 1 )); then
				sed -i "s/8.8/0/g" template_gpu.sh
			elif (( $selgpu % 3 == 2 )); then
				sed -i "s/8.8/1/g" template_gpu.sh
			else
				sed -i "s/8.8/2/g" template_gpu.sh
			fi
			((selgpu=selgpu+1))
			if [ $selgpu -eq 10 ]; then
				selgpu=1;
			else
				true
			fi
			echo "done tk$ct1"
		elif [ $submi -eq 1 ]; then
			cd $beginndir
			cd tk$ct1
			qsub template_gpu.sh
			echo "submitted tk$ct1"
		elif [ $tmp -eq 1 ]; then
			cd $beginndir
			rm -rf hext$ct1/
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
                cp tk$ct1/2010Ikeda.out/table_* results
                echo "move result tk$ct1 done"
        else
                true
        fi

	done

