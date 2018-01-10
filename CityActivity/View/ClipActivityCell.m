//
//  ClipActivityCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/20.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ClipActivityCell.h"
#import "ClipActivityController.h"
#import "IphoneVC.h"
#import "ContactUsVC.h"
#import "HelpTableViewController.h"
#import "IntegralShopVC.h"
#import "VipVC.h"
#import "NoticeListsVC.h"
#import "NewSignVC.h"

@interface ClipActivityCell ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation ClipActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *picArr = @[@"shangcheng",@"suotou",@"City_公告动态",@"bangzhu"];
        NSArray *titleArr = @[@"积分商城",@"锁投有礼",@"公告动态",@"帮助中心"];
        NSArray *contentArr = @[@"赚积分兑好礼", @"享收益拿豪礼", @"最新活动公告", @"常见问题解答"];
        //竖线
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(1);
        }];
        //横线
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
        [self.contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        for (int i = 0; i < 4; i++) {
            UIView *backView = [[UIView alloc] init];
            [self.contentView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i%2*(kScreenWidth/2));
                make.top.mas_equalTo(i/2*168*m6Scale);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 168*m6Scale));
            }];
            //图标
            _iconImageView = [[UIImageView alloc] init];
            _iconImageView.image = [UIImage imageNamed:picArr[i]];
            [backView addSubview:_iconImageView];
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(30*m6Scale);
                make.centerY.mas_equalTo(backView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(78*m6Scale, 78*m6Scale));
            }];
            //标题标签
            _titleLabel = [Factory CreateLabelWithTextColor:0.2 andTextFont:30 andText:titleArr[i] addSubView:backView];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_iconImageView.mas_right).offset(32*m6Scale);
                make.top.mas_equalTo(45*m6Scale);
            }];
            //标题介绍标签
            _introduceLabel = [Factory CreateLabelWithTextColor:0.8 andTextFont:26 andText:contentArr[i] addSubView:backView];
            [_introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_iconImageView.mas_right).offset(32*m6Scale);
                make.bottom.mas_equalTo(-45*m6Scale);
            }];
            //最上层按钮
            UIButton *btn = [UIButton buttonWithType:0];
            btn.tag = 200+i;
           // btn.exclusiveTouch = YES;
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            [self.contentView bringSubviewToFront:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i%2*(kScreenWidth/2));
                make.top.mas_equalTo(i/2*168*m6Scale);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, 168*m6Scale));
            }];
        }
    }
    
    return self;
}

- (void)buttonAction:(UIButton *)sender{
     ClipActivityController *strVC = (ClipActivityController *)[self ViewController];
    switch (sender.tag) {
        case 200:{
            if ([HCJFNSUser stringForKey:@"userId"]) {
                //积分商城
                ClipActivityController *strVC = (ClipActivityController *)[self.contentView ViewController];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strVC.navigationController.view animated:YES];
                if ([HCJFNSUser stringForKey:@"userId"]) {
                    //兑吧免登陆接口
                    [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
                        [hud hideAnimated:YES];
                        IntegralShopVC *tempVC = [IntegralShopVC new];
                        tempVC.strUrl = obj[@"ret"];
                        [strVC.navigationController pushViewController:tempVC animated:YES];
                    } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
                }
            }else{
                [Factory alertMes:@"请您先登录"];
            }
        }
            break;
        case 201:{
            //锁投有礼
//            if ([HCJFNSUser stringForKey:@"userId"]) {
                IphoneVC *tempVC = [IphoneVC new];
                [strVC.navigationController pushViewController:tempVC animated:YES];
//            }else{
//                //用户未登录 提示用户去登陆
//                [self alterUserLogin];
//            }
            break;
        }
        case 202:{
            //公告动态
            NoticeListsVC *tempVC = [NoticeListsVC new];
            
            [strVC.navigationController pushViewController:tempVC animated:YES];
            break;
        }case 203:{
            //帮助中心
            HelpTableViewController *help = [HelpTableViewController new];
            [strVC.navigationController pushViewController:help animated:YES];
            break;
        }
            
        default:
            break;
    }
}
/**
 *用户未登录 提示用户去登陆
 */
- (void)alterUserLogin{
    ClipActivityController *strVC = (ClipActivityController *)[self ViewController];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NewSignVC *signVC = [[NewSignVC alloc] init];
        signVC.presentTag = @"2";
        [strVC presentViewController:signVC animated:YES completion:nil];
    }]];
    
    [strVC presentViewController:alert animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
