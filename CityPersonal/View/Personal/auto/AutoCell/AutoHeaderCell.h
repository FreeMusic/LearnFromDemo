//
//  AutoHeaderCell.h
//  CityJinFu
//
//  Created by xxlc on 17/5/24.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoHeaderCell : UITableViewCell
@property (nonatomic, strong) UIImageView *firstImage;
@property (nonatomic, strong) UIImageView *secondImage;
@property (nonatomic, strong) UILabel *titileFirLab;
@property (nonatomic, strong) UILabel *titileSecLab;
@property (nonatomic, strong) UILabel *rankingLab;//排名
@property (nonatomic, strong) UILabel *moneyLab;//金额

- (void)cellForRank:(NSString *)rank Account:(NSString *)account;

@end
