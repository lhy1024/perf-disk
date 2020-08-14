if [ $# != 4  ] ; then
echo "USAGE: $0 option instance log_dir perf_func"
exit 1;
fi

# start: bash perf.sh start pd-server /home/lhy1024 funcgraph
# start: bash perf.sh start pd-server /home/lhy1024 iostoop
# close: bash perf.sh close pd-server /home/lhy1024 all

option=$1
instance=$2
pid=$(pidof $instance)
dir=$3
perf=$4

if [[ "$option" == "start" ]];then
	echo "current instance is $instance, current pid is $pid"
	echo "start iotop"
	nohup iotop -ob -d 1 -t &>$dir/iotop.log &
	echo "start pidstat"
	nohup pidstat 1 -t &> $dir/pid.log &
if [[ "$perf" == "funcgraph" ]];then
	echo "start funcgraph"
	nohup perf-tools/bin/funcgraph ext4_sync_file -p $pid &>$dir/funcgraph.log &
fi
if [[ "$perf" == "iosnoop" ]];then
	echo "start iosnoop"
	nohup perf-tools/bin/iosnoop &>$dir/iosnoop.log &
fi
fi

if [[ "$option" == "close" ]];then
	echo "close iotop"
	kill -9 $(ps -aux | grep bin/iotop | grep -v "grep" | awk '{print $2}')
	echo "close pidstat"
	kill -9 $(ps -aux | grep pidstat | grep -v "grep" | awk '{print $2}')
	echo "close funcgraph"
	kill -9 $(ps -aux | grep funcgraph | grep -v "grep" | awk '{print $2}')
	echo "close iosnoop"
	kill -9 $(ps -aux | grep iosnoop | grep -v "grep" | awk '{print $2}')
fi

