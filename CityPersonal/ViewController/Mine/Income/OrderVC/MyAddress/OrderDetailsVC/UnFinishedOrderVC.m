//
//  UnFinishedOrderVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/5.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "UnFinishedOrderVC.h"
#import "MyAddressVC.h"
#import "OrderDetailsModel.h"
#import "OrderVC.h"

@interface UnFinishedOrderVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) OrderDetailsModel *orderDetailsModel;
@property (nonatomic, strong) NSMutableArray *dataSource;//数据数组
@property (nonatomic, strong) NSString *addTime;//下单时间
@property (nonatomic, strong) UILabel *accountLabel;//应付金额

@end

@implementation UnFinishedOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"订单确认" andTextColor:1];
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
    imgView.image = [UIImage imageNamed:@"zhifu@2x_04"];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.tableView.mas_top).offset(60*m6Scale);
        make.size.mas_equalTo(CGSizeMake(138*m6Scale, 163*m6Scale));
    }];
    //立即支付
    [self AtOncePayForGoodsView];
    //请求服务数据
    [self serviceData];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(25*m6Scale, 240*m6Scale, kScreenWidth-50*m6Scale, 13*68*m6Scale+180*m6Scale)];
        _tableView.backgroundColor = Colorful(241, 242, 244);
        //遵循代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.bounces = NO;
    }
    return _tableView;
}
/**
 *请求服务器数据
 */
- (void)serviceData{
    //用户点击订单查看订单详情
    [DownLoadData postGetOrderDetails:^(id obj, NSError *error) {
        _orderDetailsModel = obj[@"model"];
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
        [self.dataSource addObject:[NSString stringWithFormat:@"%@", _orderDetailsModel.orderNo]];
        //下单时间
        self.addTime = [Factory stdTimeyyyyMMddFromNumer:_orderDetailsModel.addtime andtag:4];
        [self.dataSource addObject:self.addTime];
        //收货人姓名
        [self.dataSource addObject:[NSString stringWithFormat:@"%@", _orderDetailsModel.receiveName]];
        //收货人联系方式
        [self.dataSource addObject:[NSString stringWithFormat:@"%@", _orderDetailsModel.receiveMobile]];
        //联系人地址
        [self.dataSource addObject:[NSString stringWithFormat:@"%@", _orderDetailsModel.address]];
        //应付金额
        _accountLabel.text = [NSString stringWithFormat:@"应付金额：￥%.2f", _orderDetailsModel.orderAmount.floatValue*(_orderDetailsModel.goodsNum.intValue)];
        
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!section) {
        return 7;
    }else{
        return 6;
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
    return 2;
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
    UILabel *label = label = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"订单信息" addSubView:backView];
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
        NSString *goodsName = [NSString stringWithFormat:@"        %@", _orderDetailsModel.goodsName];
        NSArray *textArr = @[goodsName,@"利  率：",@"期  限：",@"预计收益"];
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
    }else{
        NSArray *textArr = @[@"订单编号：",@"下单时间：", @"联系人：",@"联系方式：",@"联系地址："];
        NSArray *picArr = @[@"queren@2x_20",@"queren@2x_24", @"dizhi@2x_07",@"dizhi@2x_11",@"dizhi@2x_14"];
        if (indexPath.row < 5) {
            _cell.textLabel.text = textArr[indexPath.row];
            _cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row]];
            _cell.textLabel.text = textArr[indexPath.row];
            if (self.dataSource.count) {
                _cell.detailTextLabel.text = self.dataSource[indexPath.row+5];
            }
        }else{
            UIButton *btn = [Factory addButtonWithTextColorRed:241 Green:160 Blue:97 andTitle:@"取消订单" addSubView:_cell.contentView];
            [btn addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_cell.contentView.mas_centerY);
                make.right.mas_equalTo(-25*m6Scale);
                make.size.mas_equalTo(CGSizeMake(150*m6Scale, 50*m6Scale));
            }];
        }
    }
}
/**
 *立即支付View
 */
- (void)AtOncePayForGoodsView{
    //空白View
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(88*m6Scale+KSafeBarHeight);
    }];
    //应付金额
    _accountLabel = [[UILabel alloc] init];
    _accountLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(32*m6Scale)];
    _accountLabel.text = @"应付金额：￥200.01";
    [whiteView addSubview:_accountLabel];
    [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(56*m6Scale);
        make.centerY.mas_equalTo(whiteView.mas_centerY).offset(-KSafeBarHeight/2);
    }];
    //立即支付按钮
    UIButton *acBtn = [UIButton buttonWithType:0];
    [acBtn setTitle:@"立即支付" forState:0];
    [acBtn setTitleColor:[UIColor whiteColor] forState:0];
    [acBtn addTarget:self action:@selector(PayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    acBtn.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:76 / 255.0 blue:42/255.0 alpha:1.0];
    [whiteView addSubview:acBtn];
    [acBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-KSafeBarHeight);
        make.width.mas_equalTo(230*m6Scale);
    }];
}
/**
 *立即支付按钮（跳转至订单确认界面）
 */
- (void)PayButtonClick{
    OrderVC *tempVC = [OrderVC new];
    tempVC.type = 1;//订单确认页面的数据获取方式是请求查询接口
    tempVC.orderNo = [NSString stringWithFormat:@"%@", self.orderNo];//商品定单编号
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *取消订单
 */
- (void)cancleButtonClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定取消订单？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消订单");
        [DownLoadData postOrderCancel:^(id obj, NSError *error) {
            if ([obj[@"result"] isEqualToString:@"success"]) {
                [Factory alertMes:@"取消订单成功"];
                //反馈成功之后三秒返回到我的界面
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    sleep(2.0);
                    //回到主队列
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                });
            }else{
                [Factory alertMes:obj[@"messageText"]];
            }
        } orderNo:self.orderNo];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
