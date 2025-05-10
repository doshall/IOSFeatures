// Swift 基础类型示例
import Foundation

// MARK: - 基本数据类型
let intNumber: Int = 42
let doubleNumber: Double = 3.14159
let floatNumber: Float = 3.14
let boolValue: Bool = true
let stringValue: String = "Hello, Swift!"

// MARK: - 可选类型
var optionalString: String? = "I am optional"
var optionalNumber: Int? = nil

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
