import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let program = content.split(whereSeparator: \.isNewline).map(String.init)

extension String {
    var cycle: Int {
        self == "noop" ? 1 : 2
    }
    
    var x: Int {
        Int(self.components(separatedBy: " ")[1])!
    }
}

func part1() {
    var x = 1
    var cycleCount = 0
    var signalCheck = 20
    var strength = [Int()]
    for instruction in program {
        let cycles = instruction.cycle
        for cycle in 1...cycles {
            cycleCount += 1
            if cycleCount == signalCheck {
                strength.append(cycleCount * x)
                signalCheck += 40
            }
            if cycle == 2 {
                x += instruction.x
            }
        }
    }
    
    print(strength.reduce(0,+))
}

func part2() {
    var x = 1
    var cycleCount = 0
    var spritePosition = Array(0...2)
    var screen = Array(repeating: "", count: 6)
    for instruction in program {
        let cycles = instruction.cycle
        for cycle in 1...cycles {
            cycleCount += 1
            let row = (cycleCount-1) / 40
            let pixel = (cycleCount-1) % 40
            spritePosition.contains(pixel) ? screen[row].append("#") : screen[row].append(".")
            
            if cycle == 2 {
                x += instruction.x
                spritePosition = Array(x-1...x+1)
            }
                        
            if cycleCount % 40 == 0 {
                spritePosition = Array(0...2)
            }
        }        
    }
    print(screen.joined(separator: "\n"))
}

part1() //12880
part2() // FCJAPJRE
