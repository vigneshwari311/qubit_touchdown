from flask import Flask, request, jsonify
from flask_cors import CORS
from quantum_logic import get_circuit_images # Import your function

app = Flask(__name__)
CORS(app)

@app.route('/generate_circuit', methods=['POST'])
def generate_circuit():
    try:
        data = request.json
        gates = data.get('gates', [])
        target_backend_key = data.get('backend')

        ideal_str, transpiled_str = get_circuit_images(gates, target_backend_key)

        return jsonify({
            "ideal_image": ideal_str,
            "transpiled_image": transpiled_str,
        })
            
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(port=5000, debug=True)

