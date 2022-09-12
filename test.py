import subprocess

failed = subprocess.call(["pip", "install", "-e", "."])
assert not failed

import hoangdz


a = input("nhap a: ")
b = input("nhap b: ")
print("tong: ",hoangdz.sum(int(a),int(b)))
print("tich: ",hoangdz.mul(int(a),int(b)))
print("type sum: ", type(hoangdz.sum(int(a),int(b))))
print(hoangdz.hello())
