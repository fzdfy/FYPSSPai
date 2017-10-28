//
//  Color.h
//  BaseProject-OC
//
//  Created by 凤云鹏 on 2016/12/20.
//  Copyright © 2016年 FYP. All rights reserved.
//

#ifndef Colors_h
#define Colors_h


/**
 十六进制颜色

 @param rgbValue
 @return
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/**
 二进制颜色

 @param r
 @param g
 @param b
 @param a
 @return
 */
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RGB(r, g, b)     RGBA(r, g, b, 1.0f)


/**
 class = ;
 title = TabBar颜色;
 
 */
#define TabBar_Color UIColorFromRGB(0xffffff)
#define TabBarNormalColor UIColorFromRGB(0xa4a6a6)
#define TabBarSelectedColor UIColorFromRGB(0xff0027)
#define SearchPColor UIColorFromRGB(0xA8A8A8)
#define UINavigationBarColor UIColorFromRGB(0xffffff)
#define BBColor UIColorFromRGB(0xff3366)
#define SearchBGColor UIColorFromRGB(0xEAEAEA)

/*
 class = FYPRefreshHeader;
 title = RefreshHeader4个点颜色;
 */
#define topPointColor    [UIColor colorWithRed:90 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0].CGColor
#define leftPointColor   [UIColor colorWithRed:250 / 255.0 green:85 / 255.0 blue:78 / 255.0 alpha:1.0].CGColor
#define bottomPointColor [UIColor colorWithRed:92 / 255.0 green:201 / 255.0 blue:105 / 255.0 alpha:1.0].CGColor
#define rightPointColor  [UIColor colorWithRed:253 / 255.0 green:175 / 255.0 blue:75 / 255.0 alpha:1.0].CGColor

#endif /* Colors_h */
