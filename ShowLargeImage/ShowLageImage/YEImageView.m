//
//  YEImageView.m
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/3.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import "YEImageView.h"


@implementation YEImageView{
    
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


+(Class)layerClass{
    return [CATiledLayer class];
}
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
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    
    int lev = ceil(log2(1/imageScale))+1;
    tiledLayer.levelsOfDetail = 1;
    tiledLayer.levelsOfDetailBias = lev;
    NSInteger tileSizeScale = sqrt(self.tileCount)/2;
    CGSize tileSize = self.bounds.size;
    tileSize.width /=tileSizeScale;
    tileSize.height/=tileSizeScale;
    tiledLayer.tileSize = tileSize;
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    imageScale = self.frame.size.width/imageRect.size.width;
    CATiledLayer *tileLayer = (CATiledLayer *)self.layer;
    CGSize tileSize = self.bounds.size;
    NSInteger tileSizeScale = sqrt(self.tileCount)/2;
    tileSize.width /=tileSizeScale;
    tileSize.height/=tileSizeScale;
    tileLayer.tileSize = tileSize;
}
-(CGPoint)rectCenter:(CGRect)rect{
    CGFloat centerX = (CGRectGetMaxX(rect)+CGRectGetMinX(rect))/2;
    CGFloat centerY = (CGRectGetMaxY(rect)+CGRectGetMinY(rect))/2;
    
    return CGPointMake(centerX, centerY);
}

-(void)drawRect:(CGRect)rect {
    //将视图frame映射到实际图片的frame
    CGRect rec = CGRectMake(rect.origin.x / imageScale,rect.origin.y / imageScale,rect.size.width / imageScale,rect.size.height / imageScale);
    //截取指定图片区域，重绘
    @autoreleasepool{
        CGImageRef cropImg = CGImageCreateWithImageInRect(originImage.CGImage, rec);
        UIImage *tileImg = [UIImage imageWithCGImage:cropImg];
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context);
        [tileImg drawInRect:rect];
        UIGraphicsPopContext();

    }
    static NSInteger drawCount = 1;
    drawCount ++;
    if(drawCount == self.tileCount){

    }
}


-(CGSize)returnTileSize{
    return [(CATiledLayer*)self.layer tileSize];
}

@end
