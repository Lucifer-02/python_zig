import time

import numpy as np

import hoangdz


def sum_l(data):
    s = 0
    for e in data:
        s += e
    return s



a = int(input("enter a: "))
b = int(input("enter b: "))
print("sum: ",hoangdz.sum(a,b))
print("multiple: ",hoangdz.mul(a,b))
print("type sum: ", type(hoangdz.sum(a,b)))
hoangdz.hello()
hoangdz.printSt(input("enter something: "))
print("Array: ", hoangdz.returnArrayWithInput(100))

data = [i for i in range(1_000_000)]

start = time.time()
print(f"Sum: {hoangdz.sum2(data)}")
end = time.time()
print(end - start)

start = time.time()
print(f"Sum: {sum_l(data)}")
end = time.time()
print(end - start)

start = time.time()
print(f"Sum: {np.sum(data)}")
end = time.time()
print(end - start)
