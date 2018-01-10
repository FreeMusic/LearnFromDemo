//
//  AlertView.h
//  UIalertView
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewDelegate <NSObject>


@optional

-(void)clickButton:(NSInteger)index;

@end

@interface AlertView : UIView

@property(nonatomic,copy)void (^GlodeBottomView)(NSInteger index ,NSString *string);
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)id<AlertViewDelegate>delegate;

+(id)GlodeBottomView;

-(void)show;

@end
