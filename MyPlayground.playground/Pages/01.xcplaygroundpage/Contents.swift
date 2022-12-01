import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let allCalories = content.components(separatedBy: "\n")


func part1() {
    var most = 0
    var elf = 0
    for c in allCalories {
        if let calorie = Int(c) {
            elf += calorie
        } else {
            if most < elf {
                most = elf
            }
            elf = 0
        }
    }
    
    print(most)
}

func part2() {
    var totalCalories = [Int]()
    var elf = 0
    for c in allCalories {
        if let calorie = Int(c) {
            elf += calorie
        } else {
            totalCalories.append(elf)
            elf = 0
        }
    }
    
    print(
        totalCalories
        .sorted(by: >)
        .prefix(3)
        .reduce(0, +)
    )
}

part1() //72602
part2() //207410
