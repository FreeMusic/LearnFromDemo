//
//  InviteRecordView.m
//  CityJinFu
//
//  Created by mic on 2017/11/7.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "InviteRecordView.h"
#import "InviteRecordCell.h"
#import "InviteFriendModel.h"

@interface InviteRecordView ()<UITableViewDelegate, UITableViewDataSource>
/**
 邀请人数
 */
@property (nonatomic, strong) UILabel *numLabel;
/**
 红包奖励
 */
@property (nonatomic, strong) UILabel *redLabel;
@property (nonatomic, strong) UILabel *accountLabel;//佣金奖励
@property (nonatomic, strong) UILabel *inviteLabel;//邀请奖励
@property (nonatomic, strong) UILabel *titleLabel;//弹出视图标题标签
@property (nonatomic, strong) UIView *awardView;//邀请奖励View
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) NSArray *dataSource;//邀请记录数据
@property (nonatomic, strong) InviteFriendModel *inviteFriendModel;

@property (nonatomic,strong) NSMutableArray *dataArr;//模型数组
@property (nonatomic,strong) NSMutableDictionary *dataDic;//模型字典
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图片
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, copy) NSString *appointTime;//预约时间

@end

@implementation InviteRecordView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = navigationYellowColor;
        _viewWidth = 670*m6Scale;
        
        //弹出视图标题标签
        _titleLabel = [Factory CreateLabelWithColor:[UIColor whiteColor] andTextFont:30 andText:@"已邀请3位好友，共获得250元现金奖励。" addSubView:self];
        [Factory ChangeColorStringArray:@[@"3", @"250"] andLabel:_titleLabel andColor:buttonColor];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(70*m6Scale);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        //邀请奖励View
        self.awardView.frame = CGRectMake((kScreenWidth-_viewWidth)/2, 240*m6Scale, _viewWidth, 290*m6Scale);
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.awardView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10*m6Scale,10*m6Scale)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = self.awardView.bounds;
        maskLayer1.path = maskPath1.CGPath;
        self.awardView.layer.mask = maskLayer1;
        //创建标题
        [self createTitleView];
        //绘制分割线
        [self drawSplitLine];
        //加载tableView
        [self tableView];
        //请求数据
        [self reciveData];
    }
    
    return self;
}
/**
 * 请求数据
 */
- (void)reciveData{
    //邀请人列表
    [DownLoadData postGetInviteInfoLists:^(id obj, NSError *error) {
        self.dataSource = obj[@"SUCCESS"];
        
        [self.tableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    
    //邀请好友首页
    [DownLoadData postInviteFriendByUserId:^(id obj, NSError *error) {
        _inviteFriendModel = [[InviteFriendModel alloc] initWithDictionary:obj];
        //邀请人数
        _numLabel.text = [NSString stringWithFormat:@"%@", _inviteFriendModel.invitePersons];
        //获得 奖励
        _redLabel.text = [NSString stringWithFormat:@"%@", _inviteFriendModel.inviteRewards];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *  创建标题
 */
- (void)createTitleView{
    //奖励标题View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-_viewWidth)/2, 170*m6Scale, _viewWidth, 70*m6Scale)];
    titleView.backgroundColor = Colorful(252, 90, 69);
    [self addSubview:titleView];
    //画曲线
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.awardView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30*m6Scale,30*m6Scale)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleView.bounds;
    maskLayer.path = maskPath.CGPath;
    titleView.layer.mask = maskLayer;
    //图标
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inviteFried_明细"]];
    [titleView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(210*m6Scale);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 37*m6Scale));
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    //邀请奖励明细标题
    UILabel *awardLabel = [Factory CreateLabelWithColor:[UIColor whiteColor] andTextFont:30 andText:@"邀请奖励明细" addSubView:titleView];
    [awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(15*m6Scale);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
}
/**
 *  绘制分割线
 */
- (void)drawSplitLine{
    
    NSArray *array = @[@"邀请人数(人)", @"红包奖励(元)", @"佣金奖励(元)", @"邀请奖励(元)"];
    //横线
    UIView *horizontal = [[UIView alloc] init];
    horizontal.backgroundColor = LineColor;
    [self.awardView addSubview:horizontal];
    [horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45*m6Scale);
        make.right.mas_equalTo(-45*m6Scale);
        make.centerY.mas_equalTo(self.awardView.mas_centerY);
        make.height.mas_equalTo(1);
    }];
    //竖线
    UIView *vertical = [[UIView alloc] init];
    vertical.backgroundColor = LineColor;
    [self.awardView addSubview:vertical];
    [vertical mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25*m6Scale);
        make.bottom.mas_equalTo(-25*m6Scale);
        make.centerX.mas_equalTo(self.awardView.mas_centerX);
        make.width.mas_equalTo(1);
    }];
    
    CGFloat width = self.awardView.frame.size.width/2;
    CGFloat height = self.awardView.frame.size.height/2;
    //邀请人数
    _numLabel = [self getLabel];
    //红包奖励
    _redLabel = [self getLabel];
    //佣金奖励
    _accountLabel = [self getLabel];
    //邀请奖励
    _inviteLabel = [self getLabel];
    
    NSArray *labelArr =@[_numLabel, _redLabel, _accountLabel, _inviteLabel];
    
    for (int i = 0; i < array.count; i++) {
        
        UILabel *label = [Factory CreateLabelWithColor:[UIColor colorWithWhite:0.3 alpha:0.7] andTextFont:25 andText:array[i] addSubView:self.awardView];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(i/2*height+25*m6Scale);
            make.width.mas_equalTo(width);
            make.left.mas_equalTo(i%2*width);
        }];

        UILabel *numLabel = (UILabel *)labelArr[i];
        
        [self layoutLabel:numLabel andOrder:i topLabel:label];
    }
}
/**
 * 约束标签
 */
- (void)layoutLabel:(UILabel *)label andOrder:(int)order topLabel:(UILabel *)topLabel{
    CGFloat width = self.awardView.frame.size.width/2;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom).offset(25*m6Scale);
        make.width.mas_equalTo(width);
        make.left.mas_equalTo(order%2*width);
    }];
    
}

- (UILabel *)getLabel{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:30*m6Scale];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = Colorful(252, 90, 69);
    label.text = @"15";
    [self.awardView addSubview:label];
    
    return label;
}
/**
 *  邀请奖励View
 */
- (UIView *)awardView{
    if(!_awardView){
        _awardView = [[UIView alloc] init];
        _awardView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_awardView];
    }
    return _awardView;
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        
        //我的邀请记录标题View
        [self initInviteRecordView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake((kScreenWidth-_viewWidth)/2, 620*m6Scale, _viewWidth, 350*m6Scale)];
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:_tableView];
    }
    return _tableView;
}
/**
 * 我的邀请记录标题View
 */
- (void)initInviteRecordView{
    //我的邀请记录标题View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-_viewWidth)/2, 550*m6Scale, _viewWidth, 70*m6Scale)];
    titleView.backgroundColor = Colorful(252, 90, 69);
    [self addSubview:titleView];
    //画曲线
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.awardView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30*m6Scale,30*m6Scale)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleView.bounds;
    maskLayer.path = maskPath.CGPath;
    titleView.layer.mask = maskLayer;
    //图标
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inviteFried_拷贝"]];
    [titleView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(210*m6Scale);
        make.size.mas_equalTo(CGSizeMake(38*m6Scale, 38*m6Scale));
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    //邀请记录标题
    UILabel *awardLabel = [Factory CreateLabelWithColor:[UIColor whiteColor] andTextFont:30 andText:@"我的邀请记录" addSubView:titleView];
    [awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(15*m6Scale);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+self.dataSource.count;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"InviteRecordCell";
    
    InviteRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[InviteRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    if (self.dataSource.count && indexPath.row) {
        [cell cellForModel:self.dataSource[indexPath.row-1]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*m6Scale;
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
        [DownLoadData postList:^(id obj, NSError *error) {
            //数据请求失败
            if (error.code == -1004) {
                [_tableView.mj_header endRefreshing];
            }else{
                self.dataArr = obj[@"SUCCESS"];
                self.dataDic = obj[@"SUCCESS1"];
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
            }
        } pageNum:@"1" pageSize:@"10" itemStatus:@"" itemType:@"-1"];
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
        [DownLoadData postList:^(id obj, NSError *error) {
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
        } pageNum:[NSString stringWithFormat:@"%ld", (long)_page] pageSize:@"10" itemStatus:@"" itemType:@"-1"];
    }
}
@end
