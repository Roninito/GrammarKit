import Foundation
import  GameplayKit

// A generalized Aristid Lindenmayer System. This design is intended to be functional and utilize decision trees.
public struct GrammarEncoder {
    
    public typealias Formula = String
    public typealias Variable = String
    public typealias ProductionVariants = [String]
    public typealias ProductionRules = [Variable: ProductionVariants]
    
    static let seeder = "Thequickredfoxranawayfromthelazybrowndog"
    
    
    // The start string that is used as the production formula.
    public var axium: Formula
    
    // A dictionary in the form where P = A(0.3). P = production rule. A = Alphabet, (0.3) = Weight or probality. This system a list of probable alpha replacements making it Stochastic.
    public var rules: ProductionRules
    
    
    public init(axium: Formula, rules: String) {
        self.axium = axium
        var r: ProductionRules = [:]
        
        let ruleList = rules.components(separatedBy: ", ")
        for rule in ruleList {
            let ruleComponents = rule.components(separatedBy: ": ")
            let variable = ruleComponents.first!
            let variants = ruleComponents.last!.components(separatedBy: " | ")
            r[variable] = variants
        }
        self.rules = r
    }
    
    
    /// This must be seeded with a four letter word.
    public func produce(itterations: Int, seed: String = "") -> String {
        // enforce seed letter count
        var validatedSeed = seed
        while validatedSeed.count > 4 { _ = validatedSeed.removeLast() }
        while validatedSeed.count < 4 { validatedSeed +=  String(GrammarEncoder.seeder.randomElement() ?? "-") }
        let seededRandom = GKARC4RandomSource(seed: Data(base64Encoded: validatedSeed)!)
        var production = axium
        for _ in 0..<itterations {
            let axiumParts = production.filter({ _ in return true })
            var itter = ""
            for alpha in axiumParts {
                // If production rule available, treat as a variable.
                if  let variants = rules["\(alpha)"], variants.count > 0 {
                    // shuffle variants and return the first
                    itter +=  seededRandom.arrayByShufflingObjects(in: variants).first as! String
                }
                else {
                    // re-insert Constant
                    itter +=  String(alpha)
                }
            }
            production = itter
        }
        print("GrammarEncoder seed: \(validatedSeed) Itterations: \(itterations) Produced: \(production)")
        return production
    }
}
