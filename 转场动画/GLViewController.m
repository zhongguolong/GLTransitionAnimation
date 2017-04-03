//
//  GLViewController.m
//  转场动画
//
//  Created by 钟国龙 on 2017/4/3.
//  Copyright © 2017年 guolong. All rights reserved.
//

#import "GLViewController.h"
#import "GLTransition.h"
#import "GLTransitionAnimation.h"

@interface GLViewController ()

@property (nonatomic, strong)GLTransition *transition;
@property (nonatomic, strong)GLTransitionAnimation *transitionAnimation;

@end

@implementation GLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = [UIImage imageNamed:@"gakki2"];
    
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:imgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.modalPresentationStyle = UIModalPresentationCustom;
//        self.transition = [[GLTransition alloc] init];
//        self.transitioningDelegate = self.transition;
        
        //必须对这个代理强引用，否则会提前释放
        self.transitionAnimation = [[GLTransitionAnimation alloc] init];
        self.transitioningDelegate = self.transitionAnimation;
        
    }
    return self;
}

- (void)btnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
