set ns [new Simulator]

set tf [open out4.tr w]
$ns trace-all $tf

set nf [open out4.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]

$n0 label "s"
$n1 label "c"

$ns duplex-link $n0 $n1 10Mb 22ms DropTail

$ns duplex-link-op $n0 $n1 orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

$tcp0 set packetSize_ 1500

set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$tcp0 set fid_ 1

$ns color 1 blue

$ns at 0.1 "$ftp0 start"

$ns at 4.5 "$ftp0 stop"

$ns at 5.0 "finish"

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exec nam out4.nam &
	exec awk -f ex5transfer.awk out4.tr &
	exec awk -f ex5convert.awk out4.tr > convert.tr &
	exec xgraph convert.tr -geometry 800*400 -t "bytes_received_at_client" -x "time_in_sec" -y "bytes_in_bps" &
	exit 0
}
$ns run



