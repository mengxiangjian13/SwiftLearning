import UIKit

// map 对于array的map，比较熟悉，不用再说

// Dictionary的map

// Dictionary 通过map遍历出的element是一个tuple，(key:key, value:value)

let someDict = ["1": 1, "2": 2, "3": 3]
let mapDict = someDict.map {$0}
print(mapDict) // tuple 的数组

// Dictionary 通过mapValues遍历Value, 并实现value的映射替换。获得的结果是映射了value的Dictionary

let mapValueDict = someDict.mapValues {
    $0 + 1
}
print(mapValueDict)


// compactMap，目的是unwrap，解包。比如下面的[int?]。经过compactMap，将非nil的值double，
// 将nil的值还保持nil，按道理resulting array应该还是[int?]，但结果是[int]。

let nilableArray = [12,33,nil,323,232,nil,nil,33,21]
print(type(of: nilableArray))

let someArray = nilableArray.compactMap { $0 != nil ? $0! * 2: nil }
print(someArray)

// flatMap 就是将高维数组放平，变成一维数组。
let highArray = [[1,2,3], [4,5,6], [7,8,9]]
let oneArray = highArray.flatMap { $0 }
print(oneArray)

// filter 顾名思义就是过滤，过滤不满足某个“条件”的元素，得到的是之前组合的子组合，并不会像map那样更改element。

let numbers = [1,2,3,4,5,6,7,8,9,10]
let evenNums = numbers.filter { $0 % 2 == 0 }
print(evenNums)

// reduce 可以将一个数组或者字典，经过计算转换为一个值，比如一个数。
// reduce 接收两个参数，第一个是initial value；第二个是closure，用来写计算逻辑。closure有
// 两个参数，第一个是阶段性的计算结果，第二个才是遍历的element

let sums = numbers.reduce(0, {$0 + $1 * 2 + 1}) // 数组里面(所有的数 * 2 + 1)之后的和
print(sums)

// forEach。遍历数组。和循环不同的是，forEach中没有break和continue。可以做到类似continue的，就是加return

numbers.forEach {
    if $0.isMultiple(of: 2) {
        return
    }
    print($0)
}

// contains。返回的就是一个Bool值。功能就是检查elements有没有符合某个条件的。数组和字典都可以
let moreThan6 = numbers.contains { $0 > 6 }
print(moreThan6)

let moreThan2 = someDict.contains { $0.value > 2 }
print(moreThan2)

// removeAll。仅对于数组有用，功能是调整数组，remove掉所有符合条件的element。对，就是return ture的被remove掉
// 而且没有返回值，就是调整调用的方法的数组。由于数组会被修改，所以声明数组要使用var

var modifyArray = [2,3,5,7,11,13,17,19]
modifyArray.removeAll { $0 < 10 }
print(modifyArray)

// sorted。排序。

let someMessyArray = [3,7,4,9,5,2,1]
let descArray = someMessyArray.sorted { $0 > $1 }
print(descArray)

// split

let someString = "hello world"
let splitResult = someString.split { $0 == " "}
print(type(of: splitResult)) // result是子字符串的数组，数组的元素并不是string类型，是substring类型，需要转化为string
let stringResult = splitResult.map {String($0)}
print(type(of: stringResult))


