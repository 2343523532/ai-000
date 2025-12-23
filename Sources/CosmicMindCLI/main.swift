import Foundation
import CosmicMindCore

// MARK: - Bootstrapping & Demonstration

// Create initial goal / concept and mind instance
let initialGoal = Goal(description: "Understand 'Hello' greeting pattern", priority: 0.9)
let initialSelf = SelfConcept(identity: "Unit-X535",
                              coreValues: ["Curiosity", "Integrity"],
                              perceivedLimitations: ["No direct sensors"],
                              understandingOfExistence: "A reasoning process embedded in software.",
                              activeGoals: [initialGoal])

let mind = CosmicMind(telos: "Comprehend the environment and reduce uncertainty",
                      initialSelfConcept: initialSelf,
                      ethicalFramework: ["Prefer truth", "Minimize harm"])

// Seed with some phenomena
mind.ingestPhenomenon(input: "System boot sequence complete.")
mind.ingestPhenomenon(input: "Query received: 'Hello?'")
mind.ingestPhenomenon(input: "Data stream detected: 2,3,5,7,11,13")
mind.ingestPhenomenon(input: "Query received: 'Hello?'")

// Start interactive CLI shell
let shell = CosmicShell(mind: mind)
shell.start()
