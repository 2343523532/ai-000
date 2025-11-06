# CosmicMind CLI

CosmicMind is an experimental Swift-based cognitive simulation that explores how a "mind" might process input, synthesize abstract truths, and pursue self-defined goals. The project is delivered as a single Swift script (`ai.py`) that can be executed with the Swift interpreter.

## Features

- **Phenomenological processing:** Transforms raw textual input into structured phenomenological frames enriched with emotional resonance and qualia signatures.
- **Abstract reasoning:** Derives abstract truths and hypotheses from accumulated frames, tracking confidence and emergent principles.
- **Goal management:** Maintains active goals with priorities and status transitions, enabling intention-driven cognition cycles.
- **Emotional modulation:** Uses a qualitative emotional matrix to interpret and describe evolving affective states.
- **Networking stubs:** Defines payloads and message envelopes for peer-to-peer synchronization between cognitive agents.

## Running the CLI

The CLI can be started with the Swift interpreter:

```bash
swift ai.py
```

Once running, the shell accepts textual commands that are ingested as phenomena. To exit, type `quit` and press <kbd>Enter</kbd>.

## Development Notes

- The script relies solely on the Swift standard library (and `Network` when available), so no additional dependencies are required.
- Cognitive state persistence is handled through JSON snapshots, and the script includes helpers for ISO 8601 date formatting and range clamping.
- A background cognition timer maintains periodic cognitive updates even when the CLI is idle.

## Testing

A minimal smoke test ensures the CLI starts and exits cleanly:

```bash
swift ai.py <<'EOF'
quit
EOF
```

## Next Steps

Potential enhancements include richer persistence strategies, a concrete networking implementation for multi-agent synchronization, and visualization tools for inspecting cognitive state transitions.
