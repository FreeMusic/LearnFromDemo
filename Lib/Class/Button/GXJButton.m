//
//  GXJButton.m
//  BtnTest
//
//  Created by 轩瑞 on 2016/9/28.
//  Copyright © 2016年 轩瑞. All rights reserved.
//

#import "GXJButton.h"

static const NSTimeInterval defaultDuration = 3.0f;
static BOOL _isIgnoreEvent = NO;
static void resetState()
{
    _isIgnoreEvent = NO;
}
@implementation GXJButton

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    _time = _time == 0 ? defaultDuration : _time;
    
    if (_isIgnoreEvent)
    {
        return;
    }
    else if (_time > 0)
    {

        _isIgnoreEvent = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            resetState();
        });
        [super sendAction:action to:target forEvent:event];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:44*m6Scale];
        self.backgroundColor = ButtonColor;
//        self.layer.cornerRadius = 5;
    }
    return self;
}

@end
