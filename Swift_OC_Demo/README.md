我来创建一个示例，展示 Swift 和 Objective-C 之间的相互调用。我们将创建一个新的文件夹，并在其中创建一些文件来演示这个功能。

首先，让我在新文件夹中创建相关文件：

1. 首先创建一个 Objective-C 的类： 

已进行更改。



2. 创建 Person 类的实现文件： 

已进行更改。



3. 创建桥接头文件（这是让 Swift 调用 Objective-C 代码必需的）： 

已进行更改。





4. 创建一个 Swift 类： 

已进行更改。





5. 创建一个示例文件来演示如何在 Objective-C 中使用 Swift 类： 

已进行更改。



让我解释一下这个示例中的关键点：

1. **Objective-C 代码被 Swift 调用**：
   - 创建了桥接头文件 `SwiftOCDemo-Bridging-Header.h`
   - 在桥接头文件中导入了需要在 Swift 中使用的 Objective-C 头文件
   - 在 Swift 代码中可以直接使用 `Person` 类

2. **Swift 代码被 Objective-C 调用**：
   - Swift 类需要继承自 `NSObject`
   - 使用 `@objc` 标记需要暴露给 Objective-C 的类和方法
   - 系统会自动生成 `SwiftOCDemo-Swift.h` 头文件供 Objective-C 使用

3. **关键语法点**：
   - Swift 类中使用 `@objc` 来标记要暴露给 Objective-C 的成员
   - Objective-C 类使用常规的头文件声明和实现方式
   - 在 Objective-C 中使用 Swift 类时，需要导入自动生成的头文件

运行这个程序会输出类似下面的内容：

```
Hello from Objective-C! My name is John and I'm 25 years old
Hello from Objective-C! My name is Alice and I'm 18 years old
I'm in grade 12
Student's grade: 12
```

要编译和运行这个项目，你需要：

1. 在 Xcode 项目设置中设置桥接头文件：
   - 在 Build Settings 中找到 "Objective-C Bridging Header"
   - 设置其值为 "SwiftOCDemo-Bridging-Header.h"

2. 确保所有文件都添加到了同一个 target 中

这个示例展示了 Swift 和 Objective-C 之间最常见的互操作模式：

- Swift 可以直接使用 Objective-C 的类和方法
- Objective-C 可以使用被标记为 `@objc` 的 Swift 代码
- 两种语言可以在同一个项目中和谐共存

在实际项目中，这种互操作性非常有用，特别是在：
- 逐步将 Objective-C 代码迁移到 Swift
- 在现有 Objective-C 项目中添加新的 Swift 功能
- 在 Swift 项目中使用现有的 Objective-C 库