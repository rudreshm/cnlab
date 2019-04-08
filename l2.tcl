set ns [new Simulator]

set ftra [open tracefile.tr w]
$ns trace-all $ftra

set fnam [open namfile.nam w]
$ns namtrace-all $fnam

set cw1 [open wind1.tr w]
set cw2 [open wind2.tr w]

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n1 $n3 15Mb 5ms DropTail
$ns duplex-link $n2 $n3 15Mb 5ms DropTail
$ns duplex-link $n3 $n4 15Mb 5ms DropTail
$ns duplex-link $n4 $n5 15Mb 5ms DropTail
$ns duplex-link $n6 $n4 15Mb 5ms DropTail

$ns duplex-link-op $n3 $n1 orient left-up
$ns duplex-link-op $n3 $n2 orient left-down
$ns duplex-link-op $n3 $n4 orient right
$ns duplex-link-op $n4 $n5 orient right-up
$ns duplex-link-op $n4 $n6 orient right-down


set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n6 $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2
set tcp3 [new Agent/TCPSink]
$ns attach-agent $n5 $tcp3

$ns connect $tcp0 $tcp1
$ns connect $tcp2 $tcp3

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp0
set telnet1 [new Application/Telnet]
$telnet1 attach-agent $tcp2

$ns at 0.1 "$ftp1 start"
$ns at 0.1 "$telnet1 start"
$ns at 2.5 "$ftp1 stop"
$ns at 2.5 "$ftp1 stop"

proc plotWindow { tcpSource file } {
	global ns
	set counter 0.01
	set currenttime [$ns now]
	set cwnd [ $tcpSource set cwnd_ ]
	puts $file "$currenttime $cwnd"
	$ns at [expr $currenttime+$counter] "plotWindow $tcpSource $file" 
}

$ns at 0.0 "plotWindow $tcp0 $cw1"
$ns at 0.0 "plotWindow $tcp2 $cw2"

proc finish { } {
	global ns ftra fnam cw1 cw2
	$ns flush-trace
	close $ftra
	close $fnam
	close $cw1
	close $cw2
	exec nam namfile.nam &
	exec xgraph wind1.tr &
	exec xgraph wind2.tr &
	exit 0
}
$ns at 2.6 "finish"
$ns run
