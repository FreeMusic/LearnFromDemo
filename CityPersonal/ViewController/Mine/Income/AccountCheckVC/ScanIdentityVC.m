//
//  ScanIdentityVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ScanIdentityVC.h"
#import "ScanIDCell.h"
#import "ScanUserIDCard.h"
#import "AccountCheckVC.h"
#import <ISOpenSDKFoundation/ISOpenSDKFoundation.h>
#import <ISIDReaderPreviewSDK/ISIDReaderPreviewSDK.h>
#import "ISLaunchAnimateViewController.h"

@interface ScanIdentityVC ()<UITableViewDelegate, UITableViewDataSource,ISOpenSDKCameraViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *finishBtn;//完成按钮
@property (nonatomic, strong) NSString *ocrName;//用于检验扫描到的身份证是正面还是反面
@property (nonatomic, assign) NSInteger scanIndex;//区别是扫描的正面还是反面 0是正面 1反面

@end

@implementation ScanIdentityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"扫描身份证"];
    //返回按钮
    UIButton *backBtn = [Factory addLeftbottonToVC:self];
    [backBtn addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    //接受扫描后的图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIdCardImg:) name:@"getIdCardImg" object:nil];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20*m6Scale, kScreenWidth, kScreenHeight-NavigationBarHeight-20*m6Scale) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
    }
    
    return _tableView;
}
/**
 *完成按钮的懒加载
 */
- (UIButton *)finishBtn{
    if(!_finishBtn){
        _finishBtn = [UIButton buttonWithType:0];
        [_finishBtn setTitle:@"完成" forState:0];
        _finishBtn.userInteractionEnabled = NO;
        _finishBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        _finishBtn.layer.cornerRadius = 6*m6Scale;
        [_finishBtn addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _finishBtn;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark - cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"ScanIDCell";
    ScanIDCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[ScanIDCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    NSArray *array = @[@"扫描本人身份证(正)", @"扫描本人身份证(反)"];
    cell.scanLabel.text = array[indexPath.row];
    if (indexPath.row == 0 && self.idCradImg != nil) {
        cell.idCardImg.image = self.idCradImg;
        cell.backView.hidden = YES;
        cell.idCardImg.hidden = NO;
    }else if (indexPath.row == 1 && self.reverseImg != nil){
        cell.idCardImg.image = self.reverseImg;
        cell.backView.hidden = YES;
        cell.idCardImg.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 588.0/708.0*438*m6Scale+20*m6Scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    UILabel *headerLabel = [Factory CreateLabelWithTextColor:0 andTextFont:28 andText:@"投资前需先实名认证，因涉及充值提现等重要交易，请务必扫描本人身份证信息" addSubView:headerView];
    headerLabel.textColor = UIColorFromRGB(0x6f6e6e);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.numberOfLines = 0;
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50*m6Scale);
        make.width.mas_equalTo(588*m6Scale);
        make.centerX.mas_equalTo(headerView.mas_centerX);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 155*m6Scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    //完成按钮
    [footerView addSubview:self.finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.right.mas_equalTo(-20*m6Scale);
        make.bottom.mas_equalTo(-142*m6Scale);
        make.height.mas_equalTo(90*m6Scale);
    }];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kScreenHeight-479*m6Scale-NavigationBarHeight-312*m6Scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    ScanUserIDCard *tempVC = [ScanUserIDCard new];
//    self.type = indexPath.row+1;
//    tempVC.backStyle = self.type;
//    tempVC.style = [NSString stringWithFormat:@"%ld", indexPath.row+1];
//    [self.navigationController pushViewController:tempVC animated:YES];
    _scanIndex = indexPath.row;
    NSString *appKey = ScanIdAPPKey;
    NSString *subAppkey = nil;//reserved for future use
    ISOpenSDKCameraViewController *cameraVC = [[ISIDCardReaderController sharedISOpenSDKController] cameraViewControllerWithAppkey:appKey subAppkey:subAppkey needCompleteness:YES];
    cameraVC.needShowBackButton = YES;
    cameraVC.view.backgroundColor = backGroundColor;
    cameraVC.customInfo = @"请将身份证放在框内识别";
    //cameraVC.shouldHightlightCorners = YES;
    cameraVC.delegate = self;
    
    [self setUpLaunchView];
    
    [self.navigationController pushViewController:cameraVC animated:YES];
}
- (void)setUpLaunchView
{
    // init launch view
    UIView *launchView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    launchView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:launchView.frame];
    imageView.image = [UIImage imageNamed:@"IS_OCR_Launch"];
    imageView.center = launchView.center;
    [launchView addSubview:imageView];
    
    ISLaunchAnimateViewController *launchCtrl = [[ISLaunchAnimateViewController alloc]initWithContentView:launchView animateType:ISLaunchAnimateTypePointZoomOut2 showSkipButton:YES];
    launchCtrl.view.backgroundColor = backGroundColor;
    [launchCtrl show];
}
- (void)onClickLeftItem{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 *完成按钮的点击事件
 */
- (void)finishButtonClick{
    NSLog(@"finishButtonClick");
    //首先判断用户是否为老用户
    if ([self.userName isEqualToString:@"<null>"] || [self.userName isEqualToString:@""] || self.userName == nil || [self.userName isEqual:[NSNull null]]) {
        //说明是新用户
        [self upLoadUserInformation];
    }else{
        //说明是老用户  校验
        [self judgeUserInformation];
    }
}
/**
 *上传身份证信息
 */
- (void)upLoadUserInformation{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"上传图片中...", @"HUD loading title");
    NSData *fileFg = UIImagePNGRepresentation(self.idCradImg);
    NSData *fileBg = UIImagePNGRepresentation(self.reverseImg);

    NSArray *array = @[fileFg, fileBg];
    AFAppDotNetAPIClient *manager = [Factory accessToken];
    manager.requestSerializer.timeoutInterval = 60;
    NSString *url = [NSString stringWithFormat:@"%@%@", Localhost,Fileupload];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.cardNum forKey:@"cardNo"];

    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < array.count; i++) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            if (i == 0) {
                [formData appendPartWithFileData:array[i] name:@"fileFg" fileName:fileName mimeType:@"image/png"];
            }else{
                [formData appendPartWithFileData:array[i] name:@"fileBg" fileName:fileName mimeType:@"image/png"];
            }
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //上传成功
        NSLog(@"123----上传成功%@",responseObject);
            [hud setHidden:YES];
            AccountCheckVC *tempVC = [AccountCheckVC new];
            tempVC.type = self.type;
            tempVC.userName = self.name;
            tempVC.identifyCard = self.cardNum;
            [self.navigationController pushViewController:tempVC animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setHidden:YES];
        [Factory alertMes:@"上传失败"];
    }];
}
/**
 *用户在上传身份证成功之后 判断用户是否是老用户 老用户的身份信息是否和扫描的身份信息是否匹配
 */
- (void)judgeUserInformation{
    //老用户验证身份证和姓名
    [DownLoadData postOldUserCheck:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            //上传图片
            [self upLoadUserInformation];
        }else{
            [Factory alertMes:obj[@"messageText"]];
        }
    } userId:[HCJFNSUser stringForKey:@"userId"] realname:self.name identifyCard:self.cardNum];
}
/**
 *扫描身份证成功之后 发送通知 让身份证照片刷新
 */
- (void)getIdCardImg:(NSNotification *)noti{
    NSLog(@"扫描身份证成功");
    if (noti.userInfo[@"cardImage"] != nil) {
        //身份证正面照
        self.idCradImg = noti.userInfo[@"cardImage"];
    }
    if (noti.userInfo[@"reverseImg"] != nil) {
        //身份证反面照
        self.reverseImg = noti.userInfo[@"reverseImg"];
    }
    //身份证号
    NSString *cardNum = noti.userInfo[@"kOpenSDKCardResultTypeCardItemInfo"][@"kCardItem0"];
    if (cardNum.integerValue) {
        self.cardNum = cardNum;
        //身份证正面照
        self.idCradImg = noti.userInfo[@"kOpenSDKCardResultTypeImage"];
    }else{
        //身份证反面照
        self.reverseImg = noti.userInfo[@"kOpenSDKCardResultTypeImage"];
    }
    //用户真实名字
    NSString *name = noti.userInfo[@"kOpenSDKCardResultTypeCardItemInfo"][@"kCardItem1"];
    if (name != nil) {
        self.name = name;
    }
    self.cardName = noti.userInfo[@"kOpenSDKCardResultTypeCardName"];
    
    NSLog(@"%@", self.numberImage);
    
    if (self.idCradImg != nil && [self.cardName isEqualToString:@"第二代身份证"] && _type == 1) {
        NSIndexPath *indexParh = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexParh] withRowAnimation:UITableViewRowAnimationNone];
    }else if (self.reverseImg != nil && _type == 2 && [self.cardName isEqualToString:@"第二代身份证背面"]){
        NSIndexPath *indexParh = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexParh] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        if (_type == 1) {
            [Factory alertMes:@"请扫描身份证正面"];
        }else{
            [Factory alertMes:@"请扫描身份证反面"];
        }
    }
    //监听用户是否已经采集完身份证正反两面信息
    [self makesureIdCard];
}
/**
 *监听用户是否已经采集完身份证正反两面信息
 */
- (void)makesureIdCard{
    if (self.idCradImg != nil && self.reverseImg != nil) {
        self.finishBtn.backgroundColor = ButtonColor;
        self.finishBtn.userInteractionEnabled = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [Factory navgation:self];
    [Factory hidentabar];
}

- (void)cameraViewController:(UIViewController *)viewController didFinishRecognizeCard:(NSDictionary *)resultInfo cardSDKType:(ISOpenPreviewSDKType)sdkType
{
    if (resultInfo != nil)
    {
        [viewController.navigationController popViewControllerAnimated:YES];
        
        self.ocrName = resultInfo[@"kOpenSDKCardResultTypeCardType"];
        
       self.cardName = resultInfo[@"kOpenSDKCardResultTypeCardName"];
        
        NSLog(@"%@", resultInfo);
        
        if (self.ocrName.integerValue == 2) {
            NSLog(@"身份证反面");
            if (_scanIndex == 1) {
                //身份证反面照
                self.reverseImg = resultInfo[@"kOpenSDKCardResultTypeImage"];
            }else{
                [Factory alertMes:@"请扫描身份证正面照"];
            }
        }else{
            NSLog(@"身份证正面");
            if (_scanIndex == 0) {
                //身份证正面照
                self.idCradImg = resultInfo[@"kOpenSDKCardResultTypeImage"];
                //身份证号
                self.cardNum = resultInfo[@"kOpenSDKCardResultTypeCardItemInfo"][@"kCardItem0"];
                //用户真实名字
                self.name = resultInfo[@"kOpenSDKCardResultTypeCardItemInfo"][@"kCardItem1"];
            }else{
                [Factory alertMes:@"请扫描身份证反面照"];
            }
        }
        
        if (self.idCradImg != nil && [self.cardName isEqualToString:@"第二代身份证"] && self.ocrName.integerValue == 0 && _scanIndex == 0) {
            NSIndexPath *indexParh = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexParh] withRowAnimation:UITableViewRowAnimationNone];
        }else if (self.reverseImg != nil && self.ocrName.integerValue == 2 && [self.cardName isEqualToString:@"第二代身份证背面"] && _scanIndex == 1){
            NSIndexPath *indexParh = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexParh] withRowAnimation:UITableViewRowAnimationNone];
        }
        //监听用户是否已经采集完身份证正反两面信息
        [self makesureIdCard];
    }
}

@end
