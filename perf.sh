# start: bash perf.sh start pd-server /home/lhy1024 funcgraph
# start: bash perf.sh start pd-server /home/lhy1024 iostoop
# close: bash perf.sh close pd-server /home/lhy1024 all
# observe: bash perf.sh observe
# clean: bashe perf.sh clean

observe(){
s=$(ps -aux | grep $1 | grep -v "grep" | awk '{print $2}')
if [ -z "$s" ];then
	echo "$1 is not running"
else
	echo "$1 is running"
fi
}

observe_all(){
observe iotop
observe pidstat
observe funcgraph
observe iosnoop
}

if [ $# == 1 ] ; then
	if [ $1 == "observe" ] ; then
	observe_all
	exit 0;
	fi
	if [ $1 == "clean" ] ; then
	rm -rf /var/tmp/.ftrace-lock
	echo "ftrace-lock is removed"
	exit 0;
	fi
fi

if [ $# != 4  ] ; then
echo "USAGE: $0 option instance log_dir perf_func"
exit 1;
fi

option=$1
instance=$2
pids=$(pidof $instance)
arr=($pids)
pid=${arr[0]}
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

close(){
s=$(ps -aux | grep $1 | grep -v "grep" | awk '{print $2}')
if [ -n "$s" ];then	
echo "close $1"
kill -9 $s
fi
}

if [[ "$option" == "close" ]];then
	close iotop
	close pidstat
	close funcgraph
	close iosnoop
fi

observe_all

