set ns [new Simulator]
set ftr [open file1.tr w]
$ns trace-all $ftr
set fnam [open file2.nam w]
$ns namtrace-all $fnam

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns queue-limit $n0 $n2 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0

set null [new Agent/Null]
$ns attach-agent $n3 $null

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCPSink]
$ns attach-agent $n3 $tcp1

$ns connect $udp0 $null
$ns connect $tcp0 $tcp1

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp0
set tcp [new Application/FTP]
$tcp attach-agent $tcp0

$ns at 0.5 "$cbr start"
$ns at 0.5 "$tcp start"
$ns at 2.5 "$cbr stop"
$ns at 2.5 "$tcp stop"
$ns at 2.5 "finish"

proc finish {} {
	global ns ftr fnam
	$ns flush-trace
	close $ftr
	close $fnam
	exec nam file2.nam &
	exit 0
		}
$ns run
