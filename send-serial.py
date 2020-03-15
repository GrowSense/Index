#!/usr/bin/env python
import sys
from time import sleep
from serial import Serial
print("Sending serial data to device...")

text=sys.argv[1]
port=sys.argv[2]

print("  Text: " + text)
print("  Serial port: " + port)

ser = Serial(port, 9600, timeout=3)

sleep(2)

ser.write(text.encode())

sleep(1)

print("Finished sending serial data to device.")

sys.exit()
