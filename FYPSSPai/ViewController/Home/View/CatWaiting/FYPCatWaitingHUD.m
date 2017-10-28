//
//  FYPCatWaitingHUD.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/25.
//  Copyright © 2017年 FYP. All rights reserved.
//

/*
 设计思路:
 一.界面剖析:界面包括1.uiwindow背景2.背景毛玻璃效果3.指示框indicatorView 三大部分
 其中指示框indicatorView 包括1.猫脸图片2.老鼠转圈动画3.猫眼转圈动画4.loading文字
 
 二.初始化构造:初始化初步控件和布局
 三.动画:启动和停止
 启动:- (void)animate;
 动画部分:1.文字动画:循环宽度逐渐变宽并透明度逐渐为0，首先设置宽度weight=0，透明度alpha=1
 设置动画时长，宽度weight从0到原本实际宽度，透明度alpha从1到0，这样就实现了文字动画，这里调整了文字间距
 2.猫眼动画:黑眼珠旋转动画，眼白轨迹动画
 3.老鼠动画:旋转动画
 4.整个HUD动画:背景框显示，指示框逐渐从无到有，毛玻璃效果显示。
 结束:- (void)stop;
一定要在结束的时候清空这个layer所附带的所有动画，否则会在下一次出现的时候重新显示未完成的动
 四.优化部分：
 1.交互：能否交互。
 2.可设置显示文字。
 3.设置动画时长
 4.适配屏幕方向。
 五.测试:本来想着用xcode自带的UITests测试，最终放弃!,太繁琐!
 
 */
#import "FYPCatWaitingHUD.h"
//#import "UIView+Frame.h"
#import "UIViewExt.h"
#import <CoreText/CoreText.h>

#define FYPCatWaiting_animationSize 80.0f
#define FYPCatWaiting_catPurple [UIColor colorWithRed:75.0f/255.0f green:52.0f/255.0f blue:97.0f/255.0f alpha:0.7f]
#define FYPCatWaiting_leftFaceGray [UIColor colorWithRed:200.0f/255.0f green:198.0f/255.0f blue:200.0f/255.0f alpha:1.0f]
#define FYPCatWaiting_rightFaceGray [UIColor colorWithRed:213.0f/255.0f green:212.0f/255.0f blue:213.0f/255.0f alpha:1.0f]

@interface FYPCatWaitingHUD ()
{
    NSTimer *timer;
}
//背景
@property (nonatomic, strong) UIView *backgroundView;
//毛玻璃
@property (nonatomic, strong) UIVisualEffectView *blurView;
//指示框
@property (nonatomic, strong) UIView *indicatorView;
//猫脸
@property (nonatomic, strong) UIImageView *faceView;
//老鼠
@property (nonatomic, strong) UIImageView *mouseView;
//提示文字
@property (nonatomic, strong) UILabel *contentLabel;
//眼睛部分
@property (nonatomic, strong) UIView *leftEye;
@property (nonatomic, strong) UIView *rightEye;
@property (nonatomic, strong) UIView *leftEyeCover;
@property (nonatomic, strong) UIView *rightEyeCover;

/**
 *  动画状态
 */
@property (nonatomic, assign,getter = isAnimating) BOOL Animating;

@property (nonatomic) UIInterfaceOrientation previousOrientation;
/**
 *  load显示文字
 */
@property (nonatomic, strong) NSString *title;

@property (nonatomic) CGFloat easeInDuration;

/**
 *  Time duration for each loop.
 */
@property (nonatomic) CGFloat animationDuration;

@end

@implementation FYPCatWaitingHUD

//单例模式
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

//初始化构造器
- (id)init {
    if (self = [super init]) {
        //检测屏幕旋转方向
        [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        [self commonInit];
    }
    return self;
}

//基本组件初始化加载
- (void)commonInit{
    
    self.animationDuration = 2.0f;
    self.easeInDuration = self.animationDuration * 0.25f;
    self.Animating = NO;
    self.title = @"Loading...";
    _backgroundView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    //背景:当前顶层窗口
    _backgroundView = [[[UIApplication sharedApplication] delegate] window];
    self.frame = _backgroundView.frame;
    self.alpha = 0.f;
    [_backgroundView addSubview:self];
    
    //毛玻璃
    self.blurView = [[UIVisualEffectView alloc]initWithFrame:_backgroundView.frame];
    _blurView.effect = nil;
    [self addSubview:_blurView];
    //指示器
    _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2.0f - (FYPCatWaiting_animationSize * 2.0f)/2.0f, MAIN_SCREEN_HEIGHT/2.0f - (FYPCatWaiting_animationSize * 2.0f)/2.0f, FYPCatWaiting_animationSize * 2.0f, FYPCatWaiting_animationSize * 2.0f)];
    _indicatorView.backgroundColor = FYPCatWaiting_catPurple;
    _indicatorView.layer.cornerRadius = 6.0f;
    _indicatorView.alpha = 0.0f;
    [self addSubview:_indicatorView];
    
    float width = 60;
    //猫脸
    _faceView = [[UIImageView alloc] initWithFrame:CGRectMake(_indicatorView.width/2.0f - width/2.0f, _indicatorView.height/2.0f - width/2.0f - 10.0f, width, width)];
    _faceView.image = [UIImage imageNamed:@"MAO@2x"];
    _faceView.contentMode = UIViewContentModeScaleAspectFill;
    [_indicatorView addSubview:_faceView];
    //猫眼部分
    _leftEye = [[UIView alloc]initWithFrame:CGRectMake(self.faceView.left + 8.0f, self.faceView.top + width/3.0f + 1.0f, 5.0f, 5.0f)];
    _leftEye.layer.masksToBounds = YES;
    _leftEye.layer.cornerRadius = 2.5f;
    _leftEye.backgroundColor = [UIColor blackColor];
    _leftEye.layer.anchorPoint = CGPointMake(1.5f, 1.5f);
    _leftEye.layer.position = CGPointMake(self.faceView.left + 13.5f,self.faceView.top + width/3.0f + 7.5f);
    [_indicatorView addSubview:_leftEye];
    
    // Note : 比例是从sketch中算出来的
    self.leftEyeCover = [[UIView alloc]initWithFrame:CGRectMake(self.faceView.left + width / 15.0f, self.leftEye.top - 5.0f - width/8.0f, width * 0.42f, width/10.0f)];
    _leftEyeCover.backgroundColor = FYPCatWaiting_leftFaceGray;
    _leftEyeCover.layer.anchorPoint = CGPointMake(0.5, 0.0f);
    [_indicatorView addSubview:_leftEyeCover];
    
    self.rightEye = [[UIView alloc]initWithFrame:CGRectMake(self.leftEye.right + width/3.0f + 1.0f, self.faceView.top + width/3.0f + 1.0f, 5.0f, 5.0f)];
    _rightEye.layer.masksToBounds = YES;
    _rightEye.layer.cornerRadius = 2.5f;
    _rightEye.backgroundColor = [UIColor blackColor];
    _rightEye.layer.anchorPoint = CGPointMake(1.5f, 1.5f);
    _rightEye.layer.position = CGPointMake(self.faceView.right - 13.5f, self.faceView.top + width/3.0f + 7.5f);
    [_indicatorView addSubview:_rightEye];
    
    self.rightEyeCover = [[UIView alloc]initWithFrame:CGRectMake(self.faceView.left + width * 0.52f, self.rightEye.top - 5.0f - width/8.0f, width * 0.42f, width/10.0f)];
    _rightEyeCover.backgroundColor = FYPCatWaiting_rightFaceGray;
    _rightEyeCover.layer.anchorPoint = CGPointMake(0.5, 0.0f);
    [_indicatorView addSubview:_rightEyeCover];
    //老鼠
    self.mouseView = [[UIImageView alloc]initWithFrame:CGRectMake(_indicatorView.width/2.0f - width * 1.8f/2.f, _indicatorView.height/2.0f - width * 1.8f/2.f - 10.0f, width * 1.8f, width * 1.8f)];
    _mouseView.contentMode = UIViewContentModeScaleAspectFill;
    _mouseView.backgroundColor = [UIColor clearColor];
    _mouseView.image = [UIImage imageNamed:@"mouse@2x"];
    [_indicatorView addSubview:_mouseView];
    //提示文字
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.0f,self.mouseView.bottom + 15.0f,0.0f,25.0f)];//初始宽度设为0
    _contentLabel.text = self.title;
    _contentLabel.textColor = [UIColor whiteColor];
    
    _contentLabel.font = [UIFont systemFontOfSize:20.0f];
    _contentLabel.lineBreakMode = NSLineBreakByClipping;
    _contentLabel.numberOfLines = 1;
    _contentLabel.alpha = 1.0f;//初始透明度设为1
    // Set a limitation here.
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    [_indicatorView addSubview:_contentLabel];
}

- (void)statusBarOrientationChange:(NSNotification *)notification{
    if(!_Animating)
    {
        // 若不在显示状态则不需要响应旋转
        return;
    }
    
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    
    CGFloat degree = 0.0f;
    switch (oriention) {
        case UIInterfaceOrientationLandscapeLeft:
        {
            if(self.previousOrientation == UIInterfaceOrientationLandscapeRight)
            {
                degree = -180.0f;
            }
            else if(self.previousOrientation == UIInterfaceOrientationPortrait)
            {
                degree = -90.0f;
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            if(self.previousOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                degree = 180.0f;
            }
            else if(self.previousOrientation == UIInterfaceOrientationPortrait)
            {
                degree = 90.0f;
            }
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            if(self.previousOrientation == UIInterfaceOrientationLandscapeRight)
            {
                degree = -90.0f;
            }
            else if(self.previousOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                degree = 90.0f;
            }
        }
            break;
        default:
            break;
    }
    
    self.previousOrientation = oriention;
    CGAffineTransform transform = _indicatorView.transform;
    transform = CGAffineTransformRotate(transform,  radians(degree));
    _indicatorView.transform = transform;
}

#pragma public Method
//动画的时候是否允许和原始的View进行交互
- (void)animateWithInteractionEnabled:(BOOL)enabled{
    
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    self.previousOrientation = oriention;
    if(oriention == UIInterfaceOrientationPortrait)
    {
        _blurView.frame = CGRectMake(0.0f, 0.0f, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2.0f - (FYPCatWaiting_animationSize * 2.0f)/2.0f, MAIN_SCREEN_HEIGHT/2.0f - (FYPCatWaiting_animationSize * 2.0f)/2.0f, FYPCatWaiting_animationSize * 2.0f, FYPCatWaiting_animationSize * 2.0f)];
    }
    else if(oriention == UIInterfaceOrientationLandscapeRight)
    {
        _blurView.frame = CGRectMake(0.0f, 0.0f, MAIN_SCREEN_HEIGHT, MAIN_SCREEN_WIDTH);
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_HEIGHT/2.0f - (FYPCatWaiting_animationSize * 2.0f)/2.0f, MAIN_SCREEN_WIDTH/2.0f - (FYPCatWaiting_animationSize * 2.0f)/2.0f, FYPCatWaiting_animationSize * 2.0f, FYPCatWaiting_animationSize * 2.0f)];
        
        CGAffineTransform transform = _indicatorView.transform;
        transform = CGAffineTransformRotate(transform,  radians(90.0f));
        _indicatorView.transform = transform;
    }
    else if(oriention == UIInterfaceOrientationLandscapeLeft)
    {
        _blurView.frame = CGRectMake(0.0f, 0.0f, MAIN_SCREEN_HEIGHT, MAIN_SCREEN_WIDTH);
        _indicatorView = [[UIView alloc]initWithFrame:CGRectMake(MAIN_SCREEN_HEIGHT/2.0f - (FYPCatWaiting_animationSize * 2.0f)/2.0f, MAIN_SCREEN_WIDTH/2.0f - (FYPCatWaiting_animationSize * 2.0f)/2.0f, FYPCatWaiting_animationSize * 2.0f, FYPCatWaiting_animationSize * 2.0f)];
        CGAffineTransform transform = _indicatorView.transform;
        transform = CGAffineTransformRotate(transform,  radians(-90.0f));
        _indicatorView.transform = transform;
    }
    //设置文本字间距
    [self configureContentLabelText];
    
    if(_Animating){
        return;
    }
    _Animating = YES;
    self.userInteractionEnabled = enabled;
    _backgroundView.userInteractionEnabled = enabled;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration * 2.0f  target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    
    [_leftEyeCover.layer addAnimation:[self scaleAnimation] forKey:@"scale"];
    [_rightEyeCover.layer addAnimation:[self scaleAnimation] forKey:@"scale"];
    
    [self performSelector:@selector(beginRotate) withObject:nil afterDelay:self.animationDuration * 0.25f];
    
    self.alpha = 1.0f;
    [UIView animateWithDuration:_easeInDuration delay:0.25f options:UIViewAnimationOptionCurveEaseIn animations:^(){
        _blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _indicatorView.alpha = 1.0f;
    } completion:nil];
}

//交互和文字
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title{
    self.title = title;
    [self animateWithInteractionEnabled:enabled];
}

//交互,文字,动画时长
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title duration:(CGFloat)duration{
    self.animationDuration = duration;
    self.easeInDuration = self.animationDuration*0.25f;
    [self animateWithInteractionEnabled:enabled title:title];
}

//交互和动画
- (void)animate{
    [self animateWithInteractionEnabled:NO];
}

#pragma private Method
- (void)beginRotate
{
    [_mouseView.layer addAnimation:[self rotationAnimation] forKey:@"rotate"];
    [_leftEye.layer addAnimation:[self rotationAnimation] forKey:@"rotate"];
    [_rightEye.layer addAnimation:[self rotationAnimation] forKey:@"rotate"];
}

//文字动画
- (void)timerUpdate:(id)sender
{
    [UIView animateWithDuration:self.animationDuration * 1.6f delay:0.0f options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.contentLabel.width = _indicatorView.width - 40.0f;//宽度从0到实际设定的宽度
        self.contentLabel.alpha = 0.0f;//透明度从1到0
    } completion:^(BOOL finished) {
        //动画完成时恢复原样
        self.contentLabel.alpha = 1.0f;
        self.contentLabel.width = 0.0f;
    }];
}

- (CAAnimationGroup *)scaleAnimation
{
    // 眼皮和眼珠需要确定一个运动时间曲线
    CABasicAnimation *scaleAnimation;
    scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 3.0, 1.0)];
    scaleAnimation.duration = self.animationDuration;
    scaleAnimation.cumulative = YES;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.removedOnCompletion= NO;
    scaleAnimation.fillMode=kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2:0.0 :0.8 :1.0];
    scaleAnimation.speed = 1.0f;
    scaleAnimation.beginTime = 0.0f;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = self.animationDuration;
    group.repeatCount = HUGE_VALF;
    group.removedOnCompletion= NO;
    group.fillMode=kCAFillModeForwards;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2:0.0:0.8 :1.0];
    
    group.animations = [NSArray arrayWithObjects:scaleAnimation, nil];
    return group;
}

- (CABasicAnimation *)rotationAnimation
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:getTransForm3DWithAngle(0.0f)];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:getTransForm3DWithAngle(radians(180.0f))];
    rotationAnimation.duration = self.animationDuration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion=NO;
    rotationAnimation.fillMode=kCAFillModeForwards;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return rotationAnimation;
}

/**
 *  处理Label中的文本间距
 */
- (void)configureContentLabelText
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.title];
    long number = 5;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
    CFRelease(num);
    
    self.contentLabel.attributedText = attributedString;
}

- (void)stop{
    if(!_Animating)
    {
        return;
    }
    
    [timer invalidate];
    timer = nil;
    
    _backgroundView.userInteractionEnabled = YES;
    //清楚所有动画防止下次动画开始时仍有之前残余动画
    // 一定要在结束的时候清空这个layer所附带的所有动画，否则会在下一次出现的时候重新显示未完成的动画
    self.contentLabel.attributedText = nil;
    self.contentLabel.width = 0;
    self.contentLabel.alpha = 1.0f;
    [self.contentLabel.layer removeAllAnimations];
    
    [UIView animateWithDuration:_easeInDuration delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _blurView.effect = nil;
        _indicatorView.alpha = 0.f;
        
    } completion:^(BOOL finish){
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        _indicatorView.transform = transform;
        _Animating = NO;
        self.alpha = 0.f;
        self.hidden = YES;
        
        [_mouseView.layer removeAnimationForKey:@"rotate"];
        [_leftEye.layer removeAnimationForKey:@"rotate"];
        [_rightEye.layer removeAnimationForKey:@"rotate"];
        [_leftEyeCover.layer removeAnimationForKey:@"scale"];
        [_rightEyeCover.layer removeAnimationForKey:@"scale"];
        
        [self removeFromSuperview];
    }];
    
}

- (void)show{
    NSLog(@"show");
}
@end
