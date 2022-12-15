import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let list = content.components(separatedBy: "\n")

extension String {
    var intValue: Int { Int(self)! }
    var crates: Int { self.components(separatedBy: " ")[1].intValue }
    var from: Int { self.components(separatedBy: " to ")[0].intValue }
    var to: Int { self.components(separatedBy: " to ")[1].intValue }
}

typealias Stack = [Int: [Character]]

func arrangeStack() -> Stack {
    var stacks = Stack()
    
    let stacksRow = list
        .split(separator: "")
        .first!
        .dropLast()
        .reversed()
    
    stacksRow.forEach { line in
        var current = 1
        for i in stride(from: 1, to: line.count, by: 4) {
            
            if stacks[current] == nil {
                stacks[current] = []
            }
            
            if Array(line)[i].isLetter {
                stacks[current]!.insert(Array(line)[i], at: 0)
            }
            current += 1
        }
    }
    return stacks
}
 
let procedure = list
    .split(separator: "")
    .last!
    .map { $0.components(separatedBy: " from ") }

func getResult(_ stacks: Stack) -> String {
    var result = ""
    for i in 1...stacks.count {
        result.append(stacks[i]!.first!)
    }
    return result
}

func part1() {
    var stacks = arrangeStack()
    procedure
        .forEach {
            let crates = $0.first!.crates
            let fromStack = $0.last!.from
            let toStack = $0.last!.to
            for _ in 0..<crates {
                stacks[toStack]!.insert(stacks[fromStack]!.removeFirst(), at: 0)
            }
        }
        
    print(getResult(stacks))
}

func part2() {
    var stacks = arrangeStack()
    procedure
        .forEach {
            let crates = $0.first!.crates
            let fromStack = $0.last!.from
            let toStack = $0.last!.to
            let removed = stacks[fromStack]!.prefix(crates)
            stacks[fromStack]!.removeFirst(crates)
            stacks[toStack]!.insert(contentsOf: removed, at: 0)
        }
        
    print(getResult(stacks))
}

part1() //TDCHVHJTG
part2() //NGCMPJLHV
