# iOS 开发示例项目集合

本仓库包含四个 iOS 开发示例项目，分别展示了不同的开发概念和技术要点。
工具:包管理工具CocoaPods,homebrew.

## 1. 协议实现多重继承示例

**目录**：`通过实现多个接口（协议protocol）来实现类似多重继承功能的例子/`

这个示例展示了如何在 Objective-C 中通过实现多个协议来模拟多重继承的功能。

### 主要文件：
- `FlyingProtocol.h` - 定义飞行能力的协议
- `SwimmingProtocol.h` - 定义游泳能力的协议
- `Bird.h/Bird.m` - 实现了两个协议的鸟类
- `main.m` - 示例代码的入口文件

### 核心概念：
- 协议定义
- 协议实现
- 多重协议实现
- 接口隔离

## 2. Swift 和 Objective-C 互操作示例

**目录**：`Swift_OC_Demo/`

这个示例展示了 Swift 和 Objective-C 代码如何在同一个项目中相互调用。

### 主要文件：
- `Person.h/Person.m` - Objective-C 类
- `Student.swift` - Swift 类
- `SwiftOCDemo-Bridging-Header.h` - Swift/OC 桥接文件
- `main.m` - 示例代码入口文件

### 核心概念：
- 桥接头文件的使用
- Swift 调用 Objective-C 代码
- Objective-C 调用 Swift 代码
- `@objc` 标记的使用

## 3. Swift 闭包使用示例

**目录**：`ClosureDemo/`

这个示例展示了 Swift 中闭包（Closure）的各种使用场景和最佳实践。

### 主要文件：
- `DataManager.swift` - 数据管理类，展示闭包在数据操作中的应用
- `ViewController.swift` - 视图控制器，展示闭包在 UI 交互中的应用
- `AppDelegate.swift` - 应用程序入口文件

### 核心概念：
- 异步操作回调
- 函数式编程
- 数据过滤和转换
- 内存管理（避免循环引用）
- UI 事件处理

### 闭包使用示例：
1. 异步回调：
```swift
dataManager.fetchData { items in
    // 处理获取到的数据
}
```

2. 数据过滤：
```swift
let filtered = dataManager.filterItems(items) { item in
    return item.contains("2")
}
```

3. 数据转换：
```swift
let transformed = dataManager.transformItems(items) { item in
    return "Transformed: \(item)"
}
```

## 运行要求

- Xcode 14.0+
- iOS 13.0+
- Swift 5.0+

## 如何运行

1. 克隆或下载本仓库
2. 使用 Xcode 打开对应项目文件夹
3. 选择适当的模拟器或实机
4. 点击运行按钮

## 注意事项

- 确保已正确配置开发环境
- Swift/OC 互操作示例需要正确设置桥接头文件
- 闭包示例中包含异步操作，请注意内存管理

## 4. SwiftUI 瀑布流相册示例

**目录**：`WaterfallDemo/`

这个示例展示了如何使用 SwiftUI 实现一个现代化的瀑布流照片墙应用。

### 主要文件：
- `Models/`
  - `PhotoItem.swift` - 照片数据模型
  - `ImageLoader.swift` - 图片加载和管理类
- `Views/`
  - `WaterfallGrid.swift` - 瀑布流布局核心实现
  - `PhotoCardView.swift` - 照片卡片视图
  - `PhotoDetailView.swift` - 照片详情视图
  - `RefreshableScrollView.swift` - 自定义可刷新滚动视图
- `ContentView.swift` - 主视图
- `WaterfallDemoApp.swift` - 应用入口

### 核心功能：
- 瀑布流布局实现
- 异步图片加载
- 下拉刷新
- 无限滚动
- 图片详情查看
- 手势缩放
- 图片分享

### 技术特点：
1. SwiftUI 布局：
```swift
WaterfallGrid(items: photos, columns: columns) { item in
    PhotoCardView(item: item)
}
```

2. 异步图片加载：
```swift
AsyncImage(url: URL(string: imageUrl)) { phase in
    switch phase {
    case .success(let image):
        image.resizable()
    case .empty:
        ProgressView()
    case .failure:
        Image(systemName: "photo")
    }
}
```

3. 手势处理：
```swift
.gesture(
    MagnificationGesture()
        .updating($zoom) { currentState, gestureState, _ in
            gestureState = currentState
        }
)
```

## 运行要求

- Xcode 14.0+
- iOS 14.0+
- Swift 5.0+

## 如何运行

1. 克隆或下载本仓库
2. 使用 Xcode 打开对应项目文件夹
3. 选择适当的模拟器或实机
4. 点击运行按钮

## 注意事项

- 确保已正确配置开发环境
- Swift/OC 互操作示例需要正确设置桥接头文件
- 闭包示例中包含异步操作，请注意内存管理
- 瀑布流示例需要网络连接以加载示例图片

## 学习资源

- [Swift 官方文档](https://swift.org/documentation/)
- [Apple 开发者文档](https://developer.apple.com/documentation/)
- [Swift 与 Objective-C 互操作指南](https://developer.apple.com/documentation/swift/importing-objective-c-into-swift)
- [SwiftUI 文档](https://developer.apple.com/documentation/swiftui)


## 许可证

本项目采用 MIT 许可证，详情请见 [LICENSE](LICENSE) 文件。