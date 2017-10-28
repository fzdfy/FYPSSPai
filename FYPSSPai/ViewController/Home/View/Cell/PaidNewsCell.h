//
//  PaidNewsCell.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaidNewsModel;
@interface PaidNewsCell : UITableViewCell

@property (nonatomic, strong) PaidNewsModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableview PaidNewsModel:(PaidNewsModel *)model;

@end
