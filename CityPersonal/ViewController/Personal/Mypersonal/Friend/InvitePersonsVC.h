//
//  InvitePersonsVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^refreshHeaderData)();

@interface InvitePersonsVC : UIViewController

@property (nonatomic, copy) refreshHeaderData refreshHeaderData;

@end
