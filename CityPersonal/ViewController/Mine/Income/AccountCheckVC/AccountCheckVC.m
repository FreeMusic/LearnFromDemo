//
//  AccountCheckVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/17.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AccountCheckVC.h"
#import "PassGuardCtrl.h"
#import "BidCardFirstVC.h"
#import "UITextField+SXYTextFiled.h"

@interface AccountCheckVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PassGuardTextField *mytextfield;
@property (nonatomic, strong) NSString *mcryptKey;//民泰键盘所需的随机因子

@end

@implementation AccountCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"开通民泰银行资金存管账户"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    //生成随机因子
    [self getSrandNum];
}
- (void)onClickLeftItem{
    
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
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
/**
 *生成随机因子
 */
- (void)getSrandNum{
    //生成随机因子
    [DownLoadData postGetSrandNum:^(id obj, NSError *error) {
        //随机因子
        self.mcryptKey = [NSString stringWithFormat:@"%@", obj[@"mcryptKey"]];
        //设置交易密码
        PassGuardTextField *setFiled = (PassGuardTextField *)[self.view viewWithTag:102];
        [setFiled setM_strInput1:self.mcryptKey];
        //确认交易密码
        PassGuardTextField *sureFiled = (PassGuardTextField *)[self.view viewWithTag:103];
        [sureFiled setM_strInput1:self.mcryptKey];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.selectionStyle = NO;
    NSArray *textArr = @[@"真实姓名", @"身份证号", @"设置交易密码", @"确认交易密码"];
    NSArray *placeArr = nil;
    NSLog(@"%@   %@", self.userName, self.identifyCard);
    if ([self.userName isEqualToString:@"(null)"] && [self.identifyCard isEqualToString:@"(null)"]) {
        placeArr = @[@"请输入您的名字", @"请输入您的证件号码", @"请设置6位数字交易密码", @"请确认6位数字交易密码"];
    }else{
        placeArr = @[self.userName, self.identifyCard, @"请设置6位数字交易密码", @"请确认6位数字交易密码"];
    }
    
    cell.textLabel.text = textArr[indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x434040);
    cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    if (indexPath.row > 1) {
        //密文显示
        _mytextfield = [[PassGuardTextField alloc] init];
        _mytextfield.placeholder = placeArr[indexPath.row];
        //延迟显示
        _mytextfield.m_isDotDelay = true;
        //licence
        [_mytextfield setM_license:KeyboardKey];
        //加密因子
        [_mytextfield setM_strInput1:self.mcryptKey];
        [_mytextfield setM_iMaxLen:6];
        _mytextfield.secureTextEntry = YES;
        _mytextfield.keyboardType = UIKeyboardTypeNumberPad;
        _mytextfield.textColor = UIColorFromRGB(0x363636);
        [_mytextfield setValue:UIColorFromRGB(0xB1B0B0) forKeyPath:@"_placeholderLabel.textColor"];
        _mytextfield.tag = 100+indexPath.row;
        _mytextfield.font = [UIFont systemFontOfSize:30*m6Scale];
        [cell addSubview:_mytextfield];
        [_mytextfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(220*m6Scale);
            make.right.equalTo(0);
            make.top.bottom.mas_equalTo(0);
        }];
    }else{
        UITextField *textFiled = [[UITextField alloc] init];
        [textFiled setValue:UIColorFromRGB(0xB1B0B0) forKeyPath:@"_placeholderLabel.textColor"];
        if ([self.userName isEqualToString:@"<null>"] && [self.identifyCard isEqualToString:@"<null>"]) {
            textFiled.placeholder = placeArr[indexPath.row];
        }else{
            textFiled.text = placeArr[indexPath.row];
        }
        textFiled.textColor = UIColorFromRGB(0x363636);
        textFiled.tag = 100+indexPath.row;
        if (indexPath.row) {
            textFiled.delegate = self;
        }
        textFiled.font = [UIFont systemFontOfSize:30*m6Scale];
        [cell addSubview:textFiled];
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(220*m6Scale);
            make.right.equalTo(0);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92*m6Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  kScreenHeight-(150*m6Scale+92*m6Scale*4+NavigationBarHeight+KSafeBarHeight);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150*m6Scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = backGroundColor;
    //下一部按钮
    UIButton *nextBtn = [UIButton buttonWithType:0];
    [nextBtn setTitle:@"下一步" forState:0];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    nextBtn.backgroundColor = UIColorFromRGB(0xffb514);
    [nextBtn addTarget:self action:@selector(nextStepButtonClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 6*m6Scale;
    nextBtn.layer.masksToBounds = YES;
    [footerView addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20*m6Scale);
        make.right.equalTo(-20*m6Scale);
        make.top.equalTo(58*m6Scale);
        make.height.equalTo(86*m6Scale);
    }];
    //下标题
    UILabel *bottomLabel = [Factory CreateLabelWithTextColor:1 andTextFont:24 andText:@"汇诚金服正式接入民泰银行资金存管系统，请您放心投资" addSubView:footerView];
    bottomLabel.textColor = UIColorFromRGB(0x949393);
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [bottomLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-48*m6Scale);
    }];
    //中间分线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [footerView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kScreenWidth/2);
        make.bottom.mas_equalTo(bottomLabel.mas_top).offset(-28*m6Scale);
        make.size.equalTo(CGSizeMake(1, 60*m6Scale));
    }];
    //左右两个图标
    NSArray *imgArr = @[@"汇诚1111", @"民泰"];
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgArr[i]]];
        [footerView addSubview:imgView];
        if (i) {
            [imgView makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(line.mas_right).offset(20*m6Scale);
                make.bottom.mas_equalTo(line.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(200*m6Scale, 60*m6Scale));
            }];
        }else{
            [imgView makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(line.mas_left).offset(-20*m6Scale);
                make.bottom.mas_equalTo(line.mas_bottom);
                make.size.equalTo(CGSizeMake(200*m6Scale, 60*m6Scale));
            }];
        }
    }
    
    return footerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = backGroundColor;
    //警告小图标
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示"]];
    [headerView addSubview:imgView];
    [imgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20*m6Scale);
        make.top.equalTo(20*m6Scale);
        make.size.equalTo(CGSizeMake(22*m6Scale, 22*m6Scale));
    }];
    //阐述标签
    UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:24 andText:@"根据国家监管要求，汇诚金服已接入民泰银行资金存管系统。用户实名认证，绑定银行卡，投资、充值、提现前需先开通银行存管账户。" addSubView:headerView];
    label.numberOfLines = 0;
    [self changeLineSpaceForLabel:label WithSpace:6];
    label.textColor = UIColorFromRGB(0x7a7a7a);
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(46*m6Scale);
        make.top.equalTo(18*m6Scale);
        make.width.equalTo(kScreenWidth-46*m6Scale);
    }];
    
    return headerView;
}
/**
 *限制身份证号长度输入
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location >= 18) {
        [Factory alertMes:@"身份证号码长度不能超过18位"];
        
        return NO;
    }else{
        return YES;
    }
}
/**
 *下一步按钮点击事件
 */
- (void)nextStepButtonClick{
    //姓名输入框
    UITextField *nameFiled = (UITextField *)[self.view viewWithTag:100];
    //身份证号输入框
    UITextField *idCardFiled = (UITextField *)[self.view viewWithTag:101];
    //设置交易密码
    PassGuardTextField *setFiled = (PassGuardTextField *)[self.view viewWithTag:102];
    //确认交易密码
    PassGuardTextField *sureFiled = (PassGuardTextField *)[self.view viewWithTag:103];
    NSLog(@"%@    %@", setFiled.text, sureFiled.text);
    //校验姓名不能为空
    if ([nameFiled.text isEqualToString:@""]) {
        //姓名为空
        [Factory alertMes:@"姓名不能为空"];
    }else{
    //用正则表达式校验身份证号(首先需要判断是否是老用户)
        if ([idCardFiled.text containsString:@"*"]) {
            //校验用户两次输入交易密码是否一致
            if ([setFiled.text isEqualToString:sureFiled.text]) {
                if (setFiled.text.length == 6) {
                    //调用实名认证接口
                    [self realName:nameFiled.text identifyCard:idCardFiled.text paymentPassword:setFiled.text];
                }else{
                    [Factory alertMes:@"请输入六位交易密码"];
                }
            }else{
                //交易密码不一致
                [Factory alertMes:@"两次输入的交易密码不一致"];
            }
        }else{
            //新用户
            if ([Factory CheckIsIdentityCard:idCardFiled.text]) {
                //校验用户两次输入交易密码是否一致
                if ([setFiled.text isEqualToString:sureFiled.text]) {
                    //调用实名认证接口
                    [self realName:nameFiled.text identifyCard:idCardFiled.text paymentPassword:setFiled.text];
                }else{
                    //交易密码不一致
                    [Factory alertMes:@"两次输入的交易密码不一致"];
                }
            }else{
                //校验身份证号失败
                [Factory alertMes:@"身份证格式不正确"];
            }
        }
    }
}
/**
 *实名认证
 */
- (void)realName:(NSString *)name identifyCard:(NSString *)identifyCard paymentPassword:(NSString *)paymentPassword{
    NSLog(@"paymentPassword = %@", paymentPassword);
    //设置交易密码
    PassGuardTextField *setFiled = (PassGuardTextField *)[self.view viewWithTag:102];
    //AES(加密方式)
    NSString *pass = [setFiled getOutput1];
    
    NSLog(@"%@    %@   %@   %@", pass, paymentPassword, _mytextfield.m_strInput1, _mytextfield.m_license);
    //实名认证
    [DownLoadData postMakeRealName:^(id obj, NSError *error) {
        NSLog(@"%@", obj[@"messageText"]);
        //当用户实名认证成功之后
        if ([obj[@"result"] isEqualToString:@"success"]) {
            //同时为了方便风险评估测试，（用户在实名成功之后，需要提示用户是否去风险评估测试）保存用户实名成功的状态
            UserDefaults(obj[@"result"], @"sxyRealName");
            //跳转到绑定银行卡界面
            BidCardFirstVC *tempVC = [BidCardFirstVC new];
            if (_type == 10) {
                tempVC.index = 10;
            }else if (_type == 20){
                tempVC.index = 20;
            }else{
                tempVC.index = 50;
            }
            tempVC.userName = name;
            [self.navigationController pushViewController:tempVC animated:YES];
        }else{
            [Factory alertMes:obj[@"messageText"]];
        }
    } userId:[HCJFNSUser stringForKey:@"userId"] realName:name identifyCard:identifyCard paymentPassword:pass mcryptKey:self.mcryptKey];
}
/**
 *改变行间距
 */
- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [Factory hidentabar];
}

@end
