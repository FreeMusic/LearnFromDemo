//
//  MyAddrseeCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddrseeCell : UITableViewCell

@property (nonatomic, strong) UITextField *textFiled;//输入框

- (void)cellForAddress:(NSString *)address;

@end
