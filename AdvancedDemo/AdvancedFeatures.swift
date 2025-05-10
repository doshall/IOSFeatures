import Foundation
import Combine

// MARK: - 1. 路由系统
protocol Routable {
    func route(to destination: Route)
}

enum Route {
    case home
    case profile(userId: String)
    case settings
    case detail(item: Any)
}

class Router: Routable {
    static let shared = Router()
    
    func route(to destination: Route) {
        switch destination {
        case .home:
            print("导航到首页")
        case .profile(let userId):
            print("导航到用户资料页: \(userId)")
        case .settings:
            print("导航到设置页")
        case .detail(let item):
            print("导航到详情页: \(item)")
        }
    }
}

// MARK: - 2. 事件总线
class EventBus {
    static let shared = EventBus()
    private var observers: [String: [UUID: (Any) -> Void]] = [:]
    
    func subscribe<T>(_ eventType: T.Type, observer: AnyObject, callback: @escaping (T) -> Void) -> UUID {
        let id = UUID()
        let eventName = String(describing: eventType)
        if observers[eventName] == nil {
            observers[eventName] = [:]
        }
        observers[eventName]?[id] = { data in
            if let eventData = data as? T {
                callback(eventData)
            }
        }
        return id
    }
    
    func publish<T>(_ event: T) {
        let eventName = String(describing: type(of: event))
        observers[eventName]?.values.forEach { callback in
            callback(event)
        }
    }
    
    func unsubscribe(_ id: UUID) {
        for (eventName, _) in observers {
            observers[eventName]?.removeValue(forKey: id)
        }
    }
}

// MARK: - 3. 服务定位器
protocol Service {
    var identifier: String { get }
}

class ServiceLocator {
    static let shared = ServiceLocator()
    private var services: [String: Any] = [:]
    
    func register<T: Service>(_ service: T) {
        services[service.identifier] = service
    }
    
    func resolve<T: Service>(_ type: T.Type) -> T? {
        return services[String(describing: type)] as? T
    }
}

// MARK: - 4. 响应式编程扩展
extension Publisher {
    func withPrevious() -> AnyPublisher<(previous: Output?, current: Output), Failure> {
        scan((previous: nil as Output?, current: nil as Output?)) { ($0.current, $1) }
            .compactMap { previous, current in
                guard let current = current else { return nil }
                return (previous: previous, current: current)
            }
            .eraseToAnyPublisher()
    }
    
    func asyncMap<T>(_ transform: @escaping (Output) async throws -> T) -> AnyPublisher<T, Error> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let transformed = try await transform(value)
                        promise(.success(transformed))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - 5. 性能监控
class PerformanceMonitor {
    static let shared = PerformanceMonitor()
    private var measurements: [String: CFTimeInterval] = [:]
    
    func startMeasuring(_ identifier: String) {
        measurements[identifier] = CACurrentMediaTime()
    }
    
    func stopMeasuring(_ identifier: String) -> CFTimeInterval? {
        guard let startTime = measurements[identifier] else { return nil }
        let endTime = CACurrentMediaTime()
        measurements.removeValue(forKey: identifier)
        return endTime - startTime
    }
}

// MARK: - 使用示例
struct LoginEvent {
    let userId: String
    let timestamp: Date
}

class AppServices {
    static func configure() {
        // 注册路由
        let router = Router.shared
        
        // 设置事件监听
        let eventBus = EventBus.shared
        let loginObserverId = eventBus.subscribe(LoginEvent.self, observer: self) { event in
            print("用户登录: \(event.userId) at \(event.timestamp)")
            router.route(to: .profile(userId: event.userId))
        }
        
        // 性能监控
        let monitor = PerformanceMonitor.shared
        monitor.startMeasuring("app_launch")
        
        // 模拟应用启动完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let launchTime = monitor.stopMeasuring("app_launch") {
                print("应用启动耗时: \(launchTime)秒")
            }
            
            // 模拟用户登录
            eventBus.publish(LoginEvent(userId: "user123", timestamp: Date()))
        }
    }
}

// 示例运行
AppServices.configure()
