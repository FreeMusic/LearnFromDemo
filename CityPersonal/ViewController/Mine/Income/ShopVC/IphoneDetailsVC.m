//
//  IphoneDetailsVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/1.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "IphoneDetailsVC.h"
#import "IphoneDetailsView.h"
#import "GoodsVC.h"
#import "ActivityRuleVC.h"
#import "AlterVC.h"
#import "DCNavTabBarController.h"
#import "OrderVC.h"
#import "IphoneDetailsModel.h"
#import "GoodsKindsModel.h"
#import "ScanIdentityVC.h"
#import "BidCardFirstVC.h"
#import "OpenAlertView.h"
#import "NewSignVC.h"
#import "MywelfareVC.h"

@interface IphoneDetailsVC ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) IphoneDetailsView *iphoneView;
@property (nonatomic,strong) UIButton *btn;//商品详情
@property (nonatomic,strong) UILabel *accountLabel;//计算金额标签
@property (nonatomic,strong) UILabel *numLabel;//计算数量的标签
@property (nonatomic,strong) IphoneDetailsModel *model;
@property (nonatomic,strong) NSMutableArray *dataArr;//期限数组
@property (nonatomic,strong) NSString *kindID;//期限种类id
@property (nonatomic,strong) NSString *result;//库存及限购校验成功的结果
@property (nonatomic,strong) NSString *goodsCount;//用户点击增加商品的件数
@property (nonatomic, strong) UIView *backView;//立即锁投页面背景图
@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, assign) float price;//商品价格
@property (nonatomic, strong) NSString *userName;//用户姓名
@property (nonatomic, strong) UIImageView *ruleImageView;//图片
@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic, strong) NSMutableArray *heighArr;
@property (nonatomic, assign) CGFloat heigh;//网络图片的高
@property (nonatomic, weak) UIView *navLine;
@property (nonatomic, strong) OpenAlertView * openAlert;

@end

@implementation IphoneDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [TitleLabelStyle addtitleViewToVC:self withTitle:@"锁投有礼" andTextColor:0];
    self.view.backgroundColor = [UIColor whiteColor];
    //左边按钮
    UIButton *leftButton = [Factory addBlackLeftbottonToVC:self WithImgName:@"Back-Arrow@2x(1)"];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //客服按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self andImageName:@"kefu@2x(1)"];
    [rightBtn addTarget:self action:@selector(serviceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight-86*m6Scale-KSafeBarHeight));
    }];
    //自定义View
    _iphoneView = [[IphoneDetailsView alloc] init];
    [self.scrollView addSubview:_iphoneView];
    [_iphoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(-64);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.mas_equalTo(_iphoneView.line.mas_bottom);
    }];
    //礼券购买view布局
    [self GiftBuy];
    //创建商品详情和活动规则
    [self createView];
    //请求数据
    [self serviceData];
    //点击期限按钮 商品数量产生变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeGoodsNum:) name:@"ChangeGoodsNum" object:nil];
    //当投资金额的数据有了之后，进行价格计算
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoodsPrice:) name:@"GoodsPrice" object:nil];
    //请求商品详情图片
    [self getGoodsDetailsPic];
}
/**
 *请求商品详情图片
 */
- (void)getGoodsDetailsPic{
    UIButton *shangpinBtn = [self.view viewWithTag:300];
    [DownLoadData postGetGoodsDescription:^(id obj, NSError *error) {
        NSArray *imgArr = [obj[@"imageId"] componentsSeparatedByString:@","];
        self.dataArr = [[NSMutableArray alloc] initWithArray:imgArr];
        [self.dataArr removeLastObject];
        __block CGFloat height = 0;
        for (int i = 0; i < self.dataArr.count; i++) {
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.tag = 2000+i;
            [self.view addSubview:imgView];
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.equalTo(shangpinBtn.mas_bottom).offset(height);
                    make.height.mas_equalTo(image.size.height*kScreenWidth/750.0);
                }];
                height = height + image.size.height*kScreenWidth/750.0;
                
                self.scrollView.contentSize = CGSizeMake(kScreenWidth, height+1230*m6Scale+86*m6Scale-180-110+128*m6Scale+12);
                _heigh = height;
            }];
        }
        [self.view bringSubviewToFront:_backView];
    } goodsId:self.goodsID];
}
- (NSMutableArray *)heighArr{
    if(!_heighArr){
        _heighArr = [NSMutableArray array];
    }
    return _heighArr;
}
/**
 *客服按钮点击事件
 */
- (void)serviceButtonClick{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"连接中...", @"HUD loading title");
    //用户个人信息
    [DownLoadData postUserInformation:^(id obj, NSError *error) {
        
        NSLog(@"%@-------",obj);
        
        if (obj[@"usableCouponCount"]) {
            
            [HCJFNSUser setValue:obj[@"usableCouponCount"] forKey:@"Red"];
        }
        if (obj[@"usableTicketCount"]) {
            [HCJFNSUser setValue:obj[@"usableTicketCount"] forKey:@"Ticket"];
            
        }
        if ([obj[@"identifyCard"] isKindOfClass:[NSNull class]] || obj[@"identifyCard"] == nil) {
            [HCJFNSUser setValue:@"1" forKey:@"IdNumber"];
        }else{
            [HCJFNSUser setValue:obj[@"identifyCard"] forKey:@"IdNumber"];
        }
        NSArray *array = obj[@"accountBankList"];
        if ([array count] == 0) {
            [HCJFNSUser setValue:@"1" forKey:@"cardNo"];
        }else{
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [HCJFNSUser setValue:obj[@"cardNo"] forKey:@"cardNo"];
            }];
        }
        [HCJFNSUser setValue:[obj[@"accountBankList"] firstObject][@"realname"] forKey:@"realname"];//姓名
        [HCJFNSUser synchronize];
        [hud setHidden:YES];
        //在线客服
        QYSessionViewController *sessionViewController = [Factory jumpToQY];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
        if (iOS11) {
            self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, NavigationBarHeight)];
        }else{
            self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)];
        }
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"汇诚金服"];
        TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
        [titleLabel titleLabel:@"汇诚金服" color:[UIColor blackColor]];
        navItem.titleView = titleLabel;
        UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanghui"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
        
        left.tintColor = [UIColor blackColor];
        [self.QYnavBar pushNavigationItem:navItem animated:NO];
        [navItem setLeftBarButtonItem:left];
        //    [navItem setRightBarButtonItem:right];
        [navi.view addSubview:self.QYnavBar];
        
        [self presentViewController:navi animated:YES completion:nil];
    } userId:[HCJFNSUser objectForKey:@"userId"]];
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *创建商品详情和活动规则
 */
- (void)createView{
    //商品详情 活动规则
    NSArray *buttonArray = @[@"商品详情",@"活动规则"];
    for (int i = 0; i<buttonArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonArray[i] forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        button.tag =300+ i;
        [button addTarget:self action:@selector(shangpinDetail:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:UIColorFromRGB(0x575757) forState:0];
        if (i == 0) {
            [button setTitleColor:UIColorFromRGB(0xde4f1e) forState:0];
        }
        [self.scrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_iphoneView.mas_bottom);
            make.left.mas_equalTo(kScreenWidth/2*i);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 88*m6Scale));
        }];
    }
}
/**
 *活动图
 */
- (UIImageView *)ruleImageView{
    if(!_ruleImageView){
        UIButton *shangpinBtn = [self.view viewWithTag:300];
        _ruleImageView = [[UIImageView alloc] init];
        _ruleImageView.image = [UIImage imageNamed:@"活动规则"];
        [self.view addSubview:_ruleImageView];
        [self.ruleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.top.equalTo(shangpinBtn.mas_bottom);
            make.height.offset(703*m6Scale);
        }];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, 1230*m6Scale+86*m6Scale-180-110+703*m6Scale);
    }
    return _ruleImageView;
}
//切换商品详情 活动规则
- (void)shangpinDetail:(UIButton *)seleButton{
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, _heigh+1230*m6Scale+86*m6Scale-180-110+12);
    UIButton *shangpinBtn = [self.view viewWithTag:300];
    UIButton *huodongBtn = [self.view viewWithTag:301];
    if (seleButton.tag == 300) {
        [shangpinBtn setTitleColor:UIColorFromRGB(0xde4f1e) forState:0];
        [huodongBtn setTitleColor:UIColorFromRGB(0x575757) forState:0];
        for (int i = 2000; i < self.dataArr.count+2000; i++) {
            UIImageView *imgView = (UIImageView *)[self.view viewWithTag:i];
            imgView.hidden = NO;
        }
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, _heigh+1230*m6Scale+86*m6Scale-180-110+128*m6Scale);
        
        self.ruleImageView.hidden = YES;
        [self.view bringSubviewToFront:_backView];
    }
    if (seleButton.tag == 301){
        for (int i = 2000; i < self.dataArr.count+2000; i++) {
            UIImageView *imgView = (UIImageView *)[self.view viewWithTag:i];
            imgView.hidden = YES;
        }
        self.ruleImageView.hidden = NO;
        [shangpinBtn setTitleColor:UIColorFromRGB(0x575757) forState:0];
        [huodongBtn setTitleColor:UIColorFromRGB(0xde4f1e) forState:0];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, 1230*m6Scale+86*m6Scale-180-110+703*m6Scale+128*m6Scale);
        [self.view bringSubviewToFront:_backView];
    }
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *父子控制器布局
 */
- (void)FatherAndSonVCLayout{
    GoodsVC *goodVc = [[GoodsVC alloc] init];
    goodVc.title = @"商品详情";
    goodVc.goodsID = self.goodsID;//将商品Id传到子控制器中
    ActivityRuleVC *activityVC = [[ActivityRuleVC alloc] init];
    activityVC.title = @"活动规则";
    //    AlterVC *alterVC = [[AlterVC alloc] init];
    //    alterVC.title = @"合同提示";
    NSArray *subViewControllers = @[goodVc,activityVC];
    DCNavTabBarController *tabBarVC = [[DCNavTabBarController alloc]initWithSubViewControllers:subViewControllers];
    [self.scrollView addSubview:tabBarVC.view];
    [tabBarVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iphoneView.mas_bottom);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
    
    [self addChildViewController:tabBarVC];
}
/**
 *礼券购买view布局
 */
- (void)GiftBuy{
    //背景view
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(0);
        make.height.mas_equalTo(86*m6Scale+KSafeBarHeight);
    }];
    //礼券购买
    UIButton *buyBtn = [UIButton buttonWithType:0];
    [buyBtn setTitle:@"立即锁投" forState:0];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:0];
    [buyBtn addTarget:self action:@selector(BuyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:76 / 255.0 blue:42/255.0 alpha:1.0];
    [_backView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.bottom.mas_equalTo(-KSafeBarHeight);
        make.width.mas_equalTo(232*m6Scale);
    }];
    //空白label
    _backLabel = [Factory CreateLabelWithTextColor:0 andTextFont:20 andText:@"" addSubView:_backView];
    _backLabel.userInteractionEnabled = YES;
    _backLabel.layer.borderWidth = 1;
    _backLabel.layer.borderColor = [UIColor colorWithRed:236 / 255.0 green:163 / 255.0 blue:142/255.0 alpha:1.0].CGColor;
    _backLabel.layer.cornerRadius = 25*m6Scale;
    [_backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24*m6Scale);
        make.size.mas_equalTo(CGSizeMake(218*m6Scale, 50*m6Scale));
        make.centerY.mas_equalTo(_backView.mas_centerY).offset(-KSafeBarHeight/2);
    }];
    //数量标签
    [self numLabel];
    //减号按钮
    UIButton *leftBtn = [UIButton buttonWithType:0];
    [leftBtn setTitle:@"-" forState:0];
    [leftBtn setTitleColor:[UIColor colorWithRed:236 / 255.0 green:163 / 255.0 blue:142/255.0 alpha:1.0] forState:0];
    [leftBtn addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backLabel addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(_numLabel.mas_left);
    }];
    //+号按钮
    UIButton *rightBtn = [UIButton buttonWithType:0];
    [rightBtn setTitle:@"+" forState:0];
    [rightBtn setTitleColor:[UIColor colorWithRed:236 / 255.0 green:163 / 255.0 blue:142/255.0 alpha:1.0] forState:0];
    [rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backLabel addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_numLabel.mas_right);
    }];
}
/**
 *金额标签
 */
- (UILabel *)accountLabel{
    if(!_accountLabel){
        _accountLabel = [Factory CreateLabelWithTextColor:0.3 andTextFont:26 andText:@"￥0.00" addSubView:_backView];
        [_accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25*m6Scale);
            make.left.mas_equalTo(_backLabel.mas_right).offset(15*m6Scale);
        }];
    }
    return _accountLabel;
}
/**
 *数量标签
 */
- (UILabel *)numLabel{
    if(!_numLabel){
        //数量标签
        _numLabel = [Factory CreateLabelWithTextRedColor:236 GreenColor:163 BlueColor:142 andTextFont:26 andText:@"" addSubView:_backLabel];
        _numLabel.layer.borderWidth = 1;
        _numLabel.layer.borderColor = [UIColor colorWithRed:236 / 255.0 green:163 / 255.0 blue:142/255.0 alpha:1.0].CGColor;
        _numLabel.text = @"1";
        _numLabel.textAlignment = NSTextAlignmentCenter;
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_backLabel.mas_centerX);
            make.centerY.mas_equalTo(_backLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(130*m6Scale, 50*m6Scale));
        }];
    }
    return _numLabel;
}
/**
 *scrollView的懒加载
 */
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:249 / 255.0 blue:249/255.0 alpha:1.0];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        //_scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
/**
 *期限数组
 */
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/**
 *请求数据
 */
- (void)serviceData{
    //单个商品点击进入详情页接口
    [DownLoadData postGetGoodsDetails:^(id obj, NSError *error) {
        _model = [[IphoneDetailsModel alloc] initWithDictionary:obj];
        if (_model.count.integerValue) {
            self.numLabel.text = @"1";
        }else{
            self.numLabel.text = @"0";
        }
        [_iphoneView viewForModel:_model];
        //根据商品id查询期限种类
        [self getGoodsKinds];
    } goodsId:_goodsID];
}
/**
 *根据商品id查询期限种类
 */
- (void)getGoodsKinds{
    //根据商品id查询期限种类
    [DownLoadData postGetGoodsKinds:^(id obj, NSError *error) {
        self.dataArr = obj[@"SUCCESS"];
        if (self.dataArr.count) {
            GoodsKindsModel *model = self.dataArr[0];
            self.kindID = [NSString stringWithFormat:@"%@", model.ID];
            [_iphoneView viewForDataArray:self.dataArr];
            self.accountLabel.text = [NSString stringWithFormat:@"￥%ld", self.numLabel.text.integerValue*self.iphoneView.account];//总价
        }
    } goodsId:_goodsID];
}
/**
 *商品数量变化
 */
- (void)ChangeGoodsNum:(NSNotification *)notification{
    self.kindID = notification.userInfo[@"kindsID"];
    self.goodsCount = @"1";
    [DownLoadData postCheckCountAndRemainder:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            self.result = obj[@"result"];
            self.numLabel.text = @"1";//购买数量
            self.accountLabel.text = [NSString stringWithFormat:@"￥%ld", self.numLabel.text.integerValue*self.iphoneView.account];//总价
        }else{
            [Factory alertMes:obj[@"messageText"]];
        }
    } kindId:self.kindID num:self.goodsCount userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *计算商品价格
 */
- (void)GoodsPrice:(NSNotification *)notification{
    NSString *pri = notification.userInfo[@"price"];
    _price = pri.floatValue;
    self.accountLabel.text = [NSString stringWithFormat:@"￥%ld", self.numLabel.text.integerValue*self.iphoneView.account];//总价
}
/*
 *库存及限购校验
 */
- (void)CheckStock{
    [DownLoadData postCheckCountAndRemainder:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            self.result = obj[@"result"];
            self.numLabel.text = self.goodsCount;//购买数量
            self.accountLabel.text = [NSString stringWithFormat:@"￥%ld", self.numLabel.text.integerValue*self.iphoneView.account];//总价
        }else{
            self.goodsCount = self.numLabel.text;
            [Factory alertMes:obj[@"messageText"]];
        }
    } kindId:self.kindID num:self.goodsCount userId:[HCJFNSUser stringForKey:@"userId"]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏tabar
    
    self.navigationController.navigationBar.translucent = YES;
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    _navLine = backgroundView.subviews.firstObject;
    _navLine.hidden = YES;
    
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     _navLine.hidden = NO;
}
/**
 *礼券购买按钮
 */
- (void)BuyButtonClick{
    //校验用户是否登录
    if ([HCJFNSUser stringForKey:@"userId"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //用户登录 判断用户是否实名
        [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
            [hud setHidden:YES];
            //获取用户实名状态
            NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
            //用户的真实姓名
            NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
            self.userName = realName;
            if (realnameStatus.integerValue) {
                //用户实名过  判断他是否绑过卡
                [self judgeIsBidCard];
            }else{
                //提示实名
                //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
                NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus];
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未实名，是否立刻去实名?" preferredStyle:UIAlertControllerStyleAlert];
//                [hud hideAnimated:YES];//HUD
//                [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                }]];
//                
//                [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    ScanIdentityVC *tempVC = [ScanIdentityVC new];
//                    tempVC.userName = realName;//用户名字
//                    tempVC.identifyCard = identifyCard;//用户身份证号
//                    tempVC.realnameStatus = realnameStatus;//用户实名的状态 0未实名 1实名
//                    [self.navigationController pushViewController:tempVC animated:YES];
//                }]];
//                
//                [self presentViewController:alert animated:YES completion:nil];
            }
        } userId:[HCJFNSUser stringForKey:@"userId"]];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NewSignVC *signVC = [[NewSignVC alloc] init];
            signVC.presentTag = @"2";
            [self presentViewController:signVC animated:YES completion:nil];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 *判断用户是否已经绑卡
 */
- (void)judgeIsBidCard{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //用户实名过  判断他是否绑过卡
    [DownLoadData postGetBankByUserId:^(id obj, NSError *error) {
        [hud hideAnimated:YES];
        NSString *result = obj[@"result"];
        if ([result isEqualToString:@"success"]) {
            //用户已经绑卡 跳转页面
            [self skipToOrderVC];
        }else {
            //提示用户去绑卡
            [self alert];
        }
    } userId:[HCJFNSUser objectForKey:@"userId"]];
}
/**
 *用户已经绑卡 跳转页面
 */
- (void)skipToOrderVC{
    [DownLoadData postCheckCountAndRemainder:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            //            self.numLabel.text = self.goodsCount;
            self.goodsCount = self.numLabel.text;
            //跳入订单界面
            OrderVC *tempVC = [[OrderVC alloc] init];
            tempVC.number = self.numLabel.text;//商品数量
            tempVC.kindID = self.kindID;//期限ID
            [self.navigationController pushViewController:tempVC animated:YES];
        }else{
            //            self.goodsCount = self.numLabel.text;
            //            if (self.numLabel.text.integerValue) {
            [Factory alertMes:obj[@"messageText"]];
            //            }else{
            //                [Factory alertMes:@"剩余库存不足"];
            //            }
        }
    } kindId:self.kindID num:self.numLabel.text userId:[HCJFNSUser stringForKey:@"userId"]];
}

/**
 是否绑卡提示
 */
- (void)alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未绑卡，是否立刻绑定银行卡?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转至绑定银行卡页面
        BidCardFirstVC *tempVC = [BidCardFirstVC new];
        tempVC.userName = self.userName;//用户的真实姓名
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollView.contentOffset.y = %f", scrollView.contentOffset.y);
}
/**
 *  提示用户去开户
 */
- (void)alertActionWithUserName:(NSString *)userName identifyCard:(NSString *)identifyCard status:(NSString *)status{
    self.openAlert = [[OpenAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.openAlert];
    __weak typeof(self.openAlert) openSelf = self.openAlert;
    __weak typeof(self) weakSelf = self;
    [self.openAlert setButtonAction:^(NSInteger tag) {
        [openSelf removeFromSuperview];
        if (tag == 0) {
            ScanIdentityVC *tempVC = [ScanIdentityVC new];
            tempVC.userName = userName;
            tempVC.identifyCard = identifyCard;
            tempVC.realnameStatus = status;
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
        }else if (tag == 2){
            
            MywelfareVC *tempVC = [MywelfareVC new];
            
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
            
        }
    }];
}
/**
 *减号点击事件
 */
- (void)leftButtonAction{
    NSInteger index = self.numLabel.text.integerValue;
    if (index > 1) {
        index--;
        //用户想要购买的商品的数量
        self.goodsCount = [NSString stringWithFormat:@"%ld", index];
        //库存及限购校验
        [self CheckStock];
    }
}
/**
 *加号点击事件
 */
- (void)rightButtonAction{
    NSInteger index = self.numLabel.text.integerValue;
    index++;
    //用户想要购买的商品的数量
    self.goodsCount = [NSString stringWithFormat:@"%ld", index];
    //库存及限购校验
    [self CheckStock];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeGoodsNum" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GoodsPrice" object:nil];
}
@end
