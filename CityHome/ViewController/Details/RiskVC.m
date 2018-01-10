//
//  RiskVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RiskVC.h"
#import "RedCell.h"
#import "DirectionScrollView.h"

@interface RiskVC ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    CGFloat contentOffY;
}

@property (nonatomic, strong) NSMutableArray *array;//红包的数量
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DirectionScrollView *scroll;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RiskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TitleLabelStyle addtitleViewToVC:self withTitle:self.title color:[UIColor whiteColor]];
    self.view.backgroundColor = backGroundColor;
    _scroll = [[DirectionScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-80*m6Scale-90*m6Scale)];
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    _imageView = [[UIImageView alloc] init];
    [_scroll addSubview:_imageView];
    [DownLoadData postGetRiskTemplet:^(id obj, NSError *error) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:obj[@"url"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(0);
                make.width.equalTo(kScreenWidth);
                make.height.mas_equalTo(image.size.height*kScreenWidth/750.0);
            }];
            _scroll.contentSize = CGSizeMake(kScreenWidth, image.size.height*kScreenWidth/750.0);
        }];
    } itemId:self.itemId];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-80*m6Scale-90*m6Scale) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return nil;
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(DirectionScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        scrollView.scrollEnabled = NO;
    }else{
        scrollView.scrollEnabled = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationYellowColor;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"webviewshouldScroll" object:nil];
}
@end
