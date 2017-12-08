% initializeGPIB.m
%
% This code initializes the GPIB connection.
%
% Author:  Cornelius von Morze
%
% (c)2017 The Regents of the University of California. All Rights Reserved.

io=agt_newconnection('gpib',0,19);
