set ns [new Simulator]

set nf [open p3.nam w]
$ns namtrace-all $nf

set nd [open p3.tr w]
$ns trace-all $nd

set ofile [open plot.tr w]

proc finish { } {
global ns nd nf ofile
$ns flush-trace
close $nf
close $nd
close $ofile
exec nam p3.nam &
exec xgraph plot.tr &
exit 0
}

$ns rtproto DV

proc plotg { tcpsrc of } {
global ns 
set t 0.01
set ctime [$ns now]
set cw [ $tcpsrc set cwnd_]
puts $of "$ctime $cw"
$ns at [expr $ctime + $t] "plotg $tcpsrc $of"
}

#create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
      
#create links between the nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n4 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n3 $n5 2Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n4 $n5 orient right-down
$ns duplex-link-op $n3 $n5 orient right-up

$ns queue-limit $n2 $n3 2

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
 
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n4 $tcp1

$ns connect $tcp0 $tcp1

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns rtmodel-at 1.0 down $n1 $n4
$ns rtmodel-at 3.0 up $n1 $n4
$ns at 0.1 "$ftp0 start"
$ns at 4.0 "$ftp0 stop"
$ns at 0.0 "plotg $tcp0 $ofile"
$ns at 5.0 "finish"
$ns run
