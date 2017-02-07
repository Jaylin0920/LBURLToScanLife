//
//  KMQRCode.h
//  URLToScanLife
//
//  Created by JiBaoBao on 17/2/7.
//  Copyright © 2017年 JiBaoBao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KMQRCode : NSObject

+ (CIImage *)createQRCodeImage:(NSString *)source;
+ (UIImage *)resizeQRCodeImage:(CIImage *)image withSize:(CGFloat)size;

+ (UIImage *)specialColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;


+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize;
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale;

@end
