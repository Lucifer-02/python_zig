from setuptools import setup, Extension
from builder import ZigBuilder

hoangdz = Extension("hoangdz", sources=["hoangdzModule.zig"])

setup(
    name="hoangdz",
    version="0.0.1",
    description="a experiment create Python module in Zig",
    ext_modules=[hoangdz],
    cmdclass={"build_ext": ZigBuilder},
)
