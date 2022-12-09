import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let motions = content.split(whereSeparator: \.isNewline).map(String.init)
//print(motions)

struct Position: Hashable, CustomStringConvertible {
    var description: String { "x:\(x) y:\(y)"}
    var x: Int
    var y: Int
    
    mutating func moveTail(headPos: Position) {
        if self == headPos { //no need to move
            return
        }
        
        if abs(headPos.x - x) <= 1 && abs(headPos.y - y) <= 1 { //no need to move
            return
        }
                
        let dX = x < headPos.x ? 1 : -1
        let dY = y < headPos.y ? 1 : -1
        if x == headPos.x {
            y += dY
        } else if headPos.y == y {
            x += dX
        } else {
            y += dY
            x += dX
        }
    }
}

extension String {
    var direction: String {
        components(separatedBy: " ")[0]
    }
    
    var steps: Int {
        Int(components(separatedBy: " ")[1])!
    }
}

func part1() {
    var headPos = Position(x: 0, y: 0)
    var tailPos = Position(x: 0, y: 0)
    var tailPositions = Set<Position>()
    
    for motion in motions {
        for _ in 1...motion.steps {
            switch motion.direction {
            case "R":
                headPos.x += 1
            case "U":
                headPos.y += 1
            case "L":
                headPos.x -= 1
            case "D":
                headPos.y -= 1
            default: assertionFailure()
            }
            
            tailPos.moveTail(headPos: headPos)
            tailPositions.insert(tailPos)
        }
    }
    
    print(tailPositions.count)
}

func part2() {
    var knots = [Position]()
    (0...9).forEach { _ in knots.append(Position(x: 0, y: 0)) }
    var tailPositions = Set<Position>()
    
    for motion in motions {
        for _ in 0..<motion.steps {
            switch motion.direction {
            case "R":
                knots[0].x += 1
            case "U":
                knots[0].y += 1
            case "L":
                knots[0].x -= 1
            case "D":
                knots[0].y -= 1
            default: assertionFailure()
            }
            
            for k in 0..<knots.count-1 {
                knots[k+1].moveTail(headPos: knots[k])
            }
            
            tailPositions.insert(knots.last!)
        }
    }
    
    print(tailPositions.count)
}

part1() //6563
part2() //2653
