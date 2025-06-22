# Program to test embeding code in a UF2 file for Raspberry Pico and MicroPython
# In a Pico there is a 'Flash memory' (2MB for Pico 1) to stock UF2 (the OS/MicroPython)
# and a 'Static Random-Access Memory' (SRAM 264KB) to stock your code and other files (ex: myfile.json)
# The trick is to put your code in Flash to have plenty of SRAM to handle data

# 1. The module MAIN.PY just toggle the internal LED every second
#    just to test if the UF2 is working
import time
from machine import Pin
def toggle_led():
    Pin("LED", Pin.OUT).toggle()

for _ in range(10) :
    toggle_led()
    time.sleep(1)

# 2. MAIN.PY calls another module 'moduf2' doing the same job at different speed
#    to test if the UF2 can embed several modules
import moduf2 
for _ in range(20) :
    moduf2.toggle_led2()
    time.sleep(0.5)
    
# 3. Same as test 2 but the module 'modmem' is in SRAM
#    After loading the UF2 and first start, this test is NOT working.
#    You must dowload it with Thonny as usual and reboot
try :
    import modmem
    for _ in range(30) :
        modmem.toggle_led3()
        time.sleep(0.1)
except :
    pass

# 4. Same as test 2 and 3, the module 'modjson' and the file 'data.json' are in SRAM
#    If you need to read and write JSON file you should to it in SRAM.
#    The Flash memory is exclusively in read mode for the program, you cannot read
#    a JSON file stored in Flash
try :
    import modjson
    modjson.loop()
except :
    pass

# 5. Nethertheless you can store your data in a Flash module 
#    Then you can create a JSON file in SRAM with your data
#    Afterwards the data can be used as usual.
import json
def read_json(file):
    with open(file) as f:
        dico = json.load(f)
    return dico
def write_json(file,dico):
    with open(file, "w") as f:
        json.dump(dico, f)

mydata = {"qty": "5", "freq": "1"}
file = "data1.json"
write_json(file, mydata)

data = read_json(file)
q = int(data["qty"])
f = int(data["freq"])

for _ in range(q) :
    toggle_led()
    time.sleep(f)

# 6. You can also create directories in SRAM to put your data
#    The free space in SRAM is just for your data. Test by changing the size of the list.
#    Run this program in SRAM (as usual) and then in Flash (in the UF2) to compare.
size_of_the_list = 10000
import os, gc, json
mem1=('Free mem to start : {} allocated: {}'.format(gc.mem_free(), gc.mem_alloc()))
os.mkdir("mydir")
os.chdir("mydir")
if ("data2.json" not in os.listdir()) :
    content = list(range(size_of_the_list))
    with open("data2.json", 'w') as destination:
        json.dump(content,destination)
mem2=(' *** Free mem with data: {} allocated: {}'.format(gc.mem_free(), gc.mem_alloc()))
content = mem1+mem2
with open("free_memory.json", 'w') as destination:
    json.dump(content,destination)
