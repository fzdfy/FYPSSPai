//
//  HomeViewController.m
//  FYPSSPai
//
//  Created by 凤云鹏 on 2017/10/22.
//  Copyright © 2017年 FYP. All rights reserved.
//

#import "HomeViewController.h"
#import "HeadView.h"
#import <MJRefresh.h>
#import "FYPRefreshHeader.h"
#import "FYPMJRefreshHeader.h"
#import "AdsModel.h"
#import "AdsCell.h"
#import "NewsCell.h"
#import "NewsModel.h"
#import "PaidNewsCell.h"
#import "PaidNewsModel.h"
#import "FYPCatWaitingHUD.h"
#import "NewsReadModel.h"
#import "ReadViewController.h"

@interface HomeViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
//头视图
@property (nonatomic, strong) HeadView *headView;
//页面内容table
@property (nonatomic, strong) UITableView *newsTableView;
//容器
@property (nonatomic, strong) UIScrollView *containerScrollView;

//新闻数据
@property (nonatomic, strong) NSMutableArray *newsData;
//广告数据
@property (nonatomic, strong) NSMutableArray *adsData;
//付费内容数据
@property (nonatomic, strong) NSMutableArray *paidNewsData;

@end

@implementation HomeViewController

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //TODO:初始化容器ScrollView
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    self.containerScrollView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.containerScrollView atIndex:0];
    //TODO:初始化内容UITableView
    self.newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    self.newsTableView.backgroundColor = [UIColor whiteColor];
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    self.newsTableView.contentInset = UIEdgeInsetsMake(130, 0, 0, 0);
    [self.containerScrollView addSubview:self.newsTableView];
    //TODO:初始化下拉刷新header
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.containerScrollView.mj_header = [FYPRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    [self.containerScrollView.mj_header beginRefreshing];
    
    self.headView = [[HeadView alloc] initViewWithTitle:@"首页" buttonImage:@"catalog_22x21_"];
    [self.containerScrollView insertSubview:self.headView  aboveSubview:self.newsTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    self.navigationController.delegate = self;
     [self setupData];
    
//     [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:YES];
    
    [[FYPCatWaitingHUD sharedInstance] animate];
//    if(![SCCatWaitingHUD sharedInstance].isAnimating)
//    {
//        [[SCCatWaitingHUD sharedInstance] animateWithInteractionEnabled:YES];
//    }
//    else
//    {
//        [[SCCatWaitingHUD sharedInstance] stop];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupData
{
    //    为模拟网络获取数据时的延迟，这里手动设置延迟0.8s，否则loadingview一闪而过
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSData *JSONDataNews = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"newsData" ofType:@"json"]];

        NSDictionary *newsDataDic = [NSJSONSerialization JSONObjectWithData:JSONDataNews options:NSJSONReadingAllowFragments error:nil];

        NSMutableArray *newsArray = [newsDataDic objectForKey:@"data"];
        for (NSDictionary *dict in newsArray) {
            NewsModel *newsModel = [NewsModel NewsModelWithDic:dict];
            [self.newsData addObject:newsModel];
        }
        
        NSData *JSONDataAds = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"adsData" ofType:@"json"]];
        
        NSDictionary *adsDataDic = [NSJSONSerialization JSONObjectWithData:JSONDataAds options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *adsArray = adsDataDic[@"data"];
        AdsModel *adsModel = [AdsModel AdsModelWithArr:adsArray];
        [self.adsData addObject:adsModel];
        
        NSData *JSONDataPaid = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"paidNewsData" ofType:@"json"]];

        NSDictionary *paidDataDic = [NSJSONSerialization JSONObjectWithData:JSONDataPaid options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *paidNewsArray = paidDataDic[@"data"];
        PaidNewsModel *paidModel = [PaidNewsModel PaidNewsModelWithArr:paidNewsArray];
        [self.paidNewsData addObject:paidModel];
        [self.newsTableView reloadData];
        //        隐藏loadingview
        [[FYPCatWaitingHUD sharedInstance] stop];
    });
}

- (void)loadNewData{
    NSLog(@"加载数据");
//    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.data insertObject:MJRandomData atIndex:0];
//    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UIScrollView *weakScrollView = self.containerScrollView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
//        [self.newsTableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [weakScrollView.mj_header endRefreshing];
    });
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    输出scrollview的content offset Y值，调试时取消注释
    NSLog(@"scroll::%f",scrollView.contentOffset.y);
    [self.headView viewScrolledByY:scrollView.contentOffset.y];
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AdsModel *model = self.adsData[0];
        return model.cellHeight;
    }
    if (indexPath.row == 2)
    {
        PaidNewsModel *model = self.paidNewsData[0];
        return model.cellHeight;
    }
    NewsModel *model = self.newsData[0];
    return model.cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsData.count + self.adsData.count + self.paidNewsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        AdsModel *model = [self.adsData objectAtIndex:0];
        AdsCell *cell = [AdsCell cellWithTableview:tableView AdsModel:model];
//        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == 2)
    {
        PaidNewsModel *model = [self.paidNewsData objectAtIndex:0];
        PaidNewsCell *cell = [PaidNewsCell cellWithTableView:tableView PaidNewsModel:model];
//        cell.delegate = self;
        return cell;
    }
    if (indexPath.row == 1)
    {
        NewsModel *model = [self.newsData objectAtIndex:indexPath.row - 1];
        NewsCell *cell = [NewsCell cellWithTableView:tableView NewsModel:model];
//        cell.delegate = self;
        return cell;
    }
    NewsModel *model = [self.newsData objectAtIndex:indexPath.row - 2];
    NewsCell *cell = [NewsCell cellWithTableView:tableView NewsModel:model];
//    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第%ld个cell被点击",(long)indexPath.row);
    NewsModel *newsModel = [[NewsModel alloc] init];
    if (indexPath.row == 1)
    {
        newsModel = self.newsData[0];
    }
    else
    {
        newsModel = self.newsData[indexPath.row - 2];
    }
    NSDictionary *dic = @{@"like_total":newsModel.like_total, @"comment_total": newsModel.comment_total, @"newsURL": @"https://sspai.com/post/40263", @"newsID": newsModel.articleID};
    NewsReadModel *model = [NewsReadModel NewsReadModelWithDic:dic];
    ReadViewController *readVC = [[ReadViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:readVC animated:YES];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma - 懒加载
- (NSMutableArray*)newsData{
    return FYP_LAZY(_newsData, ({
        _newsData = [NSMutableArray new];
        _newsData;
    }));
}

- (NSMutableArray*)adsData{
    return FYP_LAZY(_adsData, ({
        _adsData = [NSMutableArray new];
        _adsData;
    }));
}

- (NSMutableArray*)paidNewsData{
    return FYP_LAZY(_paidNewsData, ({
        _paidNewsData = [NSMutableArray new];
        _paidNewsData;
    }));
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
