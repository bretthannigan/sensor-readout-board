EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 750  6950 0    50   ~ 0
.tran 100n 1m \n.meas TRAN Iout PP @r7[i] from=0.1m\n.meas TRAN Vopamp PP V(/Vopamp) from=0.1m\n.meas TRAN Vout PP V(/Vout) from=0.1m\n\n.meas TRAN t1 TRIG V(/Vin) val=0 rise=2 TARG V(/Vin) val=0 rise=3\n.meas TRAN t2 TRIG V(/Vin) val=0 rise=2 TARG @r7[i] val=0 rise=2\n.meas TRAN phase param=‘360*(t2/t1)’
Text Notes 750  7900 0    50   ~ 0
.ac dec 1000 1 100meg \n\n.meas ac dc_gain find vdb(/Vout) at=1\n.meas ac 1k_gain find vdb(/Vout) at=1k\n.meas ac 10k_gain find vdb(/Vout) at=10k\n.meas ac 100k_gain find vdb(/Vout) at=100k​\n\n.meas ac dc_phase find vp(/Vout) at=1\n.meas ac 1k_phase find vp(/Vout) at=1k\n.meas ac 10k_phase find vp(/Vout) at=10k\n.meas ac 100k_phase find vp(/Vout) at=100k
$Comp
L pspice:VSOURCE V2
U 1 1 5F18B7B2
P 2500 4250
F 0 "V2" H 2728 4296 50  0000 L CNN
F 1 "5" H 2728 4205 50  0000 L CNN
F 2 "" H 2500 4250 50  0001 C CNN
F 3 "~" H 2500 4250 50  0001 C CNN
	1    2500 4250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR07
U 1 1 5F18C588
P 2500 5000
F 0 "#PWR07" H 2500 4750 50  0001 C CNN
F 1 "GND" H 2505 4827 50  0000 C CNN
F 2 "" H 2500 5000 50  0001 C CNN
F 3 "" H 2500 5000 50  0001 C CNN
	1    2500 5000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR06
U 1 1 5F18D164
P 2500 2500
F 0 "#PWR06" H 2500 2350 50  0001 C CNN
F 1 "VCC" H 2515 2673 50  0000 C CNN
F 2 "" H 2500 2500 50  0001 C CNN
F 3 "" H 2500 2500 50  0001 C CNN
	1    2500 2500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 5F1DDDA7
P 5250 3000
F 0 "C1" V 5500 2950 50  0000 L CNN
F 1 "20p" V 5400 2900 50  0000 L CNN
F 2 "" H 5288 2850 50  0001 C CNN
F 3 "~" H 5250 3000 50  0001 C CNN
	1    5250 3000
	0    -1   -1   0   
$EndComp
$Comp
L power:VCC #PWR04
U 1 1 5F227886
P 4900 2500
F 0 "#PWR04" H 4900 2350 50  0001 C CNN
F 1 "VCC" H 4915 2673 50  0000 C CNN
F 2 "" H 4900 2500 50  0001 C CNN
F 3 "" H 4900 2500 50  0001 C CNN
	1    4900 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 3250 5500 3250
Wire Wire Line
	5500 3250 5500 3750
Connection ~ 5500 3250
Wire Wire Line
	5500 3000 5500 3250
Wire Wire Line
	5400 3000 5500 3000
Wire Wire Line
	5100 3000 5000 3000
Wire Wire Line
	5500 3750 5300 3750
Connection ~ 5500 3750
Wire Wire Line
	5500 3750 5600 3750
Wire Wire Line
	5900 3750 6650 3750
Wire Wire Line
	6650 3750 6650 4300
Wire Wire Line
	6650 4300 6750 4300
Connection ~ 6650 4300
Wire Wire Line
	6550 4300 6650 4300
Wire Wire Line
	4900 2500 4900 3450
$Comp
L power:VCC #PWR011
U 1 1 5F3E0748
P 6100 2500
F 0 "#PWR011" H 6100 2350 50  0001 C CNN
F 1 "VCC" H 6115 2673 50  0000 C CNN
F 2 "" H 6100 2500 50  0001 C CNN
F 3 "" H 6100 2500 50  0001 C CNN
	1    6100 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 2500 6100 4100
Wire Wire Line
	4100 3850 4000 3850
Wire Wire Line
	3500 3650 3500 3950
Wire Wire Line
	4400 3850 4500 3850
Wire Wire Line
	4500 3850 4700 3850
Connection ~ 4500 3850
Wire Wire Line
	4500 3250 4500 3850
Wire Wire Line
	6300 4500 6500 4500
Wire Wire Line
	6500 4500 6500 4850
Wire Wire Line
	6500 4850 5500 4850
Text Label 6650 4300 2    50   ~ 0
Vout
Text Label 3500 3650 2    50   ~ 0
Vin
$Comp
L pspice:VSOURCE V1
U 1 1 5F1CFB9F
P 3500 4250
F 0 "V1" H 3728 4296 50  0000 L CNN
F 1 "sin(2.5, 1, 10k)" H 3728 4205 50  0000 L CNN
F 2 "" H 3500 4250 50  0001 C CNN
F 3 "~" H 3500 4250 50  0001 C CNN
	1    3500 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 3250 4500 3250
Wire Wire Line
	5000 3250 5100 3250
Connection ~ 5000 3250
Wire Wire Line
	5000 3000 5000 3250
Wire Wire Line
	3500 3650 4100 3650
$Comp
L Device:C C2
U 1 1 5F420D09
P 5250 4850
F 0 "C2" V 5502 4850 50  0000 C CNN
F 1 "20p" V 5411 4850 50  0000 C CNN
F 2 "" H 5288 4700 50  0001 C CNN
F 3 "~" H 5250 4850 50  0001 C CNN
	1    5250 4850
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5400 4400 5500 4400
Wire Wire Line
	5500 4400 5700 4400
Connection ~ 5500 4400
Wire Wire Line
	5500 4400 5500 4850
Connection ~ 5500 4850
Wire Wire Line
	5400 4850 5500 4850
Wire Wire Line
	4600 4400 5000 4400
Wire Wire Line
	5100 4850 5000 4850
Wire Wire Line
	5000 4850 5000 4400
Connection ~ 5000 4400
Wire Wire Line
	5000 4400 5100 4400
$Comp
L Device:R R2
U 1 1 5F1C6E02
P 4250 3850
F 0 "R2" V 4350 3850 50  0000 C CNN
F 1 "100k" V 4450 3850 50  0000 C CNN
F 2 "" V 4180 3850 50  0001 C CNN
F 3 "~" H 4250 3850 50  0001 C CNN
	1    4250 3850
	0    1    1    0   
$EndComp
$Comp
L Device:R R1
U 1 1 5F1C55E3
P 4250 3650
F 0 "R1" V 4043 3650 50  0000 C CNN
F 1 "100k" V 4134 3650 50  0000 C CNN
F 2 "" V 4180 3650 50  0001 C CNN
F 3 "~" H 4250 3650 50  0001 C CNN
	1    4250 3650
	0    1    1    0   
$EndComp
$Comp
L Device:R R4
U 1 1 5F47190F
P 5250 4400
F 0 "R4" V 5043 4400 50  0000 C CNN
F 1 "10k" V 5134 4400 50  0000 C CNN
F 2 "" V 5180 4400 50  0001 C CNN
F 3 "~" H 5250 4400 50  0001 C CNN
	1    5250 4400
	0    1    1    0   
$EndComp
$Comp
L Device:R R3
U 1 1 5F1D6044
P 5250 3250
F 0 "R3" V 5150 3300 50  0000 R CNN
F 1 "10k" V 5050 3350 50  0000 R CNN
F 2 "" V 5180 3250 50  0001 C CNN
F 3 "~" H 5250 3250 50  0001 C CNN
	1    5250 3250
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4400 3650 4600 3650
Wire Wire Line
	4600 3650 4700 3650
Connection ~ 4600 3650
Wire Wire Line
	4600 3650 4600 4400
Text Label 5500 3750 0    50   ~ 0
Vopamp
$Comp
L Device:R R5
U 1 1 5F22D5BE
P 5750 3750
F 0 "R5" V 5543 3750 50  0000 C CNN
F 1 "50" V 5634 3750 50  0000 C CNN
F 2 "" V 5680 3750 50  0001 C CNN
F 3 "~" H 5750 3750 50  0001 C CNN
	1    5750 3750
	0    1    1    0   
$EndComp
$Comp
L Device:R R7
U 1 1 5F48220F
P 6900 4300
F 0 "R7" V 6693 4300 50  0000 C CNN
F 1 "1000" V 6784 4300 50  0000 C CNN
F 2 "" V 6830 4300 50  0001 C CNN
F 3 "~" H 6900 4300 50  0001 C CNN
	1    6900 4300
	0    1    1    0   
$EndComp
$Comp
L pspice:OPAMP U1
U 1 1 5F497BD0
P 5000 3750
F 0 "U1" H 5344 3796 50  0000 L CNN
F 1 "OPAMP" H 5344 3705 50  0000 L CNN
F 2 "" H 5000 3750 50  0001 C CNN
F 3 "~" H 5000 3750 50  0001 C CNN
F 4 "X" H 5000 3750 50  0001 C CNN "Spice_Primitive"
F 5 "OPA350" H 5000 3750 50  0001 C CNN "Spice_Model"
F 6 "Y" H 5000 3750 50  0001 C CNN "Spice_Netlist_Enabled"
F 7 "1 2 4 5 3" H 5000 3750 50  0001 C CNN "Spice_Node_Sequence"
F 8 "/Users/brett/Documents/KiCad/Libraries/Spice Models/OPA350_PSPICE/OPA350.LIB" H 5000 3750 50  0001 C CNN "Spice_Lib_File"
	1    5000 3750
	1    0    0    -1  
$EndComp
$Comp
L pspice:OPAMP U2
U 1 1 5F497EA9
P 6000 4400
F 0 "U2" H 6000 4881 50  0000 C CNN
F 1 "OPAMP" H 6000 4790 50  0000 C CNN
F 2 "" H 6000 4400 50  0001 C CNN
F 3 "~" H 6000 4400 50  0001 C CNN
F 4 "X" H 6000 4400 50  0001 C CNN "Spice_Primitive"
F 5 "OPA350" H 6000 4400 50  0001 C CNN "Spice_Model"
F 6 "Y" H 6000 4400 50  0001 C CNN "Spice_Netlist_Enabled"
F 7 "1 2 4 5 3" H 6000 4400 50  0001 C CNN "Spice_Node_Sequence"
F 8 "/Users/brett/Documents/KiCad/Libraries/Spice Models/OPA350_PSPICE/OPA350.LIB" H 6000 4400 50  0001 C CNN "Spice_Lib_File"
	1    6000 4400
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6300 4300 6650 4300
Wire Wire Line
	7100 4300 7050 4300
Wire Wire Line
	2500 4550 2500 4700
$Comp
L power:GND #PWR02
U 1 1 5F552687
P 4900 5000
F 0 "#PWR02" H 4900 4750 50  0001 C CNN
F 1 "GND" H 4905 4827 50  0000 C CNN
F 2 "" H 4900 5000 50  0001 C CNN
F 3 "" H 4900 5000 50  0001 C CNN
	1    4900 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 4050 4900 5000
$Comp
L power:GND #PWR03
U 1 1 5F555C40
P 6100 5000
F 0 "#PWR03" H 6100 4750 50  0001 C CNN
F 1 "GND" H 6105 4827 50  0000 C CNN
F 2 "" H 6100 5000 50  0001 C CNN
F 3 "" H 6100 5000 50  0001 C CNN
	1    6100 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 4550 3500 4700
Wire Wire Line
	3500 4700 2500 4700
Connection ~ 2500 4700
Wire Wire Line
	2500 4950 2500 5000
Wire Wire Line
	2500 4700 2500 4950
Connection ~ 2500 4950
Wire Wire Line
	2150 4800 2150 5600
Wire Wire Line
	7100 5600 2150 5600
Wire Wire Line
	4000 3850 4000 4800
Wire Wire Line
	2150 4800 4000 4800
Wire Wire Line
	7100 4300 7100 5600
Wire Wire Line
	6100 4700 6100 5000
Connection ~ 2150 4800
Wire Wire Line
	1350 4950 1350 4550
Wire Wire Line
	2150 3950 2150 4800
Wire Wire Line
	1350 3950 1600 3950
$Comp
L pspice:VSOURCE V3
U 1 1 5F510417
P 1350 4250
F 0 "V3" H 1578 4296 50  0000 L CNN
F 1 "2.5" H 1578 4205 50  0000 L CNN
F 2 "" H 1350 4250 50  0001 C CNN
F 3 "~" H 1350 4250 50  0001 C CNN
	1    1350 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 4950 1350 4950
$Comp
L Device:R R6
U 1 1 5F57FF0D
P 1750 3950
F 0 "R6" V 1543 3950 50  0000 C CNN
F 1 "0" V 1634 3950 50  0000 C CNN
F 2 "" V 1680 3950 50  0001 C CNN
F 3 "~" H 1750 3950 50  0001 C CNN
	1    1750 3950
	0    1    1    0   
$EndComp
Wire Wire Line
	1900 3950 2150 3950
Wire Wire Line
	2500 2500 2500 3950
$EndSCHEMATC
