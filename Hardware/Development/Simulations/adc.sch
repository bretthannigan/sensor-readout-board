EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr USLetter 11000 8500
encoding utf-8
Sheet 1 1
Title "ADC Loop Filter"
Date "2020-10-09"
Rev "2"
Comp "MENRVA"
Comment1 "Realizes 2nd order loop filter."
Comment2 "Dynamic range scaled and rounded component values chosen."
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:GND #PWR04
U 1 1 5F8223F5
P 3000 5000
F 0 "#PWR04" H 3000 4750 50  0001 C CNN
F 1 "GND" H 3005 4827 50  0000 C CNN
F 2 "" H 3000 5000 50  0001 C CNN
F 3 "" H 3000 5000 50  0001 C CNN
	1    3000 5000
	1    0    0    -1  
$EndComp
$Comp
L pspice:VSOURCE V1
U 1 1 5F7461BF
P 2250 4250
F 0 "V1" H 2478 4296 50  0000 L CNN
F 1 "2.5" H 2478 4205 50  0000 L CNN
F 2 "" H 2250 4250 50  0001 C CNN
F 3 "~" H 2250 4250 50  0001 C CNN
	1    2250 4250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 5F747FF4
P 2400 5000
F 0 "#PWR03" H 2400 4750 50  0001 C CNN
F 1 "GND" H 2405 4827 50  0000 C CNN
F 2 "" H 2400 5000 50  0001 C CNN
F 3 "" H 2400 5000 50  0001 C CNN
	1    2400 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 5000 2250 5000
Wire Wire Line
	2250 5000 2250 4550
Wire Wire Line
	2250 5450 2250 5000
Connection ~ 2250 5000
$Comp
L power:VCC #PWR01
U 1 1 5F74906E
P 2250 2000
F 0 "#PWR01" H 2250 1850 50  0001 C CNN
F 1 "VCC" H 2265 2173 50  0000 C CNN
F 2 "" H 2250 2000 50  0001 C CNN
F 3 "" H 2250 2000 50  0001 C CNN
	1    2250 2000
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR02
U 1 1 5F8223FA
P 2250 6500
F 0 "#PWR02" H 2250 6350 50  0001 C CNN
F 1 "VDD" H 2265 6673 50  0000 C CNN
F 2 "" H 2250 6500 50  0001 C CNN
F 3 "" H 2250 6500 50  0001 C CNN
	1    2250 6500
	-1   0    0    1   
$EndComp
Wire Wire Line
	2250 6050 2250 6500
Wire Wire Line
	2250 2000 2250 3950
Wire Wire Line
	3000 3350 3450 3350
Wire Wire Line
	3000 3350 3000 3500
Wire Wire Line
	3000 2750 3000 3350
Connection ~ 3000 3350
Wire Wire Line
	3000 2500 3000 2750
Connection ~ 3000 2750
$Comp
L power:GND #PWR05
U 1 1 5F7482A3
P 3400 5000
F 0 "#PWR05" H 3400 4750 50  0001 C CNN
F 1 "GND" H 3405 4827 50  0000 C CNN
F 2 "" H 3400 5000 50  0001 C CNN
F 3 "" H 3400 5000 50  0001 C CNN
	1    3400 5000
	1    0    0    -1  
$EndComp
$Comp
L power:VDD #PWR07
U 1 1 5F753E66
P 3650 6500
F 0 "#PWR07" H 3650 6350 50  0001 C CNN
F 1 "VDD" H 3665 6673 50  0000 C CNN
F 2 "" H 3650 6500 50  0001 C CNN
F 3 "" H 3650 6500 50  0001 C CNN
	1    3650 6500
	-1   0    0    1   
$EndComp
Wire Wire Line
	3650 3550 3650 6500
Wire Wire Line
	3450 3150 3400 3150
Wire Wire Line
	3400 3150 3400 5000
$Comp
L power:VDD #PWR010
U 1 1 5F75604E
P 5650 6500
F 0 "#PWR010" H 5650 6350 50  0001 C CNN
F 1 "VDD" H 5665 6673 50  0000 C CNN
F 2 "" H 5650 6500 50  0001 C CNN
F 3 "" H 5650 6500 50  0001 C CNN
	1    5650 6500
	-1   0    0    1   
$EndComp
$Comp
L power:VDD #PWR013
U 1 1 5F756BFA
P 7650 6500
F 0 "#PWR013" H 7650 6350 50  0001 C CNN
F 1 "VDD" H 7665 6673 50  0000 C CNN
F 2 "" H 7650 6500 50  0001 C CNN
F 3 "" H 7650 6500 50  0001 C CNN
	1    7650 6500
	-1   0    0    1   
$EndComp
Wire Wire Line
	7650 6500 7650 3550
Wire Wire Line
	5650 6500 5650 3550
$Comp
L power:GND #PWR08
U 1 1 5F758129
P 5400 5000
F 0 "#PWR08" H 5400 4750 50  0001 C CNN
F 1 "GND" H 5405 4827 50  0000 C CNN
F 2 "" H 5400 5000 50  0001 C CNN
F 3 "" H 5400 5000 50  0001 C CNN
	1    5400 5000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR011
U 1 1 5F758DAB
P 7400 5000
F 0 "#PWR011" H 7400 4750 50  0001 C CNN
F 1 "GND" H 7405 4827 50  0000 C CNN
F 2 "" H 7400 5000 50  0001 C CNN
F 3 "" H 7400 5000 50  0001 C CNN
	1    7400 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7450 3150 7400 3150
Wire Wire Line
	7400 3150 7400 5000
Wire Wire Line
	5450 3150 5400 3150
Wire Wire Line
	5400 3150 5400 5000
Wire Wire Line
	5000 3950 7000 3950
Connection ~ 5000 3950
Wire Wire Line
	4050 3250 4300 3250
Wire Wire Line
	4900 3250 5000 3250
Wire Wire Line
	5000 3250 5000 3350
Wire Wire Line
	5000 3350 5450 3350
Wire Wire Line
	7000 3250 7000 3350
Wire Wire Line
	7000 3350 7450 3350
Wire Wire Line
	6900 3250 7000 3250
Wire Wire Line
	6600 3250 6300 3250
Wire Wire Line
	5000 2750 5000 3250
Connection ~ 5000 3250
Wire Wire Line
	6300 2750 6300 3250
Connection ~ 6300 3250
Wire Wire Line
	6300 3250 6050 3250
Wire Wire Line
	3000 2750 3100 2750
Wire Wire Line
	4300 2750 4300 3250
Connection ~ 4300 3250
Wire Wire Line
	4300 3250 4600 3250
Wire Wire Line
	4300 2500 4300 2750
Connection ~ 4300 2750
Wire Wire Line
	5100 2750 5000 2750
Wire Wire Line
	5400 2750 6300 2750
Wire Wire Line
	3000 2500 3100 2500
Wire Wire Line
	3400 2500 4300 2500
Wire Wire Line
	3400 2750 4300 2750
$Comp
L power:VCC #PWR06
U 1 1 5F765FBB
P 3650 2000
F 0 "#PWR06" H 3650 1850 50  0001 C CNN
F 1 "VCC" H 3665 2173 50  0000 C CNN
F 2 "" H 3650 2000 50  0001 C CNN
F 3 "" H 3650 2000 50  0001 C CNN
	1    3650 2000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR09
U 1 1 5F766BD0
P 5650 2000
F 0 "#PWR09" H 5650 1850 50  0001 C CNN
F 1 "VCC" H 5665 2173 50  0000 C CNN
F 2 "" H 5650 2000 50  0001 C CNN
F 3 "" H 5650 2000 50  0001 C CNN
	1    5650 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 2950 3650 2000
Wire Wire Line
	5650 2000 5650 2950
$Comp
L power:VCC #PWR012
U 1 1 5F769A09
P 7650 2000
F 0 "#PWR012" H 7650 1850 50  0001 C CNN
F 1 "VCC" H 7665 2173 50  0000 C CNN
F 2 "" H 7650 2000 50  0001 C CNN
F 3 "" H 7650 2000 50  0001 C CNN
	1    7650 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 2000 7650 2950
Wire Wire Line
	7100 2750 7000 2750
Wire Wire Line
	7000 2750 7000 3250
Connection ~ 7000 3250
Wire Wire Line
	7400 2750 8050 2750
Wire Wire Line
	8050 2750 8050 3250
Connection ~ 7000 3350
Wire Wire Line
	8050 2750 8050 2250
Wire Wire Line
	8050 2250 4900 2250
Connection ~ 8050 2750
Wire Wire Line
	4600 2250 3000 2250
Wire Wire Line
	3000 2250 3000 2500
Connection ~ 3000 2500
Connection ~ 5000 3350
Text Label 8050 2750 0    50   ~ 0
V_3
Text Notes 1300 7600 0    50   ~ 0
.ac dec 100 159 1.59meg\n\n
Text Label 3000 3950 0    50   ~ 0
Vin
Text Label 4300 2750 0    50   ~ 0
V_1
Text Label 6300 2750 0    50   ~ 0
V_2
Wire Wire Line
	3000 4800 3000 5000
Wire Wire Line
	3000 3950 5000 3950
$Comp
L pspice:OPAMP U3
U 1 1 5F7E69CB
P 7750 3250
F 0 "U3" H 8094 3296 50  0000 L CNN
F 1 "OPAMP" H 8094 3205 50  0000 L CNN
F 2 "" H 7750 3250 50  0001 C CNN
F 3 "~" H 7750 3250 50  0001 C CNN
F 4 "X" H 7750 3250 50  0001 C CNN "Spice_Primitive"
F 5 "LM6211" H 7750 3250 50  0001 C CNN "Spice_Model"
F 6 "Y" H 7750 3250 50  0001 C CNN "Spice_Netlist_Enabled"
F 7 "1 2 4 5 3" H 7750 3250 50  0001 C CNN "Spice_Node_Sequence"
F 8 "/Users/brett/Documents/KiCad/Libraries/Spice Models/LM6211_PSPICE/LM6211.MOD" H 7750 3250 50  0001 C CNN "Spice_Lib_File"
	1    7750 3250
	1    0    0    -1  
$EndComp
$Comp
L pspice:OPAMP U2
U 1 1 5F7E6FC9
P 5750 3250
F 0 "U2" H 6094 3296 50  0000 L CNN
F 1 "OPAMP" H 6094 3205 50  0000 L CNN
F 2 "" H 5750 3250 50  0001 C CNN
F 3 "~" H 5750 3250 50  0001 C CNN
F 4 "X" H 5750 3250 50  0001 C CNN "Spice_Primitive"
F 5 "LM6211" H 5750 3250 50  0001 C CNN "Spice_Model"
F 6 "Y" H 5750 3250 50  0001 C CNN "Spice_Netlist_Enabled"
F 7 "1 2 4 5 3" H 5750 3250 50  0001 C CNN "Spice_Node_Sequence"
F 8 "/Users/brett/Documents/KiCad/Libraries/Spice Models/LM6211_PSPICE/LM6211.MOD" H 5750 3250 50  0001 C CNN "Spice_Lib_File"
	1    5750 3250
	1    0    0    -1  
$EndComp
$Comp
L pspice:OPAMP U1
U 1 1 5F7E6BBE
P 3750 3250
F 0 "U1" H 4094 3296 50  0000 L CNN
F 1 "OPAMP" H 4094 3205 50  0000 L CNN
F 2 "" H 3750 3250 50  0001 C CNN
F 3 "~" H 3750 3250 50  0001 C CNN
F 4 "X" H 3750 3250 50  0001 C CNN "Spice_Primitive"
F 5 "LM6211" H 3750 3250 50  0001 C CNN "Spice_Model"
F 6 "Y" H 3750 3250 50  0001 C CNN "Spice_Netlist_Enabled"
F 7 "1 2 4 5 3" H 3750 3250 50  0001 C CNN "Spice_Node_Sequence"
F 8 "/Users/brett/Documents/KiCad/Libraries/Spice Models/LM6211_PSPICE/LM6211.MOD" H 3750 3250 50  0001 C CNN "Spice_Lib_File"
	1    3750 3250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R8
U 1 1 5F75BF15
P 5250 2750
F 0 "R8" V 5043 2750 50  0000 C CNN
F 1 "806" V 5134 2750 50  0000 C CNN
F 2 "" V 5180 2750 50  0001 C CNN
F 3 "~" H 5250 2750 50  0001 C CNN
	1    5250 2750
	0    1    1    0   
$EndComp
$Comp
L Device:R R6
U 1 1 5F73FC97
P 5000 3650
F 0 "R6" H 4930 3604 50  0000 R CNN
F 1 "13.7k" H 4930 3695 50  0000 R CNN
F 2 "" V 4930 3650 50  0001 C CNN
F 3 "~" H 5000 3650 50  0001 C CNN
	1    5000 3650
	-1   0    0    1   
$EndComp
$Comp
L Device:R R5
U 1 1 5F743A7B
P 7000 3650
F 0 "R5" H 6930 3604 50  0000 R CNN
F 1 "6.98k" H 6930 3695 50  0000 R CNN
F 2 "" V 6930 3650 50  0001 C CNN
F 3 "~" H 7000 3650 50  0001 C CNN
	1    7000 3650
	-1   0    0    1   
$EndComp
$Comp
L Device:R R4
U 1 1 5F73A3FC
P 3000 3650
F 0 "R4" H 3070 3696 50  0000 L CNN
F 1 "4.75k" H 3070 3605 50  0000 L CNN
F 2 "" V 2930 3650 50  0001 C CNN
F 3 "~" H 3000 3650 50  0001 C CNN
	1    3000 3650
	1    0    0    -1  
$EndComp
Connection ~ 3000 3950
Wire Wire Line
	3000 3950 3000 4200
$Comp
L Device:C C1
U 1 1 5F744E1C
P 3250 2750
F 0 "C1" V 3400 2750 50  0000 C CNN
F 1 "680p" V 3500 2750 50  0000 C CNN
F 2 "" H 3288 2600 50  0001 C CNN
F 3 "~" H 3250 2750 50  0001 C CNN
	1    3250 2750
	0    -1   1    0   
$EndComp
$Comp
L Device:R R7
U 1 1 5F73DCA2
P 4750 3250
F 0 "R7" V 4543 3250 50  0000 C CNN
F 1 "750" V 4634 3250 50  0000 C CNN
F 2 "" V 4680 3250 50  0001 C CNN
F 3 "~" H 4750 3250 50  0001 C CNN
	1    4750 3250
	0    1    1    0   
$EndComp
$Comp
L pspice:VSOURCE V3
U 1 1 5F8223F4
P 3000 4500
F 0 "V3" H 3228 4546 50  0000 L CNN
F 1 "dc 0 ac 1" H 3228 4455 50  0000 L CNN
F 2 "" H 3000 4500 50  0001 C CNN
F 3 "~" H 3000 4500 50  0001 C CNN
	1    3000 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 5F746657
P 7250 2750
F 0 "C2" V 6998 2750 50  0000 C CNN
F 1 "1.5n" V 7089 2750 50  0000 C CNN
F 2 "" H 7288 2600 50  0001 C CNN
F 3 "~" H 7250 2750 50  0001 C CNN
	1    7250 2750
	0    1    1    0   
$EndComp
$Comp
L Device:R R3
U 1 1 5F7441F8
P 4750 2250
F 0 "R3" V 4543 2250 50  0000 C CNN
F 1 "4.64k" V 4634 2250 50  0000 C CNN
F 2 "" V 4680 2250 50  0001 C CNN
F 3 "~" H 4750 2250 50  0001 C CNN
	1    4750 2250
	0    1    1    0   
$EndComp
$Comp
L pspice:VSOURCE V2
U 1 1 5F746CB5
P 2250 5750
F 0 "V2" H 2478 5796 50  0000 L CNN
F 1 "2.5" H 2478 5705 50  0000 L CNN
F 2 "" H 2250 5750 50  0001 C CNN
F 3 "~" H 2250 5750 50  0001 C CNN
	1    2250 5750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F73ED25
P 6750 3250
F 0 "R2" V 6543 3250 50  0000 C CNN
F 1 "1.10k" V 6634 3250 50  0000 C CNN
F 2 "" V 6680 3250 50  0001 C CNN
F 3 "~" H 6750 3250 50  0001 C CNN
	1    6750 3250
	0    1    1    0   
$EndComp
$Comp
L Device:R R1
U 1 1 5F73CE08
P 3250 2500
F 0 "R1" V 3043 2500 50  0000 C CNN
F 1 "14.0k" V 3134 2500 50  0000 C CNN
F 2 "" V 3180 2500 50  0001 C CNN
F 3 "~" H 3250 2500 50  0001 C CNN
	1    3250 2500
	0    1    1    0   
$EndComp
Wire Wire Line
	5000 3500 5000 3350
Wire Wire Line
	7000 3500 7000 3350
Wire Wire Line
	7000 3800 7000 3950
Wire Wire Line
	5000 3800 5000 3950
Wire Wire Line
	3000 3800 3000 3950
$EndSCHEMATC