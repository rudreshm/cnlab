BEGIN { tcp_dcount=0;
	udp_dcount=0;
	tcp_rcount=0;
	udp_rcount=0;
	}
{
if($1=="d" && $5=="tcp")
	tcp_dcount++;	
if($1=="d" && $5=="cbr")
	udp_dcount++;
if($1=="r" && $5=="tcp")
	tcp_rcount++;	
if($1=="r" && $5=="cbr")
	udp_rcount++;
}
END {
	printf("No of Packets dropped in TCP %d\n",tcp_dcount);
	printf("No of Packets dropped in UDP %d\n",udp_dcount);
	printf("No of Packets received in TCP %d\n",tcp_rcount);
	printf("No of Packets received in UDP %d\n",udp_rcount);
}
	
