import Foundation
import UIKit
import Combine

// MARK: - 1. 网络层集成示例
protocol NetworkingProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// Alamofire 风格的网络层封装
struct Endpoint {
    let path: String
    let method: String
    let parameters: [String: Any]?
    let headers: [String: String]?
}

class NetworkService: NetworkingProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        // 实际项目中这里会使用 Alamofire 或 URLSession
        fatalError("需要实现")
    }
}

// MARK: - 2. Repository 模式与数据缓存
class UserRepository {
    private let networkService: NetworkingProtocol
    private let cache: CacheProtocol
    
    init(networkService: NetworkingProtocol, cache: CacheProtocol) {
        self.networkService = networkService
        self.cache = cache
    }
    
    func getUser(id: String) async throws -> User {
        // 检查缓存
        if let cachedUser: User = try? await cache.get(forKey: id) {
            return cachedUser
        }
        
        // 网络请求
        let user: User = try await networkService.request(Endpoint(
            path: "/users/\(id)",
            method: "GET",
            parameters: nil,
            headers: nil
        ))
        
        // 保存到缓存
        try await cache.set(user, forKey: id)
        return user
    }
}

// MARK: - 3. MVVM 架构与响应式编程
class UserViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let repository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: UserRepository) {
        self.repository = repository
        setupBindings()
    }
    
    private func setupBindings() {
        // 使用 Combine 处理状态更新
        $user
            .dropFirst()
            .sink { [weak self] user in
                self?.handleUserUpdate(user)
            }
            .store(in: &cancellables)
    }
    
    func loadUser(id: String) {
        isLoading = true
        
        Task {
            do {
                let user = try await repository.getUser(id: id)
                await MainActor.run {
                    self.user = user
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - 4. UI 组件封装（SnapKit 风格）
class ProfileViewController: UIViewController {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        
        // 在实际项目中使用 SnapKit
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
    }
}

// MARK: - 5. 本地存储（Realm 风格）
protocol CacheProtocol {
    func get<T: Decodable>(forKey key: String) async throws -> T
    func set<T: Encodable>(_ value: T, forKey key: String) async throws
}

class LocalStorage: CacheProtocol {
    func get<T: Decodable>(forKey key: String) async throws -> T {
        // 实际项目中使用 Realm 或 CoreData
        fatalError("需要实现")
    }
    
    func set<T: Encodable>(_ value: T, forKey key: String) async throws {
        // 实际项目中使用 Realm 或 CoreData
        fatalError("需要实现")
    }
}

// MARK: - 6. 依赖注入容器
class DIContainer {
    static let shared = DIContainer()
    
    private var services: [String: Any] = [:]
    
    private init() {
        setupDependencies()
    }
    
    private func setupDependencies() {
        // 注册服务
        services["NetworkService"] = NetworkService()
        services["LocalStorage"] = LocalStorage()
        
        // 注册 Repository
        let networkService = services["NetworkService"] as! NetworkService
        let localStorage = services["LocalStorage"] as! LocalStorage
        services["UserRepository"] = UserRepository(
            networkService: networkService,
            cache: localStorage
        )
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return services[String(describing: type)] as? T
    }
}

// MARK: - 辅助类型
struct User: Codable {
    let id: String
    var name: String
    var avatarURL: URL?
}

// MARK: - 使用示例
class AppCoordinator {
    func startApp() {
        // 获取依赖
        guard let repository = DIContainer.shared.resolve(UserRepository.self) else {
            fatalError("无法解析 UserRepository")
        }
        
        // 创建 ViewModel
        let viewModel = UserViewModel(repository: repository)
        
        // 创建并显示 UI
        let profileVC = ProfileViewController()
        // 设置导航等...
    }
}
