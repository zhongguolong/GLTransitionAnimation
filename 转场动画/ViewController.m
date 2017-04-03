//
//  ViewController.m
//  转场动画
//
//  Created by 钟国龙 on 2017/4/3.
//  Copyright © 2017年 guolong. All rights reserved.
//

#import "ViewController.h"

#import "GLViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)btnClick:(id)sender {
    
    GLViewController *vc = [[GLViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
