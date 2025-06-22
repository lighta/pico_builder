import time
from machine import Pin
def toggle_led2():
    Pin("LED", Pin.OUT).toggle()