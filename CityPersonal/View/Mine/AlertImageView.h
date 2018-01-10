//
//  AlertImageView.h
//  CityJinFu
//
//  Created by xxlc on 17/8/22.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertImageView : UIView
@property(nonatomic,copy)void(^buttonAction)(NSInteger tag);

@end
