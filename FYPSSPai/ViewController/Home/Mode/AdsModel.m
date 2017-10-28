//
//  AdsModel.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "AdsModel.h"

@implementation AdsModel

+ (instancetype)AdsModelWithArr:(NSArray *)arr
{
    AdsModel *model = [[self alloc] init];
    model.AdsData = arr;
    model.cellHeight = (MAIN_SCREEN_WIDTH - 50) * 0.53125 + 40;
    return model;
}

@end
