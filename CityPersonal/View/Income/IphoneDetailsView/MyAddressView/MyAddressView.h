//
//  MyAddressView.h
//  CityJinFu
//
//  Created by mic on 2017/6/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAddressView : UIView

@property (nonatomic,strong) UILabel *titleLable;//标题标签
@property (nonatomic,strong) UILabel *sureLabel;//请确认标签
@property (nonatomic,strong) UILabel *addressLabel;//地址标签
@property (nonatomic,strong) UILabel *nameLabel;//姓名标签
@property (nonatomic,strong) UILabel *phoneLabel;//电话标签
@property (nonatomic,strong) UIButton *btn;//按钮
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *bgView;

- (void)ViewForAddress:(NSString *)address name:(NSString *)name mobile:(NSString *)mobile;

-(void)showView;
@end
