//
//  OrderDetailsVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/5.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "OrderDetailsModel.h"
#import "LogisticsInfoVC.h"

@interface OrderDetailsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) OrderDetailsModel *orderDetailsModel;
@property (nonatomic, strong) NSMutableArray *dataSource;//数据数组
@property (nonatomic, strong) NSString *goodsName;//商品名称

@end

@implementation OrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"订单详情" andTextColor:1];
    //左边按钮
    UIButton *leftBtn = [Factory addLeftbottonToVC:self];
    [leftBtn addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:242 / 255.0 blue:244/255.0 alpha:1.0];
    //背景图
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"queren@2x_01"]];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(740*m6Scale/kScreenWidth*329*m6Scale);
    }];
    [self.view addSubview:self.tableView];
    //下单成功图标
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"xiangq@2x_03"];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.tableView.mas_top).offset(60*m6Scale);
        make.size.mas_equalTo(CGSizeMake(138*m6Scale, 163*m6Scale));
    }];
    //商品名称初始值
    self.goodsName = @"iPhone 10";
    //请求服务器数据
    [self serviceData];
}
/**
 *请求服务器数据
 */
- (void)serviceData{
    //用户点击订单查看订单详情
    [DownLoadData postGetOrderDetails:^(id obj, NSError *error) {
        _orderDetailsModel = obj[@"model"];
        //商品名称
        _goodsName = [NSString stringWithFormat:@"        %@", _orderDetailsModel.goodsName];
        //商品数量
        NSString *num = [NSString stringWithFormat:@"%@个", _orderDetailsModel.goodsNum];
        [self.dataSource addObject:num];
        //利率
        NSString *rate = [NSString stringWithFormat:@"%.1f%@", _orderDetailsModel.investRate.floatValue, @"%"];
        [self.dataSource addObject:rate];
        //期限
        NSString *date = [NSString stringWithFormat:@"%@个月", _orderDetailsModel.lockCycle];
        [self.dataSource addObject:date];
        //预计收益
        NSString *income = [NSString stringWithFormat:@"￥%.1f", _orderDetailsModel.investInterest.floatValue];
        [self.dataSource addObject:income];
        //总计金额
        NSString *total = [NSString stringWithFormat:@"总计：￥%.1f", _orderDetailsModel.orderAmount.floatValue*(_orderDetailsModel.goodsNum.intValue)];
        [self.dataSource addObject:total];
        //订单编号
        [self.dataSource addObject:[NSString stringWithFormat:@"%@", self.orderNo]];
        //下单时间
        NSString *time = [Factory stdTimeyyyyMMddFromNumer:_orderDetailsModel.addtime andtag:66];
        [self.dataSource addObject:time];
        //收货人姓名
        [self.dataSource addObject:[NSString stringWithFormat:@"%@", _orderDetailsModel.receiveName]];
        //收货人联系方式
        [self.dataSource addObject:[NSString stringWithFormat:@"%@", _orderDetailsModel.receiveMobile]];
        //联系人地址
        [self.dataSource addObject:[NSString stringWithFormat:@"%@", _orderDetailsModel.address]];
        
        [self.tableView reloadData];
    } orderNo:self.orderNo];
}
/**
 *数据数组
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(25*m6Scale, 240*m6Scale, kScreenWidth-50*m6Scale, 13*68*m6Scale+180*m6Scale)];
        _tableView.backgroundColor = Colorful(241, 242, 244);
        //遵循代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!section) {
        return 7;
    }else if(section == 1){
        return 3;
    }else{
        return 4;
    }
}
#pragma mark - cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"cell";
    _cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!_cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    _cell.selectionStyle = NO;
    _cell.backgroundColor = [UIColor whiteColor];
    //cell内容
    [self SectioncCellWithContentIndexPath:indexPath];
    
    return _cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!section) {
        return nil;
    }else{
        return [self CreateTableViewHeaderWithSection:section];;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!section) {
        return 0;
    }else{
        return 90*m6Scale;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68*m6Scale;
}
/**
 *tableView的头部View
 */
- (UIView *)CreateTableViewHeaderWithSection:(NSInteger)section{
    //空白背景
    UIView *view = [[UIView alloc] init];
    //橙色背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 22*m6Scale, 200*m6Scale, 68*m6Scale)];
    backView.backgroundColor = Colorful(244,136,63);
    //标签
    UILabel *label = nil;
    if (section == 1) {
        label = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"订单信息" addSubView:backView];
    }else{
        label = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"配送信息" addSubView:backView];
    }
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70*m6Scale);
        make.centerY.mas_equalTo(backView.mas_centerY);
    }];
    [view addSubview:backView];
    //小车背景图
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"queren@2x_17"];
    [backView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(label.mas_left).offset(-8*m6Scale);
        make.centerY.mas_equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28*m6Scale, 20*m6Scale));
    }];
    
    return view;
}
/**
 *section的cell内容
 */
- (void)SectioncCellWithContentIndexPath:(NSIndexPath *)indexPath{
    _cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    _cell.textLabel.font = [UIFont systemFontOfSize:26*m6Scale];
    _cell.detailTextLabel.font = [UIFont systemFontOfSize:25*m6Scale];
    if (indexPath.section == 0) {
        NSArray *textArr = @[_goodsName,@"利  率：",@"期  限：",@"预计收益"];
        NSArray *picArr = @[@"queren@2x_05", @"queren@2x_09",@"queren@2x_13"];
        if (indexPath.row > 0 && indexPath.row < 6) {
            if (indexPath.row < 5) {
                _cell.textLabel.text = textArr[indexPath.row - 1];
                _cell.textLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
                if (indexPath.row >1) {
                    _cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row-2]];
                }
            }else{
                _cell.detailTextLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(26*m6Scale)];
                _cell.detailTextLabel.textColor = Colorful(228, 70, 30);
            }
            if (self.dataSource.count) {
                _cell.detailTextLabel.text = self.dataSource[indexPath.row -1];
            }
        }
    }else if (indexPath.section == 1){
        NSArray *textArr = @[@"订单编号：",@"下单时间：",@"合同详情"];
        NSArray *picArr = @[@"queren@2x_20",@"queren@2x_24",@"xiangq@2x_12"];
        _cell.textLabel.text = textArr[indexPath.row];
        _cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row]];
        if (indexPath.row == 2){
            _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            if (self.dataSource.count) {
                _cell.detailTextLabel.text = self.dataSource[indexPath.row+5];
            }
        }
    }else{
        if (indexPath.row == 0){
            _cell.textLabel.text = @"物流信息";
            _cell.imageView.image = [UIImage imageNamed:@"xiangq@2x_18"];
            _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            NSArray *textArr = @[@"联系人：",@"联系方式：",@"联系地址："];
            NSArray *picArr = @[@"dizhi@2x_07",@"dizhi@2x_11",@"dizhi@2x_14"];
            _cell.textLabel.text = textArr[indexPath.row-1];
            _cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row-1]];
            if (self.dataSource.count) {
                _cell.detailTextLabel.text = self.dataSource[indexPath.row+6];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            //合同详情
            
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //查看物流信息
            LogisticsInfoVC *tempVC = [[LogisticsInfoVC alloc] init];
            tempVC.logisticsType = [NSString stringWithFormat:@"%@", _orderDetailsModel.logisticsType];//物流公司名称
            tempVC.logisticsOrderNo = [NSString stringWithFormat:@"%@", _orderDetailsModel.logisticsOrderNo];//运单编号
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

@end
