//
//  UIImage+LBUrlToQRCode.h
//  URLToScanLife
//
//  Created by JiBaoBao on 17/2/6.
//  Copyright © 2017年 JiBaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LBUrlToQRCode)

/**
 * 根据URL生成二维码图片
 *
 * @param urlString 传入的URL
 * @param size 二维码宽度(应与UIImageView大小一致)
 *
 *  @return <#return value description#>
 */
+ (UIImage *)lbQRCodeWithUrlString:(NSString *)urlString withSize:(CGFloat)size;

/**
 * 根据URL生成中间带有icon的二维码图片
 *
 * @param urlString 传入的URL
 * @param iconImage 传入的icon图片
 * @param size 二维码宽度
 *
 *  @return <#return value description#>
 */
+ (UIImage *)lbQRCodeWithUrlString:(NSString *)urlString iconImage:(UIImage *)iconImage withSize:(CGFloat)size;

/**
 * 根据URL生成中间带圆角icon的二维码
 *
 * @param urlString 传入的URL
 * @param iconImage 传入的icon图片
 * @param size 二维码宽度
 * @param cornerRadius icon的圆角半径
 *
 *  @return <#return value description#>
 */
+ (UIImage *)lbQRCodeWithUrlString:(NSString *)urlString iconImage:(UIImage *)iconImage withSize:(CGFloat)size iconCornerRadius:(CGFloat)cornerRadius;



/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param ciImage CIImage
 * @param size 图片宽度
 *
 *  @return <#return value description#>
 */
+ (UIImage *)lbCreateUIImageFormCIImage:(CIImage *)ciImage withSize:(CGFloat)size;

/**
 * 改变UIImage的颜色
 *
 * @param image 传入的图片
 * @param red <#red#>
 * @param green <#green#>
 * @param blue <#blue#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)lbSpecialColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/**
 * 两张图片合并
 *
 * @param bottomImage 位于底层的图片
 * @param topImage 位于顶层的图片
 * @param scale 顶层图片的缩放比例
 *
 *  @return <#return value description#>
 */
+ (UIImage *)lbTwoImageCombine:(UIImage *)bottomImage topImage:(UIImage *)topImage withTopImageScale:(CGFloat)scale;

/**
 *  图片生产圆角图片
 *
 *  @param cornerRadius 圆角大小
 *  @param imageSize    图片大小
 *
 *  @return <#return value description#>
 */
- (UIImage *)lbImageCorner:(CGFloat)cornerRadius imageSize:(CGSize)imageSize;


@end
