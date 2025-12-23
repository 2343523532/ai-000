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
