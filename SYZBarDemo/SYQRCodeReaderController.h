//
//  SYQRCodeReaderController.h
//  SYQRCodeDemo
//
//  Created by sunbb on 15-1-28.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYQRCodeReaderController : UIViewController

@property (nonatomic, copy) void (^SYQRCodeCancleBlock) (SYQRCodeReaderController *);//扫描取消
@property (nonatomic, copy) void (^SYQRCodeSuncessBlock) (SYQRCodeReaderController *, NSString *);//扫描结果
@property (nonatomic, copy) void (^SYQRCodeFailBlock) (SYQRCodeReaderController *);//扫描失败

@end
