import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let grid = content
    .split(whereSeparator: \.isNewline)
    .map(String.init)
    .map(Array.init)
    .map { $0.map { Int(String($0))! } }
//print(content)
//print(grid)

struct Tree: Hashable {
    var r: Int
    var c: Int
}

func part1() {
    var visible = Set<Tree>()
    
    for (ri, row) in grid.enumerated() {
        let cols = row.count
        
        //from left
        var visited = [Int]()
        for ci in 0..<cols {
            let tree = Tree(r: ri, c: ci)
            
            if ci == 0 {
                visible.insert(tree)
            } else if row[ci] > visited.max() ?? 0 {
                visible.insert(tree)
            }
            visited.append(row[ci])
        }
        
        //from right
        visited = [Int]()
        for ci in (0..<cols).reversed() {
            let tree = Tree(r: ri, c: ci)
            if ci == cols-1 {
                visible.insert(tree)
            } else if row[ci] > visited.max() ?? 0 {
                visible.insert(tree)
            }
            visited.append(row[ci])
        }
    }
    
    let rows = grid[0].count
    let cols = grid.count
    
    //from top
    for ci in 0..<cols {
        var visited = [Int]()
        for ri in 0..<rows {
            let tree = Tree(r: ri, c: ci)
            if ri == 0 {
                visible.insert(tree)
            } else if grid[ri][ci] > visited.max() ?? 0 {
                visible.insert(tree)
            }
            visited.append(grid[ri][ci])
        }
    }
    
    //from bottom
    for ci in 0..<cols {
        var visited = [Int]()
        for ri in (0..<rows).reversed() {
            let tree = Tree(r: ri, c: ci)
            if ri == rows-1 {
                visible.insert(tree)
            } else if grid[ri][ci] > visited.max() ?? 0 {
                visible.insert(tree)
            }
            visited.append(grid[ri][ci])
        }
    }
    
    print(visible.count)
}

func part2() {
    var scenicScore = 0
    let rows = grid[0].count
    let cols = grid.count
        
    for ri in 0..<rows {
        for ci in 0..<cols {
            if (ri == 0 || ci == 0) || (ri == rows-1 || ci == cols-1) {
                continue
            }
            let current = grid[ri][ci]
            
            var lCol = 0
            var left = 0
            while ci+lCol > 0 {
                lCol -= 1
                left += 1
                if grid[ri][ci+lCol] < current {}
                else { break }
            }

            var rCol = 0
            var right = 0
            while ci+rCol < cols-1 {
                rCol += 1
                right += 1
                if grid[ri][ci+rCol] < current {}
                else { break }
            }
            
            var tRow = 0
            var top = 0
            while ri+tRow > 0 {
                tRow -= 1
                top += 1
                if grid[ri+tRow][ci] < current {}
                else { break }
            }
            
            var bRow = 0
            var bottom = 0
            while ri+bRow < rows-1 {
                bRow += 1
                bottom += 1
                if grid[ri+bRow][ci] < current {}
                else { break }
            }
            let score = left * top * right * bottom
            if scenicScore < score {
                scenicScore = score
            }            
        }
    }
        
    print(scenicScore)
}

part1() //1851
part2() //574080
