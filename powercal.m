% powercal.m
%
% This code generates a single RF pulse, for the purpose of transmit power calibration.
%
% Author:  Cornelius von Morze
%
% (c)2017 The Regents of the University of California. All Rights Reserved.


%ping the ESG
[st,st_desc,q_res]=agt_query(io,'*idn?')

%define RF waveform; as configured, generates a 500us hard pulse
points = 500;      % Number of points in the waveform
cycles = 0;  % Determines the frequency offset from the carrier
phaseInc = 2*pi*cycles/points;
phase = phaseInc * [0:points-1];
Iwave = cos(phase);
Qwave = sin(phase);
IQdata=Iwave+j*Qwave;
IQdata(end)=0;

%set RF center frequency
[status, status_description ] = agt_sendcommand( io, '*RST');
%[status,status_description]=agt_sendcommand(io,'SOURce:FREQuency 127775600');
[status,status_description]=agt_sendcommand(io,'SOURce:FREQuency 32133625');

%set RF power in dBm
[status,status_description] = agt_sendcommand(io, 'POWer -26');

%upload waveform, with 1MHz sampling
[status,status_description]=agt_waveformload(io,IQdata,'agtsample',1e6,'play','normscale')

%set TTL trigger parameters for pulse execution; as configured, trigger is set for a TR of 5 seconds
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG EXT');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:EXT EPT1');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:TYPE SING');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:RETR OFF');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:EXT:SLOPe POS');
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:EXT:DEL:STAT ON')
[status, status_description ] = agt_sendcommand( io, 'RAD:ARB:TRIG:EXT:DEL 4.998');

%configure RF blanking of the ESG
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MARK:CLE:ALL "agtsample", 1' )
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MARK:SET "agtsample", 1, 1, 499, 0' );
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MARK:SET "agtsample", 2, 500, 500, 0' );
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MPOL:MARK1 POS' );
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MDES:PULS M1' );
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MPOL:MARK2 NEG' );
[ status, status_description ] = agt_sendcommand( io, 'RAD:ARB:MDES:PULS M2' );

%turn on output
[ status, status_description ] = agt_sendcommand( io, 'OUTPut:STATe ON' );
