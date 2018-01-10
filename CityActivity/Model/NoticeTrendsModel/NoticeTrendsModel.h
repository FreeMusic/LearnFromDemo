//
//  NoticeTrendsModel.h
//  CityJinFu
//
//  Created by mic on 2017/6/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeTrendsModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;//标题
@property (nonatomic, strong) NSString *content;//内容
@property (nonatomic, strong) NSNumber *addtime;//添加时间
@property (nonatomic, strong) NSString *author;//作者
@property (nonatomic, strong) NSString *picturePath;//图片链接地址
@property (nonatomic, strong) NSString *summary;//公告内容简介

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
