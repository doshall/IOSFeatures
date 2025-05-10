// Swift 闭包详细示例
import Foundation

// MARK: - 基础闭包语法
/**
 闭包是自包含的函数代码块，可以在代码中被传递和使用。
 Swift 中的闭包类似于其他语言中的 lambda 或匿名函数。
 */

// 1. 基本语法
let simpleClosure = { (name: String) -> String in
    return "Hello, \(name)!"
}

// 2. 作为函数参数的闭包
func performOperation(on numbers: [Int], using closure: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for number in numbers {
        result.append(closure(number))
    }
    return result
}

// 使用闭包
let numbers = [1, 2, 3, 4, 5]
let doubled = performOperation(on: numbers) { number in
    return number * 2
}

// 3. 尾随闭包语法
let tripled = performOperation(on: numbers) { $0 * 3 }

// MARK: - 捕获值
/**
 闭包可以捕获和存储其所在上下文中定义的变量和常量的引用
 */
func makeIncrementer(incrementAmount: Int) -> () -> Int {
    var total = 0
    let incrementer = {
        total += incrementAmount
        return total
    }
    return incrementer
}

// 使用
let incrementByTwo = makeIncrementer(incrementAmount: 2)
print(incrementByTwo()) // 输出：2
print(incrementByTwo()) // 输出：4

// MARK: - 闭包的简写形式
/**
 Swift 允许根据上下文推断类型，并提供了参数名称简写语法
 */

// 1. 完整写法
let fullClosure = { (n1: Int, n2: Int) -> Int in
    return n1 + n2
}

// 2. 参数类型推断
let typeInferred = { n1, n2 in n1 + n2 }

// 3. 参数名称简写
let shortened: (Int, Int) -> Int = { $0 + $1 }

// MARK: - 逃逸闭包
/**
 当闭包需要在函数返回后被调用时，需要使用 @escaping 标记
 */
class DataManager {
    var completionHandlers: [() -> Void] = []
    
    func addHandler(handler: @escaping () -> Void) {
        completionHandlers.append(handler)
    }
    
    func executeHandlers() {
        for handler in completionHandlers {
            handler()
        }
    }
}

// MARK: - 内存管理和循环引用
/**
 在闭包中使用 self 时要注意避免循环引用
 */
class MyViewController {
    var name: String = "MyViewController"
    var dataManager = DataManager()
    
    func setupHandler() {
        // 使用 [weak self] 避免循环引用
        dataManager.addHandler { [weak self] in
            guard let self = self else { return }
            print("Handler called for: \(self.name)")
        }
    }
}

// MARK: - 实际应用示例

// 1. 网络请求回调
struct NetworkManager {
    func fetchData(completion: @escaping (Result<String, Error>) -> Void) {
        // 模拟异步操作
        DispatchQueue.global().async {
            let data = "Some data"
            completion(.success(data))
        }
    }
}

// 2. 数组操作
let fruits = ["Apple", "Banana", "Orange"]
let uppercased = fruits.map { $0.uppercased() }
let filtered = fruits.filter { $0.contains("a") }
let sorted = fruits.sorted { $0.count < $1.count }

// 3. 动画闭包
func animateView(completion: @escaping () -> Void) {
    // 模拟 UIView.animate
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        print("Animation completed")
        completion()
    }
}

// 4. 自定义排序
struct Person {
    let name: String
    let age: Int
}

let people = [
    Person(name: "Alice", age: 25),
    Person(name: "Bob", age: 30),
    Person(name: "Charlie", age: 20)
]

let sortedPeople = people.sorted { $0.age < $1.age }

// MARK: - 闭包作为属性
class ViewModel {
    // 闭包属性
    var updateUI: ((String) -> Void)?
    
    func fetchData() {
        // 模拟数据获取
        updateUI?("New Data")
    }
}

// MARK: - 练习示例
/**
 以下是一些常见的闭包使用场景
 */

// 1. 延迟执行
func delay(_ seconds: Int, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
        closure()
    }
}

// 2. 自定义操作符
infix operator =>
func => <T, U>(value: T, transform: (T) -> U) -> U {
    return transform(value)
}

// 使用示例
let number = 10 => { $0 * 2 } // 结果为 20

// 3. 链式调用
extension Array {
    func forEach(_ closure: (Element) -> Void) -> [Element] {
        for element in self {
            closure(element)
        }
        return self
    }
}

// 使用示例
[1, 2, 3]
    .forEach { print($0) }
    .map { $0 * 2 }
    .filter { $0 > 4 }
