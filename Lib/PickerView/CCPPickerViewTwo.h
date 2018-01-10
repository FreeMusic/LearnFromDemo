//
//  CCPPickerViewTwo.h
//  CCPPickerView
//
//  Created by CCP on 16/7/7.
//  Copyright © 2016年 CCP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCancelBtn)();

typedef void(^clickSureBtn)(NSString *leftString,NSString *rightString,NSString *leftAndRightString);

@interface CCPPickerViewTwo : UIView

@property (copy,nonatomic) void(^clickCancelBtn)();
@property (copy,nonatomic) void (^clickSureBtn)(NSString *leftString,NSString *rightString,NSString *leftAndRightString);

- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)title andCancel:(NSString *)cancel andSure:(NSString *)sure andtag:(NSInteger)tag;

- (void)pickerVIewClickCancelBtnBlock:(clickCancelBtn)cancelBlock
                          sureBtClcik:(clickSureBtn)sureBlock;

@end
