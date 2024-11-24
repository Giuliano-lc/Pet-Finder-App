from flask import Flask, request, jsonify
import sqlite3
from flask_cors import CORS
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity

app = Flask(__name__)

CORS(app)

app.config['JWT_SECRET_KEY'] = 'sua_chave_secreta_aqui'
jwt = JWTManager(app)

conn = sqlite3.connect("data.db")

@app.route("/login", methods = ['POST', 'GET'])
def login():
    if request.method == "POST": 
        data = request.get_json('nome')
        conn = sqlite3.connect("data.db")
        usuarios = conn.execute("SELECT * FROM usuario")
        print(data)
        for i in usuarios:
            if data['email'] == i[2]:
                if data['senha'] == i[3]:
                    access_token = create_access_token(identity=data["email"])
                    return jsonify(access_token=access_token)
        return jsonify({'status': 'Usuario ou senha invalidos'})

@app.route("/cadastro", methods = ["GET", "POST"])
def cadastro():
    if request.method == "POST":
        conn = sqlite3.connect("data.db")
        data = request.get_json('nome')
        emails = conn.execute(f"SELECT email FROM usuario")
        for i in emails:
            if i[0] == data['email']:
                return jsonify({'status': 'Email ja existe'})

        conn.execute(f"INSERT INTO usuario (nome, email, senha) VALUES ('{data['nome']}', '{data['email']}', '{data['senha']}')")
        conn.commit()

        return jsonify({'status': 'Cadastrato com sucesso'})