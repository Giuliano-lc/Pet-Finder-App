CREATE TABLE IF NOT EXISTS Animais (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    especie TEXT NOT NULL,
    idade INTEGER NOT NULL,
    imagem BLOB,
    dono_id INTEGER NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT CHECK(status IN ('ativo', 'inativo')) DEFAULT 'ativo',
    latitude REAL,
    longitude REAL,
    FOREIGN KEY (dono_id) REFERENCES Usuario (id)
);

