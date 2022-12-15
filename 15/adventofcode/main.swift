import Foundation

let signals = input.split(whereSeparator: \.isNewline)

extension String {
    var intValue: Int { Int(self)! }
    var x: Int { components(separatedBy: ",")[0].components(separatedBy: "x=")[1].intValue }
    var y: Int { components(separatedBy: ",")[1].components(separatedBy: "y=")[1].intValue }
}

struct Point: Hashable, CustomStringConvertible {
    var description: String { "x:\(x) y:\(y)" }
    var x: Int
    var y: Int
}

func getSensors() -> [Point] {
    let sensors = signals
        .map {
            Point(x: $0.components(separatedBy: ": ")[0].x,
                  y: $0.components(separatedBy: ": ")[0].y)
        }
    return sensors
}

func getBeacons() -> [Point] {
    let beacons = signals
        .map {
            Point(x: $0.components(separatedBy: ": ")[1].x,
                  y: $0.components(separatedBy: ": ")[1].y)
        }
    return beacons
}

func calculateDistance(_ p1: Point, _ p2: Point) -> Int {
    abs(p1.x - p2.x) + abs(p1.y - p2.y)
}

func findX(_ p: Point, sensor: Point, distance: Int) -> Set<Point> {
    var xBeacons = Set<Point>()
    let dx = abs(abs(p.y-sensor.y) - distance)
    if dx == 0 { return [p] }
    xBeacons.reserveCapacity((p.x-dx...p.x+dx).count)
    xBeacons.formUnion(Set(p.x-dx...p.x+dx).map { Point(x: $0, y: p.y) })
    return xBeacons
}

func part1() {
    let sensors = getSensors()
    let beacons = getBeacons()
    var noBeacons = Set<Point>()
    let rowY = 2_000_000
    
    for (sensor,beacon) in zip(sensors, beacons) {
        let distance = calculateDistance(sensor, beacon)
        if (sensor.y-distance...sensor.y+distance).contains(rowY) {
            let xValues = findX(Point(x: sensor.x, y: rowY), sensor: sensor, distance: distance)
            noBeacons.formUnion(xValues)
        }
    }
    
    let result = noBeacons
        .subtracting(beacons)
        .subtracting(sensors)
    print(result.count)
}

//https://www.reddit.com/r/adventofcode/comments/zmcn64/2022_day_15_solutions/
//Find borders of sensors that are just outside its range
//Find the border point that is not in range of any sensor
func part2() {
    let sensors = getSensors()
    let beacons = getBeacons()
    let max = 4_000_000
    var borders = Set<Point>()
    for (sensor,beacon) in zip(sensors, beacons) {
        let range = calculateDistance(sensor, beacon)
        let r = Point(x: sensor.x + (range + 1), y: sensor.y)
        let l = Point(x: sensor.x - (range + 1), y: sensor.y)
        let t = Point(x: sensor.x, y: sensor.y - (range + 1))
        let b = Point(x: sensor.x, y: sensor.y + (range + 1))
        borders.formUnion(points(from: r, to: t, max: max))
        borders.formUnion(points(from: t, to: l, max: max))
        borders.formUnion(points(from: l, to: b, max: max))
        borders.formUnion(points(from: b, to: r, max: max))
    }
    
    for border in borders {
        var inRange = false
        for (sensor,beacon) in zip(sensors, beacons) {
            let range = calculateDistance(sensor, beacon)
            inRange = calculateDistance(border, sensor) <= range
            if inRange { break }
        }
        if !inRange {
            print((border.x * max) + border.y)
            break
        }
    }
}

func points(from start: Point, to end: Point, max: Int) -> [Point] {
    var result = [Point]()
    let dx = (end.x - start.x).signum()
    let dy = (end.y - start.y).signum()
    let range = abs(start.x - end.x)
    result.reserveCapacity(range)
    result = (0..<range)
        .map { Point(x: start.x + dx * $0, y: start.y + dy * $0) }
        .filter { $0.x >= 0 && $0.x <= max && $0.y >= 0 && $0.y <= max }
    return result
}

part1() //5240818
part2() //13213086906101
