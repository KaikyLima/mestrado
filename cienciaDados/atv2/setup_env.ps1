py -3.9 -m venv venv
venv\Scripts\activate

pip install --upgrade pip
pip install setuptools==65.5.0
pip install wheel

pip install -r requirements.txt

pip install git+https://github.com/schelterlabs/jenga.git --no-build-isolation