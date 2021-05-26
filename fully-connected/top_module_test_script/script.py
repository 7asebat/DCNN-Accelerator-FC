FC_Layer_Inputs = []
Memory_Values = []

for i in range(0, 120):
    FC_Layer_Inputs.append(round(i/120, 2))

for i in range(0, 12000):
    Memory_Values.append(round((i % 120) / 240, 2))

F6_Layer_Values = []
OUTPUT_Layer_Values = []
Softmax_Layer_Values = []


for i in range(0, 84):
    neuron_value = 0
    mem_addr = i*121
    neuron_mem_vals = Memory_Values[mem_addr:mem_addr+121]
    neuron_value += sum([w * v for w, v in zip(FC_Layer_Inputs, neuron_mem_vals[1:])]) + neuron_mem_vals[0]

    F6_Layer_Values.append(neuron_value)

memory_offset = 84*121
for i in range(0, 10):
    neuron_value = 0
    mem_addr = memory_offset + i * 85
    neuron_mem_vals = Memory_Values[mem_addr: mem_addr+85]
    neuron_value += sum([w * v for w, v in zip(F6_Layer_Values, neuron_mem_vals[1:])]) + neuron_mem_vals[0]

    OUTPUT_Layer_Values.append(neuron_value)

max_idx = 0
max_val = -1
for idx, val in enumerate(OUTPUT_Layer_Values):
    if val > max_val:
        max_idx = idx
        max_val = val
Softmax_Layer_Values = [max_idx]


def binstring(x): return f'{(int(x*2**11)):04x}'
def formatted_binstring(x): return f"16\'b{binstring(x)}"


def print_to_file(array, file_name):
    f = open(file_name, "w")
    for x in array:
        f.writelines(f"{binstring(x)}\n")


print_to_file(FC_Layer_Inputs, "FC_Layer_Inputs.txt")
print_to_file(Memory_Values, "Memory_Values.txt")
print_to_file(F6_Layer_Values, "F6_Layer_Values.txt")
print_to_file(OUTPUT_Layer_Values, "OUTPUT_Layer_Values.txt")
print_to_file(Softmax_Layer_Values, "Softmax_Layer_Values.txt")
