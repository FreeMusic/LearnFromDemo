//
//  AwardAndInviteVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AwardAndInviteVC.h"
#import "AwardDetailsVC.h"
#import "InvitePersonsVC.h"
#import "FatherVC.h"
#import "InviteFriendModel.h"

@interface AwardAndInviteVC ()<UIScrollViewDelegate>

@property(nonatomic, strong) AwardDetailsVC *award;
@property (nonatomic,strong) InvitePersonsVC *invite;
@property (nonatomic,strong) UIScrollView *contentView;
@property (nonatomic, strong) FatherVC *father;
@property (nonatomic, strong) UILabel *titleLabel;//弹出视图标题标签
@property (nonatomic, strong) InviteFriendModel *inviteFriendModel;
/**
 红包奖励
 */
@property (nonatomic, strong) UILabel *redLabel;
@property (nonatomic, strong) UILabel *accountLabel;//佣金奖励
@property (nonatomic, strong) UILabel *inviteLabel;//邀请奖励

@end

@implementation AwardAndInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"奖励明细"];
    
    self.view.backgroundColor = Colorful(242, 242, 242);
    
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    if (self.type.integerValue) {
        self.father.contentView.contentOffset = CGPointMake(0, 0);
        
    }else{
        self.father.contentView.contentOffset = CGPointMake(0, 0);
    }
    
    //弹出视图标题标签
    _titleLabel = [Factory CreateLabelWithColor:[UIColor colorWithWhite:0.4 alpha:1] andTextFont:30 andText:@"已邀请0位好友,共获得0元现金奖励。" addSubView:self.view];
    [Factory ChangeColorStringArray:@[@"0", @"0"] andLabel:_titleLabel andColor:buttonColor];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30*m6Scale);
        make.left.mas_equalTo(30*m6Scale);
    }];
    //奖励详情View
    [self awardDetailsView];
    //请求数据
    //[self loadData];
    
    //导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    [Factory navgation:self];
    [Factory hidentabar];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KSafeBarHeight+70*m6Scale);
    }];
    //奖励说明
    UILabel *label = [Factory CreateLabelWithColor:[UIColor colorWithWhite:0.3 alpha:0.7] andTextFont:28 andText:@"注:奖励以实际发放时间为准，如有疑问可咨询客服。" addSubView:view];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-KSafeBarHeight-15*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}
/**
 * 奖励详情View
 */
- (void)awardDetailsView{
    
    UIView *awardDetailsView = [[UIView alloc] init];
    awardDetailsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:awardDetailsView];
    [awardDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(30*m6Scale);
        make.height.mas_equalTo(155*m6Scale);
    }];
    
    NSArray *array = @[@"红包奖励(元)", @"佣金奖励(元)", @"邀请奖励(元)"];
    CGFloat width = kScreenWidth/3;
    for (int i = 0; i < array.count; i++) {
    
        UILabel *label = [Factory CreateLabelWithColor:[UIColor colorWithWhite:0.4 alpha:1] andTextFont:28 andText:array[i] addSubView:awardDetailsView];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.left.mas_equalTo(i*width);
            make.bottom.mas_equalTo(-25*m6Scale);
        }];
        
        UILabel *numLabel = [Factory CreateLabelWithColor:buttonColor andTextFont:32 andText:@"0" addSubView:awardDetailsView];
        numLabel.textAlignment = NSTextAlignmentCenter;
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.left.mas_equalTo(i*width);
            make.bottom.mas_equalTo(label.mas_top).offset(-25*m6Scale);
        }];
        
        if (i) {
            UIView *line = [UIView new];
            line.backgroundColor = LineColor;
            [awardDetailsView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(1, 70*m6Scale));
                make.centerY.mas_equalTo(awardDetailsView.mas_centerY);
                make.left.mas_equalTo(i*width);
            }];
        }
        
        if (i == 0) {
            _redLabel = numLabel;
        }else if (i == 1){
            _accountLabel = numLabel;
        }else{
            _inviteLabel = numLabel;
        }
    }
}
/**
 *  请求数据
 */
- (void)loadData{
    //邀请好友首页
    [DownLoadData postInviteFriendByUserId:^(id obj, NSError *error) {
        _inviteFriendModel = [[InviteFriendModel alloc] initWithDictionary:obj];
        //邀请人数
        NSString *num = [NSString stringWithFormat:@"%d", _inviteFriendModel.invitePersons.intValue];
        //获得 奖励
        _redLabel.text = [NSString stringWithFormat:@"%d", _inviteFriendModel.inviteRewards.intValue];
        //佣金奖励
        _accountLabel.text = [NSString stringWithFormat:@"%.2f", _inviteFriendModel.inviteInvestAmount.doubleValue];
        //邀请奖励
        _inviteLabel.text = [NSString stringWithFormat:@"%d", _inviteFriendModel.invitePersonReward.intValue];
        //用户邀请总共获得的金额
        NSString *total = [NSString stringWithFormat:@"%.2f", _inviteFriendModel.inviteInvestAmount.doubleValue+_inviteFriendModel.invitePersonReward.doubleValue];
        _titleLabel.text = [NSString stringWithFormat:@"已邀请%@位好友,共获得%@元现金奖励。", num, total];
        [Factory ChangeColorStringArray:@[num, total] andLabel:_titleLabel andColor:buttonColor];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *父控制器
 */
- (FatherVC *)father{
    if(!_father){
        //奖励明细
        _award = [AwardDetailsVC new];
        _award.title = @"奖励明细";
        
        //邀请人数
        _invite = [InvitePersonsVC new];
        _invite.title = @"邀请人数";
        
        __weak typeof(self) weakSelf = self;
        [_invite setRefreshHeaderData:^{
            
            [weakSelf loadData];
        }];
        [_award setRefreshHeaderData:^{
            [weakSelf loadData];
        }];
        //数组
        NSArray *subViewControllers;
        if (_type.intValue) {
            subViewControllers = @[_invite, _award];
        }else{
            subViewControllers = @[_award, _invite];
        }
        _father = [[FatherVC alloc]initWithSubViewControllers:subViewControllers];
        _father.view.frame = CGRectMake(0, 275*m6Scale, kScreenWidth, kScreenHeight-275*m6Scale-KSafeBarHeight-70*m6Scale);
        
        [self.view addSubview:_father.view];
        [self addChildViewController:_father];
    }
    return _father;
}
/**
 *按钮的点击事件
 */
- (void)buttonAction:(UIButton *)sender{
    if (sender.tag == 200) {
        //奖励明细
        self.contentView.contentOffset = CGPointMake(0, 0);
    }else{
        //邀请人数
        self.contentView.contentOffset = CGPointMake(kScreenWidth, 0);
    }
}
@end
