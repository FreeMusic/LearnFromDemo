//
//  BidCardFirstVC.m
//  CityJinFu
//
//  Created by mic on 2017/8/1.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "BidCardFirstVC.h"
#import "BidCardVC.h"
#import "ActivityCenterVC.h"

@interface BidCardFirstVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *nameLabel;//姓名标签
@property (nonatomic, strong) UITextField *textFiled;//银行卡号输入框
@property (nonatomic, strong) UIButton *nextBtn;//绑定银行卡下一步按钮

@end

@implementation BidCardFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"绑定银行卡"];
    //返回按钮
    UIButton *backBtn = [Factory addLeftbottonToVC:self];
    [backBtn addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //支持银行
    UIButton *rightBtn = [Factory addRightbottonToVC:self andrightStr:@"支持银行"];
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 20*m6Scale;
        _tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
        //银行卡标志
        [self bankPicture];
    }
    return _tableView;
}
/**
 *  银行卡标志
 */
- (void)bankPicture{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BidBank_cunguan"]];
    [self.tableView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(598*m6Scale, 106*m6Scale));
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.top.mas_equalTo(kScreenHeight-NavigationBarHeight-50*m6Scale-25);
    }];
}
/**
 *姓名标签
 */
- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [Factory CreateLabelWithTextColor:0.2 andTextFont:30 andText:self.userName addSubView:nil];
        //_nameLabel.textColor = UIColorFromRGB(0x4a4a4a);
    }
    return _nameLabel;
}
/**
 *银行卡号输入框
 */
- (UITextField *)textFiled{
    if(!_textFiled){
        _textFiled = [[UITextField alloc] init];
        _textFiled.placeholder = @"请输入16-19位银行卡号";
        _textFiled.font = [UIFont systemFontOfSize:30*m6Scale];
        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
        KeyBoard *key = [[KeyBoard alloc] init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        _textFiled.delegate = self;
        _textFiled.inputAccessoryView = clip;
    }
    return _textFiled;
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self.view endEditing:YES];
    
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定要放弃绑卡操作？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_index == 100 || _index == 5) {
            //从投资页面跳转
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/*
 *2 *支持银行
 */
- (void)rightBtn{
    ActivityCenterVC *tempVC = [ActivityCenterVC new];
    tempVC.tag = 10;
    tempVC.strUrl = @"/html/banks.html";
    tempVC.urlName = @"支持银行";
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *限制银行卡位数
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    self.nextBtn.userInteractionEnabled = YES;
    self.nextBtn.backgroundColor = ButtonColor;
    //检测是否为纯数字
    //添加空格，每4位之后，4组之后不加空格，格式为xxxx xxxx xxxx xxxx xxxxxxxxxxxxxx
    if (toBeString.length > textField.text.length) {
        if (textField.text.length % 5 == 4) {
            textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            NSLog(@"添加空格  %@", textField.text);
        }
    }
    //只要30位数字
    if ([toBeString length] >= 19+4)
    {
        toBeString = [toBeString substringToIndex:19+4];
        textField.text = toBeString;
        [textField resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    NSArray *array = @[@"姓名", @"卡号"];
    cell.textLabel.text = array[indexPath.section];
    cell.selectionStyle = NO;
    cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    if (indexPath.section == 0) {
        //姓名
        [cell addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(130*m6Scale);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }else{
        //银行卡号输入框
        [cell addSubview:self.textFiled];
        [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(130*m6Scale);
            make.width.mas_equalTo(kScreenWidth-130*m6Scale);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }
    //详细介绍小图标按钮
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setImage:[UIImage imageNamed:@"i"] forState:0];
    btn.tag = 1000+indexPath.section;
    [btn addTarget:self action:@selector(contentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30*m6Scale);
        make.centerY.mas_equalTo(cell.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(36*m6Scale, 36*m6Scale));
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footerView = [UIView new];
        //下一步按钮
        _nextBtn = [UIButton buttonWithType:0];
        [_nextBtn setTitle:@"下一步" forState:0];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.backgroundColor = ButtonColor;
        _nextBtn.layer.cornerRadius = 6*m6Scale;
        [footerView addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-40*m6Scale, 90*m6Scale));
            make.top.mas_equalTo(80*m6Scale);
        }];
        
        return footerView;
    }else{
        return nil;
    }
}
/**
 *下一步按钮的点击事件
 */
- (void)nextBtnClick{
    NSLog(@"下一步按钮的点击事件");
    //不带空格的银行卡号
    NSArray *array = [self.textFiled.text componentsSeparatedByString:@" "];
    NSMutableString *str = [[NSMutableString alloc] initWithCapacity:1];
    for (int i = 0; i < array.count; i++) {
        NSLog(@"%@", array[i]);
        [str appendFormat:@"%@", array[i]];
        NSLog(@"%@", str);
    }
    //银行卡正则校验
    if ([Factory IsBankCard:self.textFiled.text]) {
        //通过银行卡正则校验 然后调用后台接口 判断是否支持该银行
        //根据卡号查询归属地和联行号(绑卡用)
        [DownLoadData postQueryBankLocation:^(id obj, NSError *error) {
            if ([obj[@"result"] isEqualToString:@"fail"]) {
                self.nextBtn.backgroundColor = backGroundColor;
                self.nextBtn.userInteractionEnabled = NO;
                [Factory addAlertToVC:self withMessage:obj[@"messageText"]];
            }else{
                BidCardVC *tempVC = [BidCardVC new];
                tempVC.index = _index;
                NSLog(@"%ld", _index);
                tempVC.bankNum = self.textFiled.text;//银行卡号
                tempVC.cardNum = str;//银行卡号 不带空格
                tempVC.bankName = [NSString stringWithFormat:@"%@", obj[@"bankName"]];
                tempVC.bankCode = [NSString stringWithFormat:@"%@", obj[@"bankCode"]];
                tempVC.subBankCode = [NSString stringWithFormat:@"%@", obj[@"prcptcd"]];
                [self.navigationController pushViewController:tempVC animated:NO];
            }
        } cardNo:str];
    }else{
        [Factory alertMes:@"请输入正确的银行卡号"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 300*m6Scale;
    }else{
        return 0;
    }
}
/**
 *小图标点击事件
 */
- (void)contentButtonClick:(UIButton *)sender{
    NSString *message = @"";
    if (sender.tag == 1000) {
        //姓名简介
        message = @"确认填写真实的身份信息，以便享受安全保护服务.";
    }else{
        //卡号简介
        message = @"为保证账户资金安全，请绑定本人的银行卡.";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [Factory navgation:self];
    [Factory hidentabar];
}

@end
