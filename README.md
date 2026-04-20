# CosmicMind

CosmicMind is an experimental Swift-based cognitive simulation that explores how a "mind" might process input, synthesize abstract truths, and pursue self-defined goals.

## Architecture

The project is organized as a Swift Package with two targets:

- `CosmicMindCore`: The core library containing the cognitive architecture, data models, and logic.
- `CosmicMindCLI`: A command-line interface for interacting with the CosmicMind instance.

### Key Components

- **Phenomenological processing:** Transforms raw textual input into structured phenomenological frames enriched with emotional resonance and qualia signatures.
- **Abstract reasoning:** Derives abstract truths and hypotheses from accumulated frames, tracking confidence and emergent principles.
- **Goal management:** Maintains active goals with priorities and status transitions, enabling intention-driven cognition cycles.
- **Emotional modulation:** Uses a qualitative emotional matrix to interpret and describe evolving affective states.
- **Networking:** Includes data structures for peer-to-peer synchronization (experimental).

## Building and Running

### Prerequisites

- Swift 5.5 or later.

### Build

```bash
swift build
```

### Run

To run the interactive CLI:

```bash
swift run CosmicMindCLI
```

Once running, the shell accepts textual commands that are ingested as phenomena. To exit, type `quit` or `exit`.

### Test

To run the unit tests:

```bash
swift test
```

## Usage

In the CLI, you can use the following commands:

- `say <text>`: Inject a phenomenon (e.g., `say Hello?`).
- `think`: Force a cognitive cycle and show decisions.
- `summary`: Print a compact state summary.
- `truths`: List derived truths.
- `frames`: List stored phenomenological frames.
- `inspect <truth|frame> <id>`: Inspect details of a specific item.
- `persist`: Force state persistence to disk.
- `quit`: Save state and exit.

## Persistence

Cognitive state is automatically persisted to a JSON file in your document directory or home directory (`cosmicMind.<UUID>.v3.json`). It is loaded automatically on startup if available.

## License

See [LICENSE](LICENSE).

## Cyber-OS v5.0 App (Common Lisp)

This repository now also includes `cyber-os-v5.lisp`, a standalone Common Lisp hacking-sim app with:

- A cyberpunk-style command shell (`cyber-os:boot`)
- An active trace + Black ICE lockout banking loop
- A Hunchentoot-powered web Matrix interface at `http://localhost:8080`
- SPA-like asynchronous API calls to `/api/search` and `/api/fuzzy`

### Run Cyber-OS

Prerequisites:

- SBCL
- Quicklisp
- `hunchentoot` (auto-loaded by the script)

```bash
sbcl
* (load "cyber-os-v5.lisp")
* (cyber-os:boot)
```

Core in-shell commands:

- `help`
- `net-up`
- `net-down`
- `scan`
- `bank`
- `status`
- `audit`
- `exit`



## Quantum-Entropic Strategist V3 (Common Lisp)

This repository now also includes `quantum_strat.lisp`, a CLOS-based simulation with:

- Cognitive core and market/session encapsulation via CLOS classes
- Wave-function collapse style signal perturbation with entropy-driven jitter
- Multi-agent consensus + neural inference + backprop updates
- Entropy-scaled execution sizing and recursive epoch cycles

### Run Quantum-Entropic Strategist V3

Prerequisites:

- SBCL

```bash
sbcl --script quantum_strat.lisp
```

By default it initializes the system, mints a quantum key, and runs 3 cycles.

## Quantum Super AI App (Common Lisp)

This repository also includes `quantum_ai.lisp`, a standalone Common Lisp simulation that runs cognition + financial-routing cycles with:

- Quantum-inspired state updates and forecasts
- SWIFT-like fiat balance simulation
- Crypto wallet fluctuation simulation
- Luhn-valid card generation

### Run Quantum Super AI

Prerequisites:

- SBCL
- `shasum` available in your shell

```bash
sbcl --script quantum_ai.lisp
```

By default it runs 3 full cycles and prints diagnostics to stdout.
