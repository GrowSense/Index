#!/usr/bin/env python
import sys
from time import sleep
from serial import Serial
print("Sending serial data to device...")

print("  Text: " + sys.argv[1])
print("  Serial port: " + sys.argv[2])

ser = Serial(sys.argv[2], 9600, timeout=3)

sleep(2)

ser.write(sys.argv[1])

sleep(1)

print("Finished sending serial data to device.")
