//
//  NewsModel.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avator;
@property (nonatomic, copy) NSString *banner;
@property (nonatomic, copy) NSString *comment_total;
@property (nonatomic, copy) NSString *like_total;
@property (nonatomic, copy) NSString *released_at;
@property (nonatomic, copy) NSString *articleID;
@property (nonatomic, assign) CGFloat cellHeight;
+ (instancetype)NewsModelWithDic:(NSDictionary *)dic;

@end
