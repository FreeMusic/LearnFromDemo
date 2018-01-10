//
//  AscertainView.h
//  CityJinFu
//
//  Created by mic on 2017/10/10.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举 小图标会出现的 语音识别 和 安全小图标
typedef NS_ENUM(NSUInteger, IconType){
    IconType_Voice,//语音识别
    IconType_Safe//安全小图标
};

typedef void(^GetVoiceCodeBlock)(IconType type, UILabel *label, UIButton *button);

@interface AscertainView : UIView

@property (nonatomic, strong) UIButton *button;//确定按钮

@property (nonatomic, assign) IconType iconType;

@property (nonatomic, strong) NSString *validPhoneExpiredTime;

@property (nonatomic, copy) GetVoiceCodeBlock getVoiceCodeBlock;

@property (nonatomic, strong) UIImageView *imageView;//小图标

@property (nonatomic, strong) UILabel *label;//label

@end
