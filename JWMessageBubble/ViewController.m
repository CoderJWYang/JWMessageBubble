//
//  ViewController.m
//  JWMessageBubble
//
//  Created by Jerry on 15/6/26.
//  Copyright (c) 2015年 YJW. All rights reserved.
//

#import "ViewController.h"
#import "GooView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    GooView *bubble = [[GooView alloc] initWithFrame:CGRectMake(100, 100, 10, 10) superView:self.view];
    bubble.messageCount = @"99";
    bubble.bigCircleColor = [UIColor redColor];
    bubble.bigCircleRadius = 12;
    bubble.viscosity = 0.1;
    [bubble setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
