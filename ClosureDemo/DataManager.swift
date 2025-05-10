import Foundation

class DataManager {
    // 使用闭包作为回调的异步数据获取
    typealias CompletionHandler = ([String]) -> Void
    
    // 模拟网络请求延迟
    func fetchData(completion: @escaping CompletionHandler) {
        // 模拟异步操作
        DispatchQueue.global().async {
            // 模拟一些数据
            let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
            
            // 模拟网络延迟
            Thread.sleep(forTimeInterval: 2)
            
            // 在主线程回调
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    // 使用闭包进行数据过滤
    func filterItems(_ items: [String], using predicate: (String) -> Bool) -> [String] {
        return items.filter(predicate)
    }
    
    // 使用闭包进行数据转换
    func transformItems(_ items: [String], transform: (String) -> String) -> [String] {
        return items.map(transform)
    }
}
