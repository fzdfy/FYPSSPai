//
//  BaseTabBarController.m
//  BaseProject-OC
//
//  Created by 凤云鹏 on 2017/3/23.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "FoundViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"

//#import "SITabBar.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

/**
 初始化UITabBar
 */
+ (void)initialize
{
    // 设置为不透明
    [[UITabBar appearance] setTranslucent:NO];
    // 设置背景颜色
    [UITabBar appearance].barTintColor = TabBar_Color;
    // 拿到整个导航控制器的外观
    UITabBarItem * item = [UITabBarItem appearance];
    item.titlePositionAdjustment = UIOffsetMake(0, 1.5);
    // 普通状态
    NSMutableDictionary * normalAtts = [NSMutableDictionary dictionary];
    normalAtts[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    normalAtts[NSForegroundColorAttributeName] = TabBarNormalColor;
    [item setTitleTextAttributes:normalAtts forState:UIControlStateNormal];
    // 选中状态
    NSMutableDictionary *selectAtts = [NSMutableDictionary dictionary];
    selectAtts[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    selectAtts[NSForegroundColorAttributeName] = TabBarSelectedColor;
    [item setTitleTextAttributes:selectAtts forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置tabbar
    [self setUpTabBar];
    //添加子控制器
    [self initChildViewControllers];
}

#pragma mark - 更换系统tabbar


/**
 自定义TaBar
 */
-(void)setUpTabBar
{
    //使用系统tabbar
    self.tabBar.translucent = NO;
    //使用自定义tabbar
//    SITabBar *tabBar = [[SITabBar alloc] init];
//    tabBar.backgroundColor = [UIColor whiteColor];
//    //把系统换成自定义
//    [self setValue:tabBar forKey:@"tabBar"];
}



/**
 初始化子控制器
 */
-(void)initChildViewControllers
{
    [self addChildViewControllerWithClassname:[HomeViewController description] imagename:@"home_26x23_" title:@""];
    [self addChildViewControllerWithClassname:[FoundViewController description] imagename:@"discover_18x24_" title:@""];
    [self addChildViewControllerWithClassname:[MessageViewController description]imagename:@"notification_20x24_" title:@""];
    [self addChildViewControllerWithClassname:[MineViewController description] imagename:@"user_20x24_" title:@""];
}

/**
 添加子控制器

 @param classname 类名
 @param imagename 图片名称
 @param title title
 */
- (void)addChildViewControllerWithClassname:(NSString *)classname
                                  imagename:(NSString *)imagename
                                      title:(NSString *)title
{
    UIViewController *vc = [[NSClassFromString(classname) alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:imagename] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];// 始终绘制图片原始状态，不使用Tint Color。
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:[imagename stringByAppendingString:@"pressed"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];// 始终绘制图片原始状态，不使用Tint Color。
    [self addChildViewController:nav];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
