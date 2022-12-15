import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let list = content.split(whereSeparator: \.isNewline)

extension String {
    var start: Int {
        Int(self.split(separator: "-")[0])!
    }
    
    var end: Int {
        Int(self.split(separator: "-")[1])!
    }
}

func part1() {
    let assignments = list
        .map { $0.split(separator: ",") }
        .map { $0.map { Array(String($0).start...String($0).end) } }
        .map { $0[0].contains($0[1]) || $0[1].contains($0[0]) }
    
    let total = assignments.filter { $0 }.count
    print(total)
}

func part2() {
    let assignments = list
        .map { $0.split(separator: ",") }
        .map { $0.map { Array(String($0).start...String($0).end) } }
        .map { Set($0[0]).intersection(Set($0[1])) }
    
    let total = assignments
        .filter { !$0.isEmpty }
        .count
    print(total)
}

part1() //562
part2() //924
