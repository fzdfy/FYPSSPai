//
//  NewsReadModel.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/26.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsReadModel : NSObject

@property (nonatomic, copy) NSString *like_total;
@property (nonatomic, copy) NSString *comment_total;
@property (nonatomic, copy) NSString *newsURL;
@property (nonatomic, copy) NSString *newsID;

+ (instancetype)NewsReadModelWithDic:(NSDictionary *)dic;

@end
