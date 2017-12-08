% pulsepair.m
%
% This code generates two consecutive RF pulses, for the purpose of accomplishing polarization transfers.
%
% Author:  Cornelius von Morze
%
% (c)2017 The Regents of the University of California. All Rights Reserved.


%ping the ESG
[st,st_desc,q_res]=agt_query(io,'*idn?')

%define RF waveform; as is, generates two 500-sample hard pulses with 90-degree RF phase shift, and center-to-center spacing of 3330 samples
points = 3830;      % Number of points in the waveform
Iwave=zeros(1,points);
Qwave=zeros(1,points);
Iwave(1:500)=1;
Qwave(3330:3830)=1;
IQdata=Iwave+j*Qwave;
IQdata(1,end)=0;

%reset ESG
[status, status_description ] = agt_sendcommand( io, '*RST');

%set RF center frequency
%[status,status_description]=agt_sendcommand(io,'SOURce:FREQuency 127775600');
[status,status_description]=agt_sendcommand(io,'SOURce:FREQuency 32131080');

%set RF power in dBm
[status,status_description] = agt_sendcommand(io, 'POWer -26');

%upload waveform; as is, 1MHz sampling produces two 500us hard pulses, with center-to-center spacing of 3.33ms (~1JCH coupling)
[status,status_description]=agt_waveformload(io,IQdata,'agtsample',1e6,'play','normscale')

%set TTL trigger parameters for pulse execution; the timing delay set here establishes the delay between TTL trigger and execution of RF pulses
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG EXT');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:EXT EPT1');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:TYPE SING');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:RETR OFF');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:EXT:SLOPe POS');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:EXT:DEL:STAT ON')
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:EXT:DEL 2.4823');%offset with 8 pulse specsat

%configure RF blanking of the ESG
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MARK:CLE:ALL "agtsample", 1' )
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MARK:SET "agtsample", 1, 500, 3329, 0' );
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MARK:SET "agtsample", 1, 3830, 3830, 0' );
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MPOL:MARK1 NEG' );
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MDES:PULS M1' );

%turn on RF output
[ status, status_description ] = agt_sendcommand( io, 'OUTPut:STATe ON' );
