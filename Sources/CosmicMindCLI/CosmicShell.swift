import Foundation
import Dispatch
import CosmicMindCore

// MARK: - CLI Interactive Shell

public final class CosmicShell {
    private let mind: CosmicMind
    private let inputQueue = DispatchQueue(label: "com.cosmicmind.shell")
    private var running = true
    private var cognitionTimer: DispatchSourceTimer?

    public init(mind: CosmicMind) {
        self.mind = mind
    }

    public func start() {
        printBanner()
        startBackgroundCognition()
        runREPL()
    }

    private func printBanner() {
        print("""
        ------------------------------------------------------
         CosmicMind CLI — Interactive Hybrid Agent
         Identity: \(mind.selfConcept.identity)  |  Telos: \(mind.missionTelos)
         Type 'help' for commands.
        ------------------------------------------------------
        """)
    }

    private func startBackgroundCognition() {
        // Periodically run cognitive cycles
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.schedule(deadline: .now() + 2.0, repeating: 6.0)
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            let actions = self.mind.cognize()
            for a in actions {
                print("AUTO-ACTION: [\(a.intent)] -> \(a.payload)  (Reason: \(a.justification))")
            }
        }
        timer.resume()
        cognitionTimer = timer
    }

    private func runREPL() {
        while running {
            print("\n> ", terminator: "")
            guard let line = readLine(strippingNewline: true) else { continue }
            handleLine(line)
        }
    }

    private func handleLine(_ line: String) {
        let parts = line.split(separator: " ", maxSplits: 1).map(String.init)
        let cmd = parts.first?.lowercased() ?? ""
        let arg = parts.count > 1 ? parts[1] : ""

        switch cmd {
        case "quit", "exit":
            print("Exiting—persisting state...")
            _ = mind.cognize() // finalize a cycle
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        case "help":
            printHelp()
        case "say":
            if arg.isEmpty { print("Usage: say <text>") } else { mind.receiveExternalText(arg) }
        case "think":
            let actions = mind.cognize()
            if actions.isEmpty { print("No actions decided this cycle.") } else { for a in actions { print("ACTION: [\(a.intent)] -> \(a.payload)  (Reason: \(a.justification))") } }
        case "summary":
            print(mind.dumpStateSummary())
        case "truths":
            let truths = mind.listTruths()
            if truths.isEmpty { print("No derived truths yet.") } else {
                for t in truths { print("- [\(t.id)]: \(t.emergentPrinciple) (confidence: \(t.confidence))") }
            }
        case "frames":
            let frames = mind.listFrames()
            for f in frames.prefix(20) { print("- [\(f.id)]: \(f.rawInput) (salience: \(f.salience))") }
            if frames.count > 20 { print("... \(frames.count - 20) more frames.") }
        case "persist":
            // force persist
            _ = mind.cognize()
            print("Persist requested.")
        case "inspect":
            if arg.isEmpty { print("Usage: inspect <truth|frame> <id>") } else {
                let components = arg.split(separator: " ", maxSplits: 1).map(String.init)
                if components.count < 2 { print("Usage: inspect <truth|frame> <id>") } else {
                    let type = components[0]; let idStr = components[1]
                    if type == "truth", let uuid = UUID(uuidString: idStr), let t = mind.listTruths().first(where: { $0.id == uuid }) {
                        print("Truth: \(t.emergentPrinciple)\nConfidence: \(t.confidence)\nSupporting frames: \(t.supportingFrames.count)")
                    } else if type == "frame", let uuid = UUID(uuidString: idStr), let f = mind.listFrames().first(where: { $0.id == uuid }) {
                        print("Frame raw: \(f.rawInput)\nInterpretation: \(f.subjectiveInterpretation)\nSalience: \(f.salience)")
                    } else { print("Not found.") }
                }
            }
        default:
            // treat as raw phenomenon input
            mind.receiveExternalText(line)
        }
    }

    private func printHelp() {
        print("""
        Commands:
          help                 Show this text
          say <text>           Inject a phenomenon (like 'say Hello?')
          think                Force a cognitive cycle and show decisions
          summary              Print compact state summary
          truths               List derived truths
          frames               List stored phenomenological frames
          persist              Force persist state to disk
          inspect <type> <id>  Inspect a truth or frame by UUID (type: truth|frame)
          quit / exit          Save & Exit
        Any unrecognized input is ingested as a phenomenon.
        """)
    }
}
