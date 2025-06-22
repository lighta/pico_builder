import time
from machine import Pin
def toggle_led3():
    Pin("LED", Pin.OUT).toggle()