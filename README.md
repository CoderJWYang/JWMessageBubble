# JWMessageBubble
###仿QQ中消息提示数的粘性小球
![Demo.gif](https://github.com/CoderJWYang/JWMessageBubble/blob/master/demo.gif)
###How to use
```objc
// 创建对象，并设置添加位置大小以及所处父视图
GooView *bubble = [[GooView alloc] initWithFrame:CGRectMake(100, 100, 10, 10) superView:self.view];
// 显示信息
bubble.messageCount = @"100";
// 颜色
bubble.bigCircleColor = [UIColor redColor];
// 圆半径
bubble.bigCircleRadius = 20;
// 弹性系数
bubble.viscosity = 0.1;
[bubble setup];
```

###Properties
```objc
// 父控件view
@property (nonatomic, strong) UIView *superView;

// 消息数量
@property (nonatomic, strong) NSString *messageCount;

// 大圆的半径
@property (nonatomic, assign) CGFloat bigCircleRadius;

// 大圆的颜色
@property (nonatomic, strong) UIColor *bigCircleColor;

// 弹性系数
@property (nonatomic, assign) CGFloat viscosity;

```

###MyBlog 
http://www.jianshu.com/p/58a36d93aaf6
