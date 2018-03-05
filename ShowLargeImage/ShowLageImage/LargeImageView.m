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
#import "YEImageView1.h"

#define maxWidth 1920.0

@implementation LargeImageView{
    
    
    YEImageView *yeImageView;
    YEImageView1 *yeImageView1;
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
//    yeImageView1.frame = self.bounds;
//    [yeImageView1 setNeedsDisplay];
    
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
//    YEImageView1 *imageView = [[YEImageView1 alloc]initWithImageName:_imageName andFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) andTileCount:self.tileCount];
//    [self addSubview:imageView];
//    yeImageView1 = imageView;

    
}



@end
