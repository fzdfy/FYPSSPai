//
//  AdsCell.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdsModel;

@interface AdsCell : UITableViewCell
@property (nonatomic, strong)AdsModel *dataModel;
+ (instancetype)cellWithTableview:(UITableView *)tableview AdsModel:(AdsModel *)model;
@end
