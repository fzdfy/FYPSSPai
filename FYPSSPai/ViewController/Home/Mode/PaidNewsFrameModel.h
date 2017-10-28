//
//  PaidNewsFrameModel.h
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/24.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaidNewsFrameModel : NSObject

@property (nonatomic, assign) CGRect cellTitleFrame;
@property (nonatomic, assign) CGRect moreFrame;
@property (nonatomic, assign) CGRect backScrollViewFrame;
@property (nonatomic, strong) NSMutableArray *paidNewsViewFrames;
@property (nonatomic, strong) NSMutableArray *paidTitleFrames;
@property (nonatomic, strong) NSMutableArray *avatorFrames;
@property (nonatomic, strong) NSMutableArray *nicknameFrames;
@property (nonatomic, strong) NSMutableArray *updateInfoFrames;

+(instancetype)PaidNewsFrameModelWithCount:(NSInteger )count;

@end
