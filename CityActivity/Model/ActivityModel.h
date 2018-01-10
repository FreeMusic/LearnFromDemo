//
//  ActivityModel.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/10/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic, copy) NSString *picturePath;//图片路径
@property (nonatomic, copy) NSString *pictureUrl;//图片链接
@property (nonatomic, copy) NSString *pictureName;//图片名称

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
