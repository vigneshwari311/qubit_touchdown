import os
os.environ.setdefault('OMP_NUM_THREADS', '1')
os.environ.setdefault('OPENBLAS_NUM_THREADS', '1')
os.environ.setdefault('MKL_NUM_THREADS', '1')

import threading
from flask import Flask, request, jsonify
from flask_cors import CORS
from quantum_logic import _get_bloch_animation_cached, _get_circuit_images_cached

app = Flask(__name__)

ALLOWED_ORIGINS = os.environ.get('ALLOWED_ORIGINS', '*').split(',')
CORS(app, origins=ALLOWED_ORIGINS)

_render_lock = threading.Lock()

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"})

@app.route('/generate_circuit', methods=['POST'])
def generate_circuit():
    try:
        data = request.json
        gates = tuple(data.get('gates', []))
        target_backend_key = data.get('backend')
        with _render_lock:
            ideal_sim, transpiled_sim = _get_circuit_images_cached(gates, target_backend_key)
        return jsonify({
            "player_id": data.get("player_id"),
            "ideal_image": ideal_sim,
            "transpiled_image": transpiled_sim,
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/bloch_sphere_animation', methods=['POST'])
def bloch_sphere_animation():
    try:
        data = request.json
        gates = tuple(data.get('gates', []))
        with _render_lock:
            gif_b64 = _get_bloch_animation_cached(gates)
        return jsonify({
            'player_id': data.get('player_id'),
            'gif': gif_b64,
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))