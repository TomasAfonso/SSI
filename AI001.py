# app.py
from fastapi import FastAPI, Depends, HTTPException, status, Form
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import BaseModel
import pyotp, bcrypt, time
from typing import Optional

app = FastAPI()

# Simulação de base de dados
fake_db = {}

class User(BaseModel):
    username: str
    password: str
    totp_secret: Optional[str] = None

# Utilitários

def hash_password(password):
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt())

def verify_password(password, hashed):
    return bcrypt.checkpw(password.encode(), hashed)

def generate_totp_secret():
    return pyotp.random_base32()

def get_user(username):
    return fake_db.get(username)

@app.post("/register")
def register(username: str = Form(...), password: str = Form(...)):
    if username in fake_db:
        raise HTTPException(status_code=400, detail="Utilizador já existe.")
    secret = generate_totp_secret()
    hashed = hash_password(password)
    fake_db[username] = {"password": hashed, "totp_secret": secret}
    otp_uri = pyotp.totp.TOTP(secret).provisioning_uri(name=username, issuer_name="MenziesCheckIn")
    return {"msg": "Utilizador registado.", "totp_uri": otp_uri}

@app.post("/login")
def login(username: str = Form(...), password: str = Form(...)):
    user = get_user(username)
    if not user or not verify_password(password, user['password']):
        raise HTTPException(status_code=401, detail="Credenciais inválidas.")
    return {"msg": "Password válida. Insira código TOTP.", "require_2fa": True}

@app.post("/verify-2fa")
def verify_2fa(username: str = Form(...), token: str = Form(...)):
    user = get_user(username)
    if not user:
        raise HTTPException(status_code=404, detail="Utilizador não encontrado.")
    totp = pyotp.TOTP(user['totp_secret'])
    if not totp.verify(token):
        raise HTTPException(status_code=403, detail="Código TOTP inválido.")
    return {"msg": "Autenticação bem-sucedida."}
