import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let rounds = content.split(whereSeparator: \.isNewline)

extension String {
    var opponent: String {
        self.components(separatedBy: " ")[0]
    }
    
    var you: String {
        self.components(separatedBy: " ")[1]
    }
}

func part1() {
    let score = rounds
        .lazy
        .map { String($0) }
        .map {
            switch ($0.opponent, $0.you) {
            case ("A", "X"):
                return 3+1
            case ("A", "Y"):
                return 6+2
            case ("A", "Z"):
                return 0+3
                
            case ("B", "X"):
                return 0+1
            case ("B", "Y"):
                return 3+2
            case ("B", "Z"):
                return 6+3
                
            case ("C", "X"):
                return 6+1
            case ("C", "Y"):
                return 0+2
            case ("C", "Z"):
                return 3+3
                
            default: fatalError()
            }
        }
        .reduce(0, +)
    print(score)
}

func part2() {
    //y - draw, z - win, x - lose
    //rock-1, paper-2, sci - 3
    let score = rounds
        .map { String($0) }
        .map {
            switch ($0.opponent, $0.you) {
            case ("A", "X"):
                return 0+3
            case ("A", "Y"):
                return 3+1
            case ("A", "Z"):
                return 6+2
                
            case ("B", "X"):
                return 0+1
            case ("B", "Y"):
                return 3+2
            case ("B", "Z"):
                return 6+3
                
            case ("C", "X"):
                return 0+2
            case ("C", "Y"):
                return 3+3
            case ("C", "Z"):
                return 6+1
                
            default: fatalError()
            }
        }
        .reduce(0, +)
    print(score)
}

part1() //12679
part2() //14470
