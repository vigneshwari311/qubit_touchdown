import io
import base64
import matplotlib
matplotlib.use('Agg')  
import matplotlib.pyplot as plt
from qiskit import QuantumCircuit, transpile
from qiskit_ibm_runtime.fake_provider import FakeOsaka, FakeKyoto

backends = {
    'osaka': FakeOsaka(),
    'kyoto': FakeKyoto()
}

def get_circuit_images(gates, target_backend_key=None):
    qc = QuantumCircuit(1)
    for g in gates:
        if g == 'H': qc.h(0)
        elif g == 'X': qc.x(0)
        elif g == 'Y': qc.y(0)
        elif g == 'Z': qc.z(0)
        elif g == 'S': qc.s(0)
        elif g == '√X': qc.sx(0)

    fig_ideal = qc.draw(output='mpl', style='classic')
    ideal_str = _fig_to_base64(fig_ideal)
    plt.close(fig_ideal)

    transpiled_str = None
    if target_backend_key in backends:
        backend = backends[target_backend_key]
        final_qc = transpile(qc, backend, initial_layout=[0], optimization_level=3)
        
        fig_trans = final_qc.draw(output='mpl', idle_wires=False, with_layout=True)
        transpiled_str = _fig_to_base64(fig_trans)
        plt.close(fig_trans)

    return ideal_str, transpiled_str

def _fig_to_base64(fig):
    buf = io.BytesIO()
    fig.savefig(buf, format='png', bbox_inches='tight', dpi=150)
    buf.seek(0)
    return base64.b64encode(buf.getvalue()).decode('utf-8')