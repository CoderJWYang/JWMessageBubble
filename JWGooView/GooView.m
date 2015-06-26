//
//  GooView.m
//  JWMessageBubble
//
//  Created by Jerry on 15/6/26.
//  Copyright (c) 2015年 YJW. All rights reserved.
//

#import "GooView.h"
// 最大长度
#define MAXDISTANCE 80
@interface GooView ()

@property (nonatomic, strong) UIView *smallCircleView; // 小圆
@property (nonatomic, assign) CGFloat smallCircleRadius; // 小圆半径
@property (nonatomic, strong) CAShapeLayer *shapeLayer; // 不规则图形的图层
@property (nonatomic, assign) CGPoint originPoint; // 位置

@end

@implementation GooView
- (UIView *)smallCircleView
{
    if (_smallCircleView == nil) {
        _smallCircleView = [[UIView alloc] init];
        _smallCircleView.backgroundColor = self.backgroundColor;
        
        [self.superview insertSubview:_smallCircleView belowSubview:self];
    }
    return _smallCircleView;
}

- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        // 展示不规则图形
        CAShapeLayer *layer = [CAShapeLayer layer];
        _shapeLayer = layer;
        layer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:layer below:self.layer];
    }
    return _shapeLayer;
}

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)])
    {
        self.originPoint = frame.origin;
        self.superView = superView;
        
        [self.superView addSubview:self];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:self.messageCount forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:self.bigCircleRadius];
    [self setBackgroundColor:self.bigCircleColor];
    
    CGFloat w = self.bigCircleRadius;
    self.bounds = CGRectMake(0, 0, w * 2, w * 2);
    self.layer.cornerRadius = w;
    
    self.smallCircleRadius = w;
    self.layer.cornerRadius = w;
    // 添加拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.smallCircleView.center = self.center;
    self.smallCircleView.bounds = self.bounds;
    self.smallCircleView.layer.cornerRadius = self.bigCircleRadius;
    
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint transP = [pan translationInView:self];
    
    CGPoint center = self.center;
    center.x += transP.x;
    center.y += transP.y;
    self.center = center;
    
    [pan setTranslation:CGPointZero inView:self];
    
    // 计算距离圆心的距离
    CGFloat distanceCenter = [self circleCenterDistanceWithBigCircleCenter:self.center smallCircleCenter:self.smallCircleView.center];
    CGFloat smallCircleR = _smallCircleRadius - distanceCenter / 10;
    
    // 根据变化设置小圆的尺寸
    self.smallCircleView.bounds = CGRectMake(0, 0, smallCircleR * 2, smallCircleR * 2);
    
    self.smallCircleView.layer.cornerRadius = smallCircleR;
    
    // 两圆心的距离大于限定的最大距离就移除
    if (distanceCenter > MAXDISTANCE) {
        self.smallCircleView.hidden = YES;
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        
    }else if (distanceCenter > 0 && self.smallCircleView.hidden == NO){
        self.shapeLayer.path = [self pathWithBigCircleView:self smallCircleCenter:self.smallCircleView].CGPath;
    }
    // 当手势操作结束时，大于最大距离就销毁，小于则还原
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (distanceCenter > MAXDISTANCE) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 1; i < 9; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
                [arr addObject:image];
            }
            imageView.animationImages = arr;
            imageView.animationDuration = 0.5;
            imageView.animationRepeatCount = 1;
            [imageView startAnimating];
            [self addSubview:imageView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                NSLog(@"%f", imageView.frame.origin.x);
                [self removeFromSuperview];
            });
            
        }else{
            
            // 移除不规则矩形
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            
            // 还原位置
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:self.viscosity initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                // 设置大圆中心点位置
                self.center = self.smallCircleView.center;
                
            } completion:^(BOOL finished) {
                // 显示小圆
                self.smallCircleView.hidden = NO;
            }];
        }
        
    }
    
}

// 计算两圆心距离（勾股定理）
- (CGFloat)circleCenterDistanceWithBigCircleCenter:(CGPoint)bigCircleCenter smallCircleCenter:(CGPoint)smallCircleCenter
{
    CGFloat distanceX = bigCircleCenter.x - smallCircleCenter.x;
    CGFloat distanceY = bigCircleCenter.y - smallCircleCenter.y;
    return sqrt(distanceX * distanceX + distanceY * distanceY);
}

// 描绘两圆之间的不规则路径
- (UIBezierPath *)pathWithBigCircleView:(UIView *)bigCircleView smallCircleCenter:(UIView *)smallCircleView
{
    CGPoint bigCenter = bigCircleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCircleView.bounds.size.width / 2;
    
    CGPoint smallCenter = smallCircleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCircleView.bounds.size.width / 2;
    
    // 获取圆心距离
    CGFloat distanceCenter = [self circleCenterDistanceWithBigCircleCenter:bigCenter smallCircleCenter:smallCenter];
    
    CGFloat sinθ = (x2 - x1) / distanceCenter;
    
    CGFloat cosθ = (y2 - y1) / distanceCenter;
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + distanceCenter / 2 * sinθ , pointA.y + distanceCenter / 2 * cosθ);
    CGPoint pointP =  CGPointMake(pointB.x + distanceCenter / 2 * sinθ , pointB.y + distanceCenter / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // A
    [path moveToPoint:pointA];
    
    // AB
    [path addLineToPoint:pointB];
    
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    
    // CD
    [path addLineToPoint:pointD];
    
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}
@end
