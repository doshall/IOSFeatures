import Foundation

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
