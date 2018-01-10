//
//  DirectionScrollView.h
//  YBScrollView
//
//  Created by mic on 2017/8/31.
//  Copyright © 2017年 zhangjianbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,Direction) {
    DirectionNon=0,
    DirectionUp,//向上滚动
    DirectionDown,//向下滚动
    
};

@interface DirectionScrollView : UIScrollView

@property (nonatomic, assign)Direction direction;
@property (nonatomic, assign) BOOL enableDirection;

@end
