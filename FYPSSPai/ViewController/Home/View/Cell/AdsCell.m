//
//  AdsCell.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "AdsCell.h"
#import "AdsModel.h"
#import <CALayer+YYWebImage.h>
#import <UIImage+YYWebImage.h>

@interface AdsCell()
@property (nonatomic, weak) UIScrollView *backScrollView;
@end
@implementation AdsCell

+ (instancetype)cellWithTableview:(UITableView *)tableview AdsModel:(AdsModel *)model
{
    static NSString *identifier = @"AdsCell";
    AdsCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[AdsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setupUI];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataModel = model;
    return cell;
}

- (void)setupUI
{
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, (MAIN_SCREEN_WIDTH - 50) * 0.53125 + 40)];
    backScrollView.backgroundColor = [UIColor whiteColor];
    backScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:backScrollView];
    self.backScrollView = backScrollView;
}

- (void)setDataModel:(AdsModel *)dataModel{
    _dataModel = dataModel;
    _backScrollView.contentSize = CGSizeMake(self.dataModel.AdsData.count * (MAIN_SCREEN_WIDTH - 40) + 40, 170);
    for (int i = 0; i < self.dataModel.AdsData.count; i++)
    {
        UIView *shadowView = [[UIView alloc] init];
        shadowView.frame = CGRectMake(25 + (MAIN_SCREEN_WIDTH - 40) * i, 15, MAIN_SCREEN_WIDTH - 50, (MAIN_SCREEN_WIDTH - 50) * 0.53125);
        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        shadowView.layer.shadowRadius = 5.0;
        shadowView.layer.shadowOpacity = 0.3;
        shadowView.layer.shadowOffset = CGSizeMake(-4, 4);
        shadowView.userInteractionEnabled = YES;
        shadowView.tag = i;
        CALayer *AdsView = [[CALayer alloc] init];
        AdsView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH - 50, (MAIN_SCREEN_WIDTH - 50) * 0.53125);
        
        [AdsView yy_setImageWithURL:[NSURL URLWithString:self.dataModel.AdsData[i][@"image"]] placeholder:nil options:kNilOptions progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            image = [image yy_imageByRoundCornerRadius:5.0];
            return image;
        } completion:nil];
        
        [shadowView.layer addSublayer:AdsView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AdsViewDidSelect:)];
        [shadowView addGestureRecognizer:tap];
        
        [self.backScrollView addSubview:shadowView];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
