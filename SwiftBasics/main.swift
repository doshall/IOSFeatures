import Foundation

// 测试基本类型
print("整数: \(intNumber)")
print("双精度: \(doubleNumber)")
print("布尔值: \(boolValue)")

// 测试可选类型
if let unwrappedString = optionalString {
    print("可选字符串值: \(unwrappedString)")
}

// 测试元组
print("坐标: (\(coordinates.x), \(coordinates.y))")

// 测试数组
numbers.append(6)
print("数组: \(numbers)")

// 测试字典
if let appleCount = fruits["apple"] {
    print("苹果数量: \(appleCount)")
}

// 测试集合
print("唯一数字: \(uniqueNumbers)")

// 测试枚举
let direction = Compass.north
print("方向: \(direction.description())")

// 测试结构体
var point1 = Point(x: 0, y: 0)
let point2 = Point(x: 3, y: 4)
print("两点距离: \(point1.distance(to: point2))")
point1.moveBy(x: 1, y: 1)
print("移动后的点: (\(point1.x), \(point1.y))")

// 测试类和继承
let car = Car(brand: "Tesla", year: 2025, numberOfDoors: 4)
print("汽车信息: \(car.description())")
car.start()
car.stop()
print("最高速度: \(car.maxSpeed)")

// 测试泛型
var numberStack = Stack<Int>()
numberStack.push(1)
numberStack.push(2)
if let lastNumber = numberStack.pop() {
    print("弹出的数字: \(lastNumber)")
}

// 测试高阶函数
let doubledNumbers = numbers.map { $0 * 2 }
print("双倍数字: \(doubledNumbers)")

let evenNumbers = numbers.filter { $0 % 2 == 0 }
print("偶数: \(evenNumbers)")

let sum = numbers.reduce(0, +)
print("总和: \(sum)")
