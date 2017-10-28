//
//  FYPRefreshHeader.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/22.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "FYPRefreshHeader.h"
#import "UIView+Frame.h"

const CGFloat FYPRefreshHeaderHeight = 60.0;
const CGFloat FYPRefreshPointRadius = 8.0;

const CGFloat FYPRefreshPullLen     = 55.0;
const CGFloat FYPRefreshTranslatLen = 10.0;

@interface FYPRefreshHeader()

@property (nonatomic, strong) CAShapeLayer * lineLayer;
//4个固定点
@property (nonatomic, strong) CAShapeLayer * TopPointLayer;
@property (nonatomic, strong) CAShapeLayer * BottomPointLayer;
@property (nonatomic, strong) CAShapeLayer * LeftPointLayer;
@property (nonatomic, strong) CAShapeLayer * rightPointLayer;

@property (nonatomic, assign) BOOL animating;

@end
@implementation FYPRefreshHeader

//- (instancetype)init {
//    if (self = [super initWithFrame:CGRectMake(0, 0, FYPRefreshHeaderHeight, FYPRefreshHeaderHeight)]) {
//        [self initLayers];
//    }
//    return self;
//}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    // 设置控件的高度
    self.mj_h = FYPRefreshHeaderHeight;
    [self initLayers];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
//    self.label.frame = self.bounds;
//
//    self.logo.bounds = CGRectMake(0, 0, self.bounds.size.width, 100);
//    self.logo.center = CGPointMake(self.mj_w * 0.5, - self.logo.mj_h + 20);
//
//    self.loading.center = CGPointMake(self.mj_w - 30, self.mj_h * 0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
//            [self.loading stopAnimating];
//            [self.s setOn:NO animated:YES];
//            self.label.text = @"赶紧下拉吖(开关是打酱油滴)";
            [self removeAni];
            break;
        case MJRefreshStatePulling:
            [self removeAni];
//            [self.loading stopAnimating];
//            [self.s setOn:YES animated:YES];
//            self.label.text = @"赶紧放开我吧(开关是打酱油滴)";
            break;
        case MJRefreshStateRefreshing:
            [self startAni];
//            [self.s setOn:YES animated:YES];
//            self.label.text = @"加载数据中(开关是打酱油滴)";
//            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
//    // 1.0 0.5 0.0
//    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    NSLog(@"pullingPercent == %f",pullingPercent);
    float progress = FYPRefreshPullLen*pullingPercent;
    
    NSLog(@"progress --- %f",progress);
    //如果不是正在刷新，则渐变动画
    if (!self.animating) {
        if (progress >= FYPRefreshPullLen) {
            self.y = - (FYPRefreshPullLen - (FYPRefreshPullLen - FYPRefreshHeaderHeight) / 2);
        }else {
            if (progress <= self.height) {
                self.y = - progress;
            }else {
                self.y = - (self.height + (progress - self.height) / 2);
            }
        }
        [self setLineLayerStrokeWithProgress:progress];
    }
    //如果到达临界点，则执行刷新动画
    if (progress >= FYPRefreshPullLen && !self.animating && !self.scrollView.dragging) {
        [self startAni];
//        if (self.handle) {
//            self.handle();
//        }
    }
    

}


#pragma mark - Adjustment
- (void)setLineLayerStrokeWithProgress:(CGFloat)progress {
    float startProgress = 0.f;
    float endProgress = 0.f;
    
    //隐藏
    if (progress < 0) {
        self.TopPointLayer.opacity = 0.f;
        [self adjustPointStateWithIndex:0];
    }
    else if (progress >= 0 && progress < (FYPRefreshPullLen - 40)) {
        self.TopPointLayer.opacity = progress / 20;
        [self adjustPointStateWithIndex:0];
    }
    else if (progress >= (FYPRefreshPullLen - 40) && progress < FYPRefreshPullLen) {
        self.TopPointLayer.opacity = 1.0;
        //大阶段 0 ~ 3
        NSInteger stage = (progress - (FYPRefreshPullLen - 40)) / 10;
        //大阶段的前半段
        CGFloat subProgress = (progress - (FYPRefreshPullLen - 40)) - (stage * 10);
        if (subProgress >= 0 && subProgress <= 5) {
            [self adjustPointStateWithIndex:stage * 2];
            startProgress = stage / 4.0;
            endProgress = stage / 4.0 + subProgress / 40.0 * 2;
        }
        //大阶段的后半段
        if (subProgress > 5 && subProgress < 10) {
            [self adjustPointStateWithIndex:stage * 2 + 1];
            startProgress = stage / 4.0 + (subProgress - 5) / 40.0 * 2;
            if (startProgress < (stage + 1) / 4.0 - 0.1) {
                startProgress = (stage + 1) / 4.0 - 0.1;
            }
            endProgress = (stage + 1) / 4.0;
        }
    }
    else {
        self.TopPointLayer.opacity = 1.0;
        [self adjustPointStateWithIndex:NSIntegerMax];
        startProgress = 1.0;
        endProgress = 1.0;
    }
    self.lineLayer.strokeStart = startProgress;
    self.lineLayer.strokeEnd = endProgress;
}

- (void)adjustPointStateWithIndex:(NSInteger)index { //index : 小阶段： 0 ~ 7
    self.LeftPointLayer.hidden = index > 1 ? NO : YES;
    self.BottomPointLayer.hidden = index > 3 ? NO : YES;
    self.rightPointLayer.hidden = index > 5 ? NO : YES;
    self.lineLayer.strokeColor = index > 5 ? rightPointColor : index > 3 ? bottomPointColor : index > 1 ? leftPointColor : topPointColor;
}

#pragma mark - Animation
- (void)startAni {
    self.animating = YES;
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = FYPRefreshPullLen;
        self.scrollView.contentInset = inset;
    }];
    [self addTranslationAniToLayer:self.TopPointLayer xValue:0 yValue:FYPRefreshTranslatLen];
    [self addTranslationAniToLayer:self.LeftPointLayer xValue:FYPRefreshTranslatLen yValue:0];
    [self addTranslationAniToLayer:self.BottomPointLayer xValue:0 yValue:-FYPRefreshTranslatLen];
    [self addTranslationAniToLayer:self.rightPointLayer xValue:-FYPRefreshTranslatLen yValue:0];
    [self addRotationAniToLayer:self.layer];
}

- (void)addTranslationAniToLayer:(CALayer *)layer xValue:(CGFloat)x yValue:(CGFloat)y {
    CAKeyframeAnimation * translationKeyframeAni = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    translationKeyframeAni.duration = 1.0;
    translationKeyframeAni.repeatCount = HUGE;
    translationKeyframeAni.removedOnCompletion = NO;
    translationKeyframeAni.fillMode = kCAFillModeForwards;
    translationKeyframeAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSValue * fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0.f)];
    NSValue * toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(x, y, 0.f)];
    translationKeyframeAni.values = @[fromValue, toValue, fromValue, toValue, fromValue];
    [layer addAnimation:translationKeyframeAni forKey:@"translationKeyframeAni"];
}

- (void)addRotationAniToLayer:(CALayer *)layer {
    CABasicAnimation * rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @(0);
    rotationAni.toValue = @(M_PI * 2);
    rotationAni.duration = 1.0;
    rotationAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAni.repeatCount = HUGE;
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = NO;
    [layer addAnimation:rotationAni forKey:@"rotationAni"];
}

- (void)removeAni {
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = 0.f;
        self.scrollView.contentInset = inset;
    } completion:^(BOOL finished) {
        [self.TopPointLayer removeAllAnimations];
        [self.LeftPointLayer removeAllAnimations];
        [self.BottomPointLayer removeAllAnimations];
        [self.rightPointLayer removeAllAnimations];
        [self.layer removeAllAnimations];
        [self adjustPointStateWithIndex:0];
        self.animating = NO;
    }];
}

//初始化4个点
- (void)initLayers {
    
    CGFloat centerLine = FYPRefreshHeaderHeight / 2;
    CGFloat radius = FYPRefreshPointRadius;
    
    CGPoint topPoint = CGPointMake(MAIN_SCREEN_WIDTH/2, radius);
    self.TopPointLayer = [self layerWithPoint:topPoint color:topPointColor];
    self.TopPointLayer.hidden = NO;
    self.TopPointLayer.opacity = 0.f;
    [self.layer addSublayer:self.TopPointLayer];
    
//    CGPoint leftPoint = CGPointMake(radius, centerLine);
    CGPoint leftPoint = CGPointMake(MAIN_SCREEN_WIDTH/2-FYPRefreshHeaderHeight/2+radius, centerLine);
    
    self.LeftPointLayer = [self layerWithPoint:leftPoint color:leftPointColor];
    [self.layer addSublayer:self.LeftPointLayer];
    
//    CGPoint bottomPoint = CGPointMake(centerLine, FYPRefreshHeaderHeight - radius);
    CGPoint bottomPoint = CGPointMake(MAIN_SCREEN_WIDTH/2, FYPRefreshHeaderHeight - radius);

    self.BottomPointLayer = [self layerWithPoint:bottomPoint color:bottomPointColor];
    [self.layer addSublayer:self.BottomPointLayer];
    
//    CGPoint rightPoint = CGPointMake(FYPRefreshHeaderHeight - radius, centerLine);
    CGPoint rightPoint = CGPointMake(MAIN_SCREEN_WIDTH/2+centerLine-radius, centerLine);

    self.rightPointLayer = [self layerWithPoint:rightPoint color:rightPointColor];
    [self.layer addSublayer:self.rightPointLayer];
    
    //
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.frame = self.bounds;
    self.lineLayer.lineWidth = FYPRefreshPointRadius * 2;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.fillColor = topPointColor;
    self.lineLayer.strokeColor = topPointColor;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:topPoint];
    [path addLineToPoint:leftPoint];
    [path moveToPoint:leftPoint];
    [path addLineToPoint:bottomPoint];
    [path moveToPoint:bottomPoint];
    [path addLineToPoint:rightPoint];
    [path moveToPoint:rightPoint];
    [path addLineToPoint:topPoint];
    self.lineLayer.path = path.CGPath;
    self.lineLayer.strokeStart = 0.f;
    self.lineLayer.strokeEnd = 0.f;
    [self.layer insertSublayer:self.lineLayer above:self.TopPointLayer];
}

- (CAShapeLayer *)layerWithPoint:(CGPoint)center color:(CGColorRef)color {
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(center.x - FYPRefreshPointRadius, center.y - FYPRefreshPointRadius, FYPRefreshPointRadius * 2, FYPRefreshPointRadius * 2);
    layer.fillColor = color;
    layer.path = [self pointPath];
    layer.hidden = YES;
    return layer;
}

- (CGPathRef)pointPath {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(FYPRefreshPointRadius, FYPRefreshPointRadius) radius:FYPRefreshPointRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
}

@end
