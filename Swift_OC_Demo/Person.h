#import <Foundation/Foundation.h>

// 定义一个 Objective-C 的类
NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age;
- (void)sayHello;

@end

NS_ASSUME_NONNULL_END
