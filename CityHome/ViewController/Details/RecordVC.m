//
//  RecordVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RecordVC.h"
#import "RecordCell.h"
#import "ItemTypeVC.h"
#import "RecordModel.h"
#import "AppDelegate.h"
#import "RiskDetailVC.h"

#import "InstantInvestViewController.h"

@interface RecordVC ()<UITableViewDelegate, UITableViewDataSource,FactoryDelegate>{
    NSMutableDictionary *_dic1;
    NSMutableArray *_muArray;
}

@property (nonatomic, strong) NSMutableArray *array;//投资信息个数
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) UIButton *buyBtn;//立即投资按钮
@property (nonatomic, assign) NSInteger page;

@end

@implementation RecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:self.title color:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    //(121,196)
    [self serverData];//下拉刷新
    
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}
#pragma mark - UITableView Lazyloading
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-304*m6Scale) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
/**
 *暂无数据背景图
 */
- (UIImageView *)backgroundImage{
    if(!_backgroundImage){
        _backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无数据"]];
        [self.tableView addSubview:_backgroundImage];
        [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(244*m6Scale, 244*m6Scale));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(kScreenHeight/2-160);
        }];
    }
    return _backgroundImage;
}
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //当有网状态下请求数据
    if (state == 1 || state == 2) {
        [self serverData];
    }
}
//上拉加载
- (void)example11
{
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
}
//上拉加载
-(void)LoadNewData{
    NSUserDefaults *user = HCJFNSUser;
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }
    else {
        [DownLoadData postItemInformation:^(id obj, NSError *error) {
            _dic1 = obj[@"SUCCESS1"];
            NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
            if (total.intValue <= 10) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                _page ++;
                NSString *str = [NSString stringWithFormat:@"%@",_dic1[@"isLastPage"]];
                if ([str isEqualToString:@"0"]) {
                    if (obj[@"SUCCESS"]) {
                        _muArray =[[NSMutableArray alloc]init];
                        _muArray = obj[@"SUCCESS"];
                        [_array addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                    }
                }else  {
                    _muArray =[[NSMutableArray alloc]init];
                    _muArray = obj[@"SUCCESS"];
                    [_array addObjectsFromArray:_muArray];
                    [_tableView reloadData];
                    [_tableView.mj_footer endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }

        } itemId:[user objectForKey:@"zyyItemId"] andpageSize:@"10" andpageNum:[NSString stringWithFormat:@"%ld",(long)_page]];
    }
}
/**
 *  服务器数据
 */
- (void)serverData{
    
    NSUserDefaults *user = HCJFNSUser;
    _array = [NSMutableArray array];
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    } else {
        [DownLoadData postItemInformation:^(id obj, NSError *error) {
            
            _array = obj[@"SUCCESS"];
            if (_array.count == 0) {
               
                self.backgroundImage.hidden = NO;
                self.tableView.separatorStyle = NO;
                [_tableView.mj_header endRefreshing];
            }
            else {
                self.backgroundImage.hidden = YES;
                [self.tableView reloadData];
                self.tableView.backgroundColor = [UIColor whiteColor];
                self.tableView.separatorStyle = YES;
                
                _dic1 = obj[@"SUCCESS1"];
                NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                if (total.intValue < 10) {
                    
                } else {
                    [self example11];//上拉加载
                    [_tableView.mj_footer resetNoMoreData];
                    _tableView.mj_footer = _footer;
                    _footer.stateLabel.hidden = YES;
                    _page = 2;
                    _footer.stateLabel.hidden = NO;
                }
                [_tableView.mj_header endRefreshing];
                _tableView.tableFooterView = [UIView new];
            }
            
        } itemId:[user objectForKey:@"zyyItemId"] andpageSize:@"10" andpageNum:@"1"];
    }
}
/**
 * 立即投资
 */
- (void)buyBtn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
    InstantInvestViewController *itemType = [InstantInvestViewController new];
    itemType.hidesBottomBarWhenPushed = YES;
    [navi pushViewController:itemType animated:YES];

}
#pragma mark -numberOfRows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
#pragma mark -cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = HCJF;
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[RecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    //model层数据
    RecordModel *model = _array[indexPath.row];
    [cell updateCellWithRecordModel:model andIndexPath:indexPath];
    
    return cell;
}
#pragma mark - didSelected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //model层数据
//    RecordModel *model = _array[indexPath.row];
//    [DownLoadData postInvestDetail:^(id obj, NSError *error) {
//        
//        RiskDetailVC *riskDetail = [[RiskDetailVC alloc]init];
//        
//        NSString *collectInterest = obj[@"collectInterest"];
//        riskDetail.titleStr = obj[@"itemName"];
//        riskDetail.moneyStr = [NSString stringWithFormat:@"%@",[Factory exchangeStrWithNumber:obj[@"investDealAmount"]]];//投资金额
//        riskDetail.recordTime = [Factory stdTimeyyyyMMddFromNumer:obj[@"addtime"] andtag:53];//投资日期
//        riskDetail.interest = [NSString stringWithFormat:@"%@%%",obj[@"itemRate"]];//利率
//        riskDetail.qixian = [NSString stringWithFormat:@"%@天",obj[@"itemCycle"]];//期限
//        riskDetail.hopeIncome = [NSString stringWithFormat:@"¥%.2f",collectInterest.floatValue];//预期收益
//        if ([obj[@"collectTime"] isKindOfClass:[NSNull class]]) {
//            riskDetail.feedBack = @"暂无数据";
//        } else {
//            riskDetail.feedBack = [Factory stdTimeyyyyMMddFromNumer:obj[@"collectTime"] andtag:53];//回款日
//        }
//        riskDetail.investOrder = [NSString stringWithFormat:@"%@",obj[@"investOrder"]];//订单号
//        
//        [self.navigationController pushViewController:riskDetail animated:YES];
//    } andInvestId:[NSString stringWithFormat:@"%@",model.ID]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 59*m6Scale)];
    view.backgroundColor = backGroundColor;
    [self.view addSubview:view];
    //投资人
    UILabel *labelLeft = [UILabel new];

    labelLeft.frame = CGRectMake(40, 0, self.view.bounds.size.width/3-20, 59*m6Scale);
    labelLeft.font = [UIFont systemFontOfSize:30*m6Scale];
    labelLeft.center =  CGPointMake(kScreenWidth / 6, 29.5 * m6Scale);

    labelLeft.text = @"投资人";
    labelLeft.textAlignment = NSTextAlignmentCenter;
    labelLeft.textColor = [UIColor colorWithRed:126/255.0 green:127/255.0 blue:127/255.0 alpha:1.0];
    [view addSubview:labelLeft];
    //投资金额
    UILabel *labelRight = [UILabel new];
    labelRight.frame = CGRectMake(self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 59*m6Scale);
    labelRight.font = [UIFont systemFontOfSize:30*m6Scale];
    labelRight.text = @"投资金额";

    labelRight.textAlignment = NSTextAlignmentCenter;
    labelRight.textColor = [UIColor colorWithRed:126/255.0 green:127/255.0 blue:127/255.0 alpha:1.0];
    [view addSubview:labelRight];
    //投资时间
    UILabel *labelCenter = [UILabel new];
    labelCenter.frame = CGRectMake(self.view.bounds.size.width*2/3, 0, self.view.bounds.size.width/3-20, 59*m6Scale);
    labelCenter.font = [UIFont systemFontOfSize:30 * m6Scale];
    labelCenter.center =  CGPointMake(5 * kScreenWidth / 6, 29.5 * m6Scale);

    labelCenter.text = @"投资时间";
    labelCenter.textAlignment = NSTextAlignmentCenter;
    labelCenter.textColor = [UIColor colorWithRed:126/255.0 green:127/255.0 blue:127/255.0 alpha:1.0];
    [view addSubview:labelCenter];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 59*m6Scale;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75*m6Scale;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        
        scrollView.scrollEnabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self serverData];//服务器数据
    NSUserDefaults *user = HCJFNSUser;
    NSLog(@"%@",[user objectForKey:@"zyyAccount"]);
    if ([[user objectForKey:@"zyyAccount"] intValue] == 0) {
        _buyBtn.userInteractionEnabled = NO;
        _buyBtn.backgroundColor = [UIColor lightGrayColor];
    }else{
        _buyBtn.userInteractionEnabled = YES;
        _buyBtn.backgroundColor = ButtonColor;
    }
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
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
