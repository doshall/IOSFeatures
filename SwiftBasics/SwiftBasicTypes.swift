// Swift 基础类型示例
import Foundation

// MARK: - 基本数据类型
let intNumber: Int = 42
let doubleNumber: Double = 3.14159
let floatNumber: Float = 3.14
let boolValue: Bool = true
let stringValue: String = "Hello, Swift!"

/**
    我来解释一下 Swift 中的可选类型（Optional）。

    ### 什么是可选类型？
    可选类型是 Swift 的一个特性，用来处理值可能"不存在"（nil）的情况。它把"不存在"的概念进行了封装，使得我们能够更安全地处理 nil 值。

    ### 声明语法
    可选类型在类型后面加上问号`?`来表示：
    ````swift
    var optionalValue: Type?
    ````

    ### 基本用法示例
    ````swift
    // 声明可选字符串
    var name: String? = "张三"
    name = nil  // 可以赋值为 nil

    // 声明可选整数
    var age: Int? = 20
    age = nil  // 可以赋值为 nil
    ````

    ### 访问可选值的方法
    1. 强制解包（不推荐）：
    ````swift
    let str: String? = "Hello"
    print(str!)  // 使用感叹号强制解包，但如果str为nil会崩溃
    ````

    2. 可选绑定（推荐）：
    ````swift
    if let actualString = optionalString {
        print(actualString)  // 安全地访问值
    } else {
        print("字符串为nil")
    }
    ````

    3. nil 合并运算符：
    ````swift
    let result = optionalString ?? "默认值"  // 如果optionalString为nil，使用默认值
    ````

    ### 安全建议
    - 尽量避免使用强制解包（!）
    - 优先使用可选绑定（if let）或guard语句
    - 考虑使用nil合并运算符（??）来提供默认值
    - 在确定值一定存在的情况下才使用强制解包

    使用可选类型可以帮助我们写出更安全的代码，避免运行时错误。这是 Swift 的重要特性之一，它迫使我们明确地处理值不存在的情况。
 */
// MARK: - 可选类型
var optionalString: String? = "I am optional"
var optionalNumber: Int? = nil

/**
  在 Swift 中，元组是一种将多个值组合在一起的类型。你可以用它来存储一组相关的值，而不需要为它们创建一个专门的类或结构体。以下是你代码中元组的用法以及如何使用它的详细说明：

    ### 代码解释
    ```swift
    // 定义一个元组，包含两个命名的元素 x 和 y
    let coordinates: (x: Int, y: Int) = (10, 20)

    // 解构元组，将 x 和 y 的值分别赋给同名变量
    let (x, y) = coordinates
    ```

    1. **元组的定义**：
    - `coordinates` 是一个元组，包含两个命名的元素 `x` 和 `y`，它们的类型分别是 `Int`。
    - 元组的值是 `(10, 20)`，表示 `x = 10` 和 `y = 20`。

    2. **解构元组**：
    - 使用 `(x, y)` 的形式将元组的值解构为两个独立的变量 `x` 和 `y`。
    - 解构后，`x` 的值是 `10`，`y` 的值是 `20`。

    ### 使用示例
    你可以通过以下方式使用元组和解构：

    #### 访问元组的元素
    如果不想解构元组，可以直接通过名字访问元素：
    ```swift
    print(coordinates.x) // 输出 10
    print(coordinates.y) // 输出 20
    ```

    #### 使用解构后的变量
    解构后，`x` 和 `y` 就是普通的变量，可以直接使用：
    ```swift
    print(x) // 输出 10
    print(y) // 输出 20
    ```

    #### 在函数中返回多个值
    元组常用于函数返回多个值的场景：
    ```swift
    func getCoordinates() -> (x: Int, y: Int) {
        return (10, 20)
    }

    let result = getCoordinates()
    print(result.x) // 输出 10
    print(result.y) // 输出 20

    // 或者直接解构
    let (x, y) = getCoordinates()
    print(x) // 输出 10
    print(y) // 输出 20
    ```

    ### 总结
    元组是一个轻量级的数据结构，适合用来临时存储和传递一组相关的值。通过解构，你可以快速提取元组中的值并赋给独立的变量，非常方便。
 */
// MARK: - 元组
let coordinates: (x: Int, y: Int) = (10, 20)
let (x, y) = coordinates // 解构

// MARK: - 数组
var numbers: [Int] = [1, 2, 3, 4, 5]
var strings = ["Apple", "Banana", "Orange"] // 类型推断

// MARK: - 字典
var fruits: [String: Int] = [
    "apple": 1,
    "banana": 2,
    "orange": 3
]

// MARK: - 集合
var uniqueNumbers: Set<Int> = [1, 2, 3, 3, 4] // 重复的元素会被自动去除

// MARK: - 枚举
enum Compass {
    case north
    case south
    case east
    case west
    
    func description() -> String {
        switch self {
        case .north: return "向北"
        case .south: return "向南"
        case .east: return "向东"
        case .west: return "向西"
        }
    }
}

// 带关联值的枚举
enum NetworkResult {
    case success(data: Data)
    case failure(error: Error)
}

// 带原始值的枚举
enum HttpStatusCode: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}

// MARK: - 结构体
struct Point {
    var x: Double
    var y: Double
    
    // 构造器
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    // 方法
    func distance(to other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx * dx + dy * dy)
    }
    
    // 变异方法
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

// MARK: - 类
class Vehicle {
    var brand: String
    var year: Int
    
    init(brand: String, year: Int) {
        self.brand = brand
        self.year = year
    }
    
    func description() -> String {
        return "\(year) \(brand)"
    }
}

// 继承
class Car: Vehicle {
    var numberOfDoors: Int
    
    init(brand: String, year: Int, numberOfDoors: Int) {
        self.numberOfDoors = numberOfDoors
        super.init(brand: brand, year: year)
    }
    
    override func description() -> String {
        return "\(super.description()) - \(numberOfDoors) doors"
    }
}

// MARK: - 协议
protocol Drivable {
    var maxSpeed: Double { get }
    func start()
    func stop()
}

// 扩展
extension Car: Drivable {
    var maxSpeed: Double {
        return 200.0
    }
    
    func start() {
        print("\(brand) 启动")
    }
    
    func stop() {
        print("\(brand) 停止")
    }
}

// MARK: - 泛型
struct Stack<T> {
    private var items: [T] = []
    
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T? {
        return items.popLast()
    }
}

/*
    我来解释一下 Swift 中 `guard` 语句的使用。我会在 SwiftBasicTypes.swift 文件中添加相关示例和说明。 
    ````

    ````


    已进行更改。



    让我为你详细解释一下 `guard` 语句的使用：

    ### 1. guard 的基本语法
    ```swift
    guard 条件 else {
        // 条件不满足时执行的代码
        return // 或 throw、break、continue
    }
    // 条件满足时执行的代码
    ```

    ### 2. guard 的主要用途

    1. **解包可选值**：
    ```swift
    guard let value = optionalValue else {
        // 处理值不存在的情况
        return
    }
    // 这里可以安全地使用 value
    ```

    2. **条件检查**：
    ```swift
    guard age >= 18 else {
        print("年龄不够")
        return
    }
    // 只有年龄大于等于18才会执行到这里
    ```

    3. **多条件组合**：
    ```swift
    guard let name = name,
        let age = age,
        age >= 18 else {
        return
    }
    // 所有条件都满足才会执行到这里
    ```

    ### 3. guard 的优点

    1. **提高代码可读性**：
    - 通过提前退出不满足条件的情况，使主要逻辑更清晰
    - 减少嵌套层级

    2. **强制退出**：
    - `guard` 语句必须使用 `return`、`break`、`continue` 或 `throw` 退出当前作用域
    - 确保了错误情况被正确处理

    3. **变量作用域**：
    - 通过 `guard let` 解包的变量在之后的代码中都可以使用
    - 而 `if let` 解包的变量只在 if 语句块内有效

    ### 4. 最佳实践

    1. **提前验证**：
    ```swift
    func process(data: String?) {
        guard let data = data else { return }
        // 处理数据...
    }
    ```

    2. **组合条件**：
    ```swift
    guard let user = user,
            user.isActive,
            user.age >= 18 else {
        return
    }
    ```

    3. **清理资源**：
    ```swift
    guard let file = openFile() else {
        // 处理错误
        cleanup()
        return
    }
    ```

    使用 `guard` 可以让代码更加清晰、安全，并且减少嵌套层级。它特别适合用于参数验证、前置条件检查等场景。

    需要我详细解释示例中的某个特定用法吗？
*/

// MARK: - Guard 语句示例
/**
    Swift 中的 guard 语句用于提前退出，是一种提前返回的机制，主要用于：
    1. 提前进行条件判断
    2. 优雅地处理可选值
    3. 减少嵌套层级
    4. 确保代码执行的前置条件
 */

// 基本使用示例
func processUser(name: String?, age: Int?) {
    // 使用 guard let 处理可选值
    guard let userName = name else {
        print("未提供用户名")
        return
    }
    
    guard let userAge = age else {
        print("未提供年龄")
        return
    }
    
    // 如果所有条件都满足，才会执行到这里
    print("用户名: \(userName), 年龄: \(userAge)")
}

// 多条件 guard 示例
func validateUserInput(name: String?, age: Int?, email: String?) -> Bool {
    // 使用 guard 同时检查多个条件
    guard let name = name,
          let age = age,
          let email = email,
          !name.isEmpty,    // 确保名字不为空
          age >= 18,        // 确保年龄大于等于18
          email.contains("@") // 简单的邮箱格式验证
    else {
        print("输入验证失败")
        return false
    }
    
    print("验证通过：\(name), \(age)岁, \(email)")
    return true
}

// 在循环中使用 guard
func findUser(in users: [[String: Any]]) {
    for user in users {
        guard let name = user["name"] as? String,
              let age = user["age"] as? Int
        else {
            continue // 跳过不符合条件的数据
        }
        
        print("找到用户：\(name), \(age)岁")
    }
}

// 带有清理代码的 guard
func processFile(path: String?) {
    guard let filePath = path else {
        print("文件路径无效")
        return
    }
    
    // 模拟文件操作
    print("开始处理文件：\(filePath)")
    // ... 文件处理代码 ...
    
    defer {
        print("清理资源")
        // 这里的代码会在函数结束时执行
    }
    
    // 处理文件的其他代码
}
```
