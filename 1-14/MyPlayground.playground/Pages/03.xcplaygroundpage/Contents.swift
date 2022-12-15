import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let list = content.split(whereSeparator: \.isNewline)
let priority = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

extension String {
    var compartments: [String] {
        [String(self.prefix(self.count/2)),
        String(self.suffix(self.count/2))]
    }
}

func part1() {
    let sum = list
        .map { String($0) }
        .map { $0.compartments }
        .map {
            Set($0[0]).intersection(Set($0[1]))
        }
        .map { priority.firstIndex(of: Array($0)[0])!+1 }
        .reduce(0, +)
    print(sum)
}

func part2() {
    let sum = list
        .map { String($0) }
        .chunked(into: 3)
        .map {
            Set($0[0]).intersection(Set($0[1])).intersection(Set($0[2]))
        }
        .map { priority.firstIndex(of: Array($0)[0])!+1 }
        .reduce(0, +)
    print(sum)
}

part1() //7793
part2() //2499
