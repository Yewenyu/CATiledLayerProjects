//
//  YEImageView1.m
//  ShowLageImage
//
//  Created by 叶文宇 on 2018/3/5.
//  Copyright © 2018年 叶文宇. All rights reserved.
//

#import "YEImageView1.h"

@implementation YEImageView1{
    UIImage *originImage;
    CGRect imageRect;
    CGFloat imageScale;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(id)initWithImageName:(NSString*)imageName andFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.tileCount = 36;
        self.imageName = imageName;
        [self initSelf];
    }
    return self;
}

-(id)initWithImageName:(NSString *)imageName andFrame:(CGRect)frame andTileCount:(NSInteger)tileCount{
    self = [self initWithFrame:frame];
    
    if(self){
        self.tileCount = tileCount;
        self.imageName = imageName;
        [self initSelf];
    }
    return self;
}

-(void)initSelf{
    NSString *path = [[NSBundle mainBundle]pathForResource:[_imageName stringByDeletingPathExtension] ofType:[_imageName pathExtension]];
    originImage = [UIImage imageWithContentsOfFile:path];
    imageRect = CGRectMake(0.0f, 0.0f,CGImageGetWidth(originImage.CGImage),CGImageGetHeight(originImage.CGImage));
    imageScale = self.frame.size.width/imageRect.size.width;
    
    
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    imageScale = self.frame.size.width/imageRect.size.width;
    
}
-(CGPoint)rectCenter:(CGRect)rect{
    CGFloat centerX = (CGRectGetMaxX(rect)+CGRectGetMinX(rect))/2;
    CGFloat centerY = (CGRectGetMaxY(rect)+CGRectGetMinY(rect))/2;
    
    return CGPointMake(centerX, centerY);
}

-(void)drawRect:(CGRect)rect {
    //将视图frame映射到实际图片的frame
    CGFloat tileCount = sqrt(self.tileCount);
    CGSize tileSize = CGSizeMake(rect.size.width/tileCount, rect.size.width/tileCount);
    CGPoint lastPos = CGPointZero;
    for(NSInteger h=0;h<tileCount;h++){
        lastPos.x = 0;
        for(NSInteger w=0;w<tileCount;w++){
            CGRect tileRect;
            tileRect.origin = lastPos;
            tileRect.size = tileSize;
            CGRect inScreenRect = CGRectIntersection(tileRect, [UIScreen mainScreen].bounds);
            CGRect imageCutRect = CGRectMake(inScreenRect.origin.x / imageScale,inScreenRect.origin.y / imageScale,inScreenRect.size.width / imageScale,inScreenRect.size.height / imageScale);
            //截取指定图片区域，重绘
            CGContextRef context = UIGraphicsGetCurrentContext();
            @autoreleasepool{
                CGImageRef imageRef = CGImageCreateWithImageInRect(originImage.CGImage, imageCutRect);
                UIImage *tileImage = [UIImage imageWithCGImage:imageRef];
                
                UIGraphicsPushContext(context);
                [tileImage drawInRect:tileRect];
                UIGraphicsPopContext();
            }
            lastPos.x+=tileSize.width;
        }
        lastPos.y += tileSize.height;
    }
    static NSInteger drawCount = 1;
    drawCount ++;
    if(drawCount == self.tileCount){
        
    }
}


-(CGSize)returnTileSize{
    return [(CATiledLayer*)self.layer tileSize];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
