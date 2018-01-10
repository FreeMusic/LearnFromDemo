//
//  LargeAmountRechangeVC.m
//  CityJinFu
//
//  Created by mic on 2017/11/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "LargeAmountRechangeVC.h"
#import "LargeRechargeView.h"
#import "MyBankCardVC.h"

@interface LargeAmountRechangeVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *bankIconImg;//银行卡小图标

@property (nonatomic, strong) NSArray *detailsLabelArr;//detailsTextLabel Array

@property (nonatomic, strong) UIImageView *amountImg;//金额小图标

@property (nonatomic, strong) LargeRechargeView *largeRechargeView;

@property (nonatomic, strong) NSString *company;// 开户姓名

@property (nonatomic, strong) NSString *account;//银行账户

@property (nonatomic, strong) NSString *bank;//开户银行

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LargeAmountRechangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"大额充值"];
    //添加返回按钮
    self.color = BackColor_black;
    if ([Factory theidTypeIsNull:self.bankName]) {
        self.detailsLabelArr = @[@"工商银行", @"可用金额"];
    }else{
        self.detailsLabelArr = @[self.bankName, @"可用金额"];
    }
    
    [self loadData];
    
    [self.view addSubview:self.tableView];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = backGroundColor;
        _tableView.scrollEnabled = NO;
        _tableView.contentInset = UIEdgeInsetsMake(30*m6Scale, 0, 0, 0);
    }
    
    return _tableView;
}
/**
 *  银行卡小图标
 */
- (UIImageView *)bankIconImg{
    if(!_bankIconImg){
        _bankIconImg = [[UIImageView alloc] initWithImage:self.bankIconImage];
    }
    return _bankIconImg;
}
/**
 *  可用金额小图标
 */
- (UIImageView *)amountImg{
    if(!_amountImg){
        _amountImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LargeAmountRechange_椭圆5"]];
    }
    return _amountImg;
}
/**
 *  大额充值视图
 */
- (LargeRechargeView *)largeRechargeView{
    if(!_largeRechargeView){
        _largeRechargeView = [[LargeRechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight)];
        [self.view addSubview:_largeRechargeView];
    }
    return _largeRechargeView;
}
/**
 *  请求数据
 */
- (void)loadData{
    
    [DownLoadData postBigAmountRechargeData:^(id obj, NSError *error) {
        
        UILabel *label = (UILabel *)[_imageView viewWithTag:6666];
        label.text = [NSString stringWithFormat:@"%@", obj[@"depositName"]];//开户姓名
        _company = label.text;
        UILabel *accountLabel = (UILabel *)[_imageView viewWithTag:6667];
        accountLabel.text = [NSString stringWithFormat:@"%@", obj[@"depositCardNo"]];//银行账户
        _account = accountLabel.text;
        UILabel *bankLabel = (UILabel *)[_imageView viewWithTag:6668];
        bankLabel.text = [NSString stringWithFormat:@"%@", obj[@"depositBankName"]];//开户银行
        _bank = bankLabel.text;
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuse = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.selectionStyle = NO;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *array = @[@"绑定银行卡", @"充值到"];
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    cell.textLabel.textColor = UIColorFromRGB(0x393939);
    
    cell.detailTextLabel.text = self.detailsLabelArr[indexPath.row];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x848484);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    
    if (indexPath.row) {
        [cell addSubview:self.amountImg];
        [self.amountImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
            make.right.mas_equalTo(cell.detailTextLabel.mas_left).offset(-15*m6Scale);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }else{
        [cell addSubview:self.bankIconImg];
        [self.bankIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80*m6Scale, 80*m6Scale));
            make.right.mas_equalTo(cell.detailTextLabel.mas_left).offset(-15*m6Scale);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    //背景图
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30*m6Scale, kScreenWidth, 688*m6Scale)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LargeAmountRechange_矩形14拷贝@2x" ofType:@"png"];
    _imageView.image = [UIImage imageWithContentsOfFile:path];
    [footerView addSubview:_imageView];
    //三个标签
    UILabel *topLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x333333) andTextFont:30 andText:@"使用银行APP或网银向以下账户转账完成充值" addSubView:_imageView];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_imageView.mas_centerX);
        make.top.mas_equalTo(48*m6Scale);
    }];
    
    UILabel *centerLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0xff5933) andTextFont:30 andText:@"务必使用平台绑定银行卡" addSubView:_imageView];
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom).offset(28*m6Scale);
        make.centerX.mas_equalTo(_imageView.mas_centerX);
    }];
    
    UILabel *bottomLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0xff8514) andTextFont:40 andText:@"汇诚金服大额充值专用用户" addSubView:_imageView];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerLabel.mas_bottom).offset(70*m6Scale);
        make.centerX.mas_equalTo(_imageView.mas_centerX);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LargeAmountRechange_椭圆4"]];
    [_imageView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(192*m6Scale, 93*m6Scale));
        make.centerX.mas_equalTo(_imageView.mas_centerX);
        make.top.mas_equalTo(bottomLabel.mas_top).offset(-26*m6Scale);
    }];
    //绘制表格
    [self drawTableListAddSubView:_imageView referrenceLabel:bottomLabel touchView:footerView];
    
    UIButton *rechargeBtn = [UIButton buttonWithType:0];
    [rechargeBtn setTitle:@"大额充值到账流程" forState:0];
    [rechargeBtn setTitleColor:UIColorFromRGB(0xff5933) forState:0];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    [footerView addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0*m6Scale);
        make.top.mas_equalTo(_imageView.mas_bottom).offset(35*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 112*m6Scale));
    }];
    [rechargeBtn addTarget:self action:@selector(rechargeProgressView) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}
/**
 *   绘制表格
 */
- (void)drawTableListAddSubView:(UIImageView *)subView referrenceLabel:(UILabel *)label touchView:(UIView *)touchView{
    
    subView.userInteractionEnabled = YES;
    //表格上最粗的一条View；
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = UIColorFromRGB(0xffb514);
    topLine.alpha = 0.6;
    [subView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(676*m6Scale, 1.5));
        make.centerX.mas_equalTo(subView.mas_centerX);
        make.top.mas_equalTo(label.mas_bottom).offset(52*m6Scale);
    }];
    
    for (int i = 0; i < 4; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xffb514);
        line.alpha = 0.6;
        [subView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(676*m6Scale, 1));
            make.centerX.mas_equalTo(subView.mas_centerX);
            make.top.mas_equalTo(topLine.mas_bottom).offset(5*m6Scale+112*m6Scale*i);
        }];
    }
    
    for (int i = 0; i < 2; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xffb514);
        line.alpha = 0.6;
        [subView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1, 336*m6Scale));
            if (i) {
                make.right.mas_equalTo(-150*m6Scale);
            }else{
                make.left.mas_equalTo(180*m6Scale);
            }
            make.top.mas_equalTo(topLine.mas_bottom).offset(5*m6Scale);
        }];
    }
    
    NSArray *leftArr = @[@"开户姓名", @"银行账户", @"开户银行"];
    for (int i = 0; i < leftArr.count; i++) {
        
        UILabel *leftLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x828282) andTextFont:28 andText:leftArr[i] addSubView:subView];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40*m6Scale);
            make.top.mas_equalTo(topLine.mas_bottom).offset(45*m6Scale+(112*m6Scale)*i);
        }];
        
        UILabel *label = [Factory CreateLabelWithColor:UIColorFromRGB(0x333333) andTextFont:28 andText:@"" addSubView:subView];
        label.numberOfLines = 0;
        label.tag = 6666+i;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(195*m6Scale);
            make.width.mas_equalTo(370*m6Scale);
            if (i == leftArr.count-1) {
                make.top.mas_equalTo(topLine.mas_bottom).offset(30*m6Scale+(112*m6Scale)*i);
            }else{
                make.top.mas_equalTo(topLine.mas_bottom).offset(45*m6Scale+(112*m6Scale)*i);
            }
        }];
        
        UIButton *copyBtn = [UIButton buttonWithType:0];
        [copyBtn setTitle:@"复制" forState:0];
        [copyBtn setTitleColor:UIColorFromRGB(0xffb514) forState:0];
        copyBtn.titleLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        copyBtn.tag = 5000+i;
        copyBtn.userInteractionEnabled = YES;
        [copyBtn addTarget:self action:@selector(copyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:copyBtn];
        [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-40*m6Scale);
            make.top.mas_equalTo(topLine.mas_bottom).offset(5*m6Scale+(112*m6Scale)*i);
            make.size.mas_equalTo(CGSizeMake(120*m6Scale, 112*m6Scale));
        }];
    }
}
/**
 *  流程弹出视图
 */
- (void)rechargeProgressView{
    
    self.largeRechargeView.hidden = NO;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 918*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108*m6Scale;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MyBankCardVC *tempVC = [MyBankCardVC new];
        tempVC.userName = _userName;
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}

/**
 *  复制按钮的点击事件
 */
- (void)copyButtonClick:(UIButton *)sender{
    //复制内容至系统粘贴板
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    switch (sender.tag) {
        case 5000:
            pasteBoard.string = _company;
            break;
        case 5001:
            pasteBoard.string = _account;
            break;
        case 5002:
            pasteBoard.string = _bank;
            break;
            
        default:
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"复制成功，已复制到系统粘贴板" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
