//
//  ItemTypeVC.h
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTypeVC : UIViewController
@property (nonatomic, copy) NSString *itemId;//项目ID
@property (nonatomic, copy) NSString *percentLabelText;//预期年化
@property (nonatomic, strong) NSString *itemAddRateText;//活动福利
@property (nonatomic, copy) NSString *itemNameText;//项目标题
@property (nonatomic, copy) NSString *itemTypeText;//项目副标题
@property (nonatomic, copy) NSString *itemRepayMethod;//还款方式
@property (nonatomic, copy) NSString *sumLabelText;//项目总额
@property (nonatomic, copy) NSString *itemOngoingLabelText;//已投资金
@property (nonatomic, copy) NSString *timeLabelText;//投资期限
@property (nonatomic, copy) NSString *itemType; //项目类型
@property (nonatomic) NSInteger countDown;//倒计时时间
@property (nonatomic, strong) NSString *password;//定向标
@property (nonatomic, strong) NSString *itemCycleUnit;//天还是月
@property (nonatomic, assign) NSInteger fTag;//防止复用

@property (nonatomic, assign) NSInteger itemTag;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSNumber *itemStatus;//项目状态
@property (nonatomic, strong) NSString *dataStr;//标开抢的时间

@end
