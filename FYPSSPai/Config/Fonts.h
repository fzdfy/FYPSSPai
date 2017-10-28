//
//  Fonts.h
//  BaseProject-OC
//
//  Created by 凤云鹏 on 2017/3/23.
//  Copyright © 2017年 FYP. All rights reserved.
//

#ifndef Fonts_h
#define Fonts_h

/** 字体 **/
//系统
#define STHeitiSCLight @"STHeitiSC-Light"
//已安装
#define SFOuterLimitsUpright @"SFOuterLimitsUpright"
#define SFOuterLimitsUprightBold @"SFOuterLimitsUpright-Bold"
#define HelveticaNeueBold @"HelveticaNeue-Bold"

#define NasalizationRgRegular @"NasalizationRg-Regular"
#define SpaceAge @"SpaceAge"

/** 普通字体 **/
#define UIUtilsFontSize(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
/** 粗体 **/
#define UIUtilsBoldFontSize(FONTSIZE)   [UIFont boldSystemFontOfSize:FONTSIZE]
/** 自定义字体 **/
#define UIUtilsFont(NAME,FONTSIZE) [UIFont fontWithName:(NAME) size:(FONTSIZE)]



#endif /* Fonts_h */
