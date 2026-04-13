# from flask import Flask, request, jsonify
# from flask_cors import CORS
# from qiskit import QuantumCircuit, transpile
# # Importing Fake Backends (Digital Twins of real chips)
# from qiskit_ibm_runtime.fake_provider import FakeOsaka, FakeKyoto
# import io, base64
# import matplotlib
# matplotlib.use('Agg') 
# import matplotlib.pyplot as plt

# app = Flask(__name__)
# CORS(app)

# # Initialize the fake backends once to save memory/time
# backends = {
#     'osaka': FakeOsaka(),
#     'kyoto': FakeKyoto()
# }

# @app.route('/generate_circuit', methods=['POST'])
# def generate_circuit():
#     try:
#         data = request.json
#         gates = data.get('gates', [])
#         target_backend_key = data.get('backend') # 'osaka', 'kyoto', or None
#         print(target_backend_key)
#         # 1. Create the Ideal Circuit (Logical Space)
#         qc = QuantumCircuit(1)
#         for g in gates:
#             if g == 'H': qc.h(0)
#             elif g == 'X': qc.x(0)
#             elif g == 'Y': qc.y(0)
#             elif g == 'Z': qc.z(0)
#             elif g == 'S': qc.s(0)
#             elif g == '√X': qc.sx(0)

#         # 2. Handle Transpilation if a backend is requested
#         fig_ideal = qc.draw(output='mpl', style='classic')
#         buf_ideal = io.BytesIO()
#         fig_ideal.savefig(buf_ideal, format='png', bbox_inches='tight')
#         plt.close(fig_ideal)
#         ideal_str = base64.b64encode(buf_ideal.getvalue()).decode('utf-8')

#         # --- B. CREATE TRANSPILED CIRCUIT (IF REQUESTED) ---
#         transpiled_str = None
#         if target_backend_key in backends:
#             backend = backends[target_backend_key]
#             final_qc = transpile(qc, backend, initial_layout=[0], optimization_level=1)
            
#             # Draw Transpiled (with Physical layout)
#             fig_trans = final_qc.draw(output='mpl', idle_wires=False, with_layout=True)
#             buf_trans = io.BytesIO()
#             fig_trans.savefig(buf_trans, format='png', bbox_inches='tight', dpi=150)
#             plt.close(fig_trans)
#             transpiled_str = base64.b64encode(buf_trans.getvalue()).decode('utf-8')

#         return jsonify({
#             "ideal_image": ideal_str,
#             "transpiled_image": transpiled_str,
#         })
    
#     except Exception as e:
#         print(f"Error: {e}")
#         return jsonify({"error": str(e)}), 500

# if __name__ == '__main__':
#     app.run(port=5000, debug=True)






import matplotlib
matplotlib.use('Agg')
from flask import Flask, request, jsonify
from flask_cors import CORS
from quantum_logic import generate_circuit_images

app = Flask(__name__)
CORS(app)

@app.route('/generate_circuit', methods=['POST'])
def generate_circuit():
    try:
        data = request.json
        gates = data.get('gates', [])
        target_backend_key = data.get('backend')

        ideal_str, transpiled_str = generate_circuit_images(gates, target_backend_key)

        return jsonify({
            "ideal_image": ideal_str,
            "transpiled_image": transpiled_str,
        })
    
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(port=5000, debug=True)