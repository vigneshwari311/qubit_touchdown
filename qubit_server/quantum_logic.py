import io
import base64
import matplotlib.pyplot as plt
from qiskit import QuantumCircuit, transpile
from qiskit_ibm_runtime.fake_provider import FakeOsaka, FakeKyoto

backends = {
    'osaka': FakeOsaka(),
    'kyoto': FakeKyoto()
}

def generate_circuit_images(gates, target_backend_key):
    """
    Logic to create ideal and transpiled circuit strings.
    """
    qc = QuantumCircuit(1)
    for g in gates:
        if g == 'H': qc.h(0)
        elif g == 'X': qc.x(0)
        elif g == 'Y': qc.y(0)
        elif g == 'Z': qc.z(0)
        elif g == 'S': qc.s(0)
        elif g == '√X' or g == 'SX': qc.sx(0)

    fig_ideal = qc.draw(output='mpl', style='classic')
    ideal_str = _convert_fig_to_base64(fig_ideal)
    plt.close(fig_ideal)

    transpiled_str = None
    if target_backend_key in backends:
        backend = backends[target_backend_key]
        final_qc = transpile(qc, backend, initial_layout=[0], optimization_level=1)
        
        fig_trans = final_qc.draw(output='mpl', idle_wires=False, with_layout=True)
        transpiled_str = _convert_fig_to_base64(fig_trans, dpi=150)
        plt.close(fig_trans)

    return ideal_str, transpiled_str

def _convert_fig_to_base64(fig, dpi=100):
    """Internal helper to turn matplotlib figures into strings."""
    buf = io.BytesIO()
    fig.savefig(buf, format='png', bbox_inches='tight', dpi=dpi)
    buf.seek(0)
    return base64.b64encode(buf.read()).decode('utf-8')