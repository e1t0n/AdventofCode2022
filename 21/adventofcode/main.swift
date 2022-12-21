import Foundation

extension String {
    var yellingMonkey: String { components(separatedBy: ":")[0] }
    var yell: String { components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces) }
    var intValue: Int { Int(self)! }
    func yells(_ sep: Character) -> [String] {
        split(separator: sep).map { $0.trimmingCharacters(in: .whitespaces) }
    }
    var isOperation: Bool { split(whereSeparator: \.isMathSymbol).count > 1 }
    var operand: Character { first(where: \.isMathSymbol)! }
}

let mathMonkeys = input
    .replacingOccurrences(of: "/", with: "∕")
    .replacingOccurrences(of: "*", with: "×")
    .replacingOccurrences(of: "-", with: "−")
    .split(whereSeparator: \.isNewline).map { String($0) }

let monkeyDict = Dictionary(grouping: mathMonkeys) { $0.yellingMonkey }

func performOp(_ s: [String], op: Character) -> String {
    switch op {
    case "+":
        return "\(s[0].intValue + s[1].intValue)"
    case "−":
        return "\(s[0].intValue - s[1].intValue)"
    case "×":
        return "\(s[0].intValue * s[1].intValue)"
    case "∕":
        return "\(s[0].intValue / s[1].intValue)"
    default: assertionFailure()
    }
    return ""
}

func getValue(_ s: String, dict: [String: [String]]) -> String {
    if let q = dict[s]?.first?.yell {
        if q.isOperation {
            let num1 = getValue(q.yells(q.operand)[0], dict: dict)
            let num2 = getValue(q.yells(q.operand)[1], dict: dict)
            return performOp([num1, num2], op: q.operand)
        }
        return q
    }
    return ""
}

func part1() {
    let root = getValue("root", dict: monkeyDict)
    print(root)
}

part1() //286698846151845
