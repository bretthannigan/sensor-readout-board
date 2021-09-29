EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
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
U 1 1 5F64D524
P 2500 4250
F 0 "V1" H 2728 4296 50  0000 L CNN
F 1 "VSOURCE" H 2728 4205 50  0000 L CNN
F 2 "" H 2500 4250 50  0001 C CNN
F 3 "~" H 2500 4250 50  0001 C CNN
	1    2500 4250
	1    0    0    -1  
$EndComp
$Comp
L pspice:OPAMP U1
U 1 1 5F64DD6B
P 5750 4250
F 0 "U1" H 5750 3769 50  0000 C CNN
F 1 "OPAMP" H 5750 3860 50  0000 C CNN
F 2 "" H 5750 4250 50  0001 C CNN
F 3 "~" H 5750 4250 50  0001 C CNN
	1    5750 4250
	1    0    0    1   
$EndComp
$Comp
L power:GND #PWR01
U 1 1 5F64EBFA
P 2500 5000
F 0 "#PWR01" H 2500 4750 50  0001 C CNN
F 1 "GND" H 2505 4827 50  0000 C CNN
F 2 "" H 2500 5000 50  0001 C CNN
F 3 "" H 2500 5000 50  0001 C CNN
	1    2500 5000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 5F64F2E2
P 4750 4150
F 0 "R4" V 4543 4150 50  0000 C CNN
F 1 "R" V 4634 4150 50  0000 C CNN
F 2 "" V 4680 4150 50  0001 C CNN
F 3 "~" H 4750 4150 50  0001 C CNN
	1    4750 4150
	0    1    1    0   
$EndComp
$Comp
L Device:R R3
U 1 1 5F6510A0
P 4250 4150
F 0 "R3" V 4043 4150 50  0000 C CNN
F 1 "R" V 4134 4150 50  0000 C CNN
F 2 "" V 4180 4150 50  0001 C CNN
F 3 "~" H 4250 4150 50  0001 C CNN
	1    4250 4150
	0    1    1    0   
$EndComp
Wire Wire Line
	4900 4150 5000 4150
Wire Wire Line
	4400 4150 4500 4150
$Comp
L Device:C C2
U 1 1 5F651865
P 4250 3500
F 0 "C2" V 3998 3500 50  0000 C CNN
F 1 "C" V 4089 3500 50  0000 C CNN
F 2 "" H 4288 3350 50  0001 C CNN
F 3 "~" H 4250 3500 50  0001 C CNN
	1    4250 3500
	0    1    1    0   
$EndComp
$Comp
L Device:C C4
U 1 1 5F651F88
P 4750 3500
F 0 "C4" V 4498 3500 50  0000 C CNN
F 1 "C" V 4589 3500 50  0000 C CNN
F 2 "" H 4788 3350 50  0001 C CNN
F 3 "~" H 4750 3500 50  0001 C CNN
	1    4750 3500
	0    1    1    0   
$EndComp
Wire Wire Line
	4400 3500 4500 3500
Wire Wire Line
	4900 3500 5000 3500
Wire Wire Line
	5000 3500 5000 4150
Connection ~ 5000 4150
Wire Wire Line
	5000 4150 5350 4150
Wire Wire Line
	4100 3500 4000 3500
Wire Wire Line
	4000 3500 4000 4150
Wire Wire Line
	4000 4150 4100 4150
$Comp
L Device:C C3
U 1 1 5F6528E7
P 4500 4750
F 0 "C3" H 4385 4704 50  0000 R CNN
F 1 "C" H 4385 4795 50  0000 R CNN
F 2 "" H 4538 4600 50  0001 C CNN
F 3 "~" H 4500 4750 50  0001 C CNN
	1    4500 4750
	-1   0    0    1   
$EndComp
Wire Wire Line
	4500 4600 4500 4500
Connection ~ 4500 4150
Wire Wire Line
	4500 4150 4600 4150
$Comp
L power:GND #PWR02
U 1 1 5F653A86
P 4500 5000
F 0 "#PWR02" H 4500 4750 50  0001 C CNN
F 1 "GND" H 4505 4827 50  0000 C CNN
F 2 "" H 4500 5000 50  0001 C CNN
F 3 "" H 4500 5000 50  0001 C CNN
	1    4500 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 4900 4500 5000
Wire Wire Line
	4500 3750 4500 3500
Connection ~ 4500 3500
Wire Wire Line
	4500 3500 4600 3500
Wire Wire Line
	4500 3000 4500 3500
Wire Wire Line
	2500 3750 2500 3950
Wire Wire Line
	3000 4500 3000 3750
Connection ~ 3000 3750
Wire Wire Line
	3000 3750 2500 3750
Wire Wire Line
	3000 3000 3000 3750
Wire Wire Line
	3650 3000 4500 3000
Wire Wire Line
	3650 3750 4500 3750
Wire Wire Line
	3000 4500 3350 4500
Wire Wire Line
	3000 3750 3350 3750
Wire Wire Line
	3000 3000 3350 3000
Wire Wire Line
	3650 4500 4500 4500
Connection ~ 4500 4500
Wire Wire Line
	4500 4500 4500 4150
Wire Wire Line
	2500 5000 2500 4550
Wire Wire Line
	4000 3500 4000 2700
Wire Wire Line
	4000 2700 6500 2700
Wire Wire Line
	6500 4250 6050 4250
Connection ~ 4000 3500
$Comp
L Device:R R5
U 1 1 5F65BA7E
P 5750 3750
F 0 "R5" V 5543 3750 50  0000 C CNN
F 1 "R" V 5634 3750 50  0000 C CNN
F 2 "" V 5680 3750 50  0001 C CNN
F 3 "~" H 5750 3750 50  0001 C CNN
	1    5750 3750
	0    1    1    0   
$EndComp
Wire Wire Line
	5900 3750 6500 3750
Connection ~ 6500 3750
Wire Wire Line
	6500 3750 6500 4250
Wire Wire Line
	5600 3750 5350 3750
Wire Wire Line
	5350 3750 5350 4150
Connection ~ 5350 4150
Wire Wire Line
	5350 4150 5450 4150
$Comp
L Device:R R1
U 1 1 5F65420F
P 3500 3750
F 0 "R1" V 3293 3750 50  0000 C CNN
F 1 "R" V 3384 3750 50  0000 C CNN
F 2 "" V 3430 3750 50  0001 C CNN
F 3 "~" H 3500 3750 50  0001 C CNN
	1    3500 3750
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 5F656155
P 3500 4500
F 0 "R2" V 3293 4500 50  0000 C CNN
F 1 "R" V 3384 4500 50  0000 C CNN
F 2 "" V 3430 4500 50  0001 C CNN
F 3 "~" H 3500 4500 50  0001 C CNN
	1    3500 4500
	0    1    1    0   
$EndComp
$Comp
L Device:C C1
U 1 1 5F654B67
P 3500 3000
F 0 "C1" V 3248 3000 50  0000 C CNN
F 1 "C" V 3339 3000 50  0000 C CNN
F 2 "" H 3538 2850 50  0001 C CNN
F 3 "~" H 3500 3000 50  0001 C CNN
	1    3500 3000
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5F65D651
P 5450 5000
F 0 "#PWR0101" H 5450 4750 50  0001 C CNN
F 1 "GND" H 5455 4827 50  0000 C CNN
F 2 "" H 5450 5000 50  0001 C CNN
F 3 "" H 5450 5000 50  0001 C CNN
	1    5450 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 4350 5450 5000
Text Notes 2250 2550 0    50   ~ 0
Single-amplifier biquad active filter\n[1] T. A. Hamilton and A. S. Sedra, “A single-amplifier biquad active filter,” IEEE Trans. Circuit Theory, vol. 19, no. 4, pp. 398–403, 1972.
$Comp
L Device:R R6
U 1 1 5F6A93ED
P 4850 3000
F 0 "R6" V 4643 3000 50  0000 C CNN
F 1 "R" V 4734 3000 50  0000 C CNN
F 2 "" V 4780 3000 50  0001 C CNN
F 3 "~" H 4850 3000 50  0001 C CNN
	1    4850 3000
	0    1    1    0   
$EndComp
Wire Wire Line
	4700 3000 4500 3000
Connection ~ 4500 3000
Wire Wire Line
	5000 3000 5150 3000
Wire Wire Line
	5150 3000 5150 5000
Wire Wire Line
	5150 5000 5450 5000
Connection ~ 5450 5000
Wire Wire Line
	6500 2700 6500 3750
$EndSCHEMATC