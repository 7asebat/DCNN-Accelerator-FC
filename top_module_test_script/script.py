import random
FC_Layer_Inputs = []
Memory_Values = []

def prec(x, p):
    return int(x * (1 << p))

def trunc(x, p, sz):
    x = x >> p;
    return x & ((1 << sz) - 1)

for i in range(0, 120):
    rnd = random.random()
    FC_Layer_Inputs.append(prec(rnd, 11))
    # FC_Layer_Inputs.append(round(i/120, 2))

for i in range(0, 12000):
    rnd = random.random()
    Memory_Values.append(prec(rnd, 11))
    # Memory_Values.append(round((i % 120) / 240, 2))

F6_Layer_Values = []
OUTPUT_Layer_Values = []
Softmax_Layer_Values = []

for i in range(0, 84):
    neuron_value = 0
    mem_addr = i*121

    weights = Memory_Values[mem_addr+1: mem_addr+121]
    bias = Memory_Values[mem_addr]
    neuron_value += sum([w * v for w, v in zip(weights, FC_Layer_Inputs)]) + prec(bias, 11)
    neuron_value = trunc(neuron_value, 11, 16)

    F6_Layer_Values.append(neuron_value)

memory_offset = 84*121
for i in range(0, 10):
    neuron_value = 0
    mem_addr = memory_offset + i * 85

    weights = Memory_Values[mem_addr+1: mem_addr+121]
    bias = Memory_Values[mem_addr]
    neuron_value += sum([w * v for w, v in zip(weights, F6_Layer_Values)]) + prec(bias, 11)
    neuron_value = trunc(neuron_value, 11, 16)

    OUTPUT_Layer_Values.append(neuron_value)

def gt(x, y, sz):
    if (~x & (1 << 15)) and (y & (1 << 15)):
        return True

    elif (x & (1 << 15)) and (~y & (1 << 15)):
        return False

    return x > y if (~x & (1 << 15)) else y > x


max_idx = 0
max_val = -1
for idx, val in enumerate(OUTPUT_Layer_Values):
    if gt(val, max_val, 16):
        max_idx = idx
        max_val = val
Softmax_Layer_Values = [max_idx]


def binstring(x): return f'{prec(x, 11):04x}'
def formatted_binstring(x): return f"16\'b{binstring(x)}"


def print_to_file(array, file_name):
    f = open(file_name, "w")
    for x in array:
        f.writelines(f"{x:04x}\n")
        # f.writelines(f"{binstring(x)}\n")


print_to_file(FC_Layer_Inputs, "FC_Layer_Inputs.txt")
print_to_file(Memory_Values, "Memory_Values.txt")
print_to_file(F6_Layer_Values, "F6_Layer_Values.txt")
print_to_file(OUTPUT_Layer_Values, "OUTPUT_Layer_Values.txt")
print_to_file(Softmax_Layer_Values, "Softmax_Layer_Values.txt")
