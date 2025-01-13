import sqlite3

# Conexão com o banco de dados
conn = sqlite3.connect("data.db")
cursor = conn.cursor()

# Função para executar um script SQL de um arquivo
def executescript_sql(nome_arquivo):
    with open(nome_arquivo, 'r') as file:
        sql_script = file.read()
        cursor.executescript(sql_script)
        print(f"Executado: {nome_arquivo}")

# Executa os arquivos SQL
executescript_sql("table_usuario.sql")
executescript_sql("table_animais.sql")

# Confirma as alterações e fecha a conexão
conn.commit()
conn.close()

print("Tabelas criadas com sucesso!")
