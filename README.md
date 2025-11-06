# CosmicMind CLI

CosmicMind is an experimental Swift-based cognitive simulation that explores how a "mind" might process input, synthesize abstract truths, and pursue self-defined goals. The project is delivered as a single Swift script (`ai.py`) that can be executed with the Swift interpreter.

## Features

- **Phenomenological processing:** Transforms raw textual input into structured phenomenological frames enriched with emotional resonance and qualia signatures.
- **Abstract reasoning:** Derives abstract truths and hypotheses from accumulated frames, tracking confidence and emergent principles.
- **Goal management:** Maintains active goals with priorities and status transitions, enabling intention-driven cognition cycles.
- **Intent curation shell:** Augment goals interactively, reprioritize them, or mark them achieved without restarting the agent.
- **Emotional introspection:** Surface the agent's current affective signature on demand to contextualize decisions.
- **Emotional modulation:** Uses a qualitative emotional matrix to interpret and describe evolving affective states.
- **Networking stubs:** Defines payloads and message envelopes for peer-to-peer synchronization between cognitive agents.

## Running the CLI

The CLI can be started with the Swift interpreter:

```bash
swift ai.py
```

Once running, the shell accepts textual commands that are ingested as phenomena. To exit, type `quit` and press <kbd>Enter</kbd>.

### Command Highlights

- `think [n]` — drive one or more cognition cycles manually and observe any proposed actions.
- `goals` — inspect, add, or edit goals (try `goals help` for subcommands such as `goals add 0.8 Explore numerics`).
- `emotions` — display the current qualitative emotional matrix sorted by intensity.
- `auto [on|off]` — toggle the background cognition loop if you want fully manual control.

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

Potential enhancements include richer persistence strategies, a concrete networking implementation for multi-agent synchronization, visualization tools for inspecting cognitive state transitions, and scripted scenarios that demonstrate multi-cycle planning with the new goal management utilities.
