import sys
import pip

def install(package):
    pip.main(["install", package])

try:
    import setuptools
except ImportError:
    print("setuptools is not installed, installing it now...")
    install("setuptools")

try:
    import serial
except ImportError:
    print("serial is not installed, installing it now...")
    install("serial")

print("Python modules installed.")
sys.exit()
