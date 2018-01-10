//
//  IntergralModel.h
//  CityJinFu
//
//  Created by mic on 2017/7/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntergralModel : NSObject

@property (nonatomic, strong) NSNumber *ID;//
@property (nonatomic, strong) NSNumber *isDelete;//该记录是否展示给用户：1展示，0不展示
@property (nonatomic, strong) NSNumber *addtime;//积分记录添加时间
@property (nonatomic, strong) NSNumber *operationType;//操作类型：1收入，-1支出
@property (nonatomic, strong) NSString *remark;//积分记录描述
@property (nonatomic, strong) NSNumber *operationIntegral;//该笔操作积分
@property (nonatomic, strong) NSString *icon;//图标url

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
