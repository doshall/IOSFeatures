import Foundation

/*
    让我帮你解释一下闭包（Closure）在 Swift 中的使用。我会在项目中添加一个详细的闭包示例文件。 

    已进行更改。



    我已经创建了一个新的文件 `SwiftClosures.swift`，其中包含了 Swift 闭包的详细示例和解释。让我为你解释其中的关键概念：

    ### 1. 基本语法
    闭包的基本语法是：
    ```swift
    { (参数列表) -> 返回类型 in
        // 闭包体
    }
    ```

    ### 2. 闭包的几种形式

    1. **完整形式**：
    ```swift
    let fullClosure = { (n1: Int, n2: Int) -> Int in
        return n1 + n2
    }
    ```

    2. **类型推断**：
    ```swift
    let typeInferred = { n1, n2 in n1 + n2 }
    ```

    3. **参数名称简写**：
    ```swift
    let shortened: (Int, Int) -> Int = { $0 + $1 }
    ```

    ### 3. 常见用途

    1. **异步回调**：
    ```swift
    networkManager.fetchData { result in
        switch result {
        case .success(let data):
            print(data)
        case .failure(let error):
            print(error)
        }
    }
    ```

    2. **集合操作**：
    ```swift
    let numbers = [1, 2, 3, 4, 5]
    let doubled = numbers.map { $0 * 2 }
    let filtered = numbers.filter { $0 > 2 }
    ```

    ### 4. 内存管理

    为避免循环引用，使用 `[weak self]`：
    ```swift
    dataManager.addHandler { [weak self] in
        guard let self = self else { return }
        print(self.name)
    }
    ```

    ### 5. 逃逸闭包

    当闭包需要在函数返回后才被调用时，使用 `@escaping`：
    ```swift
    func fetchData(completion: @escaping (Result<Data, Error>) -> Void) {
        // 异步操作
    }
    ```

    ### 实际应用场景

    1. **网络请求**
    2. **动画完成回调**
    3. **异步数据处理**
    4. **用户交互响应**
    5. **自定义排序**

    需要我详细解释其中的任何部分吗？或者你想看看其他的闭包使用场景？
*/

// MARK: - 1. 依赖注入模式
protocol NetworkService {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}

class RealNetworkService: NetworkService {
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - 2. Repository 模式
protocol UserRepository {
    func getUser(id: String) async throws -> User
    func saveUser(_ user: User) async throws
}

class UserRepositoryImpl: UserRepository {
    private let networkService: NetworkService
    private var cache: [String: User] = [:]
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getUser(id: String) async throws -> User {
        // 先检查缓存
        if let cachedUser = cache[id] {
            return cachedUser
        }
        
        // 从网络获取
        let user: User = try await networkService.fetch(from: URL(string: "api/users/\(id)")!)
        cache[id] = user
        return user
    }
    
    func saveUser(_ user: User) async throws {
        // 保存到缓存
        cache[user.id] = user
        // 这里应该有网络请求来保存用户
    }
}

// MARK: - 3. 结果构建器模式
@resultBuilder
struct ArrayBuilder<T> {
    static func buildBlock(_ components: T...) -> [T] {
        components
    }
}

// MARK: - 4. 状态管理
enum LoadingState<T> {
    case idle
    case loading
    case success(T)
    case failure(Error)
}

// MARK: - 5. MVVM 模式
class UserViewModel: ObservableObject {
    @Published private(set) var state: LoadingState<User> = .idle
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func loadUser(id: String) {
        state = .loading
        
        Task {
            do {
                let user = try await repository.getUser(id: id)
                await MainActor.run {
                    state = .success(user)
                }
            } catch {
                await MainActor.run {
                    state = .failure(error)
                }
            }
        }
    }
}

// MARK: - 6. 属性包装器
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

// MARK: - 7. 类型擦除
struct AnyRepository<T>: UserRepository where T == User {
    private let _getUser: (String) async throws -> T
    private let _saveUser: (T) async throws -> Void
    
    init<R: UserRepository>(_ repository: R) where R.Element == T {
        _getUser = repository.getUser
        _saveUser = repository.saveUser
    }
    
    func getUser(id: String) async throws -> T {
        try await _getUser(id)
    }
    
    func saveUser(_ user: T) async throws {
        try await _saveUser(user)
    }
}

// 使用示例
class ExampleUsage {
    // 使用属性包装器
    @UserDefault(key: "username", defaultValue: "")
    var username: String
    
    // 使用结果构建器
    func createArray(@ArrayBuilder<Int> content: () -> [Int]) -> [Int] {
        content()
    }
    
    func demonstrate() async {
        // 依赖注入
        let networkService = RealNetworkService()
        let repository = UserRepositoryImpl(networkService: networkService)
        let viewModel = UserViewModel(repository: repository)
        
        // 使用结果构建器
        let numbers = createArray {
            1
            2
            3
        }
        print("Numbers: \(numbers)")
        
        // 状态管理
        viewModel.loadUser(id: "123")
        
        // 属性包装器
        username = "新用户"
        print("保存的用户名: \(username)")
    }
}

// 辅助类型
struct User: Codable {
    let id: String
    var name: String
    var age: Int
}

extension UserRepository {
    typealias Element = User
}
