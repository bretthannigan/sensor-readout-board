from serial import Serial 

ser = Serial('COM8', 9600)

for i in range(100):
    s = ser.read()
    print(s.hex())