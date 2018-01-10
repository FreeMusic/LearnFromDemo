//
//  MyActivityViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 17/1/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyActivityViewController.h"
#import "UINavigationBar+Other.h"
#import "CreatView.h"
#import "ForgetPasswordView.h"
#import "ProtocolVC.h"

@interface MyActivityViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *activityScrollView;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, copy) NSArray *incomeArr; //收益
@property (nonatomic, copy) NSArray *amountArr; //额度
@property (nonatomic, strong) CreatView *creatView;//蒙版
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, copy) NSString *validPhoneExpiredTime;//时间戳
@property (nonatomic, strong) UITextField *textField;//文本框
@property (nonatomic, strong) ForgetPasswordView *passwordView;//验证码输入
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, copy) NSString *aountStr;//投资金额
@property (nonatomic, copy) NSString *timeStr;//时间

@end

@implementation MyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setColor:[UIColor colorWithRed:254.0 / 255.0 green:162.0 / 255.0 blue:39.0/255.0 alpha:1]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.incomeArr = @[@"¥ 17,600",@"¥ 8,800",@"¥ 4,400",@"¥ 2,200",@"¥ 880"];
    NSArray *accountArr = @[@[@"400000",@"400000",@"200000"],@[@"400000",@"400000",@"200000"],@[@"400000",@"200000",@"100000"],@[@"400000",@"200000",@"100000"],@[@"200000",@"100000",@"50000"],@[@"200000",@"100000",@"50000"],@[@"200000",@"100000",@"50000"],@[@"100000",@"50000",@"25000"],@[@"100000",@"50000",@"25000"],@[@"40000",@"20000",@"10000"]];
    self.amountArr = accountArr[self.row];
    self.month = 0;
    //标题
     [TitleLabelStyle addtitleViewToVC:self withTitle:@"锁投有礼"];
    
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self crateView];
    
    [self.view addSubview:self.textField];//短信输入框
    
    _creatView = [[CreatView alloc]initWithFrame:CGRectMake(0,kScreenHeight , kScreenWidth, kScreenHeight)];
    //取到delegate的window，将模版视图添加到window上，达到遮住导航栏的效果
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_creatView];
    [delegate.window bringSubviewToFront:_creatView];
    UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgister:)];//手势
    singleRecognizer.numberOfTapsRequired = 1;
    [self.creatView addGestureRecognizer:singleRecognizer];
}
/**
 *  验证码输入框
 */
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordView = [[ForgetPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 355 * m6Scale)];
        _textField.inputAccessoryView = _passwordView;
        _passwordView.backgroundColor = [UIColor whiteColor];
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgister:)];
        tap.numberOfTapsRequired = 1;
        [_passwordView.cancelImageView addGestureRecognizer:tap];
        _textField.hidden = YES;
        [_passwordView.reSendButton addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textField;
}



/**
 重新发送按钮
 */
- (void)sendCodeAction:(UIButton *)button {
    
    [self sendVaildPhoneCode];
    [TimeOut timeOut:button];//倒计时
}
//点击蒙版退出
- (void)resgister:(UITapGestureRecognizer *)sender{
    [self.textField resignFirstResponder];
    _creatView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    //添加动画效果
    CATransition *clip = [[CATransition alloc] init];
    clip.duration = 0.3;
    clip.type = @"fade";
    [_creatView.layer addAnimation:clip forKey:nil];
}

#pragma mark - lazyLoad
- (UIScrollView *)activityScrollView {
    
    if (!_activityScrollView) {
        
        _activityScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 100 * m6Scale)];
        _activityScrollView.delegate = self;
        _activityScrollView.showsVerticalScrollIndicator = NO;
        _activityScrollView.contentSize = CGSizeMake(0, 1950 * m6Scale);
    }
    
    return _activityScrollView;
}

#pragma mark - 视图创建
- (void)crateView {
    
    [self.view addSubview:self.activityScrollView];
    
    NSArray *imageArr = @[@"小米(MI)Air2",@"G20茶具2",@"小米净水器2",@"小米乳胶床垫2",@"小米乳胶枕2",@"小米电饭煲2",@"小天才手表2",@"小米拉杆箱2",@"帐篷2",@"小米移动电源2"];
    NSArray *titleArr = @[@"小米(MI)Air超薄笔记本电脑(12.5英寸)",@"G20杭州峰会西湖韵 西湖印象茶具组合",@"小米(MI)小米净水器(厨上式)",@"小米乳胶床垫(乐活版)",@"小米乳胶枕2只",@"小米电饭煲(3L)",@"小天才电话手表",@"小米行李箱(20寸)",@"探险者全自动户外帐篷",@"小米移动电源"];
    
    UIImageView *bannerView = [[UIImageView alloc] init];
    bannerView.image = [UIImage imageNamed:imageArr[self.row]];
    bannerView.frame = CGRectMake(0, 0, kScreenWidth, 490 * m6Scale);
    [self.activityScrollView addSubview:bannerView];
    
    UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 490 * m6Scale, kScreenWidth, 405 * m6Scale)];
    [self.activityScrollView addSubview:bodyView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleArr[self.row];
    titleLabel.font = [UIFont systemFontOfSize:32 * m6Scale];
    [bodyView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bodyView.mas_left).offset(36 * m6Scale);
        make.top.equalTo(bodyView.mas_top).offset(55 * m6Scale);
    }];
    
    CALayer *titleLayer = [CALayer layer];
    titleLayer.frame = CGRectMake(0, 138 * m6Scale, kScreenWidth, 1 * m6Scale);
    titleLayer.backgroundColor = [UIColor colorWithRed:227 / 255.0 green:226 / 255.0 blue:226 / 255.0 alpha:1] .CGColor;
    [bodyView.layer addSublayer:titleLayer];

    UILabel *limitLabel = [[UILabel alloc] init];
    limitLabel.text = @"期限";
    limitLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    [bodyView addSubview:limitLabel];
    
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bodyView.mas_left).offset(36 * m6Scale);
        make.top.equalTo(bodyView.mas_top).offset(182 * m6Scale);
    }];
    //协议选择按钮
    UIImageView *protoclImageView = [[UIImageView alloc] init];
    protoclImageView.image = [UIImage imageNamed:@"选中"];
    [bodyView addSubview:protoclImageView];
    
    [protoclImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(limitLabel.mas_centerX);
        make.top.equalTo(limitLabel.mas_bottom).offset(30 * m6Scale);
        make.size.mas_equalTo(CGSizeMake(30*m6Scale, 30*m6Scale));
    }];
    
    UILabel *protoclLabel = [[UILabel alloc] init];
    protoclLabel.text = @"《锁定自动投标授权书》";
    protoclLabel.font = [UIFont systemFontOfSize:28 * m6Scale];
    protoclLabel.userInteractionEnabled = YES;
    [bodyView addSubview:protoclLabel];
    
    [protoclLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(protoclImageView.mas_centerY);
        make.left.equalTo(protoclImageView.mas_right).offset(57 * m6Scale);
    }];
    //添加跳转页面手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolGestureAction:)];
    [protoclLabel addGestureRecognizer:tapGesture];
    
    CALayer *timeLayer = [CALayer layer];
    timeLayer.frame = CGRectMake(0, 307 * m6Scale, kScreenWidth, 1 * m6Scale);
    timeLayer.backgroundColor = [UIColor colorWithRed:227 / 255.0 green:226 / 255.0 blue:226 / 255.0 alpha:1].CGColor;
    [bodyView.layer addSublayer:timeLayer];
    
    for (NSInteger i = 0; i < 3; i ++) {
        
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        timeButton.tag = 100 + i;
        timeButton.layer.borderWidth = 1 * m6Scale;
        timeButton.layer.cornerRadius = 10 * m6Scale;
        timeButton.titleLabel.font = [UIFont systemFontOfSize:26 * m6Scale];
        [timeButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [timeButton setTitleColor:[UIColor colorWithRed:232 / 255.0 green:98 / 255.0 blue:26 / 255.0 alpha:0.5] forState:UIControlStateNormal];
        timeButton.layer.borderColor = [UIColor colorWithRed:232 / 255.0 green:98 / 255.0 blue:26 / 255.0 alpha:1].CGColor;
        switch (i) {
            case 0:{
                if (_row == 0 || _row == 1) {
                    [timeButton setTitleColor:backGroundColor forState:UIControlStateNormal];
                    [timeButton setTitle:@"3个月" forState:UIControlStateNormal];
                    timeButton.layer.borderWidth = 2 * m6Scale;
                    timeButton.layer.borderColor = backGroundColor.CGColor;
                    timeButton.userInteractionEnabled = NO;
                }else{
                    [timeButton setTitleColor:[UIColor colorWithRed:232 / 255.0 green:98 / 255.0 blue:26 / 255.0 alpha:1] forState:UIControlStateNormal];
                    [timeButton setTitle:@"3个月" forState:UIControlStateNormal];
                    timeButton.layer.borderWidth = 2 * m6Scale;
                }
               
            }
                break;
            case 1: {
                if (_row == 0 || _row == 1) {
                    [timeButton setTitleColor:[UIColor colorWithRed:232 / 255.0 green:98 / 255.0 blue:26 / 255.0 alpha:1] forState:UIControlStateNormal];
                    timeButton.layer.borderWidth = 2 * m6Scale;
                }
                [timeButton setTitle:@"6个月" forState:UIControlStateNormal];
            }
                break;
            case 2: {
                
                [timeButton setTitle:@"12个月" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }

        [bodyView addSubview:timeButton];
        
        [timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(140 * m6Scale, 44 * m6Scale));
            make.centerY.equalTo(limitLabel.mas_centerY);
            make.left.equalTo(limitLabel.mas_right).offset(57 * m6Scale + i * 190 * m6Scale);
            
        }];
    }
    
    NSArray *arr = @[@"投资金额",@"投资利率",@"预计收益"];
    
    for (NSInteger i = 0; i < 3; i ++) {
        
        UILabel *investLabel = [[UILabel alloc] init];
        investLabel.text = arr[i];
        investLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
        [bodyView addSubview:investLabel];
        
        UILabel *incomeLabel = [[UILabel alloc] init];
        incomeLabel.font = [UIFont systemFontOfSize:28 * m6Scale];
        incomeLabel.tag = 200 + i;
        incomeLabel.text = @"8.8%";
        if (i == 1) {
            
            incomeLabel.text = @"8.8%";
        }else if (i == 2) {
            if (_row == 0 || _row == 1) {
                incomeLabel.text = self.incomeArr[0];
            }else if (_row == 2 || _row == 3){
                incomeLabel.text = self.incomeArr[1];
            }else if (_row == 4 || _row == 5 || _row == 6){
                incomeLabel.text = self.incomeArr[2];
            }else if (_row == 7 || _row == 8){
                incomeLabel.text = self.incomeArr[3];
            }else{
                incomeLabel.text = self.incomeArr[4];
            }

        }else {
            if (_row == 0 || _row == 1) {

                incomeLabel.text = [Factory countNumAndChangeformat:[NSString stringWithFormat:@"%@",self.amountArr[1]]];
            }else{

                incomeLabel.text = [Factory countNumAndChangeformat:[NSString stringWithFormat:@"%@",self.amountArr[0]]];
            }
        }
        
        incomeLabel.textColor = [UIColor colorWithRed:232 / 255.0 green:98 / 255.0 blue:26 / 255.0 alpha:1];
        [bodyView addSubview:incomeLabel];
        [investLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(bodyView.mas_left).offset(36 * m6Scale + i * 245 * m6Scale);
            make.top.equalTo(bodyView.mas_top).offset(337 * m6Scale);
            
        }];
        
        [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(investLabel.mas_left);
            
            make.top.equalTo(investLabel.mas_bottom).offset(23 * m6Scale);
        }];
    }
    
    CALayer *investLayer = [CALayer layer];
    investLayer.frame = CGRectMake(0, 453 * m6Scale, kScreenWidth, 1 * m6Scale);
    investLayer.backgroundColor = [UIColor colorWithRed:227 / 255.0 green:226 / 255.0 blue:226 / 255.0 alpha:1].CGColor;
    [bodyView.layer addSublayer:investLayer];
    
    UIImageView *ruleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 944 * m6Scale, kScreenWidth, 880 * m6Scale)];
    ruleImageView.image = [UIImage imageNamed:@"investRule"];
    [self.activityScrollView addSubview:ruleImageView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 100 * m6Scale - 64, kScreenWidth, 100 * m6Scale)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UIButton *makeSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    makeSureButton.backgroundColor = [UIColor colorWithRed:254.0 / 255.0 green:162.0 / 255.0 blue:39.0/255.0 alpha:1];
    [makeSureButton setTitle:@"立即投资" forState:UIControlStateNormal];
    [makeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:makeSureButton];
    
    [makeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footView.mas_right);
        make.left.equalTo(footView.mas_left);
        make.top.equalTo(footView.mas_top);
        make.bottom.equalTo(footView.mas_bottom);
    }];
    
}

//跳转相关协议页面
- (void)protocolGestureAction:(UIGestureRecognizer *)ges {
    
    ProtocolVC *protocolVC = [[ProtocolVC alloc] init];
    protocolVC.strTag = @"2";
    [self presentViewController:protocolVC animated:YES completion:nil];
}

- (void)selectButtonAction:(UIButton *)button {
    
    self.month = button.tag - 100;
    
    //改变点击按钮状态
    for (NSInteger i = 100; i < 103; i ++) {
        
        UIButton *otherButton = [self.view viewWithTag:i];
        
        if (button.tag == i) {
            
            [otherButton setTitleColor:[UIColor colorWithRed:232 / 255.0 green:98 / 255.0 blue:26 / 255.0 alpha:1] forState:UIControlStateNormal];
            otherButton.layer.borderWidth = 2 * m6Scale;
            
        }else {
            if ((_row == 0 || _row == 1) && _month == 0) {
                otherButton.layer.borderWidth = 1 * m6Scale;
                [otherButton setTitleColor:backGroundColor forState:UIControlStateNormal];
            }else{
                otherButton.layer.borderWidth = 1 * m6Scale;
                [otherButton setTitleColor:[UIColor colorWithRed:232 / 255.0 green:98 / 255.0 blue:26 / 255.0 alpha:0.5] forState:UIControlStateNormal];
            }
        }
    }
    
    
    UILabel *label = [self.view viewWithTag:200];
//    label.text = self.amountArr[button.tag - 100];
    label.text = [Factory countNumAndChangeformat:[NSString stringWithFormat:@"%@",self.amountArr[button.tag - 100]]];
}

- (void)onClickLeftItem {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 立即投资
 */
- (void)submitButtonAction:(UIButton *)button {
    NSUserDefaults *user = HCJFNSUser;
    NSLog(@"88888----%ld",(long)(long)[self.amountArr[self.month] integerValue]);
    NSLog(@"%f",[[user objectForKey:@"cashAccount"] floatValue]);
    
    if ([self.amountArr[self.month] integerValue] <= [[user objectForKey:@"cashAccount"] floatValue]) {
        
        _aountStr = [NSString stringWithFormat:@"%ld",(long)[self.amountArr[self.month] integerValue]];
        [self successViewShowAction];//蒙版显示
        [self.textField becomeFirstResponder];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self sendVaildPhoneCode];//验证码
            [TimeOut timeOut:self.passwordView.reSendButton]; //倒计时
        });
    }else{
        [Factory alertMes:@"账户余额不足"];
    }
}
//验证码
- (void)sendVaildPhoneCode
{
    NSUserDefaults *user = HCJFNSUser;
    _timerRandom = [TimerRandom timerRandom];
    NSLog(@"_timerRandom = %@",_timerRandom);
    [DownLoadData postAutoSms:^(id obj, NSError *error) {
        
        NSLog(@"oooo----%@",obj);
        _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        
    } userId:[user objectForKey:@"userId"] andvaildPhoneCode:_timerRandom];
}
#pragma mark - textfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text;
    if ([string isEqualToString:@""] || [string integerValue] || [string isEqualToString:@"."] || [string isEqualToString:@"0"]) {
        
        if ([string isEqualToString:@""]) {
            //获取到上一次操作的字符串长度
            NSInteger clip = textField.text.length;
            //截取字符串 将最后一个字符删除
            text = [textField.text substringToIndex:clip - 1];
            
        }else {
            
            text = [textField.text stringByAppendingString:string];
        }
    }
    
    if (text.length == 6) {
        
        self.passwordView.passwordText = text;
        [DownLoadData postCheckOutGesture:^(id obj, NSError *error) {
            
            NSLog(@"%@",obj);
            
            if ([obj[@"result"] isEqualToString:@"success"]) {
                
                [self.textField resignFirstResponder];
                _creatView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
                //添加动画效果
                CATransition *clip = [[CATransition alloc] init];
                clip.duration = 0.3;
                clip.type = @"fade";
                [_creatView.layer addAnimation:clip forKey:nil];
                [self serverData];//服务器数据
                
            }else {
                self.textField.text = nil;
                self.passwordView.passwordText = nil;
                if (obj[@"messageText"]) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:obj[@"messageText"] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        } mobile:self.passwordView.phoneNum inputCode:text validTime:self.validPhoneExpiredTime jsCode:self.timerRandom];
        return YES;
        
    }else if (text.length >= 7) {
        
        return NO;
        
    }else {
        
        self.passwordView.passwordText = text;
        return YES;
    }
}
/**
 服务器数据
 */
- (void)serverData{
   
    NSUserDefaults *user = HCJFNSUser;
    NSArray *imageArr = @[@"小米笔记本电脑(12.5英寸)",@"G20茶具组合",@"小米净水器(厨上式)",@"小米乳胶床垫(乐活版)",@"小米乳胶枕2只",@"小米电饭煲(3L)",@"小天才电话手表",@"小米行李箱(20寸)",@"探险者全自动户外帐篷",@"小米移动电源"];
     NSLog(@"%@------%ld------%@",_aountStr,(long)self.month,imageArr[_row]);
    NSString *str = @"";
    if (self.month == 0) {
        if ([imageArr[_row] isEqualToString:@"小米笔记本电脑(12.5英寸)"] || [imageArr[_row] isEqualToString:@"G20茶具组合"]) {
            str = @"180";
        }else{
            str = @"90";
        }
    }else if (self.month == 1){
        str = @"180";
    }else if(self.month == 2){
        str = @"360";
    }
    [DownLoadData postAutoAdd:^(id obj, NSError *error) {
        
        NSLog(@"%@",obj);
        if ([obj[@"result"] isEqualToString:@"success"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [Factory alertMes:@"投资失败"];
        }
    } anduserId:[user objectForKey:@"userId"] anditemStatus:@"1" anditemAmountType:@"1" anditemAmount:_aountStr anditemRateMin:@"8.7" anditemRateMax:@"8.9" anditemRateStatus:@"1" anditemDayMin:@"29" anditemDayMax:@"31" anditemDayStatus:@"1" anditemLockStatus:@"1" anditemLockCycle:str anditemAddRate:@"8.8" andjsCode:_timerRandom andinputCode:_textField.text andvalidPhoneExpiredTime:_validPhoneExpiredTime andgoodsName:imageArr[_row] andautoId:NULL];
}

//蒙版的出现
- (void)successViewShowAction {
    
    _creatView.frame = CGRectMake(0, 0,kScreenWidth, kScreenHeight);
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

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
