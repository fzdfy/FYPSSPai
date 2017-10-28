//
//  PaidNewsModel.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaidNewsFrameModel.h"

@interface PaidNewsModel : NSObject

@property (nonatomic, strong) NSArray *PaidNewsData;
@property (nonatomic, strong) PaidNewsFrameModel *paidNewsFrame;
@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)PaidNewsModelWithArr:(NSArray *)arr;

@end
