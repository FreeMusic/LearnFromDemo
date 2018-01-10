//
//  IntergralRecordVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/7.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "IntergralRecordVC.h"
#import "MoreStrategyCell.h"
#import "IntergralModel.h"
#import "IntegralShopVC.h"
#import "HelpTableViewController.h"

@interface IntergralRecordVC ()<UITableViewDataSource, UITableViewDelegate, FactoryDelegate>

@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;//模型数组
@property (nonatomic,strong) NSMutableDictionary *dataDic;//模型字典
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图片
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;

@end

@implementation IntergralRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"积分记录"];
    //客服按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self andImageName :@"scoreQuestion"];
    [rightBtn addTarget:self action:@selector(helpCenter) forControlEvents:UIControlEventTouchUpInside];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    //下拉请求数据
    [self pullDown];
    
    //网络请求时时改变
    Factory *fatory = [[Factory alloc] init];
    fatory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = backGroundColor;
    }
    return _tableView;
}
/**
 *模型数组的懒加载
 */
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/**
 *模型字典的懒加载
 */
- (NSMutableDictionary *)dataDic{
    if(!_dataDic){
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
/**
 *暂无数据背景图片的懒加载
 */
- (UIImageView *)backImgView{
    if(!_backImgView){
        _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无数据"]];
        [self.tableView addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(260*m6Scale, 260*m6Scale));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(kScreenHeight/4);
        }];
    }
    return _backImgView;
}
#pragma mark - 网络情况监控
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //有网络的情况下请求数据
    if (state == 1 || state == 2) {
        [self serviceData];
    }
}
#pragma mark - 下拉刷新数据
- (void)pullDown{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serviceData)];
    [_tableView.mj_header beginRefreshing];
}
/**
 *请求数据
 */
- (void)serviceData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
        //没有网络的时候提示网络出错
        //没有网络停止刷新
        [_tableView.mj_header endRefreshing];
    }else{
        [DownLoadData postGetIntegralLogs:^(id obj, NSError *error) {
            self.dataArr = obj[@"SUCCESS"];
            self.dataDic = obj[@"SUCCESS1"];
            //假如网罗求情下来的没有数据
            if (_dataArr.count == 0) {
                //防止突然没有数据 导致暂无内容图和数据交叉
                [self.tableView reloadData];
                self.backImgView.hidden = NO;
                _tableView.mj_footer.hidden = YES;
                
                [_tableView.mj_header endRefreshing];
            }else{
                _tableView.mj_footer.hidden = NO;
                self.backImgView.hidden = YES;
                [self.tableView reloadData];
                NSString *total = [NSString stringWithFormat:@"%@",_dataDic[@"total"]];
                if (total.integerValue <= 10) {
                    
                }else{
                    [self pullup];
                    [_tableView.mj_footer resetNoMoreData];
                    _tableView.mj_footer = _footer;
                    _footer.stateLabel.hidden = YES;
                    _page = 2;
                    _footer.stateLabel.hidden = NO;
                }
                [_tableView.mj_header endRefreshing];
                _tableView.tableFooterView = [UIView new];
            }
        } userId:[HCJFNSUser stringForKey:@"userId"] pageNum:@"1" pageSize:@"10"];
    }
}
#pragma mark - 上拉加载数据
- (void)pullup{
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}
#pragma mark - 上拉加载
- (void)loadData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }else{
        [DownLoadData postGetIntegralLogs:^(id obj, NSError *error) {
            _dataDic = obj[@"SUCCESS1"];
            NSString *total = [NSString stringWithFormat:@"%@",_dataDic[@"total"]];
            if (total.integerValue <= 10) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                _page++;
                NSString *str = [NSString stringWithFormat:@"%@", _dataDic[@"isLastPage"]];
                if ([str isEqualToString:@"0"]) {
                    //不是最后一页
                    if (obj[@"SUCCESS"]) {
                        _muArray = [[NSMutableArray alloc] init];
                        _muArray = obj[@"SUCCESS"];
                        [_dataArr addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                    }
                }else{
                    //是最后一页
                    _muArray =[[NSMutableArray alloc]init];
                    _muArray = obj[@"SUCCESS"];
                    [_dataArr addObjectsFromArray:_muArray];
                    [_tableView reloadData];
                    [_tableView.mj_footer endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                    _footer.stateLabel.hidden = NO;
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    _footer.stateLabel.hidden = YES;
                }
            }
        } userId:[HCJFNSUser stringForKey:@"userId"] pageNum:[NSString stringWithFormat:@"%ld", (long)_page] pageSize:@"10"];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        NSString *reStr = @"MoreStrategyCell";
        MoreStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:reStr];
        if (!cell) {
            cell = [[MoreStrategyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reStr];
        }
        IntergralModel *model = self.dataArr[indexPath.row-1];
        [cell cellForModel:model andType:0];
        
        return cell;
    }else{
        NSString *reuse = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        cell.textLabel.text = @"全部";
        cell.detailTextLabel.text = @"我要去花积分";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = NO;
        cell.backgroundColor = backGroundColor;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        return 144*m6Scale;
    }else{
        return 84*m6Scale;
    }
}

#pragma mark Navigation上面的两个按钮
/**
 右边按钮，帮助中心,客服电话
 */
- (void)helpCenter{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertView addAction:[UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([defaults objectForKey:@"userId"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = NSLocalizedString(@"连接中...", @"HUD loading title");
            //用户个人信息
            [DownLoadData postUserInformation:^(id obj, NSError *error) {
                
                NSLog(@"%@-------",obj);
                
                if (obj[@"usableCouponCount"]) {
                    
                    [HCJFNSUser setValue:obj[@"usableCouponCount"] forKey:@"Red"];
                }
                if (obj[@"usableTicketCount"]) {
                    [HCJFNSUser setValue:obj[@"usableTicketCount"] forKey:@"Ticket"];
                    
                }
                if ([obj[@"identifyCard"] isKindOfClass:[NSNull class]] || obj[@"identifyCard"] == nil) {
                    [HCJFNSUser setValue:@"1" forKey:@"IdNumber"];
                }else{
                    [HCJFNSUser setValue:obj[@"identifyCard"] forKey:@"IdNumber"];
                }
                NSArray *array = obj[@"accountBankList"];
                if ([array count] == 0) {
                    [HCJFNSUser setValue:@"1" forKey:@"cardNo"];
                }else{
                    
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [HCJFNSUser setValue:obj[@"cardNo"] forKey:@"cardNo"];
                    }];
                }
                [HCJFNSUser setValue:[obj[@"accountBankList"] firstObject][@"realname"] forKey:@"realname"];//姓名
                [HCJFNSUser synchronize];
                [hud setHidden:YES];
                //在线客服
                QYSessionViewController *sessionViewController = [Factory jumpToQY];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
                if (iOS11) {
                    self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, NavigationBarHeight)];
                }else{
                    self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)];
                }
                UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"汇诚金服"];
                TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
                [titleLabel titleLabel:@"汇诚金服" color:[UIColor blackColor]];
                navItem.titleView = titleLabel;
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanghui"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
                
                left.tintColor = [UIColor blackColor];
                [self.QYnavBar pushNavigationItem:navItem animated:NO];
                [navItem setLeftBarButtonItem:left];
                //    [navItem setRightBarButtonItem:right];
                [navi.view addSubview:self.QYnavBar];
                
                [self presentViewController:navi animated:YES completion:nil];
            } userId:[HCJFNSUser objectForKey:@"userId"]];
        }
        else{
            [Factory alertMes:@"请先登录"];
        }
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"客服电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //呼叫客服
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"客服时间:9:00-17:30\n400-0571-909" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *str = @"tel://400-0571-909";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"帮助中心" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        HelpTableViewController *achieve = [HelpTableViewController new];
        [self.navigationController pushViewController:achieve animated:YES];
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *消费积分
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //积分商城
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //兑吧免登陆接口
        [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
            [hud hideAnimated:YES];
            IntegralShopVC *tempVC = [IntegralShopVC new];
            tempVC.strUrl = obj[@"ret"];
            [self.navigationController pushViewController:tempVC animated:YES];
        } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
    }
}

@end
