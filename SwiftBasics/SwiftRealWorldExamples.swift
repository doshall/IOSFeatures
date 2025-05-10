import Foundation

// MARK: - 1. 范型协议和关联类型实践
protocol Cache {
    associatedtype Key: Hashable
    associatedtype Value
    
    func get(forKey key: Key) -> Value?
    func set(_ value: Value, forKey key: Key)
    func remove(forKey key: Key)
}

class MemoryCache<K: Hashable, V>: Cache {
    private var storage: [K: V] = [:]
    
    func get(forKey key: K) -> V? {
        return storage[key]
    }
    
    func set(_ value: V, forKey key: K) {
        storage[key] = value
    }
    
    func remove(forKey key: K) {
        storage.removeValue(forKey: key)
    }
}

// MARK: - 2. 函数式编程实践
extension Array {
    func mapThen<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
        try map(transform)
    }
    
    func filterThen(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        try filter(isIncluded)
    }
}

// MARK: - 3. 错误处理最佳实践
enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(code: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的URL地址"
        case .noData:
            return "没有接收到数据"
        case .decodingFailed:
            return "数据解析失败"
        case .serverError(let code):
            return "服务器错误: \(code)"
        }
    }
}

// MARK: - 4. 高级异步操作
actor AsyncCache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]
    private var tasks: [Key: Task<Value, Error>] = [:]
    
    func value(for key: Key, operation: @escaping () async throws -> Value) async throws -> Value {
        // 如果缓存中有值，直接返回
        if let value = storage[key] {
            return value
        }
        
        // 如果已经有任务在进行，等待其完成
        if let existingTask = tasks[key] {
            return try await existingTask.value
        }
        
        // 创建新任务
        let task = Task {
            let value = try await operation()
            storage[key] = value
            tasks[key] = nil
            return value
        }
        
        tasks[key] = task
        return try await task.value
    }
}

// MARK: - 5. 属性包装器进阶
@propertyWrapper
struct Clamped<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>
    
    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
    
    var wrappedValue: Value {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
}

// MARK: - 6. 实际应用示例
class UserProfile {
    // 使用范型缓存
    private let cache = MemoryCache<String, Any>()
    
    // 使用属性包装器限制年龄范围
    @Clamped(0...120) var age: Int = 0
    
    // 异步缓存示例
    private let asyncCache = AsyncCache<String, Data>()
    
    func fetchUserAvatar(userID: String) async throws -> Data {
        try await asyncCache.value(for: userID) {
            // 模拟网络请求
            try await Task.sleep(nanoseconds: 1_000_000_000)
            guard let url = URL(string: "https://api.example.com/avatar/\(userID)") else {
                throw NetworkError.invalidURL
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.serverError(code: httpResponse.statusCode)
            }
            return data
        }
    }
    
    // 函数式编程示例
    func processUserData(_ users: [User]) -> [String] {
        users
            .filterThen { $0.age >= 18 }
            .mapThen { "\($0.name) (\($0.age)岁)" }
    }
}

// 示例运行
func demonstrateAdvancedFeatures() async {
    let profile = UserProfile()
    
    // 测试属性包装器
    profile.age = 150 // 会被限制在120
    print("限制后的年龄: \(profile.age)")
    
    // 测试异步缓存
    do {
        let avatar = try await profile.fetchUserAvatar(userID: "123")
        print("获取到头像数据: \(avatar.count) bytes")
    } catch {
        print("获取头像失败: \(error.localizedDescription)")
    }
    
    // 测试函数式处理
    let users = [
        User(id: "1", name: "张三", age: 25),
        User(id: "2", name: "李四", age: 17),
        User(id: "3", name: "王五", age: 30)
    ]
    
    let processed = profile.processUserData(users)
    print("处理后的用户数据: \(processed)")
}
