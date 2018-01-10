//
//  MessageCell.h
//  CityJinFu
//
//  Created by xxlc on 16/8/21.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UIView *redView;//红点 标志未读消息

/**
 * 消息中心
 */
- (void)updateCellWithRedModel:(MessageModel *)model andIndexPath:(NSIndexPath *)indexPath;
/**
 * 隐藏红点
 */
- (void)hidRedView;
@end
