//
//  ScanUserIDCard.m
//  CityJinFu
//
//  Created by mic on 2017/10/31.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "ScanUserIDCard.h"
#import <ISOpenSDKFoundation/ISOpenSDKFoundation.h>
#import <ISIDReaderPreviewSDK/ISIDReaderPreviewSDK.h>

@interface ScanUserIDCard () <CAAnimationDelegate, ISOpenSDKCameraViewControllerDelegate>

@end

@implementation ScanUserIDCard

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *appKey = ScanIdAPPKey;
    NSString *subAppkey = nil;//reserved for future use
    ISOpenSDKCameraViewController *cameraVC = [[ISIDCardReaderController sharedISOpenSDKController] cameraViewControllerWithAppkey:appKey subAppkey:subAppkey needCompleteness:YES];
    cameraVC.needShowBackButton = YES;
    cameraVC.customInfo = @"请将身份证放在框内识别";
    //cameraVC.shouldHightlightCorners = YES;
    cameraVC.delegate = self;
    
    [self setUpLaunchView];
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
    
    UILabel *versionLab = [[UILabel alloc] init];
    versionLab.backgroundColor = [UIColor blackColor];
    versionLab.layer.masksToBounds = YES;
    versionLab.layer.cornerRadius = 15;
    versionLab.layer.borderWidth=1.0f;
    versionLab.text = NSLocalizedString(@"ID Card Preview:v5.0", @"身份证预览v5.0");
    versionLab.textColor = [UIColor whiteColor];
    versionLab.font = [UIFont systemFontOfSize:15.0f];
    versionLab.textAlignment = NSTextAlignmentCenter;
    CGFloat y_f = imageView.frame.size.height*4/5;
    versionLab.frame = CGRectMake((imageView.frame.size.width-200)/2, y_f, 200, 30);
    [imageView addSubview:versionLab];
    
//    ISLaunchAnimateViewController *launchCtrl = [[ISLaunchAnimateViewController alloc]initWithContentView:launchView animateType:ISLaunchAnimateTypePointZoomOut2 showSkipButton:YES];
//    [launchCtrl show];
}

@end
