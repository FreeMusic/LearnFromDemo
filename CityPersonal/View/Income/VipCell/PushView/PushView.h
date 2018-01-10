//
//  PushView.h
//  CityJinFu
//
//  Created by mic on 2017/7/4.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushView : UIView

@property (nonatomic, strong) UIView *backView;//背景View
@property (nonatomic, strong) UILabel *pushLabel;//弹窗内容
@property (nonatomic, strong) UIButton *investBtn;//立即投资按钮
@property (nonatomic, strong) UITableView *tableView;

- (void)setPushLabelWithString:(NSString *)content andInvest:(NSString *)invest;

- (void)setTableViewCellByArray:(NSArray *)array;

@end
