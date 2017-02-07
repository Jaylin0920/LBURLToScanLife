//
//  UIImage+LBUrlToQRCode.m
//  URLToScanLife
//
//  Created by JiBaoBao on 17/2/6.
//  Copyright © 2017年 JiBaoBao. All rights reserved.
//

#import "UIImage+LBUrlToQRCode.h"

@implementation UIImage (LBUrlToQRCode)

#pragma mark - Private Methods
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}


#pragma mark - Public Methods
// 根据 url 生成二维码
+ (UIImage *)lbQRCodeWithUrlString:(NSString *)urlString withSize:(CGFloat)size{
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];

    //实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"]; //设置纠错等级越高；即识别越容易，值可设置为L(Low) |  M(Medium) | Q | H(High)
    
    //获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    UIImage *qrCodeImage =  [self lbCreateUIImageFormCIImage:outputImage withSize:size];
    return qrCodeImage;
}

//根据URL生成中间带有icon的二维码图片
+ (UIImage *)lbQRCodeWithUrlString:(NSString *)urlString iconImage:(UIImage *)iconImage withSize:(CGFloat)size{
    UIImage *bottomImage = [self lbQRCodeWithUrlString:urlString withSize:size];
    // scale≈0.25左右效果为佳
    return [self lbTwoImageCombine:bottomImage topImage:iconImage withTopImageScale:0.25];
}

//根据url生成中间带圆角icon的二维码
+ (UIImage *)lbQRCodeWithUrlString:(NSString *)urlString iconImage:(UIImage *)iconImage withSize:(CGFloat)size iconCornerRadius:(CGFloat)cornerRadius{
    return [self lbQRCodeWithUrlString:urlString iconImage:[iconImage lbImageCorner:cornerRadius imageSize:CGSizeMake(size, size)] withSize:size];
}


// 根据CIImage生成指定大小的UIImage
+ (UIImage *)lbCreateUIImageFormCIImage:(CIImage *)ciImage withSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    // 1-创建bitmap;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2-保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // 3-Release
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

// 改变UIImage的颜色
+ (UIImage *)lbSpecialColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    //Create context
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    //Traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            //Change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    //Convert to image
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProviderRef,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProviderRef);
    UIImage* img = [UIImage imageWithCGImage:imageRef];
    
    //Release
    CGImageRelease(imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    return img;
}

//两张图片合并
+ (UIImage *)lbTwoImageCombine:(UIImage *)bottomImage topImage:(UIImage *)topImage withTopImageScale:(CGFloat)scale{
    //通过两张图片进行位置和大小的绘制，实现两张图片的合并；其实此原理做法也可以用于多张图片的合并
    UIGraphicsBeginImageContext(bottomImage.size);
    CGFloat widthOfImage = bottomImage.size.width;
    CGFloat heightOfImage = bottomImage.size.height;
    CGFloat widthOfIcon = widthOfImage*scale;
    CGFloat heightOfIcon = heightOfImage*scale;
    
    [bottomImage drawInRect:CGRectMake(0, 0, widthOfImage, heightOfImage)];
    [topImage drawInRect:CGRectMake((widthOfImage-widthOfIcon)/2, (heightOfImage-heightOfIcon)/2, widthOfIcon, heightOfIcon)];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)lbImageCorner:(CGFloat)cornerRadius imageSize:(CGSize)imageSize{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    [self drawInRect:rect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
