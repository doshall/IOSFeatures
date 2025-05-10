import Foundation

// MARK: - 1. 值类型和引用类型的区别
print("\n=== 值类型和引用类型 ===")

struct User {
    var name: String
    var age: Int
}

class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

func demonstrateTypeSemantics() {
    // 值类型示例
    var user1 = User(name: "张三", age: 25)
    var user2 = user1  // 创建副本
    user2.age = 30
    print("值类型:")
    print("user1: \(user1.age)")  // 仍然是 25
    print("user2: \(user2.age)")  // 变成了 30
    
    // 引用类型示例
    let person1 = Person(name: "李四", age: 25)
    let person2 = person1  // 引用同一对象
    person2.age = 30
    print("\n引用类型:")
    print("person1: \(person1.age)")  // 也变成了 30
    print("person2: \(person2.age)")  // 变成了 30
}

// MARK: - 2. 闭包捕获值和循环引用
print("\n=== 闭包和内存管理 ===")

class DataManager {
    var data: String = "Some data"
    var onUpdate: (() -> Void)?
    
    deinit {
        print("DataManager 被释放")
    }
    
    func setupCallback() {
        // 错误示例：会造成循环引用
        onUpdate = {
            print(self.data)
        }
        
        // 正确示例：使用 [weak self]
        onUpdate = { [weak self] in
            guard let self = self else { return }
            print(self.data)
        }
    }
}

// MARK: - 3. 属性观察器和计算属性
print("\n=== 属性示例 ===")

class Temperature {
    // 存储属性with观察器
    var celsius: Double = 0 {
        willSet {
            print("温度将要从 \(celsius)°C 变为 \(newValue)°C")
        }
        didSet {
            print("温度已从 \(oldValue)°C 变为 \(celsius)°C")
        }
    }
    
    // 计算属性
    var fahrenheit: Double {
        get {
            return celsius * 9/5 + 32
        }
        set {
            celsius = (newValue - 32) * 5/9
        }
    }
}

// MARK: - 4. 泛型和协议
print("\n=== 泛型和协议 ===")

protocol Container {
    associatedtype Item
    var count: Int { get }
    mutating func add(_ item: Item)
    func get(at index: Int) -> Item?
}

struct Stack<T>: Container {
    private var items: [T] = []
    
    var count: Int {
        return items.count
    }
    
    mutating func add(_ item: T) {
        items.append(item)
    }
    
    func get(at index: Int) -> T? {
        guard index < items.count else { return nil }
        return items[index]
    }
}

// MARK: - 5. 现代并发示例
print("\n=== 现代并发 ===")

@available(iOS 13.0, *)
actor BankAccount {
    private var balance: Double
    
    init(initialBalance: Double) {
        balance = initialBalance
    }
    
    func deposit(_ amount: Double) {
        balance += amount
    }
    
    func withdraw(_ amount: Double) throws {
        guard balance >= amount else {
            throw NSError(domain: "BankError", code: 1, userInfo: [NSLocalizedDescriptionKey: "余额不足"])
        }
        balance -= amount
    }
    
    func getBalance() -> Double {
        return balance
    }
}

// MARK: - 运行演示
func runDemonstrations() {
    // 1. 值类型和引用类型
    demonstrateTypeSemantics()
    
    // 2. 属性示例
    let temp = Temperature()
    temp.celsius = 25
    print("华氏温度: \(temp.fahrenheit)°F")
    
    // 3. 泛型示例
    var numberStack = Stack<Int>()
    numberStack.add(1)
    numberStack.add(2)
    print("栈中元素数量: \(numberStack.count)")
    
    // 4. 并发示例
    if #available(iOS 13.0, *) {
        Task {
            let account = BankAccount(initialBalance: 1000)
            await account.deposit(500)
            print("当前余额: \(await account.getBalance())")
            
            do {
                try await account.withdraw(300)
                print("取款后余额: \(await account.getBalance())")
            } catch {
                print("取款失败: \(error.localizedDescription)")
            }
        }
    }
}

// 运行所有示例
runDemonstrations()
