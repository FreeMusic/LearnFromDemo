//
//  TopWithDrawalVC.m
//  CityJinFu
//
//  Created by xxlc on 16/10/14.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "TopWithDrawalVC.h"
#import "TopWithDrawalCell.h"
#import "TopUpRecordVC.h"

@interface TopWithDrawalVC ()<UITableViewDelegate, UITableViewDataSource,FactoryDelegate>{
    NSMutableDictionary *_dic1;
    NSMutableArray *_muArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) NSMutableArray *dataArr; //数据数组
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) UILabel *nameLabel;//姓名标签

@end

@implementation TopWithDrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    if ([self.tag isEqualToString:@"0"]) {
        //标题
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"充值记录"];
    }else {
        //标题
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"提现记录"];
    }
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    
    //(121,196)
    _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_tableView.frame.size.width -130)/2, (_tableView.frame.size.height -130)/2, 130, 130)];
    //[self initWithTopView];
    [self.view addSubview:self.tableView];
    [self pullDown];
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
}
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //当有网状态下请求数据
    if (state == 1 || state == 2) {
        [self loadData];
    }
}
#pragma mark - 懒加载
- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
        
    }
    
    return _dataArr;
    
}
//下拉刷新
- (void)pullDown {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    
}
//上拉加载
- (void)pullUp {
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

- (void)loadData {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    //充值
    if ([self.tag isEqualToString:@"0"]) {
        
        //网络监听
        NSInteger state = [Factory checkNetwork];
        if (state == 0) {
            [Factory showFasHud];
        } else {
            [DownLoadData postTopupRecorde:^(id obj, NSError *error) {
                
                NSLog(@"%@",obj);
                self.tableView.separatorStyle = NO;
                self.dataArr = obj[@"list"];
                _dic1 = obj[@"paginator"];
                if (_dataArr.count == 0) {
//                _tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:246/255.0 alpha:1.0];
                    _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
                    [self.view addSubview:_backgroundImage];
                    [_tableView.mj_header endRefreshing];
                    self.tableView.hidden = YES;
                } else {
                    self.tableView.hidden = NO;
                    [_backgroundImage removeFromSuperview];
                    [self.tableView reloadData];
                    self.tableView.backgroundColor = backGroundColor;
                    self.tableView.separatorStyle = YES;
                    NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                    if (total.intValue <= 10) {
                        
                    } else {
                        [self pullUp];
                        [_tableView.mj_footer resetNoMoreData];
                        _tableView.mj_footer = _footer;
                        _footer.stateLabel.hidden = YES;
                        _pageNum = 2;
                        _footer.stateLabel.hidden = NO;
                        
                    }
                    [_tableView.mj_header endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                    
                }
                
            } userId:[user objectForKey:@"userId"] pageNum:1 pageSize:10];
        }
        
    }
    //提现
    else {
        //网络监听
        NSInteger state = [Factory checkNetwork];
        if (state == 0) {
            [Factory showFasHud];
        } else {
            [DownLoadData postWithdrawRecorde:^(id obj, NSError *error) {
                
                NSLog(@"%@",obj);
                
                self.dataArr = obj[@"list"];
                _dic1 = obj[@"paginator"];
                if (_dataArr.count == 0) {
                    _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
                    [self.view addSubview:_backgroundImage];
                    self.tableView.separatorStyle = NO;
                    [_tableView.mj_header endRefreshing];
                    self.tableView.hidden = YES;
                } else {
                    self.tableView.hidden = NO;
                    [_backgroundImage removeFromSuperview];
                    [self.tableView reloadData];
                    self.tableView.separatorStyle = YES;
                    NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                    if (total.intValue <= 10) {
                        
                    } else {
                        [self pullUp];
                        [_tableView.mj_footer resetNoMoreData];
                        _tableView.mj_footer = _footer;
                        _footer.stateLabel.hidden = YES;
                        _pageNum = 2;
                        _footer.stateLabel.hidden = NO;
                        
                    }
                    [_tableView.mj_header endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                    
                }
                
            } userId:[user objectForKey:@"userId"] pageNum:1 pageSize:10];
        } 
    }
    
}
//上拉加载
- (void)loadMoreData {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    //充值
    if ([self.tag isEqualToString:@"0"]) {
     
        //网络监听
        NSInteger state = [Factory checkNetwork];
        if (state == 0) {
            [Factory showFasHud];
        }
        else {
            [DownLoadData postTopupRecorde:^(id obj, NSError *error) {
                
                _dic1 = obj[@"paginator"];
                NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                if (total.intValue <= 10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    _pageNum ++;
                    NSString *str = [NSString stringWithFormat:@"%@",_dic1[@"isLastPage"]];
                    if ([str isEqualToString:@"0"]) {
                        if (obj[@"list"]) {
                            _muArray =[[NSMutableArray alloc]init];
                            _muArray = obj[@"list"];
                            [_dataArr addObjectsFromArray:_muArray];
                            [_tableView reloadData];
                            [_tableView.mj_footer endRefreshing];
                            _tableView.tableFooterView = [UIView new];
                        }
                    }else  {
                        _muArray =[[NSMutableArray alloc]init];
                        _muArray = obj[@"list"];
                        [_dataArr addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                
            } userId:[user objectForKey:@"userId"] pageNum:self.pageNum pageSize:10];
        }
    }
    //提现
    else {
        
        //网络监听
        NSInteger state = [Factory checkNetwork];
        if (state == 0) {
            [Factory showFasHud];
        }
        else {
            [DownLoadData postWithdrawRecorde:^(id obj, NSError *error) {
                
                _dic1 = obj[@"paginator"];
                NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                if (total.intValue <= 10) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    _pageNum ++;
                    NSString *str = [NSString stringWithFormat:@"%@",_dic1[@"isLastPage"]];
                    if ([str isEqualToString:@"0"]) {
                        if (obj[@"list"]) {
                            _muArray =[[NSMutableArray alloc]init];
                            _muArray = obj[@"list"];
                            [_dataArr addObjectsFromArray:_muArray];
                            [_tableView reloadData];
                            [_tableView.mj_footer endRefreshing];
                            _tableView.tableFooterView = [UIView new];
                        }
                    }else  {
                        _muArray =[[NSMutableArray alloc]init];
                        _muArray = obj[@"list"];
                        [_dataArr addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                
            } userId:[user objectForKey:@"userId"] pageNum:self.pageNum pageSize:10];
        }
    }
}

/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = backGroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20*m6Scale;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = HCJF;
    TopWithDrawalCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[TopWithDrawalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    //充值
    if ([self.tag isEqualToString:@"0"]) {
        
        [cell cellForDictionary:dataDic];
    }else {
        //提现
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@元", [Factory countNumAndChange:[NSString stringWithFormat:@"%.2f",[dataDic[@"cashAmount"] doubleValue]]]];
        NSString *status;
        if ([dataDic[@"cashStatus"] isEqualToNumber:@0]) {
            
            status = @"提现失败";
            
        }else if ([dataDic[@"cashStatus"] isEqualToNumber:@1]) {
            
            status = @"提现成功";
            
        }else {
            
            status = @"审核中";

        }
        cell.statusLabel.text = status;
        NSString *time = [NSString stringWithFormat:@"%@",dataDic[@"addtime"]];
        cell.timeLabel.text = [Factory transClipDateWithStr:time];
    }
    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    //充值记录
    TopUpRecordVC *tempVC = [TopUpRecordVC new];
    tempVC.tag = self.tag;
    if ([self.tag isEqualToString:@"0"]) {
        tempVC.status = [NSString stringWithFormat:@"%@",dataDic[@"rechargeStatus"]];
    }else{
        tempVC.status = [NSString stringWithFormat:@"%@",dataDic[@"cashStatus"]];
    }
    tempVC.itemID = dataDic[@"id"];
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*m6Scale;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}
/**
 *顶部背景图和时间、金额、状态图标
 */
- (void)initWithTopView{
    //顶部背景View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 397*kScreenWidth/750)];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"充值记录-bg"]];
    [self.view addSubview:backView];
    //头像
    UIImageView *img = [[UIImageView alloc] init];
    img.layer.cornerRadius = 65*m6Scale;
    img.image = [UIImage imageNamed:@"thumb"];
    [backView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(129*m6Scale, 129*m6Scale));
        make.centerX.mas_equalTo(backView.mas_centerX);
        make.top.mas_equalTo(135*m6Scale);
    }];
    //用户名
    _nameLabel= [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:[HCJFNSUser stringForKey:@"userName"] addSubView:backView];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(img.mas_bottom).offset(15*m6Scale);
    }];
    //时间、金额、状态图标
    NSArray *textArr = @[@"时间", @"金额", @"状态"];
    NSArray *picArr = @[@"jilv@2x_03", @"jilv@2x_06", @"jilv@2x_08"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20*m6Scale, 397*kScreenWidth/750-62*m6Scale, kScreenWidth-40*m6Scale, 125*m6Scale)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    CGFloat width = (kScreenWidth - 40*m6Scale)/3;
    for (int i = 0; i < textArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:picArr[i]];
        [view addSubview:imgView];
        if (i == 0) {
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(37*m6Scale, 42*m6Scale));
                make.left.mas_equalTo((width-37*m6Scale)/2);
                make.top.mas_equalTo(15*m6Scale);
            }];
        }else if (i == 1){
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(38*m6Scale, 39*m6Scale));
                make.left.mas_equalTo((width-38*m6Scale)/2+width);
                make.top.mas_equalTo(15*m6Scale);
            }];
        }else{
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(31*m6Scale, 35*m6Scale));
                make.left.mas_equalTo((width-31*m6Scale)/2+width*2);
                make.top.mas_equalTo(15*m6Scale);
            }];
        }
        //标签
        UILabel *label = [Factory CreateLabelWithTextRedColor:218 GreenColor:114 BlueColor:79 andTextFont:30 andText:textArr[i] addSubView:view];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(width*i);
            make.width.mas_equalTo(width);
            make.top.mas_equalTo(imgView.mas_bottom).offset(15*m6Scale);
        }];
    }
}

@end
