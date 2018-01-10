//
//  Factory.m
//  xiao2chedai
//
//  Created by mic on 16/4/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "Factory.h"
#import "sys/utsname.h"
#import "HelpTableViewController.h"

@interface Factory ()

@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation Factory

/**
 同一个label改变字体大小  和  颜色
 */
+ (void)ChangeSizeAndColor:(NSString *)str otherStr:(NSString *)otherStr andLabel:(UILabel *)label size:(CGFloat)size color:(UIColor *)color{
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size*m6Scale] range:[label.text rangeOfString:str]];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size*m6Scale] range:[label.text rangeOfString:otherStr]];
    [string addAttribute:NSForegroundColorAttributeName value:color range:[label.text rangeOfString:str]];
    
    [string addAttribute:NSForegroundColorAttributeName value:color range:[label.text rangeOfString:otherStr]];
    
    label.attributedText = string;
}
//左边的按钮
+ (UIButton *)addLeftbottonToVC:(UIViewController *)vc
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    //[button setImage:[UIImage imageNamed:@"Back-Arrow"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"fanghui"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.leftBarButtonItem = leftBarButton;
    return button;
}
//左边的按钮(灰色)
+ (UIButton *)addBlackLeftbottonToVC:(UIViewController *)vc
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setImage:[UIImage imageNamed:@"Back-Arrow"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.leftBarButtonItem = leftBarButton;
    return button;
}
//左边的按钮(灰色)
+ (UIButton *)addBlackLeftbottonToVC:(UIViewController *)vc WithImgName:(NSString *)name
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.leftBarButtonItem = leftBarButton;
    return button;
}
//左边的按钮(透明度)
+ (UIButton *)addLeftbottonToVC:(UIViewController *)vc andAlpha:(CGFloat)alpha{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Back-Arrow"]]];
    button.alpha = alpha;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.leftBarButtonItem = leftBarButton;
    return button;
}
//有边框的按钮
+ (UIButton *)addButtonWithTextColorRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue andTitle:(NSString *)title addSubView:(UIView *)subView{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setTitle:title forState:0];
    [btn setTitleColor:Colorful(red, green, blue) forState:0];
    btn.layer.borderColor = Colorful(red, green, blue).CGColor;
    btn.layer.cornerRadius = 25*m6Scale;
    btn.layer.borderWidth = 1;
    btn.titleLabel.font = [UIFont systemFontOfSize:24*m6Scale];
    [subView addSubview:btn];
    
    return btn;
}
//侧滑按钮
+ (UIButton *)addLeftbottonWithCeHuaToVC:(UIViewController *)vc andImageName:(NSString *)ImageName
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.leftBarButtonItem = leftBarButton;
    return button;
}
//右边的按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andrightStr:(NSString *)rightStr{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];

    [button setTitle:rightStr forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.rightBarButtonItem = rightBarButton;
    return button;
}
//右边的按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andrightStr:(NSString *)rightStr andTextColor:(UIColor *)color{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    [button setTitle:rightStr forState:UIControlStateNormal];
    [button setTitleColor:color forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.rightBarButtonItem = rightBarButton;
    return button;
}
//右边的按钮(靠右)
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andNextToRightStr:(NSString *)rightStr{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenWidth-100-70*m6Scale, 30, 40)];
    [button setTitle:rightStr forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:35*m6Scale];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.rightBarButtonItem = rightBarButton;
    return button;
}
//右边图片按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setImage:[UIImage imageNamed:@"组-8"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.rightBarButtonItem = rightBarButton;
    return button;
}
//右边图片按钮
+ (UIButton *)addRightbottonToVC:(UIViewController *)vc andImageName:(NSString *)ImageName
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setImage:[UIImage imageNamed:ImageName] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    vc.navigationItem.rightBarButtonItem = rightBarButton;
    return button;
}
//背景图片的封装
+ (UIImageView *)imageView:(NSString *)imageName;
{
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:imageName];//图片名字
    imageView.userInteractionEnabled = YES;//用户交互
    
    return imageView;
}
//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3456789][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//时间戳转换日期
+ (NSString *)translateDateWithStr:(NSString *)dateStr {
    
    NSTimeInterval inter = [dateStr doubleValue] / 1000.0;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:inter];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"MM-dd";
    //时间转换日期
    NSString *date = [formatter stringFromDate:newDate];
    
    return date;
}

//时间戳转换年月日
+ (NSString *)translateYearDateWithStr:(NSString *)dateStr {
    
    
    NSTimeInterval inter = [dateStr doubleValue] / 1000.0;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:inter];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yy/MM/dd";
    //时间转换日期
    NSString *date = [formatter stringFromDate:newDate];
    
    return date;
}
//时间戳转换年月日时分秒
+ (NSString *)transClipDateWithStr:(NSString *)dateStr {
    
    NSTimeInterval inter = [dateStr doubleValue] / 1000.0;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:inter];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //时间转换日期
    NSString *date = [formatter stringFromDate:newDate];
    
    return date;
    
}
//时间戳转换周
+ (NSString *)translateWeekDayWithStr:(NSString *)dateStr {
    
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSTimeInterval inter = [dateStr doubleValue] / 1000.0;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:inter];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    
    
    return weekStr;
}
//时间
+ (NSString *)stdTimeyyyyMMddFromNumer:(NSNumber *)num andtag:(NSInteger)tag
{
    if ([num isEqualToNumber:@0]|| num==nil || [num isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[num doubleValue]/1000];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (tag == 0) {
         formatter.dateFormat = @"yyyy.MM.dd";
    } else if (tag == 1) {
        formatter.dateFormat = @"MM-dd HH:mm";
    }
    else if (tag == 2) {
        formatter.dateFormat = @"yyyy-MM-dd\nHH:mm:ss";
    }else if (tag == 3){
         formatter.dateFormat = @"MM-dd HH:mm:ss";
    }else if (tag == 4) {
        
        formatter.dateFormat = @"HH:mm";
    }else if (tag == 5){
        formatter.dateFormat = @"MM-dd";
    }else if (tag == 53) {
        formatter.dateFormat = @"yyyy-MM-dd";
    }else if (tag == 66){
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }else if(tag == 77){
        formatter.dateFormat = @"yyyy年-MM月-dd日 HH:mm";
    }else if (tag == 88){
        formatter.dateFormat = @"yyyy.MM.dd HH:mm";
    }else if (tag == 99){
        formatter.dateFormat = @"yyyy.MM.dd";
    }
    else{
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }

    NSString *time = [formatter stringFromDate:date];
    
    return time;
    
}
/**
 *  转换格式
 */
+ (NSString *)exchangeStrWithNumber:(NSNumber *)number {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *str = [numberFormatter stringFromNumber:number];
    
    return str;
}
+(NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}
/**
 带小数的逗号分隔
 */
+ (NSString *)countNumAndChange:(NSString *)num{

    NSString *money = num;
    NSMutableString *tempStr = money.mutableCopy;
    NSRange range = [money rangeOfString:@"."];
    NSInteger index = 0;
    if (range.length > 0) {
        index = range.location;
    }else{
        index = money.length;
    }
    while ((index - 3) > 0) {
        index -= 3;
        [tempStr insertString:@"," atIndex:index];
    }
//    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"." withString:@","].mutableCopy;
    NSLog(@"%@",tempStr);
    return tempStr;

}
//百分号的处理
+ (NSMutableAttributedString *)attributedString:(NSString *)initWithString andRangL:(NSRange)range andlabel:(UILabel *)label andtag:(NSInteger)tag
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:initWithString attributes:nil];
    if (tag == 0) {
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50*m6Scale] range:range];
    }
    
    else if (tag == 10) {
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:70*m6Scale] range:range];

    }else if (tag == 29) {
        
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30 * m6Scale] range:range];
    }else if (tag == 20){
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:35*m6Scale] range:range];
    }
    else{
        [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25*m6Scale] range:range];
    }
    
    label.attributedText = att;
    return att;
}
//添加暂无数据图片
+ (void)addNoDataToView:(UIViewController*)View
{
    UIView *backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((View.view.frame.size.width -200)/2, (View.view.frame.size.height -200-110)/2, 200, 200)];
    [View.view addSubview:backgroundImage];
    backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
}
+ (void)showFasHud {
    [SVProgressHUD showInfoWithStatus:@"当前没有网络，请查看你的网络设置！" maskType:SVProgressHUDMaskTypeNone];
//    [SVProgressHUD showErrorWithStatus:@"当前没有网络，请查看你的网络设置！"];
};
+ (void)showNoDataHud {
    [SVProgressHUD showInfoWithStatus:@"数据请求失败" maskType:SVProgressHUDMaskTypeNone];
//    [SVProgressHUD showWithStatus:@"数据请求失败"];
};
//网络监测
+ (NSInteger)checkNetwork
{
    NSInteger state = 0;
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        state = 1;
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        state = 2;
    } else { // 没有网络
        NSLog(@"没有网络");
        state = 0;
    }
    return state;
}
// 触发时机，网络状态发生改变
- (void)netWorkStateChanged{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkStateChanged)]) {
        
        [self.delegate netWorkStateChanged];
    }
}
//简易alert
+ (void)addAlertToVC:(UIViewController *)vc withMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
//自定义alter
+ (void)addAlertToVC:(UIViewController *)vc withMessage:(NSString *)message title:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}
//隐藏tabar
+ (void)hidentabar{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.leveyTabBarController hidesTabBar:YES animated:YES];
    
}
//显示tabar
+ (void)showTabar{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.leveyTabBarController hidesTabBar:NO animated:YES];

}
//导航的处理
+ (void)navgation:(UIViewController *)viewController{
    if (iOS10) {
        NSArray *viewArr = viewController.navigationController.navigationBar.subviews;
//        NSLog(@"%@",viewArr);
        for (UIView *obj in viewArr) {
            NSString *class = NSStringFromClass([obj class]);
            
//            NSLog(@"class:%@",class);
            if ([class isEqualToString:@"UIView"]) {
                
                [obj removeFromSuperview];
            }
        }
    }
}
//登录token
+ (AFAppDotNetAPIClient *)userToken
{
    AFAppDotNetAPIClient *sharedClient = [AFAppDotNetAPIClient sharedClient];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"userToken"]];
    [sharedClient.requestSerializer setValue:str forHTTPHeaderField:@"x-user-token"];
    return sharedClient;

}
//普通token
+ (AFAppDotNetAPIClient *)accessToken
{
    AFAppDotNetAPIClient *sharedClient = [AFAppDotNetAPIClient sharedClient];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [NSString stringWithFormat:@"%@",[user objectForKey:@"token"]];
    [sharedClient.requestSerializer setValue:str forHTTPHeaderField:@"x-access-token"];

    return sharedClient;
}
/**
 *  网易七鱼
 */
+ (QYSessionViewController *)jumpToQY
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *realname = [user objectForKey:@"realname"];//姓名
    NSString *lastLoginTime = [user objectForKey:@"lastLoginTime"];//最近登录时间
    NSString *regesterTime = [user objectForKey:@"regesterTime"];//注册时间
    NSString *IdNumber = [user objectForKey:@"IdNumber"];//身份证号
    NSString *cardNo = [user objectForKey:@"cardNo"];//用户卡号

    NSLog(@"%@    %@    %@   %@    %@", realname, lastLoginTime,regesterTime,  IdNumber, cardNo);
    
    if ([realname isKindOfClass:[NSNull class]] || realname == nil) {
        realname = @"暂无数据";
    }
    if ([lastLoginTime isKindOfClass:[NSNull class]] || lastLoginTime == nil) {
        lastLoginTime = @"暂无数据";
    }
    if ([regesterTime isKindOfClass:[NSNull class]] || regesterTime == nil) {
        regesterTime = @"暂无数据";
    }
    if ([IdNumber isKindOfClass:[NSNull class]] || IdNumber == nil || IdNumber.integerValue == 1) {
        IdNumber = @"暂无数据";
    }if ([cardNo isKindOfClass:[NSNull class]] || cardNo == nil || cardNo.integerValue == 1) {
        cardNo = @"暂无数据";
    }
    QYSource *source = [[QYSource alloc]init];
    source.title = @"汇诚金服";
    source.urlString = @"";//来源url
    
    //        QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc]init];
    //        commodityInfo.title = @"";
    
    QYUserInfo *userInfo = [[QYUserInfo alloc]init];
    userInfo.userId = [HCJFNSUser stringForKey:@"userId"];//特定用户userId
    userInfo.data = [NSString stringWithFormat:@"[{\"key\":\"real_name\", \"value\":\"%@\"},"
                     "{\"key\":\"mobile_phone\", \"value\":\"%@\"},"
                     "{\"index\":5, \"key\":\"reg_date\", \"label\":\"注册日期\", \"value\":\"%@\"},"
                     "{\"index\":6, \"key\":\"last_login\", \"label\":\"上次登录时间\", \"value\":\"%@\"},"
                     "{\"index\":7, \"key\":\"IdNumber\", \"label\":\"身份证号\", \"value\":\"%@\"},"
                     "{\"index\":8, \"key\":\"bankcard\", \"label\":\"绑定银行卡\", \"value\":\"%@\"},"
                     "{\"index\":9, \"key\":\"totalAccount\", \"label\":\"总资产\", \"value\":\"%@\"},"
                     "{\"index\":10, \"key\":\"accountUsable\", \"label\":\"余额\", \"value\":\"%@\"},"
                     "{\"index\":11, \"key\":\"collectedIncome\", \"label\":\"待收金额\", \"value\":\"%@\"},"
                     "{\"index\":12, \"key\":\"red\", \"label\":\"红包\", \"value\":\"%d个\"},"
                     "{\"index\":13, \"key\":\"ticket\", \"label\":\"加息劵\", \"value\":\"%d张\"}]",realname,[user objectForKey:@"userMobile"],regesterTime,lastLoginTime,IdNumber,cardNo,[user objectForKey:@"totalAccount"],[user objectForKey:@"accountUsable"],[user objectForKey:@"collectedIncome"],[[user objectForKey:@"Red"] intValue],[[user objectForKey:@"Ticket"] intValue]];
    [[QYSDK sharedSDK] setUserInfo:userInfo];
    [[QYSDK sharedSDK] customUIConfig].customMessageTextColor = [UIColor blackColor];
    [[QYSDK sharedSDK] customUIConfig].serviceMessageTextColor = [UIColor blackColor];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"session_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    imageView.contentMode = UIViewContentModeScaleToFill;
    //        [[QYSDK sharedSDK] customUIConfig].sessionTipTextColor = [UIColor whiteColor];//当前客服不在线字体
    [[QYSDK sharedSDK] customUIConfig].sessionBackground = imageView;//背景图片（可换成汇成的）
    
    [[QYSDK sharedSDK] customUIConfig].customerHeadImage = [UIImage imageNamed:@"customer_head"];//用户头像
    [[QYSDK sharedSDK] customUIConfig].serviceHeadImage = [UIImage imageNamed:@"service_head"];
    
    [[QYSDK sharedSDK] customUIConfig].customerMessageBubbleNormalImage = [[UIImage imageNamed:@"icon_sender_node"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
                                                                                                                                   resizingMode:UIImageResizingModeStretch];//聊天气泡(客户端)
    [[QYSDK sharedSDK] customUIConfig].customerMessageBubblePressedImage = [[UIImage imageNamed:@"icon_sender_node"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,15,30,30)
                                                                                                                                    resizingMode:UIImageResizingModeStretch];//聊天气泡(客户端复制时图片)
    [[QYSDK sharedSDK] customUIConfig].serviceMessageBubbleNormalImage = [[UIImage imageNamed:@"icon_receiver_node"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
                                                                                                                                    resizingMode:UIImageResizingModeStretch];//聊天气泡(服务端)
    [[QYSDK sharedSDK] customUIConfig].serviceMessageBubblePressedImage = [[UIImage imageNamed:@"icon_receiver_node"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,30,30,15)
                                                                                                                                     resizingMode:UIImageResizingModeStretch];//聊天气泡(服务端复制时图片)
    [[QYSDK sharedSDK] customUIConfig].rightBarButtonItemColorBlackOrWhite = NO;//右上角按钮变成白色
    
    //        [[[QYSDK sharedSDK] customUIConfig] restoreToDefault];//返回到最初始状态
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    //        sessionViewController.sessionTitle = @"汇诚金服";
    sessionViewController.source = source;
    sessionViewController.hidesBottomBarWhenPushed = YES;
    
    return sessionViewController;
}
/**
 提示框
 */
+ (void)alertMes:(NSString *)mes{
    
    UIView *view;
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.contentColor = [UIColor grayColor];
    hud.label.text = mes;
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
    
}
/**
 app版本检测
 */
+ (void)updateApp:(UIViewController *)VC{
    //2先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    //3从网络获取appStore版本号
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",STOREAPPID]]] returningResponse:nil error:nil];
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        [Factory alertMes:@"您没有连接网络"];
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"hsUpdateAppError:%@",error);
        return;
    }
    //    NSLog(@"%@",appInfoDic);
    NSArray *array = appInfoDic[@"results"];
    if (array.count == 0 || array == nil) {
        NSLog(@"还没上线");
    }else{
        NSDictionary *dic = array[0];
        NSString *appStoreVersion = dic[@"version"];

    //打印版本号
    NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
    //设置版本号
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (currentVersion.length==2) {
        currentVersion  = [currentVersion stringByAppendingString:@"0"];
    }else if (currentVersion.length==1){
        currentVersion  = [currentVersion stringByAppendingString:@"00"];
    }
    appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (appStoreVersion.length==2) {
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
    }else if (appStoreVersion.length==1){
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
    }
    
    //4当前版本号小于商店版本号,就更新
    if([currentVersion floatValue] < [appStoreVersion floatValue])
    {
        //初始化AlertView
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新"
                                                        message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",dic[@"version"]]
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"更新",nil];
        [alert show];
//        UIAlertController *alercConteoller = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",dic[@"version"]] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //此处加入应用在app store的地址，方便用户去更新，一种实现方式如下
//            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", STOREAPPID]];
//            [[UIApplication sharedApplication] openURL:url];
//        }];
//        UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alercConteoller addAction:actionYes];
//        [alercConteoller addAction:actionNo];
//        [VC presentViewController:alercConteoller animated:YES completion:nil];
    }else{
        NSLog(@"版本号好像比商店大噢!检测到不需要更新");
    }
    }
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}
/**
 app版本显示
 */
+ (UILabel *)version:(NSString *)version{
    
    UILabel *versionLab = [[UILabel alloc] init];
    versionLab.font = [UIFont systemFontOfSize:35* m6Scale];
    versionLab.textColor = [UIColor lightGrayColor];
    versionLab.textAlignment = NSTextAlignmentCenter;
    versionLab.text = [@"© 汇诚金服  V " stringByAppendingString:version];
    return versionLab;
}
/**
 我的总资产、待收金额、累计收益
 */
+ (UILabel *)myTypeLab:(NSString *)text{
    UILabel *titleClipLabel = [[UILabel alloc] init];
    titleClipLabel.textAlignment = NSTextAlignmentCenter;
    titleClipLabel.text = text;
    titleClipLabel.textColor = TitleViewBackgroundColor;
    titleClipLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    return titleClipLabel;
}
/**
 生成Label，字体为灰色
 */
+ (UILabel *)CreateLabelWithTextColor:(CGFloat)color andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithWhite:color alpha:1.0];
    label.font = [UIFont systemFontOfSize:font*m6Scale];
    label.text = text;
    [view addSubview:label];
    
    return label;
}
/**
 生成Label，字体为彩色
 */
+ (UILabel *)CreateLabelWithTextRedColor:(CGFloat)red GreenColor:(CGFloat)green BlueColor:(CGFloat)blue andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:font*m6Scale];
    label.text = text;
    [view addSubview:label];
    
    return label;
}
//长条文字按钮
+ (UIButton *)addCenterButtonWithTitle:(NSString *)title andTitleColor:(CGFloat)textColor andButtonbackGroundColorRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue andCornerRadius:(CGFloat)radius addSubView:(UIView *)subView{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setTitle:title forState:0];
    [btn setTitleColor:[UIColor colorWithWhite:textColor alpha:1] forState:0];
    btn.backgroundColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue/255.0 alpha:1.0];
    btn.layer.cornerRadius = radius*m6Scale;
    [subView addSubview:btn];
    
    
    return btn;
}
//长条文字按钮
+ (UIButton *)addCenterButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)textColor andButtonBackGroundColor:(UIColor *)buttonBackGroundColor andCornerRadius:(CGFloat)radius addSubView:(UIView *)subView{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setTitle:title forState:0];
    [btn setTitleColor:textColor forState:0];
    btn.backgroundColor = buttonBackGroundColor;
    btn.layer.cornerRadius = radius*m6Scale;
    [subView addSubview:btn];
    
    
    return btn;
}
/**
 中间字体颜色的改变(万全)
 */
+ (void)NSMutableAttributedStringWithString:(NSString *)string andChangeColorString:(NSString *)str andLabel:(UILabel *)label{
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:string attributes:nil];
    [str1 addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x434343) range:[string rangeOfString:str]];
    label.attributedText = str1;
}
/**
 中间字体颜色的改变
 */
+ (void)ChangeColorString:(NSString *)str andLabel:(UILabel *)label andColor:(UIColor *)color{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
    [string addAttribute:NSForegroundColorAttributeName value:color range:[label.text rangeOfString:str]];
    label.attributedText = string;
}
/**
 中间字体颜色的改变(因为有可能会有一个lable中改变多处字体大小)
 */
+ (void) ChangeColorStringArray:(NSArray *)array andLabel:(UILabel *)label andColor:(UIColor *)color{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
    for (int i = 0; i < array.count; i++) {
        [string addAttribute:NSForegroundColorAttributeName value:color range:[label.text rangeOfString:array[i]]];
    }
    label.attributedText = string;
}
/**
 同一个label改变字体大小
 */
+ (void)ChangeSize:(NSString *)str andLabel:(UILabel *)label size:(CGFloat)size{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:label.text];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size*m6Scale] range:[label.text rangeOfString:str]];
    label.attributedText = string;
}
/**
 同一个label改变字体大小(可自定义改变字体大小)
 */
+ (NSMutableAttributedString *)MutableString:(NSString *)string andLeftRange:(NSRange)leftrange leftFont:(CGFloat)leftFont{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    //设置某个范围内的字体大小
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:leftFont*m6Scale] range:leftrange];
    
    return str;
}
/**
 获取某年某个月 该月有多少天
 */
+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}
/**
 获得时间期限单位
 */
+ (NSString *)dataUnitByItemCycleUnit:(NSNumber *)cycleunit{
    NSString *dataUnit = nil;
    switch (cycleunit.integerValue) {
        case 1:
            dataUnit = @"天";
            break;
        case 2:
            dataUnit = @"月";
            break;
        case 3:
            dataUnit = @"季";
            break;
        case 4:
            dataUnit = @"年";
            break;
            
        default:
            break;
    }
    
    return dataUnit;
}
/**
 客户电话
 */
+ (void)resgisterInViewController:(UIViewController *)vc{
    //呼叫客服
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"客服时间:9:00-17:30\n400-0571-909" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *str = @"tel://400-0571-909";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }]];
    
    [vc presentViewController:alert animated:YES completion:nil];
}
/**
 *取消html中的标签
 */
+(NSString *)flattenHTML:(NSString *)html{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html=[html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    return html;
}
/**
 *获取未登录时候个人中心页面的头部背景图
 */
+(UIImageView *)getPersonHeaderView{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400*m6Scale+64)];
    imageview.image = [UIImage imageNamed:@"我的头部背景"];

//     UIButton *messBtn = [UIButton buttonWithType:0];
//    [messBtn setImage:[UIImage imageNamed:@"消息"] forState:0];
//    [messBtn setImage:[UIImage imageNamed:@"youxiaoxi"] forState:UIControlStateSelected];
//    messBtn.frame = CGRectMake(30*m6Scale, 50*m6Scale, 70*m6Scale, 70*m6Scale);
//    [imageview addSubview:messBtn];
//    
//    UIButton *right = [UIButton buttonWithType:0];
//    right.frame = CGRectMake(kScreenWidth-100*m6Scale, 50*m6Scale, 70*m6Scale, 70*m6Scale);
//    [right setImage:[UIImage imageNamed:@"设置"] forState:0];
//    [imageview addSubview:right];
    
    UILabel *logLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"正在数钱中" addSubView:imageview];
    logLabel.textAlignment = NSTextAlignmentCenter;
    logLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    logLabel.layer.borderWidth = 1;
    [logLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(243*m6Scale, 70*m6Scale));
        make.centerX.mas_equalTo(imageview.mas_centerX);
        make.centerY.mas_equalTo(imageview.mas_centerY);
    }];
    
    NSArray *topArr = @[@"待收金额 ", @"累计收益"];
    for (int i = 0; i < topArr.count; i++) {
        UILabel *bottomLabel = [Factory CreateLabelWithTextColor:1 andTextFont:24 andText:topArr[i] addSubView:imageview];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kScreenWidth/2*i);
            make.width.mas_equalTo(kScreenWidth/2);
            make.bottom.mas_equalTo(-20*m6Scale);
        }];
        UILabel *topLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"正在数钱中" addSubView:imageview];
        topLabel.textAlignment = NSTextAlignmentCenter;
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bottomLabel.mas_top).offset(-10*m6Scale);
            make.left.mas_equalTo(kScreenWidth/2*i);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
    }
    
    return imageview;
    
}
//校验身份证号
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard
{
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}
/**
 *银行卡正则校验
 */
+ (BOOL) IsBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <=0 || size.height <=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//删掉字符串最后一个字符
+(NSString*) removeLastOneChar:(NSString*)origin{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}
//输入交易金额 带小数点数字处理
+ (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *resultStr;
//    if ([string isEqualToString:@""]) {
//        //获取到上一次操作的字符串长度
//        NSInteger clip = textField.text.length;
//        //截取字符串 将最后一个字符删除
//        resultStr = [textField.text substringToIndex:clip - 1];
//        
//    }else if ([string hasPrefix:@"."]){
//        resultStr = [textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
//    }else {
//        resultStr = [textField.text stringByAppendingString:string];
//    }
    if (range.location>7) {
        return NO;
    }
    //如果输入的是“.”  判断之前已经有"."或者字符串为空
    if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])) {
        return NO;
    }
    //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
    NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
    [str insertString:string atIndex:range.location];
    if (str.length >= [str rangeOfString:@"."].location+4){
        return NO;
    }
    return YES;
}
//将小数点后的最后一位小数舍掉的方法
+ (NSString *)stringByNotRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
/**
 *  6.判断一个月有多少天
 *
 *  @param date 日期
 *
 *  @return
 */
+(NSInteger)NSStringIntTeger:(NSInteger)teger andYear:(NSInteger)year
{
    NSInteger dayCount;
    switch (teger) {
        case 1:
            dayCount = 31;
            break;
        case 2:
            if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
                dayCount = 29;
            }else{
                dayCount = 28;
            }
            break;
        case 3:
            dayCount = 31;
            break;
        case 4:
            dayCount = 30;
            break;
        case 5:
            dayCount = 31;
            break;
        case 6:
            dayCount = 30;
            break;
        case 7:
            dayCount = 31;
            break;
        case 8:
            dayCount = 31;
            break;
        case 9:
            dayCount = 30;
            break;
        case 10:
            dayCount = 31;
            break;
        case 11:
            dayCount = 30;
            break;
        default:
            dayCount = 31;
            break;
    }
    return dayCount;
    
}
/**
 生成Label，颜色自定义
 */
+ (UILabel *)CreateLabelWithColor:(UIColor *)color andTextFont:(CGFloat)font andText:(NSString *)text addSubView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font*m6Scale];
    label.text = text;
    [view addSubview:label];
    
    return label;
}
/**
 * 因为在项目中要遇到一些后台返回的字符串或者其他空值 要做特殊处理 校验这个值是否为空
 */
+ (BOOL)theidTypeIsNull:(id)type{
    NSString *string = [NSString stringWithFormat:@"%@", type];
    
    if (![string isEqual:[NSNull null]] && ![string isEqual:@""] && string != nil && ![string isEqualToString:@"<null>"] && ![string isEqualToString:@"(null)"]) {
        return NO;
    }else{
        return YES;
    }
}
/**
 *改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space{
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}
/**
 *创建Button  带有点击事件
 */
+ (UIButton *)ButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)textColor andButtonbackGroundColor:(UIColor *)buttonBackGroundColor andCornerRadius:(CGFloat)radius addTarget:(UIViewController *)viewController action:(NSString *)action{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setTitle:title forState:0];
    [btn setTitleColor:textColor forState:0];
    btn.backgroundColor = buttonBackGroundColor;
    btn.layer.cornerRadius = radius*m6Scale;
    SEL selector = NSSelectorFromString(action);
    [btn addTarget:viewController action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
/**
 *创建Button  带有点击事件 带subView
 */
+ (UIButton *)ButtonWithTitle:(NSString *)title andTitleColor:(UIColor *)textColor andButtonbackGroundColor:(UIColor *)buttonBackGroundColor andCornerRadius:(CGFloat)radius addTarget:(UIViewController *)viewController action:(NSString *)action addSubView:(UIView *)subView{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setTitle:title forState:0];
    [btn setTitleColor:textColor forState:0];
    btn.backgroundColor = buttonBackGroundColor;
    btn.layer.cornerRadius = radius*m6Scale;
    SEL selector = NSSelectorFromString(action);
    [btn addTarget:viewController action:selector forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:btn];
    
    return btn;
}
//给view加渐变色
+ (void)colorLayer :(UIView *)view {
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [gradientLayer setColors:@[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor blueColor].CGColor]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [view.layer addSublayer:gradientLayer];
}
//view转化为图片
+(UIImage *)convertViewToImage:(UIView*)view{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//画一个渐变色的图片
+(UIImage *)navgationImage{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)];
    [self colorLayer :view];
    UIImage *image = [self convertViewToImage:view];
    return image;
}
@end
