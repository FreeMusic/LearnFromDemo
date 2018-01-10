  //
//  AuthenticationVC.m
//  CityJinFu
//
//  Created by mic on 2017/11/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AuthenticationVC.h"
#import "FinalDecisionVC.h"
#import <ZMCert/ZMCert.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WithdrawalVC.h"
#import "HumanReViewVC.h"

#define IsZMCertVideo true

@interface AuthenticationVC ()

@property (nonatomic, strong) NSString  *isSuccess;//人脸识别的结果 1 成功 0 失败

@end

@implementation AuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"身份认证"];
    
    self.color = BackColor_black;
    //UI页面
    [self allocInitAuthenticationUI];
}
/**
 *  返回按钮的点击事件
 */
- (void)onClickLeftItem{
    if (_reviewType == NeedReview_YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  UI页面
 */
- (void)allocInitAuthenticationUI{
    //身份认证大图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-517*m6Scale)/2, 112*m6Scale, 517*m6Scale, 517*m6Scale)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LargeAmountRechange_矢量智能对象@2x" ofType:@"png"];
    imageView.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:imageView];
    
    //立即验证按钮
    UIButton *button = [Factory ButtonWithTitle:@"立即验证" andTitleColor:[UIColor whiteColor] andButtonbackGroundColor:navigationYellowColor andCornerRadius:5 addTarget:self action:@"atOnceVerifyButtonClick" addSubView:self.view];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).offset(128*m6Scale);
        make.size.mas_equalTo(CGSizeMake(585*m6Scale, 86*m6Scale));
    }];
    
    //描述文字
    UILabel *label = [Factory CreateLabelWithColor:UIColorFromRGB(0x999999) andTextFont:26 andText:@"1、为了您的账户资金安全，请先进行安全验证；\n2、请本人亲自完成，将脸部置于提示框内，并按提示做动作。" addSubView:self.view];
    label.numberOfLines = 0;
    [Factory changeLineSpaceForLabel:label WithSpace:5];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(585*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        if (_reviewType == NeedReview_YES) {
            make.top.mas_equalTo(button.mas_bottom).offset(150*m6Scale);
        }else{
            make.top.mas_equalTo(button.mas_bottom).offset(94*m6Scale);
        }
    }];
    
    if (_reviewType == NeedReview_YES) {
        //创建人工审核按钮
        [self HumanReViewButton:button];
    }
}
/**
 *  创建人工审核按钮
 */
- (void)HumanReViewButton:(UIButton *)btn{
    
    UIButton *button = [UIButton buttonWithType:0];
    [button setTitle:@"人工审核" forState:0];
    button.layer.cornerRadius = 5*m6Scale;
    button.buttonShapeType = ButtonShapeTypeWithLine;
    [button addTarget:self action:@selector(reviewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(btn.mas_bottom).offset(35*m6Scale);
        make.size.mas_equalTo(CGSizeMake(585*m6Scale, 86*m6Scale));
    }];
}
/**
 *  人工审核按钮 点击事件
 */
- (void)reviewButtonClick{
    HumanReViewVC *tempVC = [[HumanReViewVC alloc] init];
    
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *立即验证按钮点击事件
 */
- (void)atOnceVerifyButtonClick{
    //    FinalDecisionVC *tempVC = [[FinalDecisionVC alloc] init];
    //
    //    [self.navigationController pushViewController:tempVC animated:YES];
    ZMCertification *manager = [[ZMCertification alloc] init];
    __weak AuthenticationVC *weakSelf = self;
    
//    #if IsZMCertVideo
//    //  录制动作检测录像
//    [manager startVideoWithBizNO:self.bizNo
//                      merchantID:MerchantID
//                       extParams:@{@"RecordVideo" : [NSNumber numberWithBool:YES]}
//                  viewController:self
//                        onFinish:^(BOOL isCanceled, BOOL isPassed, ZMStatusErrorType errorCode, NSString * _Nullable videoPath) {
//                            if (videoPath) {
//                                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
//                                [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:videoPath]
//                                                                  completionBlock:^(NSURL *assetURL, NSError *error) {
//                                                                      if (error) {
//                                                                          NSLog(@"Save video fail:%@",error);
//                                                                      } else {
//                                                                          NSLog(@"Save video succeed.");
//                                                                      }
//                                                                  }];
//                            }
//                            if (isCanceled) {
//                                NSLog(@"用户取消了认证");
//                                //   weakSelf.resultView.text = [NSString stringWithFormat:@"用户取消了认证！"];
//                            } else {
//                                if (isPassed) {
//                                    NSLog(@"认证成功");
//                                    //       weakSelf.resultView.text = [NSString stringWithFormat:@"认证成功"];
//                                } else {
//                                    NSLog(@"认证失败了 %zi", errorCode);
//                                    //    weakSelf.resultView.text = [NSString stringWithFormat:@"认证中出现问题--%zi", errorCode];
//                                }
//                            }
//                        }];
//#else
    //  不进行动作检测视频录制
    [manager startWithBizNO:self.bizNo
                 merchantID:MerchantID
                  extParams:nil
             viewController:self
                   onFinish:^(BOOL isCanceled, BOOL isPassed, ZMStatusErrorType errorCode) {
                       if (isCanceled) {
                           NSLog(@"用户取消了认证");
                           // weakSelf.resultView.text = [NSString stringWithFormat:@"用户取消了认证！"];
                       }else{
                           if (isPassed) {
                               NSLog(@"认证成功");
                               self.isSuccess = @"1";
                               //   weakSelf.resultView.text = [NSString stringWithFormat:@"认证成功"];
                               [DownLoadData postDoFaceAuthent:^(id obj, NSError *error) {
                                   NSLog(@"%@", obj[@"messageText"]);
                                   if (self.isSuccess.intValue) {
                                       //用户人脸识别成功
                                       WithdrawalVC *tempVC = [WithdrawalVC new];
                                       tempVC.skipFrom = VCSkipFrom_FaceAuthent;//从人脸识别跳转提现页面
                                       [self.navigationController pushViewController:tempVC animated:YES
                                        ];
                                   }
                               } userId:[HCJFNSUser stringForKey:@"userId"] isSuccess:self.isSuccess];
                           }else{
                               NSLog(@"认证失败了 %zi", errorCode);
                               self.isSuccess = @"0";
                               //   weakSelf.resultView.text = [NSString stringWithFormat:@"认证中出现问题--%zi", errorCode];
                                   [DownLoadData postDoFaceAuthent:^(id obj, NSError *error) {
                                       NSLog(@"%@", obj[@"messageText"]);
                                       if (self.isSuccess.intValue) {
                                           if (_skipFromVC == SkipFromVC_MyCenter) {
                                               //用户人脸识别成功
                                               WithdrawalVC *tempVC = [WithdrawalVC new];
                                               tempVC.skipFrom = VCSkipFrom_FaceAuthent;//从人脸识别跳转提现页面
                                               [self.navigationController pushViewController:tempVC animated:YES
                                                ];
                                           }else{
                                               //提示用户人脸识别成功
                                               [self alertUserSuccess];
                                           }
                                       }
                                   } userId:[HCJFNSUser stringForKey:@"userId"] isSuccess:self.isSuccess];
                               }
                       }
                   }];
//#endif
}
/**
 *   提示用户人脸识别成功
 */
- (void)alertUserSuccess{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已经人脸识别成功。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIViewController *vc = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:vc animated:YES];
    }]];
    
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [Factory hidentabar];
    
    //设置透明度
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    self.navigationController.navigationBar.hidden = NO;
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
