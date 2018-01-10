//
//  IphoneDetailsView.m
//  CityJinFu
//
//  Created by mic on 2017/6/1.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "IphoneDetailsView.h"
#import "SDCycleScrollView.h"
#import "IphoneDetailsVC.h"

@interface IphoneDetailsView ()<SDCycleScrollViewDelegate>

@property(nonatomic, strong) NSArray *dataArr;//接受期限数组，方便点击事件数据的调整
@property (nonatomic,assign) NSInteger btnTag;//记录上一个按钮的tag值
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;//滑动视图
@property (nonatomic, strong) UINavigationBar *QYnavBar;

@end

@implementation IphoneDetailsView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //顶部banner图
        [self addSubview:self.cycleScrollView];
        //标题标签
        _titleLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"G20峰会西湖韵  西湖印象茶具组合" addSubView:self];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18*m6Scale);
            make.top.mas_equalTo(self.cycleScrollView.mas_bottom).offset(18*m6Scale);
        }];
        //现有标配
        _nowLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:24 andText:@"现有标配" addSubView:self];
        [_nowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18*m6Scale);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(18*m6Scale);
        }];
        //库存、是否限购
        _stockLaabel = [Factory CreateLabelWithTextRedColor:233 GreenColor:174 BlueColor:161 andTextFont:24 andText:@"剩余库存：00  是否限购" addSubView:self];
        [_stockLaabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nowLabel.mas_top);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        //客服按钮
//        _serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _serviceBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"kefu11111"]];
//        [_serviceBtn addTarget:self action:@selector(serviceButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_serviceBtn];
//        [_serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(82*m6Scale, 82*m6Scale));
//            make.top.mas_equalTo(self.cycleScrollView.mas_bottom).offset(18*m6Scale);
//            make.right.mas_equalTo(-18*m6Scale);
//        }];
        //中间四条横线
        [self CreateNewLine];
    }
    return self;
}
/**
 广告滚动页
 */
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 478*m6Scale) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    return _cycleScrollView;
}

/**
 *四条横线 两条竖线
 */
- (void)CreateNewLine{
    for (int i = 0; i < 4; i++) {
        //横线
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:_line];
        if (i < 2) {
            if (i) {
                [self CreateFirstLineContent];
            }
            [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
                make.top.mas_equalTo(_stockLaabel.mas_bottom).offset(18*m6Scale + 65*m6Scale*i);
            }];
        }else if (i == 2){
            [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
                make.top.mas_equalTo(_stockLaabel.mas_bottom).offset(83*m6Scale + 120*m6Scale);
            }];
            [self CreateSecondLineContent];
        }else{
            [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(1);
                make.top.mas_equalTo(_stockLaabel.mas_bottom).offset(83*m6Scale + 120*m6Scale + 150*m6Scale);
            }];
            [self CreateThirdLineContent];
        }
    }
}
/**
 *第一条横线
 */
- (void)CreateFirstLineContent{
    //售价
    _priceLabel = [Factory CreateLabelWithTextRedColor:224 GreenColor:69 BlueColor:76 andTextFont:26 andText:@"售价：10.00" addSubView:self];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18*m6Scale);
        make.bottom.mas_equalTo(_line.mas_top).offset(-12*m6Scale);
    }];
    //参考价
    _referLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"参考价：1000" addSubView:self];
    [_referLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(_line.mas_top).offset(-12*m6Scale);
    }];
    //快递
    _expressLabel = [Factory CreateLabelWithTextColor:0.6 andTextFont:26 andText:@"快递：免运费" addSubView:self];
    [_expressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18*m6Scale);
        make.bottom.mas_equalTo(_line.mas_top).offset(-12*m6Scale);
    }];
}
/**
 *第二条横线
 */
- (void)CreateSecondLineContent{
    for (int k = 1; k < 3; k++) {
        //竖线
        UIView *vertical = [[UIView alloc] init];
        vertical.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:vertical];
        [vertical mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kScreenWidth / 3 * k);
            make.height.mas_equalTo(150*m6Scale);
            make.top.mas_equalTo(_line.mas_bottom);
            make.width.mas_equalTo(1);
        }];
    }
    //期限
    _dataLabel = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"期限" addSubView:self];
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_line.mas_top).offset(-40*m6Scale);
        make.left.mas_equalTo(18*m6Scale);
    }];
    //    NSArray *arr = @[@"3个月", @"6个月", @"12个月"];
    //    CGFloat width = (kScreenWidth-18*m6Scale-_dataLabel.frame.size.width-420*m6Scale)/4;
    //    //期限按钮
    //    for (int m = 0; m < arr.count; m++) {
    //        _dataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _dataBtn.tag = 200+m;
    //        _dataBtn.layer.cornerRadius = 8*m6Scale;
    //        _dataBtn.layer.borderWidth = 1;
    //        [_dataBtn addTarget:self action:@selector(dataButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //        if (!m) {
    //            //_dataBtn.selected = YES;
    //            //_dataBtn.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:74 / 255.0 blue:28/255.0 alpha:1.0].CGColor;
    //        }else{
    //             _dataBtn.layer.borderColor = [UIColor colorWithRed:243 / 255.0 green:195 / 255.0 blue:185/255.0 alpha:1.0].CGColor;
    //        }
    //        [_dataBtn setTitle:arr[m] forState:0];
    //        _dataBtn.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
    //        [_dataBtn setTitleColor:[UIColor colorWithRed:243 / 255.0 green:195 / 255.0 blue:185/255.0 alpha:1.0] forState:0];
    //        [_dataBtn setTitleColor:[UIColor colorWithRed:214 / 255.0 green:74 / 255.0 blue:28/255.0 alpha:1.0] forState:UIControlStateSelected];
    //        [self addSubview:_dataBtn];
    //        [_dataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.size.mas_equalTo(CGSizeMake(140*m6Scale, 42*m6Scale));
    //            make.left.mas_equalTo(_dataLabel.mas_right).offset(width + (140*m6Scale+width)*m);
    //            make.bottom.mas_equalTo(_line.mas_top).offset(-39*m6Scale);
    //        }];
    //    }
}
/**
 *第三条横线
 */
- (void)CreateThirdLineContent{
    NSArray *arr = @[@"投资金额",@"投资利率",@"预期收益"];
    CGFloat width = kScreenWidth/3;
    for (int n = 0; n < arr.count; n++) {
        _label = [Factory CreateLabelWithTextColor:0.2 andTextFont:28 andText:arr[n] addSubView:self];
        _label.textAlignment = NSTextAlignmentCenter;
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(n*width);
            make.width.mas_equalTo(width);
            make.bottom.mas_equalTo(_line.mas_top).offset(-87*m6Scale);
        }];
        switch (n) {
            case 0:
                //投资金额
                _accountLabel = [Factory CreateLabelWithTextRedColor:219 GreenColor:72 BlueColor:5 andTextFont:28 andText:@"￥123,200" addSubView:self];
                [self Label:_accountLabel andLeftDistance:n];
                break;
            case 1:
                //投资利率
                _rateLabel = [Factory CreateLabelWithTextRedColor:219 GreenColor:72 BlueColor:5 andTextFont:28 andText:@"8.8%" addSubView:self];
                [self Label:_rateLabel andLeftDistance:n];
                break;
            case 2:
                //预期收益
                _incomeLabel = [Factory CreateLabelWithTextRedColor:219 GreenColor:72 BlueColor:5 andTextFont:28 andText:@"￥623,222" addSubView:self];
                [self Label:_incomeLabel andLeftDistance:n];
                break;
                
            default:
                break;
        }
    }
}
/**
 *客服按钮点击事件
 */
- (void)serviceButtonClick{
    if([defaults objectForKey:@"userId"]){
        IphoneDetailsVC *strVC = (IphoneDetailsVC *)[self ViewController];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strVC.view animated:YES];
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
            
            [strVC presentViewController:navi animated:YES completion:nil];
        } userId:[HCJFNSUser objectForKey:@"userId"]];
    }
    else{
        [Factory alertMes:@"请先登录"];
    }
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    IphoneDetailsVC *strVC = (IphoneDetailsVC *)[self ViewController];
    
    [strVC dismissViewControllerAnimated:YES completion:nil];
}
/**
 *布局
 */
- (void)Label:(UILabel *)label andLeftDistance:(CGFloat)distance{
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(distance*(kScreenWidth/3));
        make.top.mas_equalTo(_label.mas_bottom).offset(15*m6Scale);
        make.width.mas_equalTo(kScreenWidth/3);
    }];
}
/**
 *期限按钮点击事件
 */
-(void)dataButtonClick:(UIButton *)sender{
    //创建可变数组容纳button的tag值
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 200; i < 200+_dataArr.count; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    //将选中的按钮的tag值移除掉
    [arr removeObject:[NSString  stringWithFormat:@"%ld", sender.tag]];
    //点击的按钮切换为选中状态
    sender.selected = YES;
    sender.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:74 / 255.0 blue:28/255.0 alpha:1.0].CGColor;
    //其他按钮设为未选中状态
    for (int i = 0; i < _dataArr.count-1; i++) {
        NSString *index = arr[i];
        UIButton *btn = (UIButton *)[self viewWithTag:index.integerValue];
        btn.selected = NO;
        btn.layer.borderColor = [UIColor colorWithRed:243 / 255.0 green:195 / 255.0 blue:185/255.0 alpha:1.0].CGColor;
    }
    GoodsKindsModel *model = _dataArr[sender.tag-200];
    //投资金额
    _accountLabel.text = [NSString stringWithFormat:@"￥%@", model.investAmount];
    _account = model.investAmount.floatValue;
    //发送通知
    [self postNotification];
    //投资利率
    _rateLabel.text = [NSString stringWithFormat:@"%.1f%@", model.investRate.floatValue, @"%"];
    //预期收益
    _incomeLabel.text = [NSString stringWithFormat:@"￥%@", model.investInterest];
    //因为假如每次用户点击不同的时间期限，那么id值不同。此处发送通知让控制器中的商品数量有所变化。
    NSNotification *notification = [[NSNotification alloc] initWithName:@"ChangeGoodsNum" object:nil userInfo:@{@"kindsID":model.ID}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)viewForModel:(IphoneDetailsModel *)model{
    //将imageId截成数组放在轮播图中
    NSArray *picArr = [model.imageId componentsSeparatedByString:@","];
    //创建一个可变数组,将最后一个空白元素移除掉
    NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:picArr];
    [muArr removeLastObject];
    NSLog(@"%@     %@", picArr, muArr);
    //为防止少于三张图出现闪退的情况 故此做一个判断
    if (muArr.count > 2) {
        for (int i = 0; i < 2; i++) {
            [muArr removeObjectAtIndex:0];
        }
    }
    NSLog(@"%@", muArr);
    if (muArr.count > 0) {
        self.cycleScrollView.imageURLStringsGroup = muArr;
    }else if (muArr.count == 1){
        //当数组只有一个元素的时候，在添加一个元素
        //[muArr addObject:muArr[0]];
        self.cycleScrollView.imageURLStringsGroup = muArr;
    }
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.goodsName];//标题标签
    //是否限购
    NSString *limite = (model.isLimit.integerValue == 1) ? @"不限购" : [NSString stringWithFormat:@"限购数量：%d", model.limitNum.intValue];
    
    //库存以及限购标签
    _stockLaabel.text = [NSString stringWithFormat:@"剩余库存：%ld  %@", model.count.integerValue, limite];
    //售价
    _priceLabel.text = [NSString stringWithFormat:@"售价：%.2f", model.nowPrice.floatValue];
    //参考价
    _referLabel.text = [NSString stringWithFormat:@"参考价：%.2f", model.originalPrice.floatValue];
    NSAttributedString *tejiaStr = [[NSAttributedString alloc]initWithString:_referLabel.text attributes:@{NSStrikethroughStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)}];
    _referLabel.attributedText = tejiaStr;
    //快递
    NSString *freightPrice = (model.freightPrice.integerValue == 0) ? @"免运费" : [NSString stringWithFormat:@"%.2f", model.freightPrice.floatValue];
    _expressLabel.text = [NSString stringWithFormat:@"快递：%@", freightPrice];
}
- (void)viewForDataArray:(NSArray *)array{
    _dataArr = array;
    CGFloat width = (kScreenWidth-18*m6Scale-_dataLabel.frame.size.width-420*m6Scale)/4;
    //期限按钮
    if (array.count) {
        for (int i = 0; i < array.count; i++) {
            _dataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _dataBtn.tag = 200+i;
            _dataBtn.layer.cornerRadius = 8*m6Scale;
            _dataBtn.layer.borderWidth = 1;
            [_dataBtn addTarget:self action:@selector(dataButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            GoodsKindsModel *model = array[i];
            if (!i) {
                _dataBtn.selected = YES;
                //记录默认选中的按钮的tag值
                _btnTag = 200;
                _dataBtn.layer.borderColor = [UIColor colorWithRed:214 / 255.0 green:74 / 255.0 blue:28/255.0 alpha:1.0].CGColor;
                //投资金额
                _accountLabel.text = [NSString stringWithFormat:@"￥%@", model.investAmount];
                _account = model.investAmount.floatValue;
                //发送通知
                [self postNotification];
                //投资利率
                _rateLabel.text = [NSString stringWithFormat:@"%.1f%@", model.investRate.floatValue, @"%"];
                //预期收益
                _incomeLabel.text = [NSString stringWithFormat:@"￥%@", model.investInterest];
            }else{
                _dataBtn.layer.borderColor = [UIColor colorWithRed:243 / 255.0 green:195 / 255.0 blue:185/255.0 alpha:1.0].CGColor;
            }
            
            [_dataBtn setTitle:[NSString stringWithFormat:@"%ld个月", model.lockCycle.integerValue] forState:0];
            _dataBtn.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
            [_dataBtn setTitleColor:[UIColor colorWithRed:243 / 255.0 green:195 / 255.0 blue:185/255.0 alpha:1.0] forState:0];
            [_dataBtn setTitleColor:[UIColor colorWithRed:214 / 255.0 green:74 / 255.0 blue:28/255.0 alpha:1.0] forState:UIControlStateSelected];
            [self addSubview:_dataBtn];
            [_dataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(140*m6Scale, 42*m6Scale));
                make.left.mas_equalTo(_dataLabel.mas_right).offset(width + (140*m6Scale+width)*i);
                make.bottom.mas_equalTo(_dataLabel.mas_bottom).offset(4*m6Scale);
            }];
        }
    }
}
/**
 *当得到投资金额之后，发送通知让控制器中的金额发生变化
 */
- (void)postNotification{
    NSString *account = _accountLabel.text;
    NSNotification *notification = [[NSNotification alloc] initWithName:@"GoodsPrice" object:nil userInfo:@{@"price":account}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
