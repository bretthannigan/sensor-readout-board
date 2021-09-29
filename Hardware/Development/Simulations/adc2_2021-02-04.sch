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
$Comp
L pspice:VSOURCE V1
U 1 1 5F7461BF
P 2000 3750
F 0 "V1" H 2228 3796 50  0000 L CNN
F 1 "2.5" H 2228 3705 50  0000 L CNN
F 2 "" H 2000 3750 50  0001 C CNN
F 3 "~" H 2000 3750 50  0001 C CNN
	1    2000 3750
	1    0    0    -1  
$EndComp
$Comp
L pspice:VSOURCE V2
U 1 1 5F746CB5
P 2000 5250
F 0 "V2" H 2228 5296 50  0000 L CNN
F 1 "2.5" H 2228 5205 50  0000 L CNN
F 2 "" H 2000 5250 50  0001 C CNN
F 3 "~" H 2000 5250 50  0001 C CNN
	1    2000 5250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 5F747FF4
P 2150 4500
F 0 "#PWR03" H 2150 4250 50  0001 C CNN
F 1 "GND" H 2155 4327 50  0000 C CNN
F 2 "" H 2150 4500 50  0001 C CNN
F 3 "" H 2150 4500 50  0001 C CNN
	1    2150 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2150 4500 2000 4500
Wire Wire Line
	2000 4500 2000 4050
Wire Wire Line
	2000 4950 2000 4500
Connection ~ 2000 4500
$Comp
L power:VCC #PWR01
U 1 1 5F74906E
P 2000 1500
F 0 "#PWR01" H 2000 1350 50  0001 C CNN
F 1 "VCC" H 2015 1673 50  0000 C CNN
F 2 "" H 2000 1500 50  0001 C CNN
F 3 "" H 2000 1500 50  0001 C CNN
	1    2000 1500
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR02
U 1 1 5F749C33
P 2000 6000
F 0 "#PWR02" H 2000 5850 50  0001 C CNN
F 1 "VDD" H 2015 6173 50  0000 C CNN
F 2 "" H 2000 6000 50  0001 C CNN
F 3 "" H 2000 6000 50  0001 C CNN
	1    2000 6000
	-1   0    0    1   
$EndComp
Wire Wire Line
	2000 5550 2000 6000
Wire Wire Line
	2000 1500 2000 3450
Text Notes 1950 6550 0    50   ~ 0
.ac dec 100 159 1.59meg\n\n
$Comp
L pspice:OPAMP U?
U 1 1 5F758C68
P 6750 3250
F 0 "U?" H 7094 3296 50  0000 L CNN
F 1 "OPAMP" H 7094 3205 50  0000 L CNN
F 2 "" H 6750 3250 50  0001 C CNN
F 3 "~" H 6750 3250 50  0001 C CNN
F 4 "X" H 6750 3250 50  0001 C CNN "Spice_Primitive"
F 5 "LMV116" H 6750 3250 50  0001 C CNN "Spice_Model"
F 6 "Y" H 6750 3250 50  0001 C CNN "Spice_Netlist_Enabled"
F 7 "1 2 4 5 3" H 6750 3250 50  0001 C CNN "Spice_Node_Sequence"
F 8 "/Users/brett/Documents/KiCad/Libraries/Spice Models/LMV116_PSPICE/LMV116.CIR" H 6750 3250 50  0001 C CNN "Spice_Lib_File"
	1    6750 3250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 5F738E95
P 4750 2500
F 0 "C3" V 4498 2500 50  0000 C CNN
F 1 "100p" V 4589 2500 50  0000 C CNN
F 2 "" H 4788 2350 50  0001 C CNN
F 3 "~" H 4750 2500 50  0001 C CNN
	1    4750 2500
	0    1    1    0   
$EndComp
Connection ~ 4500 2500
Connection ~ 7050 2750
Wire Wire Line
	4500 1750 4500 2500
Wire Wire Line
	7050 1750 4500 1750
Wire Wire Line
	7050 2750 7050 1750
Wire Wire Line
	3000 3250 3000 3000
Connection ~ 3000 3250
Wire Wire Line
	4000 3250 3000 3250
Wire Wire Line
	4000 4000 4000 3250
Wire Wire Line
	4100 4000 4000 4000
Text Label 7050 2750 0    50   ~ 0
Vout
Wire Wire Line
	6000 3350 5500 3350
Connection ~ 6000 3350
Wire Wire Line
	6000 2750 6000 3350
Wire Wire Line
	6100 2750 6000 2750
Wire Wire Line
	5750 4100 5750 3000
Wire Wire Line
	5750 4500 5750 4400
Wire Wire Line
	7050 2750 6400 2750
Wire Wire Line
	7050 3250 7050 2750
Wire Wire Line
	6650 2950 6650 1500
$Comp
L power:VCC #PWR08
U 1 1 5F74DD4D
P 6650 1500
F 0 "#PWR08" H 6650 1350 50  0001 C CNN
F 1 "VCC" H 6665 1673 50  0000 C CNN
F 2 "" H 6650 1500 50  0001 C CNN
F 3 "" H 6650 1500 50  0001 C CNN
	1    6650 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6650 6000 6650 3550
$Comp
L power:VDD #PWR09
U 1 1 5F74BC2D
P 6650 6000
F 0 "#PWR09" H 6650 5850 50  0001 C CNN
F 1 "VDD" H 6665 6173 50  0000 C CNN
F 2 "" H 6650 6000 50  0001 C CNN
F 3 "" H 6650 6000 50  0001 C CNN
	1    6650 6000
	-1   0    0    1   
$EndComp
Wire Wire Line
	6250 3150 6450 3150
Wire Wire Line
	6250 3150 6250 4500
$Comp
L power:GND #PWR07
U 1 1 5F744CE1
P 6250 4500
F 0 "#PWR07" H 6250 4250 50  0001 C CNN
F 1 "GND" H 6255 4327 50  0000 C CNN
F 2 "" H 6250 4500 50  0001 C CNN
F 3 "" H 6250 4500 50  0001 C CNN
	1    6250 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5500 3350 5500 3500
Connection ~ 5500 3350
Wire Wire Line
	5500 2500 5500 3350
Wire Wire Line
	6450 3350 6000 3350
$Comp
L power:GND #PWR06
U 1 1 5F74178A
P 5750 4500
F 0 "#PWR06" H 5750 4250 50  0001 C CNN
F 1 "GND" H 5755 4327 50  0000 C CNN
F 2 "" H 5750 4500 50  0001 C CNN
F 3 "" H 5750 4500 50  0001 C CNN
	1    5750 4500
	1    0    0    -1  
$EndComp
Connection ~ 5000 3000
Wire Wire Line
	5000 3000 5750 3000
$Comp
L Device:R R3
U 1 1 5F740C0F
P 5750 4250
F 0 "R3" H 5680 4204 50  0000 R CNN
F 1 "1.30k" H 5680 4295 50  0000 R CNN
F 2 "" V 5680 4250 50  0001 C CNN
F 3 "~" H 5750 4250 50  0001 C CNN
	1    5750 4250
	-1   0    0    1   
$EndComp
$Comp
L Device:R R1
U 1 1 5F74026C
P 6250 2750
F 0 "R1" V 6043 2750 50  0000 C CNN
F 1 "243k" V 6134 2750 50  0000 C CNN
F 2 "" V 6180 2750 50  0001 C CNN
F 3 "~" H 6250 2750 50  0001 C CNN
	1    6250 2750
	0    1    1    0   
$EndComp
Wire Wire Line
	5000 4400 5000 4500
$Comp
L power:GND #PWR05
U 1 1 5F73FB55
P 5000 4500
F 0 "#PWR05" H 5000 4250 50  0001 C CNN
F 1 "GND" H 5005 4327 50  0000 C CNN
F 2 "" H 5000 4500 50  0001 C CNN
F 3 "" H 5000 4500 50  0001 C CNN
	1    5000 4500
	1    0    0    -1  
$EndComp
Connection ~ 5000 4000
Wire Wire Line
	5000 4100 5000 4000
$Comp
L Device:C C1
U 1 1 5F73F15F
P 5000 4250
F 0 "C1" H 4885 4204 50  0000 R CNN
F 1 "220p" H 4885 4295 50  0000 R CNN
F 2 "" H 5038 4100 50  0001 C CNN
F 3 "~" H 5000 4250 50  0001 C CNN
	1    5000 4250
	-1   0    0    1   
$EndComp
Wire Wire Line
	5000 3000 5000 2500
Wire Wire Line
	3900 3000 5000 3000
Wire Wire Line
	5000 3500 5100 3500
Connection ~ 5000 3500
Wire Wire Line
	5000 4000 4400 4000
Wire Wire Line
	5000 3500 5000 4000
Wire Wire Line
	4900 3500 5000 3500
Wire Wire Line
	5500 2500 5400 2500
Wire Wire Line
	5400 3500 5500 3500
Wire Wire Line
	4500 3500 4600 3500
Wire Wire Line
	4500 2500 4500 3500
Wire Wire Line
	4600 2500 4500 2500
Connection ~ 5000 2500
Wire Wire Line
	5100 2500 5000 2500
Wire Wire Line
	5000 2500 4900 2500
Wire Wire Line
	5000 2000 5000 2500
Wire Wire Line
	3900 2000 5000 2000
Wire Wire Line
	3000 2000 3000 3000
Wire Wire Line
	3600 2000 3000 2000
Connection ~ 3000 3000
Wire Wire Line
	3000 3000 3600 3000
Wire Wire Line
	3000 3450 3000 3250
Wire Wire Line
	3000 4050 3000 4500
$Comp
L Device:R R2
U 1 1 5F73B648
P 4250 4000
F 0 "R2" V 4043 4000 50  0000 C CNN
F 1 "5.23k" V 4134 4000 50  0000 C CNN
F 2 "" V 4180 4000 50  0001 C CNN
F 3 "~" H 4250 4000 50  0001 C CNN
	1    4250 4000
	0    1    1    0   
$EndComp
$Comp
L Device:R R6
U 1 1 5F73B12C
P 5250 3500
F 0 "R6" V 5043 3500 50  0000 C CNN
F 1 "5.62k" V 5134 3500 50  0000 C CNN
F 2 "" V 5180 3500 50  0001 C CNN
F 3 "~" H 5250 3500 50  0001 C CNN
	1    5250 3500
	0    1    1    0   
$EndComp
$Comp
L Device:R R5
U 1 1 5F73A691
P 4750 3500
F 0 "R5" V 4543 3500 50  0000 C CNN
F 1 "5.62k" V 4634 3500 50  0000 C CNN
F 2 "" V 4680 3500 50  0001 C CNN
F 3 "~" H 4750 3500 50  0001 C CNN
	1    4750 3500
	0    1    1    0   
$EndComp
$Comp
L Device:C C2
U 1 1 5F739FA0
P 3750 2000
F 0 "C2" V 3498 2000 50  0000 C CNN
F 1 "22p" V 3589 2000 50  0000 C CNN
F 2 "" H 3788 1850 50  0001 C CNN
F 3 "~" H 3750 2000 50  0001 C CNN
	1    3750 2000
	0    1    1    0   
$EndComp
$Comp
L Device:C C4
U 1 1 5F739B8F
P 5250 2500
F 0 "C4" V 4998 2500 50  0000 C CNN
F 1 "100p" V 5089 2500 50  0000 C CNN
F 2 "" H 5288 2350 50  0001 C CNN
F 3 "~" H 5250 2500 50  0001 C CNN
	1    5250 2500
	0    1    1    0   
$EndComp
$Comp
L Device:R R4
U 1 1 5F738870
P 3750 3000
F 0 "R4" V 3543 3000 50  0000 C CNN
F 1 "46.4k" V 3634 3000 50  0000 C CNN
F 2 "" V 3680 3000 50  0001 C CNN
F 3 "~" H 3750 3000 50  0001 C CNN
	1    3750 3000
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR04
U 1 1 5F738259
P 3000 4500
F 0 "#PWR04" H 3000 4250 50  0001 C CNN
F 1 "GND" H 3005 4327 50  0000 C CNN
F 2 "" H 3000 4500 50  0001 C CNN
F 3 "" H 3000 4500 50  0001 C CNN
	1    3000 4500
	1    0    0    -1  
$EndComp
$Comp
L pspice:VSOURCE V3
U 1 1 5F737572
P 3000 3750
F 0 "V3" H 3228 3796 50  0000 L CNN
F 1 "dc 0 ac 1" H 3228 3705 50  0000 L CNN
F 2 "" H 3000 3750 50  0001 C CNN
F 3 "~" H 3000 3750 50  0001 C CNN
	1    3000 3750
	1    0    0    -1  
$EndComp
$EndSCHEMATC
