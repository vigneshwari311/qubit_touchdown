# import io
# import base64
# import os
# import matplotlib
# matplotlib.use('Agg')  
# import matplotlib.pyplot as plt
# from qiskit import QuantumCircuit, transpile
# from qiskit_aer import AerSimulator
# from qiskit.circuit.library import HGate, XGate, YGate, ZGate, SGate, SXGate
# from qiskit.quantum_info import Statevector
# import matplotlib.animation as animation
# import tempfile
# from functools import lru_cache


# @lru_cache(maxsize=256)
# def _get_circuit_images_cached(gates_tuple, target_backend_key=None):
#     return get_circuit_images(list(gates_tuple), target_backend_key)

# @lru_cache(maxsize=256)
# def _get_bloch_animation_cached(gates_tuple):
#     return get_bloch_animation(list(gates_tuple))


# def _fig_to_base64(fig):
#     buf = io.BytesIO()
#     fig.savefig(buf, format='png', bbox_inches='tight', dpi=150, facecolor = fig.get_facecolor())
#     buf.seek(0)
#     return base64.b64encode(buf.getvalue()).decode('utf-8')

# DARK_BG = '#000000'
# VECTOR_COLOR = '#00f5ff'
# SPHERE_COLOR = '#2a2f3a'
# FONT_COLOR = '#8b929e'

# CIRCUIT_DARK_STYLE = {
#     'backgroundcolor': DARK_BG,
#     'textcolor': FONT_COLOR,
#     'gatetextcolor': DARK_BG,        # text drawn ON gate boxes — keep dark so it's readable against the bright gate fill
#     'subtextcolor': FONT_COLOR,
#     'linecolor': FONT_COLOR,         # qubit wires
#     'creglinecolor': FONT_COLOR,     # classical register wires
#     'gatefacecolor': VECTOR_COLOR,   # gate box fill — matches bloch vector color
#     'barrierfacecolor': SPHERE_COLOR,
#     'labelcolor': FONT_COLOR,
#     'fontsize': 14,
#     'figwidth': -1,
#     'dpi': 150,
# }
# def get_circuit_images(gates, target_backend_key=None):
#     qc = QuantumCircuit(1)
#     for g in gates:
#         if g == 'H': qc.h(0)
#         elif g == 'X': qc.x(0)
#         elif g == 'Y': qc.y(0)
#         elif g == 'Z': qc.z(0)
#         elif g == 'S': qc.s(0)
#         elif g == '√X': qc.sx(0)

#     fig_ideal = qc.draw(output='mpl', style=CIRCUIT_DARK_STYLE, scale=0.7)
#     fig_ideal.set_facecolor(DARK_BG)
#     for ax in fig_ideal.get_axes():
#         ax.set_facecolor(DARK_BG)
#     ideal_str = _fig_to_base64(fig_ideal)
#     plt.close(fig_ideal)

#     backend = AerSimulator()
#     final_qc = transpile(qc, backend, initial_layout=[0], optimization_level=3)

#     # Check if anything is actually left to draw after transpilation
#     has_ops = any(
#         instr.operation.name not in ('barrier', 'id')
#         for instr in final_qc.data
#     )

#     if has_ops:
#         fig_trans = final_qc.draw(
#             output='mpl', idle_wires=False, with_layout=True,
#             style=CIRCUIT_DARK_STYLE, scale=0.7
#         )
#         fig_trans.set_facecolor(DARK_BG)
#         for ax in fig_trans.get_axes():
#             ax.set_facecolor(DARK_BG)
#         transpiled_str = _fig_to_base64(fig_trans)
#         plt.close(fig_trans)
#     else:
#         transpiled_str = None

#     return ideal_str, transpiled_str


# GATE_MAP = {
#     'H': HGate(),
#     'X': XGate(),
#     'Y': YGate(),
#     'Z': ZGate(),
#     'S': SGate(),
#     '√X': SXGate(),
# }


# def _statevector_to_bloch(state: Statevector):
#     rho = state.to_operator().data
#     x = 2*rho[0,1].real
#     y = 2*rho[0,1].imag
#     z = (rho[0, 0] - rho[1, 1]).real
#     return [x, y, z]
    
# from qiskit.visualization.bloch import Bloch


# def _draw_bloch_sphere(fig, vector):
#     b = Bloch(fig=fig)

#     b.vector_color = [VECTOR_COLOR]
#     b.vector_width = 3

#     b.sphere_color = SPHERE_COLOR
#     b.sphere_alpha = 0.15

#     b.frame_color = FONT_COLOR
#     b.frame_alpha = 0.25

#     b.font_color = FONT_COLOR
#     b.font_size = 14

#     b.add_vectors(vector)
#     b.render()

#     b.axes.set_facecolor(DARK_BG)
#     fig.set_facecolor(DARK_BG)


# def get_bloch_animation(gates):
#     state = Statevector.from_label('0')
#     frames = [_statevector_to_bloch(state)]
#     for g in gates:
#         gate = GATE_MAP.get(g)
#         if gate is not None:
#             state = state.evolve(gate)
#             frames.append(_statevector_to_bloch(state))

#     pause_frames = 3
#     frames = frames + [frames[-1]] * pause_frames

#     fig = plt.figure(figsize=(4, 4), facecolor=DARK_BG)

#     def update(frame_idx):
#         fig.clear()
#         _draw_bloch_sphere(fig, frames[frame_idx])

#     ani = animation.FuncAnimation(
#         fig, update, frames=len(frames), interval=600, repeat=True,
#     )

#     with tempfile.NamedTemporaryFile(suffix='.gif', delete=False) as tmp:
#         tmp_path = tmp.name

#     try:
#         ani.save(tmp_path, writer='pillow', savefig_kwargs={'facecolor': DARK_BG})
#         with open(tmp_path, 'rb') as f:
#             gif_bytes = f.read()
#     finally:
#         plt.close(fig)
#         os.remove(tmp_path)

#     return base64.b64encode(gif_bytes).decode('utf-8')












import io
import base64
import os
import matplotlib
matplotlib.use('Agg')  
import matplotlib.pyplot as plt
from qiskit import QuantumCircuit, transpile
from qiskit_aer import AerSimulator
from qiskit.circuit.library import HGate, XGate, YGate, ZGate, SGate, SXGate
from qiskit.quantum_info import Statevector
from functools import lru_cache
from PIL import Image

@lru_cache(maxsize=256)
def _get_circuit_images_cached(gates_tuple, target_backend_key=None):
    return get_circuit_images(list(gates_tuple), target_backend_key)

@lru_cache(maxsize=256)
def _get_bloch_animation_cached(gates_tuple):
    return get_bloch_animation(list(gates_tuple))


def _fig_to_base64(fig):
    buf = io.BytesIO()
    fig.savefig(
        buf, format='png', bbox_inches='tight',
        dpi=100,
        facecolor=fig.get_facecolor(),
    )
    buf.seek(0)
    return base64.b64encode(buf.getvalue()).decode('utf-8')


DARK_BG = '#000000'
VECTOR_COLOR = '#00f5ff'
SPHERE_COLOR = '#2a2f3a'
FONT_COLOR = '#8b929e'

CIRCUIT_DARK_STYLE = {
    'backgroundcolor': DARK_BG,
    'textcolor': FONT_COLOR,
    'gatetextcolor': DARK_BG,        # text drawn ON gate boxes — keep dark so it's readable against the bright gate fill
    'subtextcolor': FONT_COLOR,
    'linecolor': FONT_COLOR,         # qubit wires
    'creglinecolor': FONT_COLOR,     # classical register wires
    'gatefacecolor': VECTOR_COLOR,   # gate box fill — matches bloch vector color
    'barrierfacecolor': SPHERE_COLOR,
    'labelcolor': FONT_COLOR,
    'fontsize': 14,
    'figwidth': -1,
    'dpi': 150,
}

_SIMULATOR = AerSimulator()

def get_circuit_images(gates, target_backend_key=None):
    qc = QuantumCircuit(1)
    for g in gates:
        if g == 'H': qc.h(0)
        elif g == 'X': qc.x(0)
        elif g == 'Y': qc.y(0)
        elif g == 'Z': qc.z(0)
        elif g == 'S': qc.s(0)
        elif g == '√X': qc.sx(0)

    fig_ideal = qc.draw(output='mpl', style=CIRCUIT_DARK_STYLE, scale=0.7)
    fig_ideal.set_facecolor(DARK_BG)
    for ax in fig_ideal.get_axes():
        ax.set_facecolor(DARK_BG)
    ideal_str = _fig_to_base64(fig_ideal)
    plt.close(fig_ideal)

    final_qc = transpile(qc, _SIMULATOR, initial_layout=[0], optimization_level=1)

    # Check if anything is actually left to draw after transpilation
    has_ops = any(
        instr.operation.name not in ('barrier', 'id')
        for instr in final_qc.data
    )

    if has_ops:
        fig_trans = final_qc.draw(
            output='mpl', idle_wires=False, with_layout=True,
            style=CIRCUIT_DARK_STYLE, scale=0.7
        )
        fig_trans.set_facecolor(DARK_BG)
        for ax in fig_trans.get_axes():
            ax.set_facecolor(DARK_BG)
        transpiled_str = _fig_to_base64(fig_trans)
        plt.close(fig_trans)
    else:
        transpiled_str = None

    return ideal_str, transpiled_str


GATE_MAP = {
    'H': HGate(),
    'X': XGate(),
    'Y': YGate(),
    'Z': ZGate(),
    'S': SGate(),
    '√X': SXGate(),
}


def _statevector_to_bloch(state: Statevector):
    rho = state.to_operator().data
    x = 2*rho[0,1].real
    y = 2*rho[0,1].imag
    z = (rho[0, 0] - rho[1, 1]).real
    return [x, y, z]
    
from qiskit.visualization.bloch import Bloch

def _draw_bloch_sphere(fig, vector):
    ax = fig.add_subplot(111, projection='3d')
    b = Bloch(fig=fig, axes=ax)

    b.vector_color = [VECTOR_COLOR]
    b.vector_width = 3

    b.sphere_color = SPHERE_COLOR
    b.sphere_alpha = 0.15

    b.frame_color = FONT_COLOR
    b.frame_alpha = 0.25

    b.font_color = FONT_COLOR
    b.font_size = 14

    b.add_vectors(vector)
    b.render()

    b.axes.set_facecolor(DARK_BG)
    fig.set_facecolor(DARK_BG)
    
    
def get_bloch_animation(gates):
    state = Statevector.from_label('0')
    vectors = [_statevector_to_bloch(state)]
    for g in gates:
        gate = GATE_MAP.get(g)
        if gate is not None:
            state = state.evolve(gate)
            vectors.append(_statevector_to_bloch(state))

    pause_frames = 3
    vectors = vectors + [vectors[-1]] * pause_frames

    pil_frames = []
    for vec in vectors:
        fig = plt.figure(figsize=(3.2, 3.2), facecolor=DARK_BG)
        _draw_bloch_sphere(fig, vec)  # fresh figure every time, never cleared/reused
        buf = io.BytesIO()
        fig.savefig(buf, format='png', facecolor=DARK_BG, dpi=90)
        plt.close(fig)
        buf.seek(0)
        pil_frames.append(Image.open(buf).convert('RGB'))

    gif_buf = io.BytesIO()
    pil_frames[0].save(
        gif_buf,
        format='GIF',
        save_all=True,
        append_images=pil_frames[1:],
        duration=600,
        loop=0,
    )
    gif_buf.seek(0)
    return base64.b64encode(gif_buf.getvalue()).decode('utf-8')
