//
//  NoticeView.h
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeView : UIView
@property (nonatomic, strong) UISwitch *swith;

- (void)whetherSms:(NSString *)whetherSms andwhetherSiteMail:(NSString *)whetherSiteMail andwhetherAppPush:(NSString *)whetherAppPush;

@end
