//
//  DeviceInfo.h
//  BaseProject-OC
//
//  Created by 凤云鹏 on 2016/12/20.
//  Copyright © 2016年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef MAIN_SCREEN_WIDTH
#define MAIN_SCREEN_WIDTH   [DeviceUitil mainScreenWidth]
#endif
#ifndef MAIN_SCREEN_HEIGHT
#define MAIN_SCREEN_HEIGHT  [DeviceUitil mainScreenHeight]
#endif


#define NAVIGATION_BAR_HEIGHT 44.0f

//物理1像素
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)

//基于5S的效果图用这个比例 6S自己改改
#ifndef MAIN_SCREEN_WIDTH_SCALE
#define MAIN_SCREEN_WIDTH_SCALE     [DeviceUitil mainScreenWidth] / 320.0f
#endif
#ifndef MAIN_SCREEN_HEIGHT_SCALE
#define MAIN_SCREEN_HEIGHT_SCALE    [DeviceUitil mainScreenHeight] / 568.0f
#endif


#ifndef IS_RETINA_35
#define IS_RETINA_35  ([DeviceUitil mainScreenHeight] == 480.0F)
#endif

#ifndef IS_RETINA_40
#define IS_RETINA_40  ([DeviceUitil mainScreenHeight] == 568.0f)
#endif

#ifndef IS_RETINA_47
#define IS_RETINA_47  ([DeviceUitil mainScreenHeight] == 667.0F)
#endif

#ifndef IS_RETINA_55
#define IS_RETINA_55  ([DeviceUitil mainScreenHeight] == 736.0F)
#endif

@interface DeviceUitil : NSObject
+ (NSString *)deviceType;
+ (CGFloat)mainScreenWidth;
+ (CGFloat)mainScreenHeight;

@end
