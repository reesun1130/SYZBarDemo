//
//  ViewController.m
//  SYZBarDemo
//
//  Created by sunbb on 15-2-13.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "ViewController.h"
#import "SYQRCodeReaderController.h"
#import "QRCodeGenerator.h"
#import "ZBarReaderController.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//打开摄像头并扫描
- (IBAction)saomiaoAction:(id)sender
{
    //扫描二维码
    SYQRCodeReaderController *qrcodevc = [[SYQRCodeReaderController alloc] init];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeReaderController *aqrvc,NSString *qrString){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        [self showAlertWithMsg:qrString];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeReaderController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        [self showAlertWithMsg:@"cancle~"];
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeReaderController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        [self showAlertWithMsg:@"fail~"];
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
}

//生成二维码
- (IBAction)shengchengAction:(id)sender
{
    [self.xianBtn setImage:[QRCodeGenerator qrImageForString:@"https://github.com/reesun1130" imageSize:150] forState:UIControlStateNormal];
}

//从相册读取二维码
- (IBAction)readAction:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary])
    {
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        //imagePickerController.navigationBar.tintColor = kNavBgColor;
        //imagePickerController.navigationBar.backgroundColor = kNavBgColor;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        //imagePickerController.allowsEditing = YES;
        
        [self presentViewController:imagePickerController animated:NO completion:nil];
    }
    else
    {
        [self showAlertWithMsg:@"fail~"];
    }
}

//显示提示信息
- (void)showAlertWithMsg:(NSString *)amsg
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
    UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:nil message:amsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alerV show];
#else
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:nil message:amsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actCancle = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alerVC addAction:actCancle];
    [self presentViewController:alerVC animated:YES completion:nil];
#endif
}

//读取后的代理回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    ZBarReaderController* read = [ZBarReaderController new];
    
    read.readerDelegate = self;
    
    CGImageRef cgImageRef = image.CGImage;
    
    ZBarSymbol* symbol = nil;
    
    for(symbol in [read scanImage:cgImageRef]) break;
    
    NSString *qrText = symbol.data ;
    
    NSLog(@"read--%@",qrText);
    
    [picker.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
    if (qrText && ![qrText isEqualToString:@""] && qrText.length > 0)
    {
        [self showAlertWithMsg:qrText];
    }
    else
    {
        [self showAlertWithMsg:@"fail~"];
    }
}

@end
