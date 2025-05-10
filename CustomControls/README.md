# iOS 自定义控件示例

这个项目展示了使用 SwiftUI 创建各种自定义控件和动画效果的方法。

## 功能特性

### 1. LoadingIndicator (加载指示器)
- 渐变色圆环动画
- 无限旋转效果
- 可自定义颜色和大小

```swift
LoadingIndicator()
    .frame(width: 60, height: 60)
```

### 2. AnimatedButton (动画按钮)
- 点击反馈动画
- 自定义外观
- Spring 动画效果

```swift
AnimatedButton(title: "点击我") {
    // 处理点击事件
}
```

### 3. CardView (卡片视图)
- 支持拖拽交互
- 自动回弹效果
- 阴影和圆角样式
- 可自定义内容

```swift
CardView {
    VStack {
        Text("标题")
        Text("内容")
    }
}
```

### 4. GradientProgressBar (渐变进度条)
- 平滑动画过渡
- 渐变色填充
- 可控制进度

```swift
GradientProgressBar(progress: 0.7)
    .frame(height: 8)
```

## 实现细节

### 动画系统
- 使用 SwiftUI 的动画系统
- 支持 spring 动画
- 手势响应
- 状态管理

### 自定义修饰符
- 阴影效果
- 渐变色
- 圆角处理

### 交互设计
- 拖拽手势
- 点击反馈
- 动画过渡

## 使用方法

1. 将 `CustomControls.swift` 添加到项目中
2. 导入需要的组件
3. 在 SwiftUI 视图中使用

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            LoadingIndicator()
            AnimatedButton(title: "按钮") {
                print("Button tapped")
            }
            // 其他组件...
        }
    }
}
```

## 自定义选项

### LoadingIndicator
- 颜色
- 大小
- 动画时长

### AnimatedButton
- 文字
- 背景色
- 动画参数

### CardView
- 内容布局
- 阴影效果
- 交互行为

### GradientProgressBar
- 进度值
- 渐变色
- 圆角大小

## 注意事项

1. 性能考虑
   - 避免过度使用复杂动画
   - 注意内存使用
   - 优化重绘频率

2. 可访问性
   - 支持动态字体
   - 考虑色盲用户
   - 添加适当的标签

3. 设备适配
   - 支持不同屏幕尺寸
   - 横竖屏适配
   - Dark Mode 支持

## 最佳实践

1. **状态管理**
   ```swift
   @State private var isAnimating = false
   ```

2. **动画配置**
   ```swift
   .animation(.spring(response: 0.4, dampingFraction: 0.6))
   ```

3. **布局约束**
   ```swift
   .frame(maxWidth: .infinity)
   ```

## 性能优化

1. 使用 `drawingGroup()` 提高渲染性能
2. 合理使用 `@State` 和 `@StateObject`
3. 避免不必要的视图更新

## 调试技巧

1. 使用 Preview 预览组件
2. 添加动画检查点
3. 监控性能指标

## 未来改进

1. 添加更多自定义选项
2. 支持手势配置
3. 添加更多动画效果
4. 优化性能

## 贡献

欢迎提交 Issue 和 Pull Request

## 许可证

MIT License

让我创建一个新的自定义控件和动画的演示项目，展示 iOS 开发中的高级 UI 特性： 

已进行更改。







让我创建一个对应的 README 文件： 

已进行更改。



这个新的示例项目展示了：

1. **自定义加载动画**：
   - 渐变效果
   - 无限旋转
   - 可配置参数

2. **动画按钮**：
   - 点击反馈
   - Spring 动画
   - 自定义外观

3. **卡片视图**：
   - 拖拽交互
   - 动画效果
   - 阴影和圆角

4. **渐变进度条**：
   - 动画过渡
   - 渐变填充
   - 进度控制

需要我详细解释其中的任何组件实现吗？或者想看某个特定动画效果的更多变体？