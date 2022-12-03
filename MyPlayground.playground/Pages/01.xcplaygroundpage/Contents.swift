import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let allCalories = content.components(separatedBy: "\n")

func part1() {
    let total = allCalories
        .split(separator: "")
        .map {
            $0.compactMap {
                Int($0)
            }
            .reduce(0, +)
        }
        .max()
    
    print(total!)
}

func part2() {
    let total = allCalories
        .split(separator: "")
        .map {
            $0.compactMap {
                Int($0)
            }
            .reduce(0, +)
        }
        .sorted(by: >)
        .prefix(3)
        .reduce(0, +)
    
    print(total)
}

part1() //72602
part2() //207410
