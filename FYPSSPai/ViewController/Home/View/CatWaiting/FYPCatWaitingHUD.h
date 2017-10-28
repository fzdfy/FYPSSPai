//
//  FYPCatWaitingHUD.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/25.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYPCatWaitingHUD : UIView

+ (instancetype)sharedInstance;

- (void)animate;
- (void)stop;

//动画的时候是否允许和原始的View进行交互
- (void)animateWithInteractionEnabled:(BOOL)enabled;
//交互和文字
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title;
//交互,文字,动画时长
- (void)animateWithInteractionEnabled:(BOOL)enabled title:(NSString *)title duration:(CGFloat)duration;
@end
