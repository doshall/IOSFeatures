import Foundation

// 测试属性观察器
var temp = Temperature(celsius: 25)
temp.celsius = 30
print("华氏温度: \(temp.fahrenheit)°F")
temp.fahrenheit = 100
print("摄氏温度: \(temp.celsius)°C")

// 测试错误处理
let validator = PasswordValidator()
do {
    try validator.validate("abc") // 太短
} catch ValidationError.tooShort(let min) {
    print("密码太短，最少需要\(min)个字符")
}

do {
    try validator.validate("abcdef") // 正确
    print("密码验证通过")
} catch {
    print("密码验证失败：\(error)")
}

// 测试闭包
let example = FunctionExample()
let numbers = [1, 2, 3, 4, 5]

// 使用闭包进行数字处理
let doubled = example.performOperation(numbers) { $0 * 2 }
print("加倍后的数字：\(doubled)")

// 测试增量器
let incrementByTwo = example.makeIncrementer(incrementAmount: 2)
print(incrementByTwo()) // 2
print(incrementByTwo()) // 4
print(incrementByTwo()) // 6

// 测试值类型和引用类型
var valueType = ValueTypeExample(value: 1)
let valueType2 = valueType
valueType.incrementValue()
print("值类型1: \(valueType.value)") // 2
print("值类型2: \(valueType2.value)") // 1

let referenceType1 = ReferenceTypeExample(value: 1)
let referenceType2 = referenceType1
referenceType1.incrementValue()
print("引用类型1: \(referenceType1.value)") // 2
print("引用类型2: \(referenceType2.value)") // 2

// 测试并发编程
if #available(iOS 13.0, *) {
    Task {
        do {
            try await AsyncExample().processData()
        } catch {
            print("错误：\(error)")
        }
    }
}
