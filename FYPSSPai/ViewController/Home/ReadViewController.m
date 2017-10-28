//
//  ReadViewController.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/26.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "ReadViewController.h"
#import "NewsReadModel.h"
#import <WebKit/WebKit.h>

@interface ReadViewController ()

@property (nonatomic, strong)NewsReadModel*model;
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ReadViewController

- (instancetype)initWithModel:(NewsReadModel *)model{
    
    self = [super init];
    self.model = model;
    self.hidesBottomBarWhenPushed = YES;
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    底部工具栏，用uiview模拟
    UIView *toolBar = [[UIView alloc] init];
    [self.view addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.right.mas_equalTo(self.view.mas_right).with.offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
        make.height.mas_equalTo(49);
    }];
    toolBar.backgroundColor = RGB(248, 248, 248);
    
    UIView *line = [[UIView alloc] init];
    [toolBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(toolBar.mas_left).with.offset(0);
        make.right.mas_equalTo(toolBar.mas_right).with.offset(0);
        make.top.mas_equalTo(toolBar.mas_top).with.offset(0);
        make.height.mas_equalTo(SINGLE_LINE_WIDTH);
    }];
    line.backgroundColor = RGB(190, 190, 190);
    //    返回按钮
    UIButton *back = [[UIButton alloc] init];
    [toolBar addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(toolBar.mas_left).with.offset(25);
        make.top.mas_equalTo(toolBar.mas_top).with.offset(16);
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(17);
    }];
    [back setImage:[UIImage imageNamed:@"Back_11x17_"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *comment = [[UIButton alloc] init];
    [toolBar addSubview:comment];
    [comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MAIN_SCREEN_WIDTH * 0.45);
        make.top.mas_equalTo(toolBar.mas_top).with.offset(16);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(17);
    }];
    [comment setImage:[UIImage imageNamed:@"comment_default_18x17_"] forState:UIControlStateNormal];
    [comment setTitle:[NSString stringWithFormat:@"  %@",self.model.comment_total] forState:UIControlStateNormal];
    [comment setTitleColor:RGB(170, 160, 160) forState:UIControlStateNormal];
    comment.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [comment addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *like = [[UIButton alloc] init];
    [toolBar addSubview:like];
    [like mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(comment.mas_right).with.offset(10);
        make.top.mas_equalTo(toolBar.mas_top).with.offset(16);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(17);
    }];
    [like setImage:[UIImage imageNamed:@"like_20x17_"] forState:UIControlStateNormal];
    [like setTitle:[NSString stringWithFormat:@"  %@", self.model.like_total] forState:UIControlStateNormal];
    [like setTitleColor:RGB(170, 160, 160) forState:UIControlStateNormal];
    like.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [like addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *store = [[UIButton alloc] init];
    [toolBar addSubview:store];
    [store mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(like.mas_right).with.offset(20);
        make.top.mas_equalTo(toolBar.mas_top).with.offset(16);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);
    }];
    [store setImage:[UIImage imageNamed:@"collect_15x18_"] forState:UIControlStateNormal];
    [store addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIButton *share = [[UIButton alloc] init];
    [toolBar addSubview:share];
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(store.mas_right).with.offset(35);
        make.top.mas_equalTo(toolBar.mas_top).with.offset(16);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);
    }];
    [share setImage:[UIImage imageNamed:@"home_share_17x17_"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    //    webview初始化
    WKWebView *webview = [[WKWebView alloc] init];
    //    为进度条KVO
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view insertSubview:webview belowSubview:self.progressView];
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.right.mas_equalTo(self.view.mas_right).with.offset(0);
        make.top.mas_equalTo(self.view.mas_top).with.offset(20);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-49);
    }];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [webview addGestureRecognizer:swipe];
    self.webview = webview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.newsURL]]];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webview && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
// 记得取消监听
- (void)dealloc {
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 懒加载
- (UIProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 0)];
        _progressView.tintColor = [UIColor orangeColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
