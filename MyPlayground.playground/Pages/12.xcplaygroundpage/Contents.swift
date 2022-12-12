import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let grid = content
    .split(whereSeparator: \.isNewline)
    .map(String.init)
    .map(Array.init)
//print(grid)

struct Point: Hashable {
    var r: Int
    var c: Int
}

extension Character {
    var elevation: Int { Array("SabcdefghijklmnopqrstuvwxyzE").firstIndex(of: self)! }
}

let startRow = grid.firstIndex(of: grid.filter { $0.contains("S") }.first!)!
let endRow = grid.firstIndex(of: grid.filter { $0.contains("E") }.first!)!
let start = Point(r: startRow,  c: grid[startRow].firstIndex(of: "S")!)
let end = Point(r: endRow, c: grid[endRow].firstIndex(of: "E")!)
let rowCount = grid.count
let columnCount = grid[0].count

func part1() {
    var heap = Heap<(Int, Point)>(sort: { $0.0 < $1.0 }) //Dijkstra’s Algorithm
    heap.insert((0, start))
    var visited = Set<Point>()
    
    while true {
        guard let node: (Int, Point) = heap.remove() else { break }
        guard !visited.contains(node.1) else { continue }
        visited.insert(node.1)
        
        if node.1 == end {
            print(node.0)
            break
        }
        
        var neighbours = [Point]()
        
        for (dr, dc) in [(0,1), (0,-1), (1,0), (-1,0)] {
            let rr = node.1.r + dr
            let cc = node.1.c + dc
            
            guard rr < rowCount, cc < columnCount, rr >= 0, cc >= 0 else { continue }
            
            if grid[rr][cc].elevation <= grid[node.1.r][node.1.c].elevation+1 {
                neighbours.append(Point(r: rr, c: cc))
            }
        }
                
        for p in neighbours {
            heap.insert((node.0+1, Point(r: p.r, c: p.c)))
        }
    }
}

func part2() {
    var heap = Heap<(Int, Point)>(sort: { $0.0 < $1.0 })
    heap.insert((0, end)) //start at E and backtrack
    var visited = Set<Point>()
    
    while true {
        guard let node: (Int, Point) = heap.remove() else { break }
        guard !visited.contains(node.1) else { continue }
        visited.insert(node.1)
        
        if grid[node.1.r][node.1.c] == "a" {
            print(node.0)
            break
        }
        
        var neighbours = [Point]()
        for (dr, dc) in [(0,1), (0,-1), (1,0), (-1,0)] {
            let rr = node.1.r + dr
            let cc = node.1.c + dc
            
            guard rr < rowCount, cc < columnCount, rr >= 0, cc >= 0 else { continue }
            
            if grid[rr][cc].elevation >= grid[node.1.r][node.1.c].elevation-1 {
                neighbours.append(Point(r: rr, c: cc))
            }
        }
        
        for p in neighbours {
            heap.insert((node.0+1, Point(r: p.r, c: p.c)))
        }
    }
}

part1() //408
part2() //399
