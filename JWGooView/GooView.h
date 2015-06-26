//
//  GooView.h
//  JWMessageBubble
//
//  Created by Jerry on 15/6/26.
//  Copyright (c) 2015年 YJW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooView : UIButton
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

// 设置大圆的位置及其父控件
- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;

- (void)setup;
@end
