import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let stream = Array(content)

func findMarker(size: Int) -> Int {
    var index = 0
    while index < stream.count-size-1 {
        if stream[index..<index+size].count == Set(stream[index..<index+size]).count {
            return index + size
        }
        index += 1
    }
    return index
}

func part1() {
    print(findMarker(size: 4))
}

func part2() {
    print(findMarker(size: 14))
}

part1() //1909
part2() //3380
