//
//  MessageModel.h
//  CityJinFu
//
//  Created by mic on 16/10/8.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSNumber *addtime; //时间戳

@property (nonatomic, strong) NSString *title; //标题

@property (nonatomic, strong) NSString *contents; //内容

@property (nonatomic, strong) NSNumber *type;//消息的类型

@property (nonatomic, strong) NSNumber *ID;

@property (nonatomic, strong) NSNumber *status;//状态0-未读 1-已读（用于判断红点）

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
