//
//  LockView.m
//  test
//
//  Created by 姜姜敏 on 16/7/29.
//  Copyright © 2016年 clip. All rights reserved.
//

#import "LockView.h"
#import "UIView+ViewController.h"


@interface LockView ()

@property (nonatomic, strong) NSMutableArray *imageArray; //存放小图片数组

@property (nonatomic, strong) UILabel *messageLabel; //信息label

@end

@implementation LockView

#pragma mark-懒加载
- (NSMutableArray *)buttons {
    
    if (_buttons==nil) {
        
        _buttons=[NSMutableArray array];
    
    }
         return _buttons;

}

- (NSMutableArray *)btnArray {
    
    if (_btnArray == nil) {
        
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (NSMutableArray *)imageArray {
    
    if (_imageArray == nil) {
        
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
    
}
 //界面搭建
- (id)initWithFrame:(CGRect)frame {
         self = [super initWithFrame:frame];
         if (self) {
             
            self.clipsToBounds = YES;
            
            [self setup];
    }
         return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
         if (self=[super initWithCoder:aDecoder]) {
             self.clipsToBounds = YES;
                 [self setup];
             }
         return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSString *str = change[@"new"];
    
    for (NSInteger i = 0; i < str.length; i ++) {
        
        NSRange range = NSMakeRange(i, 1);
        
        NSString *clip = [str substringWithRange:range];
        
        UIImageView *imageView = self.imageArray[[clip integerValue]];
        
        imageView.image = [UIImage imageNamed:@"clickImage"];
    }
    
    
}

 //在界面上创建9个按钮
- (void)setup {
     
     
     _messageLabel = [[UILabel alloc] init];
     _messageLabel.textColor = [UIColor colorWithRed:119 / 255.0 green:93 / 255.0 blue:17 / 255.0 alpha:1];
     _messageLabel.text = @"至少链接四个点";
     _messageLabel.textAlignment = NSTextAlignmentCenter;
     _messageLabel.font = [UIFont systemFontOfSize:31 * m6Scale];
     [self addSubview:_messageLabel];
     
     UILabel *clipLabel = [[UILabel alloc] init];
     clipLabel.text = @"绘制解锁图案";
     clipLabel.textAlignment = NSTextAlignmentCenter;
     clipLabel.font = [UIFont systemFontOfSize:41 * m6Scale];
     clipLabel.textColor = [UIColor colorWithRed:119 / 255.0 green:93 / 255.0 blue:17 / 255.0 alpha:1];
     [self addSubview:clipLabel];
    
//    for (NSInteger i = 0; i < 9; i ++) {
//        
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.image = [UIImage imageNamed:@"手势圆"];
//        [self addSubview:imageView];
//        
//        //九宫格法计算每个image的frame
//        CGFloat row = i / 3;
//        CGFloat loc   = i % 3;
//        CGFloat imageW = 10;
//        CGFloat imageH = 10;
//        CGFloat imageL = 3;
//        CGFloat imageX =  self.centerX - 1.5 * imageW - imageL + loc * (imageW + imageL);
//        CGFloat imageY = 100 + row * (imageH + imageL);
//        [self.imageArray addObject:imageView];
//        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
//    }
    
         //1.创建9个按钮
         for (int i=0; i<9; i++) {
                 UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                 btn.tag = i;
                 //2.设置按钮的状态背景
                 [btn setBackgroundImage:[UIImage imageNamed:@"手势圆"] forState:UIControlStateNormal];
                 [btn setBackgroundImage:[UIImage imageNamed:@"手势点击圆"] forState:UIControlStateSelected];
                 //3.把按钮添加到视图中
                 [self  addSubview:btn];
                 //4.禁止按钮的点击事件
                 btn.userInteractionEnabled=NO;
             
             //4.3九宫格法计算每个按钮的frame
             CGFloat row = i / 3;
             CGFloat loc   = i % 3;
             CGFloat btnW = 74;
             CGFloat btnH = 74;
             CGFloat padding = (self.frame.size.width- 3 * btnW) / 4;
             CGFloat btnX = padding + (btnW + padding) * loc;
             CGFloat btnY = - padding + (btnW + padding) * row;
             btn.frame = CGRectMake(btnX ,94 + btnY + self.frame.size.height / 4, btnW, btnH);
             
             
             if (i == 0) {
                 
                 [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                     
                     make.bottom.equalTo(btn.mas_top).offset(- self.frame.size.height / 8 + 30);
                     make.centerX.mas_equalTo(self.mas_centerX);
                     
                 }];
                 
                 [clipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                     make.top.equalTo(_messageLabel.mas_bottom).offset(5);
                     make.centerX.mas_equalTo(self.mas_centerX);
                 }];
             
             }
             }
     
}



- (void)refreshView {
    
    for (UIButton *btn in self.buttons) {
        
        btn.selected = NO;
    }
    
    for (UIImageView *imageView in self.imageArray) {
        
        imageView.image = [UIImage imageNamed:@"手势圆"];
        
    }
    
    [self.btnArray removeAllObjects];
    [self.buttons removeAllObjects];
    [self setNeedsDisplay];
    
}

 //4.设置按钮的frame
- (void)layoutSubviews {
         //4.1需要先调用父类的方法
        [super layoutSubviews];
    
}

 //5.监听手指的移动
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
         CGPoint starPoint=[self getCurrentPoint:touches];
         UIButton *btn=[self getCurrentBtnWithPoint:starPoint];
    
         if (btn && btn.selected != YES) {
            btn.selected=YES;
            [self.buttons addObject:btn];
             NSString *clipTag = [NSString stringWithFormat:@"%li",(long)btn.tag];
             
             [self.btnArray addObject:clipTag];
             }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
 {
     
     
         CGPoint movePoint=[self getCurrentPoint:touches];
         UIButton *btn=[self getCurrentBtnWithPoint:movePoint];
         //存储按钮
         //已经连过的按钮，不可再连
         if (btn && btn.selected != YES) {
             
                 //设置按钮的选中状态
                 btn.selected=YES;
                 //把按钮添加到数组中
                 [self.buttons addObject:btn];
             NSString *clipTag = [NSString stringWithFormat:@"%li",(long)btn.tag];
             
             [self.btnArray addObject:clipTag];
             
             
             }
         //通知view重新绘制
         [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
   
    NSInteger clip = 0;
    
    NSMutableArray *numArray = [NSMutableArray array];
    
    for (UIButton *btn in self.buttons) {
        
        NSString *str = [NSString stringWithFormat:@"%li",(long)btn.tag];
        
        [numArray addObject:str];
    }

    
    
    if (numArray.count < 4) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手势密码至少链接4个点" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self refreshView];
        }]];
        
        
        [self.ViewController presentViewController:alert animated:YES completion:nil];
    } else {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        NSArray *secondArray = [user objectForKey:@"clipPassword"];
        
        if (secondArray) {
            
            //判断前后数组个数是否相同
            if (secondArray.count != numArray.count) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次手势密码不一致" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self refreshView];
                }]];
                
                [self.ViewController presentViewController:alert animated:YES completion:nil];
            }else {
                
                
                for (NSInteger i = 0; i < numArray.count; i ++) {
                    
                    if (! [numArray[i] isEqualToString:secondArray[i]]) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次手势密码不一致" preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [self refreshView];
                        }]];
                        
                        [self.ViewController presentViewController:alert animated:YES completion:nil];
                        
                    }else {
                        
                        
                        clip ++;
                    }
                    
                    
                    if (clip == numArray.count) {
                        
                        MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.ViewController.navigationController.view animated:YES];
                        hud2.mode = MBProgressHUDModeCustomView;
                        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        //                        hud2.contentColor = [UIColor whiteColor];
                        hud2.customView = [[UIImageView alloc] initWithImage:image];
                        hud2.square = YES;
                        //                        hud2.bezelView.backgroundColor = [UIColor blackColor];
                        hud2.label.text = NSLocalizedString(@"设置成功", @"HUD done title");
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [hud2 hideAnimated:YES];
//                            [user setObject:numArray forKey:@"gesturePassword"];

                                [user setValue:@"YES" forKey:@"gestureLock"];
                                [user setValue:@"NO" forKey:@"fingerSwitch"];
                            
                            [user synchronize];
                            
                            [DownLoadData postChangeSystemSetting:^(id obj, NSError *error) {
                                
                                NSLog(@"%@",obj);
                                
                            } userId:[user objectForKey:@"userId"] gesture:@"1" touchID:@"0" accountProtect:@"0"];
                            
                            NSString *gestureClip = @"";
                            
                            for (NSString *str in numArray) {
                                
                                
                                gestureClip = [gestureClip stringByAppendingString:str];
                            }
                      [DownLoadData postUpdateGesture:^(id obj, NSError *error) {
    
                          NSLog(@"%@",obj);
                          
                         } userId:[user objectForKey:@"userId"] newGesture:gestureClip];
                            
                            [self.ViewController.navigationController popViewControllerAnimated:YES];
                        });
                        
                    }
                    
                }
                
            }
            
        } else {
            
            [user setValue:numArray forKey:@"clipPassword"];
            [user synchronize];
            
            self.messageLabel.text = @"请再次确认密码";
            
            [self refreshView];
            
        }
                
        
    }
    
}
 //对功能点进行封装
- (CGPoint)getCurrentPoint:(NSSet *)touches {
         UITouch *touch=[touches anyObject];
         CGPoint point=[touch locationInView:touch.view];
         return point;
}

- (UIButton *)getCurrentBtnWithPoint:(CGPoint)point {
    
         for (UIView *btn in self.subviews) {
             
             if ([btn isKindOfClass:NSClassFromString(@"UIButton")]) {
                 
                 if (CGRectContainsPoint(btn.frame, point)) {
                     return (UIButton *)btn;
                 }
             }
             
        }
         return nil;
}

 //重写drawrect:方法
- (void)drawRect:(CGRect)rect {
         //获取上下文
         CGContextRef ctx = UIGraphicsGetCurrentContext();
         //绘图（线段）
         for (NSInteger i = 0; i < self.buttons.count; i++) {
             
                 UIButton *btn=self.buttons[i];
             
                 if (i == 0) {
                         //设置起点（注意连接的是中点）
             //            CGContextMoveToPoint(ctx, btn.frame.origin.x, btn.frame.origin.y);
                         CGContextMoveToPoint(ctx, btn.center.x, btn.center.y);
                    }else
                         {
                     //            CGContextAddLineToPoint(ctx, btn.frame.origin.x, btn.frame.origin.y);
                                 CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
                             }
             }
         //渲染
         //设置线条的属性
         CGContextSetLineWidth(ctx, 3);
         CGContextSetRGBStrokeColor(ctx, 255 / 255.0, 167/255.0, 79/255.0, 1);
         CGContextStrokePath(ctx);
}


        
@end
