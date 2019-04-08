set ns [new Simulator -multicast on]

set tf [open mcast.tr w]
$ns trace-all $tf

set fd [open mcast.nam w]
$ns namtrace-all $fd

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$ns duplex-link $n0 $n2  1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2  1.5Mb 10ms DropTail
$ns duplex-link $n2 $n3  1.5Mb 10ms DropTail
$ns duplex-link $n3 $n4  1.5Mb 10ms DropTail
$ns duplex-link $n3 $n7  1.5Mb 10ms DropTail
$ns duplex-link $n4 $n5  1.5Mb 10ms DropTail
$ns duplex-link $n4 $n6  1.5Mb 10ms DropTail

set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

set group1 [Node allocaddr]
set group2 [Node allocaddr]

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

$udp0 set dst_addr_ $group1
$udp0 set dst_port_ 0

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0


set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

$udp0 set dst_addr_ $group2
$udp1 set dst_port_ 0


set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1


set recvr1 [new Agent/Null]
$ns attach-agent $n5 $recvr1
$ns at 1.0 "$n5 join-group $recvr1 $group1"

set recvr2 [new Agent/Null]
$ns attach-agent $n6 $recvr2
$ns at 1.5 "$n6 join-group $recvr2 $group1"

set recvr3 [new Agent/Null]
$ns attach-agent $n7 $recvr3
$ns at 2.0 "$n7 join-group $recvr3 $group1"

set recvr4 [new Agent/Null]
$ns attach-agent $n5 $recvr1
$ns at 2.5 "$n5 join-group $recvr4 $group2"

set recvr5 [new Agent/Null]
$ns attach-agent $n6 $recvr2
$ns at 3.0 "$n6 join-group $recvr5 $group2"

set recvr6 [new Agent/Null]
$ns attach-agent $n7 $recvr3
$ns at 3.5 "$n7 join-group $recvr6 $group2"

$ns at 4.0 "$n5 leave-group $recvr1 $group1"
$ns at 4.5 "$n6 leave-group $recvr2 $group1"
$ns at 5.0 "$n7 leave-group $recvr3 $group1"
$ns at 5.5 "$n5 leave-group $recvr4 $group2"
$ns at 6.0 "$n6 leave-group $recvr5 $group2"
$ns at 6.5 "$n7 leave-group $recvr6 $group2"

$ns at 0.5 "$cbr0 start"
$ns at 9.5 "$cbr0 stop"
$ns at 0.2 "$cbr1 start"
$ns at 9.5 "$cbr1 stop"

$ns at 10.5 "finish"

proc finish {} {
 global ns tf 
 $ns flush-trace
 exec nam mcast.nam &
 close $tf
 #close $fd
 exit 0
}

$ns color 10 red
$ns color 11 green
$ns color 30 purple
$ns color 31 green

#ns duplex-link-op $n0 $n1 orient right
#$ns duplex-link-op $n0 $n1 orient right-up
#$ns duplex-link-op $n0 $n3 orient right-down
#$ns duplex-link-op $n2 $n3 queuepos 0.5
 
$udp0 set fid_ 10
$n0 color red
$n0 label "source1"

$udp1 set fid_ 11
$n1 color green
$n1 label "source2"

$n5 label "receiver1"
$n5 color blue

$n6 label "receiver2"
$n6 color blue

$n7 label "receiver3"
$n7 color blue

$ns set-animation-rate 3.0ms
$ns run



