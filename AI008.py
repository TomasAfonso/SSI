# app_bagagens.py
from flask import Flask, request, jsonify
from werkzeug.exceptions import BadRequest
import re

app = Flask(__name__)

# Expressões regulares para validação segura
VALID_ID = re.compile(r'^[A-Z0-9]{6,10}$')
VALID_NOME = re.compile(r'^[A-Za-zÀ-ÿ\s]{2,50}$')

@app.route("/registar_bagagem", methods=["POST"])
def registar_bagagem():
    try:
        dados = request.get_json()
        codigo = dados.get("codigo")
        passageiro = dados.get("nome")

        if not codigo or not VALID_ID.match(codigo):
            raise BadRequest("Código inválido. Use apenas letras maiúsculas e números (6-10 caracteres).")
        
        if not passageiro or not VALID_NOME.match(passageiro):
            raise BadRequest("Nome de passageiro inválido. Use apenas letras e espaços (2-50 caracteres).")

        # Simulação de sucesso
        return jsonify({"status": "ok", "mensagem": f"Bagagem {codigo} registada para {passageiro}."})

    except BadRequest as e:
        return jsonify({"status": "erro", "mensagem": str(e)}), 400
    except Exception:
        return jsonify({"status": "erro", "mensagem": "Erro interno."}), 500

if __name__ == "__main__":
    app.run(debug=True)
