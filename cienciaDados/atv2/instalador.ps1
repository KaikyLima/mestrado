py -3.9 -m venv venv
.\venv\Scripts\Activate.ps1

pip install --upgrade pip
pip install setuptools==65.5.0
pip install wheel

pip install -r requirements.txt

# Clonar jenga
git clone https://github.com/schelterlabs/jenga.git

# Remover .git interno
$gitPath = "jenga\.git"
if (Test-Path $gitPath) {
    Write-Host "Removendo .git interno do jenga..."
    Remove-Item -Recurse -Force $gitPath
}

Write-Host "Ambiente pronto!"