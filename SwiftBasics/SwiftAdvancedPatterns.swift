import Foundation
import Combine

// MARK: - 1. Combine 框架的使用
class WeatherService {
    // 使用 PassthroughSubject 发布天气更新
    let weatherUpdates = PassthroughSubject<Temperature, Error>()
    private var cancellables = Set<AnyCancellable>()
    
    func startMonitoring() {
        // 模拟每秒更新一次温度
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .map { _ in Temperature(celsius: Double.random(in: 20...30)) }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("温度监控已完成")
                    case .failure(let error):
                        print("温度监控错误: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] temperature in
                    self?.weatherUpdates.send(temperature)
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - 2. Result Builder 的高级用法
@resultBuilder
struct HTMLBuilder {
    static func buildBlock(_ components: String...) -> String {
        components.joined(separator: "\n")
    }
    
    static func buildEither(first component: String) -> String {
        component
    }
    
    static func buildEither(second component: String) -> String {
        component
    }
}

class HTMLRenderer {
    @HTMLBuilder
    func render(isLoggedIn: Bool) -> String {
        "<!DOCTYPE html>"
        "<html>"
        "<body>"
        if isLoggedIn {
            "<h1>欢迎回来！</h1>"
            "<p>这是您的个人页面</p>"
        } else {
            "<h1>请登录</h1>"
            "<p>您需要登录才能查看内容</p>"
        }
        "</body>"
        "</html>"
    }
}

// MARK: - 3. Property Wrapper 进阶用例
@propertyWrapper
struct Validated<T> {
    private var value: T
    private let validator: (T) -> Bool
    private let errorMessage: String
    
    var wrappedValue: T {
        get { value }
        set {
            guard validator(newValue) else {
                print("验证失败: \(errorMessage)")
                return
            }
            value = newValue
        }
    }
    
    init(wrappedValue: T, validator: @escaping (T) -> Bool, errorMessage: String) {
        self.value = wrappedValue
        self.validator = validator
        self.errorMessage = errorMessage
    }
}

// MARK: - 4. 高级协议设计
protocol Injectable {
    associatedtype Dependencies
    init(dependencies: Dependencies)
}

protocol DIContainer {
    func resolve<T>() -> T?
}

class AppDIContainer: DIContainer {
    private var services: [String: Any] = [:]
    
    func register<T>(_ service: T) {
        services[String(describing: T.self)] = service
    }
    
    func resolve<T>() -> T? {
        services[String(describing: T.self)] as? T
    }
}

// MARK: - 5. 自定义操作符
infix operator ==>: AssignmentPrecedence

func ==><T>(lhs: T?, rhs: (T) -> Void) {
    if let value = lhs {
        rhs(value)
    }
}

// MARK: - 实际应用示例
class UserProfileManager: Injectable {
    struct Dependencies {
        let networkService: NetworkService
        let cache: Cache
    }
    
    private let dependencies: Dependencies
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    // 使用自定义验证器的属性包装器
    @Validated(validator: { $0.count >= 2 && $0.count <= 50 }, 
              errorMessage: "用户名必须在2-50字符之间")
    var username: String = ""
    
    required init(dependencies: Dependencies) {
        self.dependencies = dependencies
        setupWeatherMonitoring()
    }
    
    private func setupWeatherMonitoring() {
        weatherService.weatherUpdates
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] temperature in
                    self?.handleTemperatureUpdate(temperature)
                }
            )
            .store(in: &cancellables)
        
        weatherService.startMonitoring()
    }
    
    private func handleTemperatureUpdate(_ temperature: Temperature) {
        // 使用自定义操作符
        temperature.celsius ==> { temp in
            if temp > 25 {
                print("警告：温度过高 (\(temp)°C)")
            }
        }
    }
}

// 使用示例
func demonstrateAdvancedUsage() {
    // 1. 依赖注入容器
    let container = AppDIContainer()
    container.register(RealNetworkService())
    container.register(MemoryCache<String, Any>())
    
    // 2. HTML 渲染
    let renderer = HTMLRenderer()
    print(renderer.render(isLoggedIn: true))
    
    // 3. 用户配置管理
    let dependencies = UserProfileManager.Dependencies(
        networkService: RealNetworkService(),
        cache: MemoryCache<String, Any>()
    )
    let profileManager = UserProfileManager(dependencies: dependencies)
    
    // 4. 测试验证器
    profileManager.username = "a" // 会打印验证失败消息
    profileManager.username = "Alice" // 有效用户名
    
    // 5. 异步等待温度更新
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        print("演示完成")
    }
}
