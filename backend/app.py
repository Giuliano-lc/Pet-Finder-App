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

def convert_blob_to_base64(blob):
    return base64.b64encode(blob).decode('utf-8')

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
#@jwt_required()
def cadastrar_animal():
    if request.method == "POST":
        nome = request.form.get("nome")
        especie = request.form.get("especie")
        idade = request.form.get("idade")
        dono_animal = request.form.get("dono")

        foto = request.files.get('foto')
        foto = foto.read()

        #current_user = get_jwt_identity()

        conn = sqlite3.connect("data.db")

        #user_id = conn.execute(f"SELECT id FROM Usuario WHERE email='{current_user}'")
        user_id = 1

        conn.execute(f"INSERT INTO Animais (nome, especie, idade, imagem, dono_id, dono_animal) VALUES (?, ?, ?, ?, ?)", (nome, especie, idade, foto, user_id, dono_animal))
        conn.commit()

        return jsonify({'status': 'Animal cadastrado com sucesso'})

    if request.method == "GET":
        return render_template("cadastro_animais.html")

@app.route('/listar_animais/<filtro>', methods=['GET'])
def listar_animais(filtro):
    filtro = filtro.lower()
    conn = sqlite3.connect('data.db')
    cursor = conn.cursor()

    if filtro == 'todos':
        cursor.execute('SELECT id, nome, especie, idade, dono, imagem FROM Animais')
    else:
        cursor.execute(
            'SELECT id, nome, especie, idade, dono, imagem FROM Animais WHERE especie LIKE ? OR idade LIKE ?',
            (f'%{filtro}%', f'%{filtro}%')
        )

    animals = []
    for row in cursor.fetchall():
        animals.append({
            'id': row[0],
            'name': row[1],
            'species': row[2],
            'age': row[3],
            'owner': row[4],
            'image': f"data:image/jpeg;base64,{convert_blob_to_base64(row[5])}"
        })

    conn.close()
    return jsonify(animals)

@app.route('/listar/<int:animal_id>', methods=['GET'])
def listar_detalhes(animal_id):
    conn = sqlite3.connect('data.db')
    cursor = conn.cursor()
    cursor.execute('SELECT id, nome, especie, idade, dono, imagem FROM animals WHERE id = ?', (animal_id,))
    row = cursor.fetchone()

    if row:
        animal = {
            'id': row[0],
            'name': row[1],
            'species': row[2],
            'age': row[3],
            'owner': row[4],
            'image': f"data:image/jpeg;base64,{convert_blob_to_base64(row[5])}"
        }
        conn.close()
        return jsonify(animal)

    conn.close()
    return jsonify({"error": "Animal not found"}), 404
