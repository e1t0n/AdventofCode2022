import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)

func parse(list: String) -> [Any] {
    var arrayList = Stack<[Any]>()
    var previousWasInt = false
    var shouldAppend = false
    for char in list.dropFirst().dropLast() {
        if char == "[" {
            var newArray = [Any]()
            arrayList.push(newArray)
            previousWasInt = false
        }
        
        var popped: [Any]? = nil
        if char == "]" {
            popped = arrayList.pop()
            previousWasInt = false
        }
        
        var array = arrayList.pop() ?? [Any]()
        if let popped { array.append(popped) }
        shouldAppend = previousWasInt && char.isWholeNumber
        
        if char.isWholeNumber {
            var newElement = char.wholeNumberValue!
            if shouldAppend {
                let a = array.removeLast()
                newElement = Int("\(a)\(char)")!
            }
            array.append(newElement)
            previousWasInt = true
        }
        else { previousWasInt = false }
        
        arrayList.push(array)
    }
    return arrayList.flatMap { $0 }
}

func isCorrectOrder(_ l: Any, _ r: Any) -> Int {
    var left = l
    var right = r
    
    if let left = left as? Int,
       let right = right as? Int {
        //        print("int", left, right)
        if left < right { return 1 }
        else if left > right { return 0 }
    }
    
    if var left = left as? [Any],
       var right = right as? [Any] {
        //        print("array", left, "&", right)
        while true {
            if right.isEmpty && !left.isEmpty {
                return 0
            }
            if !right.isEmpty && left.isEmpty {
                return 1
            }
            if left.isEmpty && right.isEmpty {
                return -1
            }
            let l1 = left.removeFirst()
            let r1 = right.removeFirst()
            let result = isCorrectOrder(l1, r1)
            if result == -1 { continue }
            return result
        }
    }
    
    if let left = left as? [Any],
       let right = right as? Int {
        //        print("array-int", left, right)
        return isCorrectOrder(left, [right])
    }
    
    if let right = right as? [Any],
       let left = left as? Int {
        //        print("int-array", left, right)
        return isCorrectOrder([left], right)
    }
    
    return -1
}

func part1() {
    let signals = content
        .components(separatedBy: "\n")
        .split(separator: "")
        .map { (Array($0)[0], Array($0)[1]) }
    
    var sum = 0
    for (i, (left, right)) in signals.enumerated() {
        let leftParsed = parse(list: left)
        let rightParsed = parse(list: right)
        let result = isCorrectOrder(leftParsed, rightParsed)
        if result == 1 {
            sum += i+1
        }
    }
    print(sum)
}

func part2() {
    let divider = "[[2]]\n[[6]]"
        .components(separatedBy: "\n")
        .map(parse)
    var signals = content
        .components(separatedBy: "\n")
        .split(separator: "")
        .flatMap { $0 }
        .map(parse)
    signals.append(contentsOf: divider)
    signals.sort { isCorrectOrder($0, $1) == 1 }
    
    var index1 = 0
    var index2 = 0
    for i in 0..<signals.count {
        if let a = signals[i] as? [[Int]] {
            if a == [[2]] {
                index1 = i+1
            }
            else if a == [[6]] {
                index2 = i+1
            }
            
            if index1 != 0 && index2 != 0 { break }
        }
    }
    print(index1*index2)
}

part1() //5198
part2() //22344
