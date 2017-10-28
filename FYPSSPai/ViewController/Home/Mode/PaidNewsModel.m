//
//  PaidNewsModel.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "PaidNewsModel.h"

@implementation PaidNewsModel

+ (instancetype)PaidNewsModelWithArr:(NSArray *)arr
{
    PaidNewsModel *model = [[self alloc] init];
    model.PaidNewsData = arr;
    model.paidNewsFrame = [PaidNewsFrameModel PaidNewsFrameModelWithCount:arr.count];
    model.cellHeight = MAIN_SCREEN_WIDTH * 0.8 + 60;
    return model;
}

@end
