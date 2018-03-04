//
//  LargeImageView.m
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/3.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import "LargeImageView.h"
#import "UIImage+YEImage.h"
#import "YEImageView.h"

#define maxWidth 1920.0

@implementation LargeImageView{
    
    
    YEImageView *yeImageView;
    CGSize lastSize;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithImageName:(NSString*)imageName andTileCount:(NSInteger)tileCount{
    
    self = [super init];
    if(self){
        
        self.imageName = imageName;
        self.tileCount = tileCount;
        [self selfInit];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    yeImageView.frame = self.bounds;
    
}


-(void)selfInit{
    
    CGRect bounds = [[UIScreen mainScreen]bounds];
    
    CGSize screenSize = bounds.size;
    CGSize viewSize = CGSizeZero;
    NSString *path = [[NSBundle mainBundle]pathForResource:[_imageName stringByDeletingPathExtension] ofType:[_imageName pathExtension]];
    
    CGSize originImageSize = [UIImage imageWithContentsOfFile:path].size;
    self.maxSize = originImageSize;
    if(originImageSize.width>originImageSize.height){
        viewSize.width = screenSize.width;
        viewSize.height = screenSize.width/originImageSize.width*originImageSize.height;
        screenSize = viewSize;
    }
    self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    lastSize = self.frame.size;
    
    YEImageView *imageView = [[YEImageView alloc]initWithImageName:_imageName andFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) andTileCount:self.tileCount];
    [self addSubview:imageView];
    yeImageView = imageView;

    
}
//-(void)selfInit{
//
//    CGRect bounds = [[UIScreen mainScreen]bounds];
//    BOOL isWExactDivision = YES;
//    BOOL isHExactDivision = YES;
//    CGSize screenSize = bounds.size;
//    CGSize viewSize = CGSizeZero;
//    CGSize originImageSize = originImage.size;
//    if(originImageSize.width>originImageSize.height){
//        viewSize.width = screenSize.width;
//        viewSize.height = screenSize.width/originImageSize.width*originImageSize.height;
//        screenSize = viewSize;
//    }
//    NSInteger wCount = originImageSize.width/screenSize.width;
//    if(wCount*screenSize.width<originImageSize.width){
//        wCount +=1;
//        isWExactDivision = NO;
//    }
//    NSInteger hCount = originImageSize.height/screenSize.height;
//    if(hCount*screenSize.height<originImageSize.height){
//        hCount +=1;
//        isHExactDivision = NO;
//    }
//    CGSize imageScale = CGSizeMake(originImageSize.width/screenSize.width, originImageSize.height/screenSize.height);
//    CGPoint lastImagePos = CGPointZero;
//    CGPoint lastImageViewPos = CGPointZero;
//    CGSize selfSize = CGSizeZero;
//
//    CGFloat subImageWidth = screenSize.width;
//    CGFloat subImageHeight = screenSize.height;
//    for(NSInteger i = 0;i<hCount;i++){
//        if(i+1 == hCount){
//            if(!isHExactDivision){
//                subImageHeight = subImageHeight*hCount-originImageSize.height;
//            }
//
//        }
//        CGSize smallSize = CGSizeMake(subImageWidth/imageScale.width, subImageHeight/imageScale.height);
//        for(NSInteger j=0;j<wCount;j++){
//
//            if(j+1 == wCount){
//                if(!isWExactDivision){
//                    subImageWidth = subImageWidth*wCount-originImageSize.width;
//                    smallSize.width = subImageWidth/imageScale.width;
//                }
//
//            }
//
//            UIImage *subImage = [originImage getSubImage:CGRectMake(lastImagePos.x, lastImagePos.y, subImageWidth, subImageHeight)];
//            [subImageArray addObject:subImage];
//
//
//
//            UIImage *smallSubImage = [subImage scaleToSize:smallSize];
//            UIImageView *subImageView = [[UIImageView alloc]initWithImage:smallSubImage];
//            subImageView.frame = CGRectMake(lastImageViewPos.x, lastImageViewPos.y, smallSize.width, smallSize.height);
//            [self addSubview:subImageView];
//            [subImageViewArray addObject:subImageView];
//
//            lastImagePos.x += subImageWidth;
//            lastImageViewPos.x += smallSize.width;
//
//            if(j+1 == wCount){
//                lastImagePos.x = 0;
//                lastImageViewPos.x = 0;
//            }
//            if(i<1){
//                selfSize.width += smallSize.width;
//            }
//
//        }
//        lastImagePos.y += subImageHeight;
//        lastImageViewPos.y += smallSize.height;
//        if(i+1 == hCount){
//            lastImagePos.y = 0;
//            lastImageViewPos.y = 0;
//        }
//        selfSize.height += smallSize.height;
//    }
//
//    self.frame = CGRectMake(0, 0, selfSize.width, selfSize.height);
//}



@end
