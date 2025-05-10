import Foundation

// MARK: - 属性观察器示例
struct Temperature {
    var celsius: Double {
        willSet {
            print("温度将要从 \(celsius)°C 变为 \(newValue)°C")
        }
        didSet {
            print("温度已经从 \(oldValue)°C 变为 \(celsius)°C")
        }
    }
    
    var fahrenheit: Double {
        get {
            return celsius * 9/5 + 32
        }
        set {
            celsius = (newValue - 32) * 5/9
        }
    }
}

// MARK: - 错误处理示例
enum ValidationError: Error {
    case tooShort(min: Int)
    case tooLong(max: Int)
    case invalidCharacter(Character)
}

class PasswordValidator {
    func validate(_ password: String) throws {
        guard password.count >= 6 else {
            throw ValidationError.tooShort(min: 6)
        }
        
        guard password.count <= 20 else {
            throw ValidationError.tooLong(max: 20)
        }
        
        for char in password {
            guard char.isASCII else {
                throw ValidationError.invalidCharacter(char)
            }
        }
    }
}

// MARK: - 闭包示例
class FunctionExample {
    // 闭包作为参数
    func performOperation(_ numbers: [Int], using operation: (Int) -> Int) -> [Int] {
        return numbers.map(operation)
    }
    
    // 闭包捕获值
    func makeIncrementer(incrementAmount: Int) -> () -> Int {
        var total = 0
        let incrementer: () -> Int = {
            total += incrementAmount
            return total
        }
        return incrementer
    }
}

// MARK: - 访问控制示例
public class PublicClass {
    public var publicProperty: String
    internal var internalProperty: String
    private var privateProperty: String
    
    public init() {
        publicProperty = "公开访问"
        internalProperty = "内部访问"
        privateProperty = "私有访问"
    }
}

// MARK: - 关键路径示例
struct Person {
    var name: String
    var age: Int
    var address: Address
}

struct Address {
    var street: String
    var city: String
    var country: String
}

// MARK: - 值类型与引用类型示例
struct ValueTypeExample {
    var value: Int
    
    mutating func incrementValue() {
        value += 1
    }
}

class ReferenceTypeExample {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    func incrementValue() {
        value += 1
    }
}

// MARK: - 并发编程示例
@available(iOS 13.0, *)
class AsyncExample {
    func fetchData() async throws -> String {
        // 模拟异步网络请求
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return "异步获取的数据"
    }
    
    func processData() async throws {
        let data = try await fetchData()
        print("处理数据: \(data)")
    }
}
