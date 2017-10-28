//
//  NewsCell.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsModel;

@interface NewsCell : UITableViewCell

@property (nonatomic, strong) NewsModel *model;
//@property (nonatomic, weak) id<NewsCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableview NewsModel:(NewsModel *)model;

@end
