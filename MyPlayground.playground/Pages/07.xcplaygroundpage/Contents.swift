import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let terminal = content.split(whereSeparator: \.isNewline)

extension String {
    var directory: String { self.components(separatedBy: " ")[2] }
    var isBack: Bool { self == ".." }
}

class Directory: CustomStringConvertible {
    weak var parent: Directory?
    var description: String { "dir:\(value) s:\(totalSize) sub:\(children)" }
    var value: String
    var size: Int
    private(set) var children: [Directory]
    
    init(_ value: String) {
        self.value = value
        size = 0
        children = []
    }
    
    var totalSize: Int {
        size + children.map { $0.totalSize }.reduce(0, +)
    }
    
    func sumTotalSizes() -> [Int] {
         [totalSize] + children.flatMap { $0.sumTotalSizes() }
    }
    
    func add(child: Directory) {
        child.parent = self
        children.append(child)
    }
}

func generateDirectories() -> Directory {
    let rootDir = Directory("/")
    var current = rootDir
    let cmds = terminal
        .dropFirst()
        .map { String($0) }
    
    for cmd in cmds {
        if cmd.starts(with: "$ cd") {
            if cmd.directory.isBack {
                current = current.parent ?? rootDir
                continue
            }
            
            let temp = Directory(cmd.directory)
            if current.parent == nil { current.add(child: temp) }
            else { current.add(child: temp) }
            current = temp
        }
        else if let size = Int(cmd.components(separatedBy: " ")[0]) {
            current.size += size
        }
    }
    
    return rootDir
}

let rootDir = generateDirectories()

func part1() {
    let total = rootDir
        .sumTotalSizes()
        .filter { $0 <= 100000 }
        .reduce(0, +)
    print(total)
}

func part2() {
    let available = 70000000-30000000
    let neededFreeSpace = rootDir.totalSize-available
    let result = rootDir
        .sumTotalSizes()
        .filter { $0 >= neededFreeSpace }
        .min()!
    print(result)
}

part1() //1297683
part2() //5756764
