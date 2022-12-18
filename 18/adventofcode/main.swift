import Foundation

extension String {
    var intValue: Int { Int(self)! }
    var x: Int { components(separatedBy: ",")[0].intValue }
    var y: Int { components(separatedBy: ",")[1].intValue }
    var z: Int { components(separatedBy: ",")[2].intValue }
}

struct Point: Hashable, CustomStringConvertible {
    var description: String { "x:\(x) y:\(y) z:\(z)" }
    var x: Int
    var y: Int
    var z: Int
    
    func adjacent() -> [Point] {
        var adjacentCubes = [Point]()
        for d in 0..<3 { //x,y,z
            adjacentCubes.append(contentsOf: [-1, 1].compactMap {
                switch d {
                case 0:
                    return Point(x: x+$0, y: y, z: z)
                case 1:
                    return Point(x: x, y: y+$0, z: z)
                case 2:
                    return Point(x: x, y: y, z: z+$0)
                default: return nil
                }
            })
        }
        return adjacentCubes
    }
}

let cubes = Set(
    input.split(whereSeparator: \.isNewline)
        .map { String($0) }
        .map { Point(x: $0.x, y: $0.y, z: $0.z) }
)


func part1() {
    let allSides = cubes
        .map { $0.adjacent() }
        .flatMap { $0 }
        .filter { !cubes.contains($0) }
    print(allSides.count)
}

part1() //3454
