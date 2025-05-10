#import <Foundation/Foundation.h>
#import "SwiftOCDemo-Swift.h" // 这个头文件会自动生成

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 创建一个 Person 实例（OC 类）
        Person *person = [[Person alloc] initWithName:@"John" age:25];
        [person sayHello];
        
        // 创建一个 Student 实例（Swift 类）
        Student *student = [[Student alloc] initWithName:@"Alice" age:18 grade:12];
        [student introduce];
        
        NSInteger grade = [student getGrade];
        NSLog(@"Student's grade: %ld", (long)grade);
    }
    return 0;
}
