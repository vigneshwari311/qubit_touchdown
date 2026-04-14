

Uploading 0414.mp4…

# **QUBIT TOUCHDOWN**

Qubit Touchdown is a digital implementation of the quantum board game by Professor Thomas G. Wong. It translates the rules of American Football into the logic of the Bloch Sphere. You can watch his detailed explanation of the rules and the quantum physics involved here: 
> [Qubit Touchdown - A Quantum Computing Board Game by Tom Wong](https://youtu.be/_289qVBOvgM)

## How to Play

* **The Field:** The board represents the **Bloch Sphere**. Player 1 aims for the $|+\rangle$ end zone, while Player 2 aims for $|-\rangle$. Intermediate states include $|0\rangle, |1\rangle, |i\rangle,$ and $|-i\rangle$.
* **The Deck:** A 52-card deck containing **Quantum Gates** ($H, X, Y, Z, S, \sqrt{X}$) and **Measurement** cards. Each player holds 4 cards at a time.
* **Movement:** Moves follow quantum logic. If your gate card has a matching **arrow** from your current position, the ball moves. If there is no arrow, the ball stays put (Identity move).
* **Scoring:** Reach your designated end zone ($|+\rangle$ or $|-\rangle$) and play any card to trigger a **Touchdown**. This increases your score by 1 and unlocks the **Circuit Visualization**.
* **The Science:** After a touchdown, you can view the **Transpiled Circuit** to see how your logical moves are optimized for real IBM Quantum hardware.
* **The Toss:** After scoring, a "Measurement" (coin toss) is performed. The result ($|0\rangle$ or $|1\rangle$) determines the starting position for the next kickoff.
  
## Tech Stack
- **Frontend:** Flutter
- **State Management:** Provider
- **Backend:** Flask (Python)
- **Quantum Engine:** Qiskit (IBM Quantum SDK)

## Project Structure
```text
.
├── qubittouchdown/       # Flutter Frontend
│   ├── lib/              # Game logic, UI, and Provider
│   ├── assets/           # Lottie animations and icons
│   └── pubspec.yaml      # Dart dependencies
└── qubit_server/         # Python Backend
    ├── app.py            # Flask API Entry point
    ├── quantum_logic.py  # Qiskit circuit & transpilation logic
    └── requirements.txt  # Python dependencies
```

## Setup & Installation

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Python 3.9+](https://www.python.org/downloads/)

### 2. Backend Setup (qubit_server)
```bash
cd qubit_server
# Create a virtual environment
python -m venv venv
# Activate it (Windows: venv\Scripts\activate | Mac/Linux: source venv/bin/activate)
pip install -r requirements.txt
python app.py
```
*The server will run on `http://localhost:5000`.*

### 3. Frontend Setup (qubit_touchdown)
```bash
cd qubittouchdown
flutter pub get
flutter run -d chrome  # Or your preferred device
```
