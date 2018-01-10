//
//  ItemListModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/15.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemListModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *itemRate;//利率
@property (nonatomic, strong) NSString *itemName;//名称
@property (nonatomic,strong) NSNumber *itemCycle;//天数
@property (nonatomic,strong) NSNumber *itemCycleUnit;//期限单位
@property (nonatomic,strong) NSNumber *itemIsrecommend;//是否推荐：0-否 1-推荐表（优先）
@property (nonatomic,strong) NSNumber *moveVip;//是否移动专享0-否1-是'(优先)
@property (nonatomic,strong) NSString *password;//如果是null 或者 ''则不是定向标 反之是定向标（优先1）
@property (nonatomic, strong) NSNumber *itemStatus;//标的状态
@property (nonatomic, strong) NSNumber *itemIsnew;//新手推荐
@property (nonatomic, strong) NSString *itemScale;//标的进度百分比

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
