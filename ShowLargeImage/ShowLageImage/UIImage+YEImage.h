//
//  UIImage+YEGImage.h
//  ProductModifier
//
//  Created by 小点草 on 2017/8/10.
//  Copyright © 2017年 小点草. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YEImage)

//+(UIImage*)imageWithName:(NSString *)name;
//+(UIImage *)imageWithFilePath:(NSString *)path;
+(UIImage*)changTheNewSize:(CGSize)newSize WithImage:(UIImage*)image;
//+(NSData*)reduceTheMemoryWithImage:(UIImage*)image;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
+(NSData*)reduceTheMemoryWithImage:(UIImage*)image andSize:(CGSize)size;
+(UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;
/**截取View作为图片**/
+ (UIImage *)snapshot:(UIView *)view;
-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;
@end
