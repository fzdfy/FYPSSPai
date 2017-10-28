//
//  AdsModel.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdsModel : NSObject

@property (nonatomic, strong) NSArray *AdsData;
@property (nonatomic, assign) CGFloat cellHeight;
+ (instancetype)AdsModelWithArr:(NSArray *)arr;

@end
