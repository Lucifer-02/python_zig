run:
	clear
	# pip install . && python3 test.py
	pip install . && ipython3

clean:
	rm -rf build dist hoangdz.egg-info hoangdz.cpython-311-x86_64-linux-gnu.so __pycache__
