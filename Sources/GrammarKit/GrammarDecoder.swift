import Foundation
import Combine

public typealias GrammarInstruction = (Any) -> ()


public protocol GrammarDecoderDelegate {
    func grammarDecoderWillProduceItem(for instructionCharacter: Character, in context: Any)
}


open class GrammarDecoder: ObservableObject {
    
    @Published public var publisher = PassthroughSubject<Any, Never>()
    
    public var instructions: [Character: GrammarInstruction] = [:]
    public var context: Any {
        didSet {
            publisher.send(self.context)
        }
    }
    
    public var delegate: GrammarDecoderDelegate?
    
    
    public init(context: Any, instructions: [Character: GrammarInstruction]) {
        self.instructions = instructions
        self.context = context
    }
    
    
    public func decode(_ grammar: String) -> Any {
        grammar.forEach { instructionCharacter in
            delegate?.grammarDecoderWillProduceItem(for: instructionCharacter, in: context)
            if let instruction = instructions[instructionCharacter] {
                instruction(context)
            }
        }
        publisher.send(context)
        return context
    }
}



