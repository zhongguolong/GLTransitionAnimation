//
//  HMTransitionAnimation.m
//  自定义转场动画
//
//  Created by ItHeiMa on 2017/3/8.
//  Copyright © 2017年 itHeima. All rights reserved.
//

#import "GLTransitionAnimation.h"

@interface GLTransitionAnimation ()<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>

//解决block循环引用(产生循环应用环)三种情况
//1.静态方法内部调用self.访问属性默认是局部变量
//2.在block内部调用self.之前先对self做一个weak处理
//3.在block内部执行完代码块,手动释放self


//此处应该使用weak,否则会产生循环引用环导致循环引用
@property(nonatomic,weak)id<UIViewControllerContextTransitioning> context;

//是否是present
@property(nonatomic,assign)BOOL ispresent;

@end

@implementation GLTransitionAnimation

#pragma mark -UIViewControllerTransitioningDelegate 转场的参与者(谁提供转场,谁解除转场)

//由谁提供转场(龙猫)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    //prsent
    self.ispresent = YES;
    
    //需要实现转场动画协议
    return self;
}

//由谁提供解除转场(龙猫)
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    //dismiss
    self.ispresent = NO;
    return self;
}

#pragma mark -UIViewControllerAnimatedTransitioning 转场动画的具体实现


//转场的时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

/**转场动画表演的舞台
 提供转场动画的具体实现
 transitionContext:转场上下文,为转场提供所有的环境
 重点:transitionContext会强引用控制器
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //1.获取上下文的容器视图
    UIView *containView = [transitionContext containerView];
    //2.获取控制器的视图
    
    //如果是present跳转,fromView就是黄色控制器视图.如果是dismiss,fromView就是龙猫控制器视图
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    //如果是present跳转,toView就是龙猫控制器视图.如果是dismiss,toView就是nil
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];//龙猫控制器视图
    
    UIView *view = self.ispresent?toView:fromView;
    //3.将控制器的视图添加到容器视图
    [containView addSubview:view];
    //4.实现动画
    [self animationWithView:view];
    
    //5.完成转场
    //注意:一定要完成转场,否则系统会一直等待完成,会拦截所有的交互(被容器视图拦截)
    //    [transitionContext completeTransition:YES];
    
    self.context = transitionContext;
}

#pragma mark -CAAnimationDelegate 动画代理

//动画结束时才完成转场
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.context completeTransition:YES];
}

- (void)animationWithView:(UIView *)view
{
    //1.创建shapeLayer
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    
    
    //2.创建贝塞尔路径
    
    //2.1贝塞尔路径画圆(内切圆)
    
    //2.1.1  起始圆
    //圆的半径
    CGFloat radius = 25;
    //圆的边距
    CGFloat margins = 20;
    
    CGRect startRect = CGRectMake(view.bounds.size.width-margins-radius*2, margins, radius*2, radius*2);
    //圆的起始路径
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:startRect];
    
    //2.1.2 结束圆
    //圆的半径  勾股定理计算view的对角线距离
    CGFloat endRadius = sqrt((view.bounds.size.width * view.bounds.size.width) + (view.bounds.size.height * view.bounds.size.height));
    
    //圆的结束路径  使用缩进矩形CGRectInset:中心点不变,水平垂直分别缩小  第一个参数:原始矩形  第二个参数:水平缩进距离  第三个参数:垂直缩进距离   -方法 +缩小
    UIBezierPath *endBezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(startRect, -endRadius, -endRadius)];
    
    //2.2 设置shapelayer的填充颜色
    // setFillColor:填充圆  setStrokeColor:边框圆
    [shapeLayer setFillColor:[UIColor redColor].CGColor];
    //    [shareLayer setStrokeColor:[UIColor redColor].CGColor];
    
    //3.设置layer的路径为贝塞尔路径
    shapeLayer.path = bezierPath.CGPath;
    
    //4.将layer添加到view中
    //不会裁切图层,在当前图层上添加一个图层
    //        [view.layer addSublayer:shapeLayer];
    
    //5.将layer设置为view的遮罩图层
    //mask遮罩图层  1.会裁切当前图层,只保留mask遮罩图层的形状   2.一旦设置mask遮罩属性,layer填充颜色就会失效
    view.layer.mask = shapeLayer;
    
    
    //使用动画改变shapelayer的路径
    //UIView的动画不能对layer生效,layer层的动画应该使用核心动画
    //    [UIView animateWithDuration:10 animations:^{
    //        shapeLayer.path = endBezierPath.CGPath;
    //    }];
    
    
    //使用核心动画添加layer图层的动画
    //1.创建核心动画  参数是动画的属性
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    //2.设置动画属性
    
    //时长
    animation.duration = [self transitionDuration:self.context];
    
    if (self.ispresent == YES)//从小圆到大圆
    {
        //动画fomeValue  toValue
        animation.fromValue = (__bridge id _Nullable)(bezierPath.CGPath);
        animation.toValue = (__bridge id _Nullable)(endBezierPath.CGPath);
    }
    else//从大圆到小圆
    {
        //动画fomeValue  toValue
        animation.fromValue = (__bridge id _Nullable)(endBezierPath.CGPath);
        animation.toValue = (__bridge id _Nullable)(bezierPath.CGPath);
    }
    
    
    //动画完成之后不移除(1.设置removedOnCompletion为NO  2.设置动画填充模式为向前填充)
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    animation.delegate = self;
    
    //3.执行核心动画(将动画添加到指定的图层)
    [shapeLayer addAnimation:animation forKey:nil];
}

@end
