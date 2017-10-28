//
//  NewsReadModel.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/26.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "NewsReadModel.h"

@implementation NewsReadModel

+ (instancetype)NewsReadModelWithDic:(NSDictionary *)dic
{
    NewsReadModel *model = [[self alloc] init];
    model.like_total = dic[@"like_total"];
    model.comment_total = dic[@"comment_total"];
    model.newsURL = dic[@"newsURL"];
    model.newsID = dic[@"newsID"];
    return model;
}

@end
