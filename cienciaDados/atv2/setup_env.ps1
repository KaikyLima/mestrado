py -3.9 -m venv venv
venv\Scripts\activate

pip install --upgrade pip
pip install setuptools==65.5.0
pip install wheel

pip install -r requirements.txt

REM clonar jenga
git clone https://github.com/schelterlabs/jenga.git

REM instalar jenga no ambiente
cd jenga
pip install -e .
cd ..

echo Ambiente pronto!
pause