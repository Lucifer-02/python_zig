import subprocess

failed = subprocess.call(["pip", "install", "-e", "."])
assert not failed

import hoangdz


a = input("enter a: ")
b = input("enter b: ")
print("sum: ",hoangdz.sum(int(a),int(b)))
print("multiple: ",hoangdz.mul(int(a),int(b)))
print("type sum: ", type(hoangdz.sum(int(a),int(b))))
hoangdz.hello()
hoangdz.printSt(input("enter something: "))
