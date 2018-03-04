//
//  UIImage+YEGImage.m
//  ProductModifier
//
//  Created by 小点草 on 2017/8/10.
//  Copyright © 2017年 小点草. All rights reserved.
//

#import "UIImage+YEImage.h"

@implementation UIImage (YEImage)

//+(UIImage*)imageWithName:(NSString *)name{
//
//    UIImage *image = [self imageNamed:name];
//    if(image){
//
//        NSData *data = [self reduceTheMemoryWithImage:image];
//        image = [UIImage imageWithData:data];
//
//    }
//
//    return image;
//}
//
//+(UIImage *)imageWithFilePath:(NSString *)path{
//
//    UIImage *image = [self imageWithContentsOfFile:path];
//
//    if(image){
//
//        NSData *data = [self reduceTheMemoryWithImage:image];
//        image = [UIImage imageWithData:data];
//
//    }
//
//    return image;
//
//}

+(NSData*)reduceTheMemoryWithImage:(UIImage*)image andSize:(CGSize)size{
    
    UIImage *newImage = nil;
    
    
    
    float wScale = image.size.width/size.width;
    float hScale = image.size.height/size.height;
    float maxScale = MAX(wScale, hScale);
    
    float newWidth = image.size.width/maxScale;
    float newHeight = image.size.height/maxScale;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    
    return imageData;
}

+(UIImage*)changTheNewSize:(CGSize)newSize WithImage:(UIImage*)image{
    
    if(image == nil){
        return nil;
    }
    NSData *newData = [self returnDataByChangTheNewSize:newSize WithImage:image];
    UIImage *newImage = [UIImage imageWithData:newData];
    return newImage;
}
+(NSData*)returnDataByChangTheNewSize:(CGSize)newSize WithImage:(UIImage*)image{
    
    UIImage *newImage = nil;
    
    CGSize size = newSize;
    
    float wScale = image.size.width/size.width;
    float hScale = image.size.height/size.height;
    float maxScale = MAX(wScale, hScale);
    
    float newWidth = image.size.width/maxScale;
    float newHeight = image.size.height/maxScale;
    newSize = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    
    return imageData;
}


+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)snapshot:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);

    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    //UIGraphicsEndImageContext();
    
    
    return smallImage;
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIImage* scaledImage = nil;
    @autoreleasepool{
        UIGraphicsBeginImageContext(size);
        
        // 绘制改变大小的图片
        [self drawInRect:CGRectMake(xPos, yPos, width, height)];
        
        // 从当前context中创建一个改变大小后的图片
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


@end
