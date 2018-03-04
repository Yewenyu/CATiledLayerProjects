//
//  textView.m
//  ShowLageImage
//
//  Created by 叶文宇 on 2018/3/3.
//  Copyright © 2018年 叶文宇. All rights reserved.
//

#import "TextView.h"
#import "OTLargeImageReader.h"

@implementation TextView{
    UIImageView *currentImageView;
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
        self.imageName = imageName;
        [self selfInit];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    currentImageView.frame = self.bounds;
}
-(void)selfInit{
     NSString *path = [[NSBundle mainBundle]pathForResource:[_imageName stringByDeletingPathExtension] ofType:[_imageName pathExtension]];
    UIImage *image = [OTLargeImageFileReader thumbImageFromLargeFile:path withMinPixelSize:1080 imageSize:CGSizeZero];
    currentImageView = [[UIImageView alloc]initWithImage:image];
    
    [self addSubview:currentImageView];
    
}

@end
