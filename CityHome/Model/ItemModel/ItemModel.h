//
//  ItemModel.h
//  CityJinFu
//
//  Created by xxlc on 16/9/11.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject
@property (nonatomic, strong) NSNumber *ID;//项目ID
@property (nonatomic, strong) NSString *itemName;//项目名称
@property (nonatomic, strong) NSDecimalNumber *itemRate;//利率
@property (nonatomic, strong) NSDecimalNumber *itemAddRate;//加息利率
@property (nonatomic, strong) NSDecimalNumber *itemCycle;//期限
@property (nonatomic, strong) NSDecimalNumber *itemAccount;//项目总金额
@property (nonatomic, strong) NSDecimalNumber *itemOngoingAccount;//项目已投金额
@property (nonatomic, strong) NSDecimalNumber *itemRepayMethod;//还款方式
@property (nonatomic, strong) NSDecimalNumber *itemCycleUnit;//天、月
@property (nonatomic, strong) NSString *itemSecondName;//二级标题
@property (nonatomic, strong) NSNumber *itemStatus;
@property (nonatomic, strong) NSNumber *countdown;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
