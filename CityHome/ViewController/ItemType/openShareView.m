//
//  openShareView.m
//  CityJinFu
//
//  Created by mic on 16/9/29.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#define scrollViewHEIGHT 600*m6Scale
#define leftMargin (kScreenWidth-100*m6Scale*3)/6
#import "openShareView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "UIView+ViewController.h"
#import "FL_Button.h"

#import <MessageUI/MessageUI.h>

@interface openShareView ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) FL_Button *btn;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation openShareView{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createMyView:frame];
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    }
    return self;
}

- (void)createMyView:(CGRect)frame
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-scrollViewHEIGHT, self.frame.size.width, scrollViewHEIGHT)];
    _scrollView.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:1.0];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.contentSize = CGSizeMake(CGFloat width, 80);
    [self addSubview:_scrollView];
    
//    UIColor *blue=UIColorFromRGB(0x4799dd);
    //分享到字样
    UILabel *label = [[UILabel alloc]init];
    label.text = @"分享到";
    label.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:30*m6Scale];
    [_scrollView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_scrollView.mas_centerX);
        make.top.mas_equalTo(_scrollView.mas_top).mas_equalTo(30*m6Scale);
    }];
    int buttonWidth=100*m6Scale;
    if(buttonWidth>80){
        buttonWidth=80;
    }

    for (int i = 0; i < 5; i ++) {
        
        
        _btn=[FL_Button fl_shareButton];

        if (i < 3) {
            _btn.frame=CGRectMake(leftMargin * ((i + 1) * 2 - 1) + buttonWidth * i, 130*m6Scale, buttonWidth, buttonWidth+34*m6Scale);
        } else if (i == 1) {
            _btn.frame=CGRectMake(leftMargin, 160*m6Scale+94*m6Scale, buttonWidth, 120*m6Scale);
        }
        else {
            _btn.frame=CGRectMake(leftMargin * ((i - 2) * 2 - 1) + buttonWidth * (i-3), 210*m6Scale+buttonWidth, buttonWidth, buttonWidth+34*m6Scale);
        }
        
        if (i == 0) {
            [_btn setBackgroundImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        } else if (i == 1) {
            [_btn setBackgroundImage:[UIImage imageNamed:@"微信朋友圈"] forState:UIControlStateNormal];
        } else if (i == 2) {
            [_btn setBackgroundImage:[UIImage imageNamed:@"手机QQ"] forState:UIControlStateNormal];
        } else if (i == 3) {
            [_btn setBackgroundImage:[UIImage imageNamed:@"QQ空间"] forState:UIControlStateNormal];
        }
        else if (i == 5) {
            [_btn setBackgroundImage:[UIImage imageNamed:@"SendMessage"] forState:UIControlStateNormal];
        }
        else  if(i == 4){
            [_btn setBackgroundImage:[UIImage imageNamed:@"新浪微博"] forState:UIControlStateNormal];
        }
        [_scrollView addSubview:_btn];
        [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn.tag=i+1;
    }
    //中间的分割线
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = backGroundColor.CGColor;
    layer.bounds = CGRectMake(20*m6Scale, 95*m6Scale, self.frame.size.width-40*m6Scale, 1);
    layer.position = CGPointMake(20*m6Scale, 95 * m6Scale);
    layer.anchorPoint = CGPointMake(0, 0.5);
    [_scrollView.layer addSublayer:layer];
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:0];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:34*m6Scale];
    [cancelButton setTitleColor:[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 4.0;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelButton.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1.0];
    [_scrollView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(690 * m6Scale, 80 * m6Scale));
        make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(-30*m6Scale);
    }];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([self.clipTag isEqualToString:@"0"]) {
        
        UINavigationController *navi = [[delegate.leveyTabBarController viewControllers] objectAtIndex:1];
        
        [[navi.viewControllers lastObject] dismissViewControllerAnimated:YES completion:nil];
        
    }else if ([self.clipTag isEqualToString:@"4"]) {
        
        UINavigationController *navi = [[delegate.leveyTabBarController viewControllers] objectAtIndex:0];
        
        [[navi.viewControllers lastObject] dismissViewControllerAnimated:YES completion:nil];
        
    }
    else {
        
        UINavigationController *navi = [[delegate.leveyTabBarController viewControllers] lastObject];
        
       [[navi.viewControllers lastObject] dismissViewControllerAnimated:YES completion:nil];
        
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    switch (result) {
        case MessageComposeResultSent:
            //信息发送成功
            
            if ([self.clipTag isEqualToString:@"4"]) {
                
                [DownLoadData postShareMessage:^(id obj, NSError *error) {
                    
                    if ([obj[@"result"] isEqualToString:@"success"]) {
                        
                        hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                        hud.label.text = NSLocalizedString(@"发送成功", @"HUD done title");
                        [hud hideAnimated:YES afterDelay:1.5];
                    }
                    
                } userId:[user objectForKey:@"userId"]];
                
            }else {
                
                hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                hud.label.text = NSLocalizedString(@"发送成功", @"HUD done title");
                [hud hideAnimated:YES afterDelay:1.5];
            }
            
            break;
        case MessageComposeResultFailed:
            //信息发送失败
            hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WrongMark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            hud.label.text = NSLocalizedString(@"发送失败", @"HUD done title");
            [hud hideAnimated:YES afterDelay:1.5];
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消发送
            hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WrongMark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            hud.label.text = NSLocalizedString(@"取消发送", @"HUD done title");
            [hud hideAnimated:YES afterDelay:1.5];
            break;
        default:
            break;
    }
    
}

//取消
- (void)cancelButton:(UIButton *)sender
{
    [self removeFromSuperview];
}
- (void)hideView:(UITapGestureRecognizer *)sender {

    [self removeFromSuperview];
}

-(void)btnClicked:(UIButton*)btn {
      NSLog(@"%@, %@",self.urlName, self.strUrl);

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (self.clickCancelBtn) {
        self.clickCancelBtn();
    }
    
    if (btn.tag == 6) {
        if (self.cannotShare) {
            
        }else{
            //发送短信
            if ([MFMessageComposeViewController canSendText]) {
                
                MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
                messageVC.body = @"你好，汇诚金服~";
                messageVC.messageComposeDelegate = self;
                if (self.sendMessage) {
                    
                    messageVC.body = self.sendMessage;
                }
                //活动页面跳转
                if ([self.clipTag isEqualToString:@"0"]) {
                    
                    UINavigationController *navi = [[delegate.leveyTabBarController viewControllers] objectAtIndex:0];
                    
                    [[navi.viewControllers lastObject] presentViewController:messageVC animated:YES completion:nil];
                    
                }else if ([self.clipTag isEqualToString:@"4"]) {
                    
                    
                    UINavigationController *navi = [[delegate.leveyTabBarController viewControllers] objectAtIndex:0];
                    
                    [[navi.viewControllers lastObject] presentViewController:messageVC animated:YES completion:nil];
                    
                    
                }
                else {
                    
                    UINavigationController *navi = [[delegate.leveyTabBarController viewControllers] lastObject];
                    
                    [[navi.viewControllers lastObject] presentViewController:messageVC animated:YES completion:nil];
                    
                }
                
            }
            
            
            //        UIView *view;
            //        if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
            //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            //        hud.contentColor = [UIColor grayColor];
            //        hud.label.text = @"配置有误";
            //        hud.mode = MBProgressHUDModeText;
            //        hud.removeFromSuperViewOnHide = YES;
            //        [hud hideAnimated:YES afterDelay:1.0];
        }

    } else if (btn.tag == 3) {
        // QQ好友
        if (self.cannotShare) {
            
        }else{
            [self share:SSDKPlatformSubTypeQQFriend];
        }
        

    } else if (btn.tag == 4) {
        // QQ空间
        if (self.cannotShare) {
            
        }else{
            [self share:SSDKPlatformSubTypeQZone];
        }
        

    } else if (btn.tag == 1) {
//        [DownLoadData postShare:^(id obj, NSError *error) {
//
//        } userId:[HCJFNSUser stringForKey:@"userId"] isBanner:self.isBanner];
        // 微信好友
        [self share:SSDKPlatformSubTypeWechatSession];

    } else if (btn.tag == 2) {
//        [DownLoadData postShare:^(id obj, NSError *error) {
//
//        } userId:[HCJFNSUser stringForKey:@"userId"] isBanner:self.isBanner];
        // 微信圈
        [self share:SSDKPlatformSubTypeWechatTimeline];

    } else if (btn.tag == 5) {
        if (self.cannotShare) {
            
        }else{
            //新浪微博
            [self share:SSDKPlatformTypeSinaWeibo];
        }
        

    }
    
}


-(void)share:(SSDKPlatformType)type
{
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.bodyMessage
                                     images:[UIImage imageNamed:@"57-57"]
                                        url:[NSURL URLWithString:self.strUrl]
                                      title:self.urlName
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error)
     {
         switch (state)
         {
             case SSDKResponseStateSuccess:
             {
                 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                
                 if ([self.clipTag isEqualToString:@"4"]) {
                     
                     if ([user objectForKey:@"userId"]) {
                         
                         [DownLoadData postShareMessage:^(id obj, NSError *error) {
                             
                             if ([obj[@"result"] isEqualToString:@"success"]) {
                                 
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                     message:nil
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"确定"
                                                                           otherButtonTitles:nil];
                                 [alertView show];
                                 
                                 
                             }
                             
                         } userId:[user objectForKey:@"userId"]];
                         
                     }
                     
                 }else {
                     
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确定"
                                                               otherButtonTitles:nil];
                     [alertView show];
                     
                     
                 }
                 
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                 message:nil
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
                 [alert show];
                 break;
             }
             default:
                 break;
         }
     }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
