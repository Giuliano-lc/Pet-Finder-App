from flask import Flask, request, jsonify, render_template
import sqlite3
from flask_cors import CORS
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
import base64

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

@app.route("/cadastrar_animal", methods = ["GET", "POST"])
def cadastrar_animal():
    if request.method == "POST":
        file = request.files["file"]
        nome = request.form.get("nome")
        especie = request.form.get("especie")
        idade = request.form.get("idade")

        imagem_binaria = file.read()

        conn = sqlite3.connect("data.db")
        conn.execute(f"INSERT INTO Animais (nome, especie, idade, imagem, dono_id) VALUES (?, ?, ?, ?, ?)", (nome, especie, idade, imagem_binaria, 1))
        conn.commit()

        return jsonify({'status': 'Animal cadastrado com sucesso'})

    if request.method == "GET":
        return render_template("cadastro_animais.html")

@app.route("/listar_animais", methods = ["GET", "POST"])
def listar_animais():

    conn = sqlite3.connect("data.db")

    if request.method == "POST":
        especie = request.form.get("especie_animal")
        idade = request.form.get("idade_animal")

        print(especie)

        if idade == "" and especie == "":
            data = conn.execute(f"SELECT nome, especie, idade, imagem FROM Animais")
        elif idade == "" and especie != "":
            data = conn.execute(f"SELECT nome, especie, idade, imagem FROM Animais WHERE especie='{especie}'")
        elif idade != "" and especie == "":
            data = conn.execute(f"SELECT nome, especie, idade, imagem FROM Animais WHERE idade={idade}")
        else:
            data = conn.execute(f"SELECT nome, especie, idade, imagem FROM Animais WHERE especie='{especie}' AND idade={idade}")

        data = list(data)

        dados = []
        for nome, especie, idade, imagem_binaria in data:
            imagem_base64 = base64.b64encode(imagem_binaria).decode("utf-8")
            dados.append({
                "nome": nome,
                "especie": especie,
                "idade": idade,
                "imagem": f"data:image/jpg;base64,{imagem_base64}"
            })
        
        return render_template("lista_animais.html", animais = dados)

    if request.method == "GET":
        data = conn.execute(f"SELECT nome, especie, idade, imagem FROM Animais")
        data = list(data)

        dados = []
        for nome, especie, idade, imagem_binaria in data:
            imagem_base64 = base64.b64encode(imagem_binaria).decode("utf-8")
            dados.append({
                "nome": nome,
                "especie": especie,
                "idade": idade,
                "imagem": f"data:image/jpg;base64,{imagem_base64}"
            })

        return render_template("lista_animais.html", animais = dados)