#module_json.py

import json

import time
from machine import Pin
def toggle_led():
    Pin("LED", Pin.OUT).toggle()


def read_json(file):
    with open(file) as f:
        dico = json.load(f)
    return dico
def write_json(file,dico):
    with open(file, "w") as f:
        json.dump(dico, f)


data = read_json("data.json")
q = int(data["qty"])
f = int(data["freq"])
print(q,f)
for _ in range(q) :
    toggle_led()
    time.sleep(f)

dico = {"data": "test OK"}
write_json("data2.json",dico)
while True :
    toggle_led()
    time.sleep(0.1)
