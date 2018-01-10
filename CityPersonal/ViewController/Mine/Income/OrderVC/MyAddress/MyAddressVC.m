//
//  MyAddressVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/2.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyAddressVC.h"
#import "MyAddressView.h"
#import "MyAddressModel.h"
#import "MyAddrseeCell.h"
#import "BuyOrderVC.h"

@interface MyAddressVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(nonatomic,  strong) UIButton *headerBtn;//头像按钮
@property (nonatomic, strong) UILabel *nameLabel;//姓名标签
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyAddressModel *myAddressModel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) NSMutableArray *dataSource;//数据
@property (nonatomic, assign) NSInteger index;//创建一个标签（防止tableView中的textFiled多创建）
@property (nonatomic, strong) NSArray *placeArr;

@end

@implementation MyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"我的地址"];
    _placeArr = @[@"请输入姓名",@"请输入手机号码",@"请输入地址，以确保收货地址"];
    //左边按钮
    _leftBtn = [Factory addLeftbottonToVC:self];
    [_leftBtn addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //背景、tableView布局
    [self backViewLayout];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = backGroundColor;
    //接受通知 让控制器中的数据回到未输入状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshTableView) name:@"sxy_Refesh" object:nil];
    if (_type == 20) {
        [self.dataSource addObject:self.userName];
        [self.dataSource addObject:self.mobile];
        [self.dataSource addObject:self.address];
        
        [self.tableView reloadData];
    }else{
        //请求数据
        [self serviceData];
    }
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20*m6Scale, kScreenWidth, kScreenHeight)];
        //代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.backgroundColor = backGroundColor;
    }
    return _tableView;
}
/**
 *请求数据
 */
- (void)serviceData{
    //我的地址查询
    [DownLoadData postQueryAddressByUserId:^(id obj, NSError *error) {
        _myAddressModel = obj[@"model"];
        if (_myAddressModel) {
            _nameLabel.text = [NSString stringWithFormat:@"%@", _myAddressModel.userName];
            //用户名
            [self.dataSource addObject:[NSString stringWithFormat:@"%@", _myAddressModel.userName]];
            //联系方式
            [self.dataSource addObject:[NSString stringWithFormat:@"%@", _myAddressModel.mobile]];
            //收货地址
            [self.dataSource addObject:[NSString stringWithFormat:@"%@", _myAddressModel.address]];
            [_btn setTitle:@"修改" forState:0];
            _btn.tag = 500;
            [self.tableView reloadData];
        }else{
            [_btn setTitle:@"确认" forState:0];
        }
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *数据数组的懒加载
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/**
 *背景、tableView布局
 */
- (void)backViewLayout{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"cell";
    MyAddrseeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[MyAddrseeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.backgroundColor = [UIColor whiteColor];
    //数组
    NSArray *picArr = @[@"lianxiren",@"lianxifangshi",@"shouhuodizhi"];
    NSArray *textArr = @[@"联系人：",@"联系方式：",@"联系地址："];
    cell.imageView.image = [UIImage imageNamed:picArr[indexPath.row]];
    cell.textLabel.text = textArr[indexPath.row];
    if (indexPath.row == 1) {
        cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    }else if (indexPath.row == 0){
        cell.textFiled.delegate = self;
    }
    if ([cell.textFiled.text isEqualToString:@""]) {
        
    }else{
        
    }
    KeyBoard *key = [[KeyBoard alloc]init];
    UIView *clip = [key keyBoardview];
    [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.textFiled.inputAccessoryView = clip;
    cell.textFiled.tag = 200+indexPath.row;
    cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    
    if (_myAddressModel || self.dataSource.count) {
        [cell cellForAddress:self.dataSource[indexPath.row]];
    }else{
        cell.textFiled.placeholder = _placeArr[indexPath.row];
    }
    cell.selectionStyle = NO;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 308*m6Scale/3;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *backView = [[UIView alloc] init];
    
    _btn = [Factory addCenterButtonWithTitle:@"修改" andTitleColor:1 andButtonbackGroundColorRed:229 Green:91 Blue:56 andCornerRadius:6 addSubView:backView];
    _btn.backgroundColor = ButtonColor;
    [_btn addTarget:self action:@selector(makeSureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _btn.frame = CGRectMake(15*m6Scale, 40*m6Scale, kScreenWidth-30*m6Scale, 90*m6Scale);
    
    return backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90*m6Scale;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *头像按钮点击事件
 */
- (void)HeaderButtonClick{
    NSLog(@"头像");
}
- (void)RefreshTableView{
    _nameLabel.text = @"姓名未确认";
    [_headerBtn setImage:[UIImage imageNamed:@""] forState:0];
    //清空信息
    for (int i = 200; i < 204; i++) {
        UITextField *textFiled = (UITextField *)[self.view viewWithTag:i];
        textFiled.userInteractionEnabled = YES;
        textFiled.text = @"";
    }
}
/**
 *确认按钮点击事件
 */
- (void)makeSureButtonClick{
    UITextField *mobile = (UITextField *)[self.view viewWithTag:201];
    UITextField *address = (UITextField *)[self.view viewWithTag:202];
    UITextField *name = (UITextField *)[self.view viewWithTag:200];
    if ([mobile.text isEqualToString:@""] || [address.text isEqualToString:@""] || [name.text isEqualToString:@""]) {
        [Factory alertMes:@"您输入的地址信息不完善"];
    }else{
        if ([Factory valiMobile:mobile.text]) {
            if (_myAddressModel) {
                if (_type == 20) {
                    BuyOrderVC *tempVC = [BuyOrderVC new];
                    tempVC.result = @"200";
                    NSNotification *noti = [[NSNotification alloc] initWithName:@"refreshAddress" object:nil userInfo:@{@"mobile":mobile.text, @"address":address.text, @"name":name.text}];
                    [[NSNotificationCenter defaultCenter] postNotification:noti];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    //调用修改接口
                    [DownLoadData postModifyAddress:^(id obj, NSError *error) {
                        if ([obj[@"result"] isEqualToString:@"fail"]) {
                            [Factory alertMes:obj[@"respMsg"]];
                        }else{
                            [Factory alertMes:@"我的地址已经修改成功"];
                        }
                    } userId:[HCJFNSUser stringForKey:@"userId"] mobile:mobile.text address:address.text  userName:name.text type:1 addressId:[NSString stringWithFormat:@"%@", _myAddressModel.ID]];
                }
            }else{
                [DownLoadData postQueryAddressByUserId:^(id obj, NSError *error) {
                    MyAddressModel *model = obj[@"model"];
                    if (model) {
                        //调用修改接口
                        if (_type == 20) {
                            NSNotification *noti = [[NSNotification alloc] initWithName:@"refreshAddress" object:nil userInfo:@{@"mobile":mobile.text, @"address":address.text, @"name":name.text}];
                            [[NSNotificationCenter defaultCenter] postNotification:noti];
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [DownLoadData postModifyAddress:^(id obj, NSError *error) {
                                if ([obj[@"result"] isEqualToString:@"fail"]) {
                                    [Factory alertMes:obj[@"respMsg"]];
                                }else{
                                    [Factory alertMes:@"我的地址已经修改成功"];
                                }
                            } userId:[HCJFNSUser stringForKey:@"userId"] mobile:mobile.text address:address.text  userName:name.text type:1 addressId:[NSString stringWithFormat:@"%@", _myAddressModel.ID]];
                        }
                    }else{
                        if (_type == 20) {
                            NSNotification *noti = [[NSNotification alloc] initWithName:@"refreshAddress" object:nil userInfo:@{@"mobile":mobile.text, @"address":address.text, @"name":name.text}];
                            [[NSNotificationCenter defaultCenter] postNotification:noti];
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            //调用添加接口
                            [DownLoadData postModifyAddress:^(id obj, NSError *error) {
                                if ([obj[@"result"] isEqualToString:@"fail"]) {
                                    [Factory alertMes:obj[@"respMsg"]];
                                }else{
                                    [Factory alertMes:@"我的地址已经添加成功"];
                                    [_btn setTitle:@"修改" forState:0];
                                }
                            } userId:[HCJFNSUser stringForKey:@"userId"] mobile:mobile.text address:address.text  userName:name.text type:0 addressId:@""];
                        }
                    }
                } userId:[HCJFNSUser stringForKey:@"userId"]];
            }
        }else{
            [Factory alertMes:@"请输入正确的手机号"];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    _nameLabel.text = str;
    
    return YES;
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    [self.view endEditing:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

@end
