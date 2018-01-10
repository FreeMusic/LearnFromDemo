//
//  CalendarListModel.h
//  CityJinFu
//
//  Created by mic on 2017/9/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarListModel : NSObject

@property (nonatomic, strong) NSString *itemName;//项目名
@property (nonatomic, strong) NSNumber *itemStatus;//状态 状态（投资状态：0-投资成功 1复审通过 2失败 3-投资已还款） 回款状态（0 还款中 1还款成功）
@property (nonatomic, strong) NSNumber *amount;//本金
@property (nonatomic, strong) NSString *futureIncome;//预期收益
@property (nonatomic, strong) NSNumber *addtime;//时间
@property (nonatomic, strong) NSString *collectId;//回款ID
@property (nonatomic, strong) NSNumber *investId;//投资ID
@property (nonatomic, strong) NSString *type;//类型  投资或回款
//@property (nonatomic, strong) NSNumber *itemCycle;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
