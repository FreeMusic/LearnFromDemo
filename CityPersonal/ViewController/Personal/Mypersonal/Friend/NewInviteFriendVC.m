//
//  NewInviteFriendVC.m
//  CityJinFu
//
//  Created by mic on 2017/11/9.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "NewInviteFriendVC.h"
#import "FriendHeaderCell.h"
#import "CodeView.h"
#import "UIImage+JGQRCode.h"
#import "AlertView.h"
#import "InviteFriendModel.h"
#import "AwardAndInviteVC.h"
#import "InviteFriedsDetailsVC.h"
#import "InviteRecordView.h"
#import "InviteFriedsDetailsVC.h"

@interface NewInviteFriendVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *numLabe;//邀请码
@property (nonatomic, strong) UIButton *cpyBtn;//复制按钮
@property (nonatomic, strong) UIImageView *imageview;//二维码图片
@property (nonatomic, strong) UIButton *inviteBtn;//邀请好友按钮
@property (nonatomic, strong) CodeView *codeview;//二维码
@property (nonatomic, strong) InviteFriendModel *inviteFriendModel;
@property (nonatomic, strong) UIImage *imgName;//二维码
@property (nonatomic, strong) NSString *coupn;//新手红包
@property (nonatomic, strong) NSString *expGold;//体验金
@property (nonatomic, strong) InviteRecordView *inviteRecordView;
@property (nonatomic, strong) UIImageView *activiImg;//活动图
@property (nonatomic, strong) NSString *activiImgName;//活动图片链接
@property (nonatomic, strong) NSString *activityUrl;//活动图跳转链接
@property (nonatomic, strong) NSString *activityTitle;//活动标题
@property (nonatomic, strong) NSString *realName;//用户的名字

@end

@implementation NewInviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    [TitleLabelStyle addtitleViewToMyVC:self withTitle:@"邀请好友"];
    //左边按钮
    UIButton *leftButton = [Factory addBlackLeftbottonToVC:self WithImgName:@"Back-Arrow"];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    //    //右边按钮
    //    UIButton *rightBtn = [Factory addRightbottonToVC:self andrightStr:@"奖励规则" andTextColor:[UIColor whiteColor]];
    //    [rightBtn addTarget:self action:@selector(onClickRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    _numLabe = [UILabel new];//邀请码
    _cpyBtn = [UIButton buttonWithType:UIButtonTypeCustom];//复制按钮
    _imageview = [[UIImageView alloc]init];//二维码图片
    [self.view addSubview:self.inviteBtn];//邀请好友按钮
    [_inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-KSafeBarHeight);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 100*m6Scale));
    }];
    //请求数据
    [self serviceData];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *请求数据
 */
- (void)serviceData{
    //邀请好友首页
    [DownLoadData postInviteFriendByUserId:^(id obj, NSError *error) {
        _inviteFriendModel = [[InviteFriendModel alloc] initWithDictionary:obj];
        
        [self.tableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //获取新手福利信息
    [DownLoadData postCountNoviceWelfare:^(id obj, NSError *error) {
        
        self.coupn = obj[@"coupon"];
        self.expGold = obj[@"expGold"];
        
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //获取二维码
    [DownLoadData postGetUserQrCode:^(id obj, NSError *error) {
        _imgName = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj[@"qrCode"]]]];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //邀请好友中的图片
    [DownLoadData postGetInvitePagePic:^(id obj, NSError *error) {
        
        self.activiImgName = obj[@"ret"][@"picturePath"];//图片链接
        self.activityTitle = obj[@"ret"][@"pictureName"];//图片链接标题
        self.activityUrl = [NSString stringWithFormat:@"%@", obj[@"ret"][@"pictureUrl"]];//点击图片跳转链接
        
        [self.activiImg sd_setImageWithURL:[NSURL URLWithString:self.activiImgName]];
        
        [self.tableView reloadData];
        
    }];
    
    [DownLoadData postInviteUserMessage:^(id obj, NSError *error) {
        
        
        _realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
        NSLog(@"%@", _realName);
        if (![_realName isEqual:[NSNull null]] && ![_realName isEqualToString:@""] && _realName != nil && ![_realName isEqualToString:@"<null>"]) {
            
            _realName = [_realName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
            
            
        }else {
            
            
        }
        
    } userId:[HCJFNSUser objectForKey:@"userId"]];
}
/**
 奖励规则
 */
//- (void)onClickRight{
//    [Factory alertMes:@"dsgdsgsdg"];
//}
/**
 邀请好友按钮
 */
- (UIButton *)inviteBtn{
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
        _inviteBtn.backgroundColor = ButtonColor;
        _inviteBtn.titleLabel.font = [UIFont systemFontOfSize:36*m6Scale];
        [_inviteBtn addTarget:self action:@selector(inviteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inviteBtn;
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor = SeparatorColor;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 15*m6Scale;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        return 3;
    }else{
        return 1;
    }
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = HCJF;
    if (indexPath.section) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSArray *array = @[@"邀请人数",@"邀请码",@"我的二维码"];
        if (indexPath.row == 0) {
            cell.textLabel.text = array[indexPath.row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", _inviteFriendModel.invitePersons.intValue];
        }else if(indexPath.row == 1){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = array[indexPath.row];
            //复制
            _cpyBtn.backgroundColor = ButtonColor;
            [_cpyBtn setTitle:@"复制" forState:UIControlStateNormal];
            _cpyBtn.layer.cornerRadius = 30*m6Scale;
            _cpyBtn.titleLabel.font = [UIFont systemFontOfSize:36*m6Scale];
            [_cpyBtn addTarget:self action:@selector(cpybtn) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_cpyBtn];
            [_cpyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-30*m6Scale);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(150*m6Scale, 60*m6Scale));
            }];
            //邀请码
            if (_inviteFriendModel.inviteCode == nil) {
                _numLabe.text = @"";
            }else{
                _numLabe.text = [NSString stringWithFormat:@"%@", _inviteFriendModel.inviteCode];
            }
            _numLabe.font = [UIFont systemFontOfSize:36*m6Scale];
            _numLabe.textColor = [UIColor colorWithWhite:0.0 alpha:0.6];
            [cell.contentView addSubview:_numLabe];
            [_numLabe mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_cpyBtn.mas_left).offset(-10*m6Scale);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
        }else{
            cell.textLabel.text = array[indexPath.row];
            cell.textLabel.textColor = ButtonColor;
            _imageview.image = [UIImage imageNamed:@"二维码"];
            [cell.contentView addSubview:_imageview];
            [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-30*m6Scale);
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(60*m6Scale, 60*m6Scale));
            }];
        }
        return cell;
    }else{
        FriendHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[FriendHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell cellForModel:_inviteFriendModel];
        [cell.detailsBtn addTarget:self action:@selector(detailsBtn) forControlEvents:UIControlEventTouchUpInside];//奖励明细
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section) {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = TitleViewBackgroundColor;
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 21*m6Scale)];
        header.backgroundColor = backGroundColor;
        [footerView addSubview:header];
        UILabel *titleLab = [self commitLab:@"邀请好友一起来赚钱"];
        [footerView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).offset(30*m6Scale);
            make.top.equalTo(footerView.mas_top).offset(51.5*m6Scale);
        }];
        if (self.activiImgName) {
            [footerView addSubview:self.activiImg];
            [self.activiImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-25*m6Scale);
                make.left.mas_equalTo(28*m6Scale);
                make.right.mas_equalTo(-28*m6Scale);
                make.height.mas_equalTo(340*m6Scale);
            }];
        }else{
            NSArray *imageArray = @[@"分享链接",@"好友实名",@"邀请红包"];
            NSArray *titileArray = @[@"分享链接好友注册",@"实名绑卡即拿红包",@"邀请好友多邀多得"];
            //三个图片
            for (int i = 0; i < 3; i++) {
                UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(30*m6Scale + i*(kScreenWidth / 3), 180*m6Scale, 150*m6Scale, 150*m6Scale)];
                imageview.image = [UIImage imageNamed:imageArray[i]];
                [footerView addSubview:imageview];
                UILabel *threeLab = [self commitLab:titileArray[i]];
                [footerView addSubview:threeLab];
                [threeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(footerView.mas_left).offset(30*m6Scale + i*(kScreenWidth / 3));
                    make.top.equalTo(footerView.mas_top).offset(340*m6Scale);
                    make.size.mas_equalTo(CGSizeMake(160*m6Scale, 90*m6Scale));
                }];
            }
        }
        return footerView;
    }else{
        return nil;
    }
}
/**
 *  活动图
 */
- (UIImageView *)activiImg{
    if(!_activiImg){
        _activiImg = [[UIImageView alloc] init];
        _activiImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapClick)];
        [_activiImg addGestureRecognizer:tap];
        
    }
    return _activiImg;
}
/**
 *  图片的点击事件
 */
- (void)imageTapClick{
    if (![self.activityUrl isEqualToString:@""] && ![self.activityUrl isEqual:[NSNull null]] && ![self.activityUrl isEqualToString:@"<null>"] && self.activityUrl != nil) {
        
        InviteFriedsDetailsVC *tempVC = [InviteFriedsDetailsVC new];
        tempVC.url = [NSString stringWithFormat:@"%@?userToken=%@&token=%@", self.activityUrl, [HCJFNSUser stringForKey:@"userToken"], [HCJFNSUser stringForKey:@"token"]];
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}
#pragma mark -didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _codeview = [[CodeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _codeview.img = _imgName;
        UITapGestureRecognizer *clipTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCancelActivityAction:)];
        [self.codeview addGestureRecognizer:clipTap];
        [delegate.window addSubview:_codeview];
        _codeview.codeImage.image = _imgName;
        //_codeview.codeImage.image = [UIImage qrCodeImageWithContent:@""
        //                                                      codeImageSize:200
        //                                                               logo:_imgName
        //                                                          logoFrame:CGRectMake(75, 75, 500, 500)
        //                                                                red:253.0/255.0
        //                                                              green:182.0/255.0
        //                                                               blue:21/225.0];
    }else if(indexPath.row == 0){
        AwardAndInviteVC *tempVC = [AwardAndInviteVC new];
        tempVC.type = @"1";
        [self.navigationController pushViewController:tempVC animated:YES];
    }else{
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 260*m6Scale;
    }else{
        return 100*m6Scale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section) {
        return 480*m6Scale;
    }else{
        return 21*m6Scale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
/**
 复制
 */
- (void)cpybtn{
    if (self.numLabe.text == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败，请检查网络设置！" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        //复制内容至系统粘贴板
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = self.numLabe.text;
        if (self.numLabe.text) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"复制成功，已复制到系统粘贴板" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
/**
 奖励明细
 */
- (void)detailsBtn{
    AwardAndInviteVC *tempVC = [AwardAndInviteVC new];
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 邀请好友
 */
- (void)inviteBtn:(UIButton *)sneder{
    openShareView *openShare = [[openShareView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //openShare.isBanner = @"1";
    NSString *name;
    NSString *url;
    if (![_realName isEqual:[NSNull null]] && ![_realName isEqualToString:@""] && _realName != nil && ![_realName isEqualToString:@"<null>"]) {
        
        name = [NSString stringWithFormat:@"%@推荐你使用汇诚金服，还送万元体验金+388元红包", _realName];
        url =  [NSString stringWithFormat:@"https://www.hcjinfu.com/html/invitationRegister.html?invite=%@&name=%@",[NSString stringWithFormat:@"%@", _inviteFriendModel.inviteCode], _realName];
        
        
    }else {
        url =  [NSString stringWithFormat:@"https://www.hcjinfu.com/html/invitationRegister.html?invite=%@&name=%@",[NSString stringWithFormat:@"%@", _inviteFriendModel.inviteCode], @""];
        name = [NSString stringWithFormat:@"推荐你使用汇诚金服，还送万元体验金+388元红包"];
        
    }
    //在分享的过程中。假如分享的字符串中带有汉字的话，必须要转成UTF8格式，否则会造成乱码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
     openShare.bodyMessage = [NSString stringWithFormat:@"注册即得388元红包+10000元体验金！来银行资金存管平台，安全放心。"];
    openShare.strUrl = url;
    openShare.urlName = name;
    [delegate.window addSubview:openShare];
    [delegate.window bringSubviewToFront:openShare];
}
/**
 公共label
 */
- (UILabel *)commitLab:(NSString *)text{
    UILabel *titleLab = [UILabel new];
    titleLab.text = text;
    titleLab.font = [UIFont systemFontOfSize:35*m6Scale];
    titleLab.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    return titleLab;
}
//点击取消按钮
- (void)didCancelActivityAction:(UIGestureRecognizer *)tap {
    
    [UIView animateWithDuration:1 animations:^{
        
        self.codeview.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            self.codeview.hidden = YES;
        }
    }];
    //做图片放大的效果
    [UIView beginAnimations:@"Animations_4" context:nil];
    [UIView setAnimationDuration:1];
    self.codeview.transform = CGAffineTransformScale(self.codeview.transform, 3, 3);
    [UIView commitAnimations];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [Factory hidentabar];//隐藏tabar
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = navigationYellowColor;
    //navigationBar延展性并设置透明
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    //隐藏导航栏的分割线
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)]];
    [Factory navgation:self];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = navigationColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}

@end
