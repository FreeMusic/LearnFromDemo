//
//  HumanReViewVC.m
//  CityJinFu
//
//  Created by mic on 2017/12/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "HumanReViewVC.h"

@interface HumanReViewVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isFullScreen;
}
@property (nonatomic, strong) UIButton *button;//拍照按钮

@property (nonatomic, strong) UIImage *savedImage;//拍照 或者 从相册选择的图片

@end

@implementation HumanReViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.color = BackColor_black;
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"人工审核"];
    //添加拍照按钮
    _button = [UIButton buttonWithType:0];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LargeAmountRechange_矩形17@2x" ofType:@"png"];
    [_button setImage:[UIImage imageWithContentsOfFile:path] forState:0];
    [_button addTarget:self action:@selector(callCameraAndPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(76*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(629*m6Scale, 477*m6Scale));
    }];
    //创建确定按钮 和 描述文字
    [self descriptionLabelEnsureButton:_button];
}
/**
 *  创建确定按钮 和 描述文字
 */
- (void)descriptionLabelEnsureButton:(UIButton *)btn{
    //确定按钮
    UIButton *ensureBtn = [Factory ButtonWithTitle:@"确定" andTitleColor:[UIColor whiteColor] andButtonbackGroundColor:navigationYellowColor andCornerRadius:5 addTarget:self action:@"ensureButtonClick" addSubView:self.view];
    [ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(585*m6Scale, 88*m6Scale));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(btn.mas_bottom).offset(132*m6Scale);
    }];
    //描述文字 标签
    UILabel *label = [Factory CreateLabelWithColor:UIColorFromRGB(0x999999) andTextFont:26 andText:@"1、为了您的账户资金安全，请先进行安全验证；\n2、提交审核后，一般1-2个工作日内审核完成，审核结果可到账户设置-人脸识别查看。如有疑问，请咨询客服。" addSubView:self.view];
    label.numberOfLines = 0;
    [Factory changeLineSpaceForLabel:label WithSpace:4];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(585*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(ensureBtn.mas_bottom).offset(126*m6Scale);
    }];
}
/**
 *  确定按钮的点击事件
 */
- (void)ensureButtonClick{
    if (self.savedImage) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = NSLocalizedString(@"上传图片中...", @"HUD loading title");
        NSData *file = UIImageJPEGRepresentation(self.savedImage, 0.9);
        
        AFAppDotNetAPIClient *manager = [Factory accessToken];
        manager.requestSerializer.timeoutInterval = 120;
        NSString *url = [NSString stringWithFormat:@"%@%@", Localhost,PictureFile];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat =@"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                [formData appendPartWithFileData:file name:@"file" fileName:fileName mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //上传成功
            NSData *data = (NSData *)responseObject;
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dic1);

            [DownLoadData postManualCheck:^(id obj, NSError *error) {
                if ([obj[@"result"] isEqualToString:@"success"]) {
                    [hud setHidden:YES];
                    //图片上传成功提示
                    [self alterSuccess];
                }else{
                    [Factory addAlertToVC:self withMessage:obj[@"messageText"]];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"] imgUrl:dic1[@"url"]];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud setHidden:YES];
            [Factory addAlertToVC:self withMessage:@"上传图片失败"];

            NSLog(@"%@", error);
        }];
    }else{
        [Factory alertMes:@"请您先选择照片。"];
    }
}
/**
 *   图片上传成功提示
 */
- (void)alterSuccess{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的照片已提交审核，我们会在1-2工作日内给您回复。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}
/**
 *  调用相机和相册
 */
- (void)callCameraAndPhoto{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消"otherButtonTitles:@"拍照",@"从相册选择",nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消"otherButtonTitles:@"从相册选择",nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"currentImage.png"];
    
    self.savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [self.button setImage:self.savedImage forState:0];
    
    isFullScreen =NO;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag ==255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

@end
