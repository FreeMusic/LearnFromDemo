//
//  ShopBannerModel.h
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopBannerModel : NSObject

@property (nonatomic, strong) NSString *picturePath;//图片地址
@property (nonatomic, strong) NSString *pictureUrl;//图片跳转链接
@property (nonatomic, strong) NSString *pictureName;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
