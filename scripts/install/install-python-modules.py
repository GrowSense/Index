import sys
import pip

def install(package):
    pip.main(["install", package])

try:
    import serial
except ImportError:
    print("serial is not installed, installing it now...")
    install("serial")

print("Python modules installed.")
sys.exit(1)
