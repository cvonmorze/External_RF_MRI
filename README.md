# External_RF_MRI
This Matlab code allows the user to control a Agilent RF vector electronic signal generator (ESG) from a PC, for the purpose of generating RF excitation pulses for magnetic resonance imaging (MRI). This is especially useful for equipping a standard "single nucleus" MRI scanner with a supplementary RF transmission channel for enabling heteronuclear MRI experiments. 

The hardware is controlled by sending commands (formatted with syntax of Standard Commands for Programmable Instruments or SCPI), over a General Purpose Input Output (GPIO) / Universal Serial Bus (USB) connection. The user must first obtain necessary hardware and install the Agilent IO Libraries Suite onto the PC running the Matlab code, as well as the Agilent Waveform Download Assistant (v2). Arbitrary waveforms may be downloaded to the ESG and timed with arbitrary offsets with respect to a TTL trigger signal fed to the ESG (i.e. from the MRI system exciter board, for synchronization with a scanner pulse sequence). 

The code has been successfully tested on a Agilent E4438C ESG (option package 601), as described in the publication "In vivo hyperpolarization transfer in a clinical MRI scanner" by von Morze et al.

Author: Cornelius von Morze

(c)2017 The Regents of the University of California. All rights reserved.
