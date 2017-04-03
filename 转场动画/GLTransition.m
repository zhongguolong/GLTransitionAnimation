//
//  GLTransition.m
//  转场动画
//
//  Created by 钟国龙 on 2017/4/3.
//  Copyright © 2017年 guolong. All rights reserved.
//

#import "GLTransition.h"

@interface GLTransition ()<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>

@property (nonatomic, weak)id<UIViewControllerContextTransitioning> context;

@end

@implementation GLTransition

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //容器视图 控制器的视图，会添加到容器视图中
    UIView *containerView = [transitionContext containerView];
    
    //获取要展示的控制器
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [containerView addSubview:toView];
    
    [self animationWithView:toView];
    
    self.context = transitionContext;
}

- (void)animationWithView:(UIView *)view
{
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    
    CGFloat radius = 25;
    CGFloat margins = 20;
    
    CGRect startRect = CGRectMake(view.bounds.size.width - margins - radius * 2, margins, radius * 2, radius * 2);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    
    CGFloat endRadius = sqrt((view.bounds.size.width * view.bounds.size.width) + (view.bounds.size.height * view.bounds.size.height));
    
    UIBezierPath *endBezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(startRect, -endRadius, -endRadius)];
    
    shapeLayer.path = bezierPath.CGPath;
    
    view.layer.mask = shapeLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    animation.duration = [self transitionDuration:self.context];
    
    animation.fromValue = (__bridge id _Nullable)(bezierPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(endBezierPath.CGPath);
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    animation.delegate = self;
    
    [shapeLayer addAnimation:animation forKey:nil];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.context completeTransition:YES];
}


@end
