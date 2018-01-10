//
//  RedViewController.m
//  CityJinFu
//
//  Created by xxlc on 16/9/14.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RedViewController.h"
#import "RedCell.h"
#import "RedModel.h"

@interface RedViewController ()<UITableViewDelegate, UITableViewDataSource,FactoryDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;//红包的数量
@property (nonatomic, strong) RedModel *model;
@property (nonatomic, strong) RedCell *cell;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;

@end

@implementation RedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"红包"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];

    //(121,196)
    _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_tableView.frame.size.width -130)/2, (_tableView.frame.size.height -130)/2, 130, 130)];
    [self pullDown];//下拉刷新
    
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}
/**
 返回
 */
- (void)onClickLeftItem{
    
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 当有网状态下请求数据
 */
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    if (state == 1 || state == 2) {
        [self serverData];
    }
}
//下拉刷新
- (void)pullDown
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serverData)];
    [_tableView.mj_header beginRefreshing];
    
}
#pragma mark -tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}


/**
 *  服务器数据
 */
- (void)serverData{
    NSUserDefaults *user = HCJFNSUser;
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }
    else {
        //红包
        [DownLoadData postShowRedMessage:^(id obj, NSError *error) {
            _array = obj[@"SUCCESS"];
            [user setValue:[NSString stringWithFormat:@"%lu",(unsigned long)_array.count] forKey:@"Red"];
            [user synchronize];//红包个数写入
            if (_array.count == 0) {
//                _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
                _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
                [_tableView addSubview:_backgroundImage];
                self.tableView.separatorStyle = NO;
                [_tableView.mj_header endRefreshing];
            }
            else {
                [_backgroundImage removeFromSuperview];
                [self.tableView reloadData];
                self.tableView.backgroundColor = [UIColor whiteColor];
                self.tableView.separatorStyle = YES;
                [_tableView.mj_footer resetNoMoreData];
                _tableView.mj_footer = _footer;
                [_tableView.mj_header endRefreshing];
                _tableView.tableFooterView = [UIView new];
            }
        } amount:_moneyStr userId:[user objectForKey:@"userId"] anditemCycle:_itemTime andbalance:_balance];
    }
}
#pragma mark -numberOfSections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
#pragma mark -cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = HCJF;
    _cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!_cell) {
        _cell = [[RedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        _cell.backgroundColor = [UIColor clearColor];
    }
    //model层数据
    _model = _array[indexPath.section];
    [_cell updateCellWithRedModel:_model andIndexPath:indexPath];
    
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 295*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 3;
}
#pragma mark -didSelect
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RedModel *model = _array[indexPath.section];
    NSLog(@"111---%@",model.ID);

    NSUserDefaults *user = HCJFNSUser;
    
    NSString *status;
    
    if ([[NSString stringWithFormat:@"%@",model.ID] isEqualToString:[user objectForKey:@"zyyRedId"]]) {
        
        [user removeObjectForKey:@"zyyRedId"];
        
        [user synchronize];
        
        status = @"NO";
        NSDictionary *userInfo = @{
                                   @"text" : model.amount,
                                   @"status" : status
                                   };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectRed" object:nil userInfo:userInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (model.canUse.integerValue == 2){
        [user removeObjectForKey:@"zyyRedId"];
        
        [user synchronize];
        
        //status = @"NO";
        [Factory alertMes:@"您的投资金额没有达到使用该红包的条件"];
    }else if (model.canUse.integerValue == 1){
        status = @"YES";
        [user setValue:[NSString stringWithFormat:@"%@",model.ID] forKey:@"zyyRedId"];
        [user synchronize];
        NSDictionary *userInfo = @{
                                   @"text" : model.amount,
                                   @"status" : status
                                   };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectRed" object:nil userInfo:userInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)]];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
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
