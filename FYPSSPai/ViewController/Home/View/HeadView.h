//
//  HeadView.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/22.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HeadView : UIView

- (instancetype)initViewWithTitle:(nonnull NSString *)title buttonImage:(nonnull NSString*)image;
//scrollview的offset Y值变化时，视图作相应变化
- (void)viewScrolledByY:(float)Y;
@end
NS_ASSUME_NONNULL_END
