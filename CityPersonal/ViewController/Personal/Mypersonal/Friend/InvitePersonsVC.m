//
//  InvitePersonsVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "InvitePersonsVC.h"
#import "InvitePersonCell.h"

@interface InvitePersonsVC ()<UITableViewDelegate, UITableViewDataSource, FactoryDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;//数组数据
@property (nonatomic,strong) UIImageView *backIngView;//暂无数据背景图片
@property (nonatomic,strong) NSMutableDictionary *dataDic;//模型字典
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图片
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;

@end

@implementation InvitePersonsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"邀请人数"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    NSArray *array = @[@"好友", @"注册时间", @"是否绑卡", @"是否投资"];
    CGFloat width = kScreenWidth/4;
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [Factory CreateLabelWithTextColor:0.4 andTextFont:28 andText:array[i] addSubView:self.view];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i > 1) {
                make.width.mas_equalTo(width-30*m6Scale);
                make.left.mas_equalTo((width+30*m6Scale)*2+(i-2)*(width-30*m6Scale));
            }else{
                make.width.mas_equalTo(width+30*m6Scale);
                make.left.mas_equalTo((width+30*m6Scale)*i);
            }
            make.top.mas_equalTo(20*m6Scale);
        }];
    }
    //网络请求时时改变
    Factory *fatory = [[Factory alloc] init];
    fatory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    //请求数据
    [self pullDown];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 68*m6Scale, kScreenWidth, kScreenHeight-KSafeBarHeight-68*m6Scale-NavigationBarHeight-275*m6Scale-44)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.tableFooterView = [UIView new];
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
 *  暂无数据背景图片的懒加载
 */
- (UIImageView *)backImgView{
    if(!_backImgView){
        _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无数据"]];
        [self.tableView addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(260*m6Scale, 260*m6Scale));
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(kScreenHeight/6);
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
/**
 *  返回
 */
- (void)onClickLeftItem{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"InvitePersonsCell";
    InvitePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[InvitePersonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    
    if (self.dataArr.count) {
        [cell cellForModel:self.dataArr[indexPath.row]];
        
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*m6Scale;
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
        [DownLoadData postGetPageInviteInfoLists:^(id obj, NSError *error) {
            //数据请求失败
                self.dataArr = obj[@"SUCCESS"];
                self.dataDic = obj[@"SUCCESS1"];
            
            if (_refreshHeaderData) {
                _refreshHeaderData();
            }
                //假如网罗求情下来的没有数据
                if (_dataArr.count == 0) {
                    //防止突然没有数据 导致暂无内容图和数据交叉
                    [self.tableView reloadData];
                    self.backImgView.hidden = NO;
                    [_tableView.mj_header endRefreshing];
                    self.tableView.mj_footer.hidden = YES;
                }else{
                    _tableView.mj_footer.hidden = NO;
                    self.backImgView.hidden = YES;
                    [self.tableView reloadData];
                    NSString *total = [NSString stringWithFormat:@"%@",_dataDic[@"total"]];
                    if (total.integerValue <= 10) {
                        self.tableView.mj_footer.hidden = YES;
                    }else{
                        self.tableView.mj_footer.hidden = NO;
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
        [DownLoadData postGetPageInviteInfoLists:^(id obj, NSError *error) {
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
        } userId:[HCJFNSUser stringForKey:@"userId"] pageNum:[NSString stringWithFormat:@"%ld", _page] pageSize:@"10"];
    }
}

@end
