//
//  NewsModel.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (instancetype)NewsModelWithDic:(NSDictionary *)dic
{
    NewsModel *model = [[self alloc] init];
    model.title = dic[@"title"];
    model.banner = dic[@"banner"];
    model.summary = dic[@"promote_intro"];
    model.like_total = dic[@"like_total"];
    model.comment_total = dic[@"comment_total"];
    model.released_at = dic[@"released_at"];
    NSMutableDictionary *author = dic[@"author"];
    model.avator = author[@"avatar"];
    model.nickname = author[@"nickname"];
    model.articleID = dic[@"id"];
    model.cellHeight = 210 + MAIN_SCREEN_WIDTH * 0.3331;
    return model;
}

@end
