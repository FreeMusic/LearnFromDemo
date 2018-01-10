//
//  MessageVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/21.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "FilterView.h"

@interface MessageVC ()<UITableViewDelegate, UITableViewDataSource,FactoryDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *deleteArr;
@property (nonatomic, strong) NSNumber *ID;
@property(nonatomic, strong) UIButton *selectAllBtn;//选择按钮
@property(nonatomic, strong) UIButton *deleteBtn;//删除
@property(nonatomic, strong) UIView *baseView;//背景view
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableDictionary *dic1;
@property (nonatomic, strong) NSMutableArray *muArray;
@property (nonatomic, strong) FilterView *filterView;//筛选时间视图
@property (nonatomic, assign) BOOL isAllowShow;//筛选视图是否允许弹出
@property (nonatomic, strong) NSString *type;//消息筛选类型
@property (nonatomic, strong)  UIButton *rightButton;
@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"消息中心"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //消息筛选按钮
    self.rightButton = [Factory addRightbottonToVC:self andrightStr:@""];
    self.rightButton.frame = CGRectMake(0, 0, 50, 40);
    [self.rightButton setImage:[UIImage imageNamed:@"messageChoose"] forState:0];
    [self.rightButton addTarget:self action:@selector(filterMessage) forControlEvents:UIControlEventTouchUpInside];
    //筛选视图是否允许弹出
    self.isAllowShow = YES;
    [self.view addSubview:self.tableView];
    
    //(121,196)
    _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_tableView.frame.size.width -130)/2, (_tableView.frame.size.height -130)/2, 130, 130)];
    
    self.deleteArr = [NSMutableArray new];
    
    self.type = @"null";
    
    [self pullDown];//下拉加载
    [self example11];//上拉加载
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    //用户点击筛选消息
    [self monitorFilter];
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
/**
 *数据数组的懒加载
 */
- (NSMutableArray *)array{
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}
/**
 *数据字典的懒加载
 */
- (NSMutableDictionary *)dic1{
    if(!_dic1){
        _dic1 = [NSMutableDictionary dictionary];
    }
    return _dic1;
}
/**
 *可变数组
 */
- (NSMutableArray *)muArray{
    if(!_muArray){
        _muArray = [NSMutableArray array];
    }
    return _muArray;
}
/**
 *用户点击筛选消息
 */
- (void)monitorFilter{
    self.filterView.hidden = YES;
    __weak typeof(self)weakSelf = self;
    //监听点击事件
    [self.filterView setFilterSelect:^(NSInteger index){
        weakSelf.isAllowShow = !weakSelf.isAllowShow;
        weakSelf.rightButton.selected = !weakSelf.rightButton.selected;
        if (index == 0) {
            weakSelf.type = @"null";
        }else if(index == 1){
            [weakSelf allAlreadyRead];
        }else{
            weakSelf.type = [NSString stringWithFormat:@"%ld", index-1];
        }
        if (index == 1) {
            
        }else{
            //请求数据
            [weakSelf serverData];
        }
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.filterView.tableView.frame = CGRectMake(0, -440*m6Scale, kScreenWidth, 440*m6Scale);
        } completion:^(BOOL finished) {
            weakSelf.filterView.hidden = YES;
        }];
    }];
}
/**
 *时间选择视图
 */
- (FilterView *)filterView{
    if(!_filterView){
        _filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        [self.view addSubview:_filterView];
    }
    return _filterView;
}

/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView Lazyloading
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 65) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = SeparatorColor;
    }
    return _tableView;
}
//上拉加载
- (void)example11
{
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
}
//时间选择时间
- (void)filterMessage{
    
    if (self.isAllowShow) {
        self.filterView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.filterView.tableView.frame = CGRectMake(0, 0, kScreenWidth, 88*m6Scale*6);
        }];
        self.isAllowShow = NO;
    }else{
        self.filterView.hidden = YES;
        self.filterView.tableView.frame = CGRectMake(0, -88*m6Scale*6, kScreenWidth, 88*m6Scale*6);
        self.isAllowShow = YES;
    }
}
//上拉加载
-(void)LoadNewData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }
    else {
        [DownLoadData postGetSiteMailList:^(id obj, NSError *error) {
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
            
        } userId:[HCJFNSUser stringForKey:@"userId"] pageNum:[NSString stringWithFormat:@"%ld", (long)_page] pageSize:@"10" type:self.type];
    }
}
//下拉刷新
- (void)pullDown
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serverData)];
    [_tableView.mj_header beginRefreshing];
    
}
- (void)allAlreadyRead{
    [DownLoadData postReadAllSiteMail:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            self.type = @"";
            [self serverData];
        }
    }];
}
/**
 *  服务器数据
 */
- (void)serverData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    } else {
        [DownLoadData postGetSiteMailList:^(id obj, NSError *error) {
            [self.array removeAllObjects];
            self.array = obj[@"SUCCESS"];
            self.dic1 = obj[@"SUCCESS1"];
            if (_array.count == 0) {
                [self.tableView reloadData];
                _deleteBtn.backgroundColor = [UIColor lightGrayColor];
                _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"zanwuxiaoxi"]];
                [_tableView addSubview:_backgroundImage];
                self.tableView.separatorStyle = NO;
                [_tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = YES;
            }
            else {
                [_backgroundImage removeFromSuperview];
                [self.tableView reloadData];
                self.tableView.separatorStyle = YES;
                
                NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                if (total.intValue <= 10) {
                    
                } else {
                    [_tableView.mj_footer resetNoMoreData];
                    _tableView.mj_footer = _footer;
                    _page = 2;
                    [self example11];
                }
                _deleteBtn.backgroundColor = ButtonColor;
                [_tableView.mj_header endRefreshing];
                _tableView.tableFooterView = [UIView new];
            }
        } userId:[HCJFNSUser stringForKey:@"userId"] pageNum:@"1" pageSize:@"10" type:self.type];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
#pragma mark -cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"HCJF";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
       cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    MessageModel *model = _array[indexPath.row];
    self.ID = model.ID;
    [cell updateCellWithRedModel:model andIndexPath:indexPath];
    
    return cell;
}
#pragma mark -heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 169*m6Scale;
}
#pragma mark -didSelect

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18*m6Scale;
}
#pragma mark -heightForFooterInSection
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];
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
