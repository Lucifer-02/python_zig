run:
	python3 setup.py bdist_wheel && python3 test.py

clean:
	rm -rf build dist hoangdz.egg-info hoangdz.cpython-311-x86_64-linux-gnu.so __pycache__

