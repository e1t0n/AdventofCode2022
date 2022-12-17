import Foundation
import Collections

struct Point: Hashable, CustomStringConvertible {
    var description: String { "x:\(x) y:\(y)" }
    var x: Int
    var y: Int
}

var jets = Array(input)
    .map { String($0) }
    .reduce(into: RingBuffer<String>(count: input.count), { $0.write($1) })

var rocks = shapes.components(separatedBy: "\n\n")
    .map {
        var pattern = [Point]()
        let l = $0.split(whereSeparator: \.isNewline)
        for y in 0..<l.count {
            for x in 0..<l[y].count {
                if String(Array(l[y])[x]) == "#" {
                    pattern.append(Point(x: x+2, y: y))
                }
            }
        }
        return pattern
    }
    .reduce(into: RingBuffer<[Point]>(count: 5), { $0.write($1) })
    
extension String {
    var intValue: Int { Int(self)! }
    var row: Int { components(separatedBy: ",")[0].intValue }
    var column: Int { components(separatedBy: ",")[1].intValue }
    var move: Int { self == ">" ? 1 : -1 }
}

func xOffsetRock(_ points: inout [Point], offset: Int, grid: OrderedSet<Point>? = nil) {
    let maxX = points.max(by: { $0.x < $1.x})!.x
    let minX = points.min(by: { $0.x < $1.x})!.x
    let canMove = (0..<7).contains(maxX+offset) && (0..<7).contains(minX+offset)
    if let grid {
        var pointsCopy = points
        if canMove {
            xOffsetRock(&pointsCopy, offset: offset)
            if grid.intersection(Set(pointsCopy)).count != 0 {
                return
            }
        }
    }
    
    if canMove {
        for p in 0..<points.count {
            points[p].x += offset
        }
    }
}

func yOffsetRock(_ points: inout [Point], offset: Int) {
    for p in 0..<points.count {
        points[p].y += offset
    }
}

func isFalling(_ r: [Point], grid: OrderedSet<Point>, jet: Int) -> Bool {
    if r.min(by: { $0.y < $1.y})!.y <= 0 { return false }
    var points = r
    xOffsetRock(&points, offset: jet, grid: grid)
    yOffsetRock(&points, offset: -1)
    return grid.intersection(Set(points)).count == 0
}

func transformRock(_ r: inout [Point]) {
    let maxY: Int = r.max(by: { $0.y < $1.y})!.y
    if maxY > 0 {
        for p in 0..<r.count {
            let y = abs(r[p].y - maxY)
            r[p].y = y
        }
    }
}

func part1() {
    var numberOfRocks = 2022
    var grid = OrderedSet<Point>()
    var maxY = 0
    
    while numberOfRocks > 0 {
        numberOfRocks -= 1
        var rock = rocks.read()!
        transformRock(&rock)
        yOffsetRock(&rock, offset: maxY + 3)

//        debug(grid.union(OrderedSet(rock)))
        var jet = jets.read()!
        while isFalling(rock, grid: grid, jet: jet.move) {
            xOffsetRock(&rock, offset: jet.move, grid: grid)
            yOffsetRock(&rock, offset: -1)
//            debug(grid.union(OrderedSet(rock)))
            jet = jets.read()!
        }
        xOffsetRock(&rock, offset: jet.move, grid: grid)
        grid.formUnion(OrderedSet(rock))
        maxY = grid.max(by: { $0.y < $1.y })!.y + 1
    }
//    debug(grid)
    print(maxY)
}

func debug(_ grid: OrderedSet<Point>) {
    let maxY = grid.max(by: { $0.y < $1.y})!.y
    for r in (0..<maxY+1).reversed() {
        var str = ""
        for c in (0..<7) {
            if grid.contains(Point(x: c, y: r)) {
                str.append("#")
            } else {
                str.append(".")
            }
        }
        print(str)
    }
    print("\n")
}

part1() //3102
