import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let input = content
    .components(separatedBy: "\n")
    .split(separator: "")
    .map { $0.map { String($0).trimmingCharacters(in: .whitespaces) } }
//print(content)

class Monkey: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String { "\(items) op:\(operation) test:\(test) worry:\(worry) ifTrue:\(ifTrue) ifFalse:\(ifFalse)" }
    var debugDescription: String { "\(inspections)" }
    var items: [Int]
    let operation: String
    let test: Int
    let worry: Int
    let ifTrue: Int
    let ifFalse: Int
    var inspections = 0
    
    init(items: [Int], operation: String, test: Int, worry: Int, ifTrue: Int, ifFalse: Int) {
        self.items = items
        self.operation = operation
        self.test = test
        self.worry = worry
        self.ifTrue = ifTrue
        self.ifFalse = ifFalse
    }
}

extension String {
    var key: String { self.components(separatedBy: ":")[0].trimmingCharacters(in: .whitespaces) }
    var value: String { self.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces) }
    var intValue: Int { Int(self.trimmingCharacters(in: .whitespaces)) ?? 0 }
}

func getMonkeys() -> [Monkey] {
    var monkeys = [Monkey]()
    let ops = ["+", "*"]
    for line in input {
        var items = [Int]()
        var op: String = ""
        var test: Int = 0
        var worry = 0
        var ifTrue = 0
        var ifFalse = 0
        for monkeyStr in line {
            switch monkeyStr.key {
            case "Starting items":
                items = monkeyStr.value.split(separator: ", ").map { Int($0)! }
            case "Operation":
                op = String(monkeyStr.value.filter { ops.contains(String($0)) }.first!)
                worry = monkeyStr.value.components(separatedBy: op)[1].intValue
            case "Test":
                test = monkeyStr.value.replacingOccurrences(of: "divisible by ", with: "").intValue
            case _ where monkeyStr.key.starts(with: "If false"):
                ifFalse = monkeyStr.value.components(separatedBy: "monkey ")[1].intValue
            case _ where monkeyStr.key.starts(with: "If true"):
                ifTrue = monkeyStr.value.components(separatedBy: "monkey ")[1].intValue
            case _ where monkeyStr.key.starts(with: "Monkey"):
                continue
            default:
                assertionFailure()
            }
        }
        let monkey = Monkey(items: items, operation: op, test: test, worry: worry, ifTrue: ifTrue, ifFalse: ifFalse)
        monkeys.append(monkey)
    }
    //print(monkeys.debugDescription)
    return monkeys
}

func part1() {
    var monkeys = getMonkeys()
    for _ in 0..<20 {
        for monkey in monkeys {
            for _ in 0..<monkey.items.count {
                monkey.inspections += 1
                let item = monkey.items.removeFirst()
                var currentWorry = 0
                
                switch monkey.operation {
                case "+":                    
                    currentWorry = (monkey.worry + item)/3
                case "*":
                    if monkey.worry == 0 { currentWorry = (item * item)/3 }
                    else { currentWorry = (monkey.worry * item)/3 }
                default: assertionFailure()
                }
                
                if currentWorry % monkey.test == 0 {
                    monkeys[monkey.ifTrue].items.append(currentWorry)
                } else {
                    monkeys[monkey.ifFalse].items.append(currentWorry)
                }
            }
        }
    }
    let result = monkeys
        .map { $0.inspections }
        .sorted(by: >)
        .prefix(2)
        .reduce(1, *)
    print(result)
}

//https://www.reddit.com/r/adventofcode/comments/zim5o6/2022_day11_part2_python_brute_force/
func part2() {
    var monkeys = getMonkeys()
    let mod = monkeys.map { $0.test }.reduce(1, *)
    
    for _ in 0..<10_000 {
        for monkey in monkeys {
            for _ in 0..<monkey.items.count {
                monkey.inspections += 1
                let item = monkey.items.removeFirst()
                var currentWorry = 0
                
                switch monkey.operation {
                case "+":
                    currentWorry = monkey.worry + item
                case "*":
                    if monkey.worry == 0 { currentWorry = item * item }
                    else { currentWorry = monkey.worry * item }
                default: assertionFailure()
                }
                
                currentWorry = currentWorry % mod
                
                if currentWorry % monkey.test == 0 {
                    monkeys[monkey.ifTrue].items.append(currentWorry)
                } else {
                    monkeys[monkey.ifFalse].items.append(currentWorry)
                }
            }
        }
    }
    let result = monkeys
        .map { $0.inspections }
        .sorted(by: >)
        .prefix(2)
        .reduce(1, *)
    print(result)
}

part1()//78960
part2()//14561971968

