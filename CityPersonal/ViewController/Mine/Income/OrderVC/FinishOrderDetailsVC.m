//
//  FinishOrderDetailsVC.m
//  CityJinFu
//
//  Created by mic on 2017/8/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "FinishOrderDetailsVC.h"
#import "MyAddressVC.h"
#import "OrderModel.h"
#import "ForgetPasswordView.h"
#import "CreatView.h"
#import "MyAddressVC.h"
#import "OrderDetailsModel.h"
#import "LogisticsInfoVC.h"
#import "ProtocolVC.h"

@interface FinishOrderDetailsVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) OrderModel *orderModel;
@property (nonatomic,strong) NSMutableArray *dataArr;//数据
@property (nonatomic,strong) UILabel *accountLabel;//应付金额
@property (nonatomic, strong) NSString *timeRandom;//生成的短信验证码
@property (nonatomic, strong) NSString *validPhoneExpiredTime;//发送验证码时间
@property (nonatomic, strong) UITextField *textField;//文本框
@property (nonatomic, strong) ForgetPasswordView *passwordView;
@property (nonatomic, strong) CreatView *creatView;
@property (nonatomic, strong) UIButton *addAdressBtn;//添加地址按钮
@property (nonatomic, strong) OrderDetailsModel *model;
@property (nonatomic, strong) NSArray *addressArr;//地址数组
@property (nonatomic, strong) NSString *protocol;//记录页面是否已经创建了

@end

@implementation FinishOrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"订单确认"];
    self.view.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:242 / 255.0 blue:244/255.0 alpha:1.0];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
}
/**
 *调用查询订单接口，调用查询地址接口
 */
- (void)GetData{
    //用户点击订单查看订单详情
    [DownLoadData postGetOrderDetails:^(id obj, NSError *error) {
        _model = obj[@"model"];
        //数量
        [self.dataArr addObject:[NSString stringWithFormat:@"%@个", _model.goodsNum]];
        //利率
        [self.dataArr addObject:[NSString stringWithFormat:@"%.1f%@", _model.investRate.floatValue, @"%"]];
        //期限
        [self.dataArr addObject:[NSString stringWithFormat:@"%@个月", _model.lockCycle]];
        //预计收益
        [self.dataArr addObject:[NSString stringWithFormat:@"￥%@", _model.investInterest]];
        //总计
        [self.dataArr addObject:[NSString  stringWithFormat:@"总计：￥%.1f", _model.orderAmount.floatValue]];
        //联系人地址
        [self.dataArr addObject:[NSString stringWithFormat:@"%@", _model.address]];
        //收货人姓名
        [self.dataArr addObject:[NSString stringWithFormat:@"%@", _model.receiveName]];
        //收货人联系方式
        [self.dataArr addObject:[NSString stringWithFormat:@"%@", _model.receiveMobile]];
        self.addressArr = @[[NSString stringWithFormat:@"%@", _model.address], [NSString stringWithFormat:@"%@", _model.receiveName], [NSString stringWithFormat:@"%@", _model.receiveMobile]];
        
        [self.tableView reloadData];
    } orderNo:self.orderNo];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight-88*m6Scale) style:UITableViewStyleGrouped];
        //代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _tableView;
}
/**
 *数据数组的懒加载
 */
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 3;
    }else{
        return 4;
    }
}
#pragma mark - cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    //图片数组
    NSArray *picArr;
    //种类数组
    NSArray *typeArr;
    picArr = @[@"gouwu", @"lilv",@"qixian",@"shouyi",@"zhuangtai",@"bianhao",@"xiadanshijian",@"hetong"];
    NSString *goodsName = [NSString stringWithFormat:@"%@", _model.goodsName];
    typeArr = @[goodsName,@"利率",@"期限",@"预计收益",@"订单状态",@"订单编号",@"下单时间", @"合同查看"];
    cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    cell.textLabel.textColor = UIColorFromRGB(0x393939);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:24*m6Scale];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row]];
        cell.textLabel.text = typeArr[indexPath.row];
        if (indexPath.row == 4) {
            cell.detailTextLabel.text = @"已授权";
            cell.detailTextLabel.textColor = UIColorFromRGB(0xff5933);
        }else{
            if (self.dataArr.count) {
                cell.detailTextLabel.textColor = UIColorFromRGB(0x696565);
                cell.detailTextLabel.text = self.dataArr[indexPath.row];
            }
        }
    }else if (indexPath.section == 1){
        cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row+5]];
        cell.textLabel.text = typeArr[indexPath.row+5];
        if (indexPath.row == 0) {
            //订单编号
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _model.orderNo];
            //下单时间
            cell.detailTextLabel.textColor = UIColorFromRGB(0x696565);
        }else if (indexPath.row == 1){
            //下单时间
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [Factory stdTimeyyyyMMddFromNumer:_model.addtime andtag:100]];
            cell.detailTextLabel.textColor = UIColorFromRGB(0x696565);
        }else{
            //合同查看
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(indexPath.section == 2){
        NSArray *array = @[@"收货地址", @"联系人", @"联系方式", @"物流信息"];
        NSArray *photoArr = @[@"dizhiOrder", @"lianxirenOrder", @"lianxifangshiOrder", @"wuliu"];
        cell.imageView.image = [UIImage imageNamed:photoArr[indexPath.row]];
        cell.textLabel.text = array[indexPath.row];
        if (indexPath.row == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.detailTextLabel.text = self.addressArr[indexPath.row];
        }
    }
    cell.selectionStyle = NO;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70*m6Scale;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *array = @[@"产品信息", @"订单信息", @"配送信息"];
    
    return array[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 3) {
            NSLog(@"%@", _model.logisticsOrderNo);
            if (_model.logisticsOrderNo != nil) {
                LogisticsInfoVC *tempVC = [LogisticsInfoVC new];
                tempVC.logisticsType = [NSString stringWithFormat:@"%@", _model.logisticsType];
                tempVC.logisticsOrderNo = [NSString stringWithFormat:@"%@", _model.logisticsOrderNo];
                [self.navigationController pushViewController:tempVC animated:YES];
            }else{
                [Factory addAlertToVC:self withMessage:@"暂无物流信息"];
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 2) {
            ProtocolVC *protocol = [ProtocolVC new];
            self.protocol = @"0";
            protocol.strTag = @"4";
            [self presentViewController:protocol animated:YES completion:nil];
        }
    }
}

/**
 *  返回
 */
- (void)onClickLeftItem
{
    if (_type == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(_type == 2){
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    //请求数据
    [self GetData];
}

@end
