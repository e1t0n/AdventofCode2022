import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let coordinates = content.split(whereSeparator: \.isNewline)
    .map { $0.split(separator: " -> ") }
    .map { $0.map { String($0) } }

struct Point: Hashable, CustomStringConvertible {
    var description: String { "x:\(x) y:\(y)" }
    var x: Int
    var y: Int
}

extension String {
    var intValue: Int { Int(self)! }
    var x: Int { components(separatedBy: ",")[0].intValue }
    var y: Int { components(separatedBy: ",")[1].intValue }
}

func getStoneCoordinates() -> Set<Point> {
    var stones = Set<Point>()
    for line in coordinates {
        for i in 0..<line.count-1 {
            let start = line[i]
            let end = line[i+1]
            if start.x == end.x {
                let startY = start.y < end.y ? start.y : end.y
                let endY = start.y < end.y ? end.y : start.y
                for y in startY...endY {
                    stones.insert(Point(x: start.x, y: y))
                }
            }
            else {
                let startX = start.x < end.x ? start.x : end.x
                let endX = start.x < end.x ? end.x : start.x
                for x in startX...endX {
                    stones.insert(Point(x: x, y: start.y))
                }
            }
        }
    }
    return stones
}

func part1() {
    let stones = getStoneCoordinates()
    var fallingSand = stones
    let maxY = stones.map { $0.y }.max()!
    
    func isStone(_ x: Int, _ y: Int) -> Bool {
        stones.contains(Point(x: x, y: y))
    }
    
    func isFilled(_ x: Int, _ y: Int) -> Bool {
        fallingSand.contains(Point(x: x, y: y))
    }
    
    while true {
        var dX = 500
        var dY = 0
        while true {
            if dY == maxY {
                print(fallingSand.subtracting(stones).count)
                return
            }
            
            if !isFilled(dX, dY+1) {
                dY += 1
            }
            else if !isFilled(dX-1, dY+1) {
                dX -= 1
                dY += 1
            }
            else if !isFilled(dX+1, dY+1) {
                dX += 1
                dY += 1
            }
            else {
                break
            }
        }
        fallingSand.insert(Point(x: dX, y: dY))
    }
}

func part2() {
    var stones = getStoneCoordinates()
    let maxY = stones.map { $0.y }.max()!
    for floor in 0...1000 { //simulate infinite floor
        stones.insert(Point(x: floor, y: maxY+2))
    }
    var fallingSand = stones
    
    func isFilled(_ x: Int, _ y: Int) -> Bool {
        fallingSand.contains(Point(x: x, y: y))
    }
        
    while true {
        var dX = 500
        var dY = 0
        while true {
            if fallingSand.contains(Point(x: 500, y: 0)) {
                print(fallingSand.subtracting(stones).count)
                return
            }
            
            if !isFilled(dX, dY+1) {
                dY += 1
            }
            else if !isFilled(dX-1, dY+1) {
                dX -= 1
                dY += 1
            }
            else if !isFilled(dX+1, dY+1) {
                dX += 1
                dY += 1
            }
            else {
                break
            }
        }
        fallingSand.insert(Point(x: dX, y: dY))
    }
}

part1() //578
part2() //24377
