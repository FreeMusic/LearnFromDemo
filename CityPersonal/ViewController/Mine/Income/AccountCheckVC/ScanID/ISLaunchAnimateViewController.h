//
//  ISLaunchAnimateViewController.h
//  ISIDReaderCameraPreviewDemo
//
//  Created by Simon Liu on 17/3/1.
//  Copyright © 2017年 xzliu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ISLaunchAnimateType){
    ISLaunchAnimateTypeNone = 0,
    ISLaunchAnimateTypeFade,
    ISLaunchAnimateTypeFadeAndZoomIn,
    ISLaunchAnimateTypePointZoomIn1,
    ISLaunchAnimateTypePointZoomIn2,
    ISLaunchAnimateTypePointZoomOut1,
    ISLaunchAnimateTypePointZoomOut2
};

typedef void(^CompleteBlock)();

@interface ISLaunchAnimateViewController : UIViewController

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) ISLaunchAnimateType animateType;
@property (nonatomic, assign) CGFloat animateDuration;
@property (nonatomic, assign) CGFloat waitDuration;
@property (nonatomic, copy) CompleteBlock complete;
@property (nonatomic, assign) BOOL showSkipButton;

- (instancetype)initWithContentView:(UIView *)contentView animateType:(ISLaunchAnimateType)animateType showSkipButton:(BOOL)showSkipButton;

- (void)show;
- (void)dismissAtOnce;

@end
