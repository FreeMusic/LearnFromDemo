//
//  OrderVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/2.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "OrderVC.h"
#import "MyAddressVC.h"
#import "OrderModel.h"
#import "ForgetPasswordView.h"
#import "CreatView.h"
#import "MyAddressVC.h"
#import "OrderDetailsModel.h"
#import "RechargeView.h"
#import "FinishOrderDetailsVC.h"
#import "DealPswVC.h"

@interface OrderVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

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
@property (nonatomic, strong) UIButton *cancleBtn;//取消订单按钮
@property (nonatomic, strong) RechargeView *rechargeView;//输入交易密码弹出视图
@property (nonatomic, strong) NSMutableArray *addressArr;//地址数组

@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"订单确认" andTextColor:0];
    self.view.backgroundColor = [UIColor colorWithRed:241 / 255.0 green:242 / 255.0 blue:244/255.0 alpha:1.0];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    //获取加密因子和密码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyRecharge:) name:@"sxyRecharge" object:nil];
    //立即支付
    [self AtOncePayForGoodsView];
    //获取我的地址页面的地址信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddress:) name:@"refreshAddress" object:nil];
    //请求数据
    [self serviceData];
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
 *请求数据
 */
- (void)serviceData{
    //商品详情页立即投资
    [DownLoadData postInvest:^(id obj, NSError *error) {
        _orderModel = [[OrderModel alloc] initWithDictionary:obj];
        //请求到数据之后将数组中的数据清空
        [self.dataArr removeAllObjects];
        //数量
        [self.dataArr addObject:[NSString stringWithFormat:@"%@个", _orderModel.goodsNum]];
        //利率
        [self.dataArr addObject:[NSString stringWithFormat:@"%.1f%@", _orderModel.investRate.floatValue, @"%"]];
        //期限
        [self.dataArr addObject:[NSString stringWithFormat:@"%@个月", _orderModel.lockCycle]];
        //预计收益
        [self.dataArr addObject:[NSString stringWithFormat:@"￥%@", _orderModel.investInterest]];
        //总计
        [self.dataArr addObject:[NSString  stringWithFormat:@"总计：￥%.1f", _orderModel.orderAmount.floatValue*(_orderModel.goodsNum.floatValue)]];
        //收货人姓名
        [self.dataArr addObject:[NSString stringWithFormat:@"%@", _orderModel.receiveName]];
        //收货人联系方式
        [self.dataArr addObject:[NSString stringWithFormat:@"%@", _orderModel.receiveMobile]];
        //联系人地址
        [self.dataArr addObject:[NSString stringWithFormat:@"%@", _orderModel.address]];
        
        NSString *address = [NSString stringWithFormat:@"%@", _orderModel.address];
        NSString *name = [NSString stringWithFormat:@"%@", _orderModel.receiveName];
        NSString *mobile = [NSString stringWithFormat:@"%@", _orderModel.receiveMobile];
        
        if (![address isEqualToString:@"(null)"] && ![mobile isEqualToString:@"(null)"] && ![name isEqualToString:@"(null)"]) {
            [self.addressArr addObject:[NSString stringWithFormat:@"%@", _orderModel.address]];
            [self.addressArr addObject:[NSString stringWithFormat:@"%@", _orderModel.receiveName]];
            [self.addressArr addObject:[NSString stringWithFormat:@"%@", _orderModel.receiveMobile]];
        }
        //应付金额
        _accountLabel.text = [NSString stringWithFormat:@"应付金额：￥%.2f", _orderModel.orderAmount.floatValue];
        
        [self.tableView reloadData];
    } kindId:self.kindID num:self.number userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *地址数组
 */
- (NSMutableArray *)addressArr{
    if(!_addressArr){
        _addressArr = [NSMutableArray array];
    }
    return _addressArr;
}
/**
 *输入交易密码弹出视图
 */
- (RechargeView *)rechargeView{
    if(!_rechargeView){
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_rechargeView];
    }
    return _rechargeView;
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
 *取消订单按钮
 */
- (UIButton *)cancleBtn{
    if(!_cancleBtn){
        _cancleBtn = [UIButton buttonWithType:0];
        _cancleBtn = [UIButton buttonWithType:0];
        _cancleBtn.layer.cornerRadius = 25*m6Scale;
        [_cancleBtn setTitle:@"取消订单" forState:0];
        _cancleBtn.layer.borderWidth = 1;
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        [_cancleBtn setTitleColor:UIColorFromRGB(0xa2a2a2) forState:0];
        _cancleBtn.layer.borderColor = UIColorFromRGB(0xa2a2a2).CGColor;
        [_cancleBtn addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
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
        if (self.addressArr.count) {
            return 4;
        }else{
            return 2;
        }
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
    picArr = @[@"gouwu", @"lilv",@"qixian",@"shouyi",@"zhuangtai",@"bianhao",@"xiadanshijian",@""];
    NSString *goodsName = [NSString stringWithFormat:@"%@", _orderModel.goodsName];
    typeArr = @[goodsName,@"利率",@"期限",@"预计收益",@"订单状态",@"订单编号",@"下单时间",@""];
    cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    cell.textLabel.textColor = UIColorFromRGB(0x393939);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:24*m6Scale];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row]];
        cell.textLabel.text = typeArr[indexPath.row];
        if (indexPath.row == 4) {
            cell.detailTextLabel.text = @"待授权";
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
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _orderModel.orderNo];
            //下单时间
            cell.detailTextLabel.textColor = UIColorFromRGB(0x696565);
        }else if (indexPath.row == 1){
            //下单时间
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [Factory stdTimeyyyyMMddFromNumer:_orderModel.addtime andtag:100]];
            cell.detailTextLabel.textColor = UIColorFromRGB(0x696565);
        }else{
            [cell addSubview:self.cancleBtn];
            [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-30*m6Scale);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(120*m6Scale, 50*m6Scale));
            }];
        }
    }else if(indexPath.section == 2){
        if (self.addressArr.count) {
            if (indexPath.row == 3) {
                [cell addSubview:self.addAdressBtn];
                [self.addAdressBtn setTitle:@"修改地址" forState:0];
                self.addAdressBtn.hidden = NO;
                [self.addAdressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30*m6Scale);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(120*m6Scale, 50*m6Scale));
                }];
            }else{
                self.addAdressBtn.hidden = YES;
                NSArray *array = @[@"收货地址", @"联系人", @"联系方式"];
                NSArray *photoArr = @[@"dizhiOrder", @"lianxirenOrder", @"lianxifangshiOrder"];
                cell.imageView.image = [UIImage imageNamed:photoArr[indexPath.row]];
                cell.textLabel.text = array[indexPath.row];
                NSLog(@"%@", self.addressArr[indexPath.row]);
                cell.detailTextLabel.text = self.addressArr[indexPath.row];
            }
            
        }else{
            if (indexPath.row) {
                [cell addSubview:self.addAdressBtn];
                self.addAdressBtn.hidden = NO;
                [self.addAdressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30*m6Scale);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(120*m6Scale, 50*m6Scale));
                }];
            }else{
                cell.textLabel.text = @"收货地址";
                cell.imageView.image = [UIImage imageNamed:@"dizhiOrder"];
            }
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
/**
 *取消订单按钮
 */
- (void)cancleButtonClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定取消订单？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消订单");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DownLoadData postOrderCancel:^(id obj, NSError *error) {
            if ([obj[@"result"] isEqualToString:@"success"]) {
                [hud hideAnimated:YES];
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
        } orderNo:[NSString stringWithFormat:@"%@", _orderModel.orderNo]];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *添加地址按钮
 */
- (UIButton *)addAdressBtn{
    if(!_addAdressBtn){
        _addAdressBtn = [UIButton buttonWithType:0];
        [_addAdressBtn setTitle:@"添加地址" forState:0];
        [_addAdressBtn setTitleColor:buttonColor forState:0];
        _addAdressBtn.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        [_addAdressBtn addTarget:self action:@selector(AddAdressButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _addAdressBtn.layer.cornerRadius = 25*m6Scale;
        _addAdressBtn.layer.borderColor = UIColorFromRGB(0xff5933).CGColor;
        _addAdressBtn.layer.borderWidth = 1;
    }
    
    return _addAdressBtn;
}
/**
 *添加地址按钮点击事件
 */
- (void)AddAdressButtonClick{
    MyAddressVC *tempVC= [[MyAddressVC alloc] init];
    tempVC.type = 20;//在用户点击商城购买订单的时候 用户未添加地址  到该页面添加地址
    NSString *mobile = [self.addressArr lastObject];
    if (mobile.integerValue) {
        //有地址将地址传过去
        tempVC.userName = self.addressArr[1];
        tempVC.mobile = mobile;
        tempVC.address = self.addressArr[0];
        NSLog(@"%@    %@    %@", tempVC.userName, tempVC.mobile, tempVC.address);
    }else{
        tempVC.userName = @"";
        tempVC.mobile = @"";
        tempVC.address = @"";
    }
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *立即支付按钮
 */
- (void)PayButtonClick{
    //用户有地址
    if (self.addressArr.count) {
        //弹出交易密码输入视图
        self.rechargeView.hidden = NO;
        self.rechargeView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", _orderModel.orderAmount.floatValue];
        self.rechargeView.styleLabel.text = @"";
        [self.rechargeView.myTextFiled becomeFirstResponder];
        
        [self.view endEditing:YES];
    }else{
        [Factory alertMes:@"请完善您的收货地址"];
    }
}
/**
 *商品支付接口
 */
- (void)sxyRecharge:(NSNotification *)noti{
    //加密因子
    NSString *mcryptKey = noti.userInfo[@"mcryptKey"];
    //加密码
    NSString *passWord = noti.userInfo[@"passWord"];
    //订单支付
    [DownLoadData postOrderPay:^(id obj, NSError *error) {
        self.rechargeView.hidden = YES;
        self.rechargeView.myTextFiled.text = @"";
        [self.rechargeView.myTextFiled resignFirstResponder];
        if ([obj[@"result"] isEqualToString:@"fail"]) {
            //假如订单支付失败(防止弹屏和提示重叠)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                sleep(1);
                NSString *error = obj[@"messageText"];
                //用户交易密码输入错误
                if ([error containsString:@"密码错误"]) {
                    //用户交易密码输入错误
                    [self alterUserPswError];
                }else{
                    //
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                        sleep(1);
                        //回到主队列
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Factory alertMes:obj[@"messageText"]];
                        });
                    });
                }
            });
        }else{
            [Factory alertMes:@"订单支付成功"];
            //订单支付成功
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                sleep(1);
                //回到主队列
                dispatch_async(dispatch_get_main_queue(), ^{
                    FinishOrderDetailsVC *tempVC = [FinishOrderDetailsVC new];
                    tempVC.kindID = [NSString stringWithFormat:@"%@", self.kindID];//kindId
                    tempVC.number = [NSString stringWithFormat:@"%@", self.number];//商品数量
                    tempVC.type = 2;//订单确认页面的数据获取方式是顺值(从锁投有礼跳转)
                    tempVC.orderNo = [NSString stringWithFormat:@"%@", _orderModel.orderNo];//商品定单编号
                    [self.navigationController pushViewController:tempVC animated:YES];
                });
            });
        }
    } orderNo:[NSString stringWithFormat:@"%@", _orderModel.orderNo] address:[NSString stringWithFormat:@"%@", self.addressArr[0]] receiveName:[NSString stringWithFormat:@"%@", self.addressArr[1]] receiveMobile:[NSString stringWithFormat:@"%@", self.addressArr[2]] password:passWord salt:mcryptKey];
}
/**
 * 获取修改地址页面添加的地址信息
 */
- (void)refreshAddress:(NSNotification *)noti{
    [self.addressArr removeAllObjects];
    //@{@"mobile":mobile.text, @"address":address.text, @"name":name.text}];
    //联系地址
    [self.addressArr addObject:noti.userInfo[@"address"]];
    //联系人
    [self.addressArr addObject:noti.userInfo[@"name"]];
    //联系方式
    [self.addressArr addObject:noti.userInfo[@"mobile"]];
    
    NSLog(@"%@", self.addressArr);
    
    [self.tableView reloadData];
}
/**
 *提示用户交易密码输入错误
 */
- (void)alterUserPswError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您输入的交易密码错误" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        DealPswVC *tempVC = [DealPswVC new];
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.rechargeView.hidden = NO;
        [self.rechargeView.myTextFiled becomeFirstResponder];
        
        [self.view endEditing:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}


@end
