//
//  UIView+ViewAutoLayout.m
//  ProductModifier
//
//  Created by 小点草 on 2017/6/24.
//  Copyright © 2017年 . All rights reserved.
//

#define CGRectMakeWidthLocation(location,width,height) CGRectMake(location.x, location.y, width, height)
#define CGRectMakeWidthLocationAndSize(location,CGSize) CGRectMake(location.x, location.y, CGSize.width, CGSize.height)
#define CGRectMakeWidthSize(x,y,CGSize) CGRectMake(x, y, CGSize.width, CGSize.height)

#import "UIView+ViewAutoLayout.h"

@implementation UIView (ViewAutoLayout)


-(void)setFrameOrigin:(CGPoint)pos{
    
    self.frame = CGRectMakeWidthLocationAndSize(pos, self.frame.size);
}
-(void)setFrameSize:(CGSize)size{
    
    self.frame = CGRectMakeWidthLocationAndSize(self.frame.origin, size);
}
-(void)setFrameWithOrigin:(CGPoint)pos andSize:(CGSize)size{
    
    self.frame = CGRectMakeWidthLocationAndSize(pos, size);
}

-(void)posAdjustFromView:(id)view andOffset:(CGPoint)offset{
    
    CGPoint viewPos = [view frame].origin;
    
    CGPoint selfPos = CGPointMake(viewPos.x+offset.x, viewPos.y+offset.y);
    
    [self setFrameOrigin:selfPos];
}
-(void)setSize:(CGSize)size posAdjustFromView:(id)view andOffset:(CGPoint)offset{
    
    CGPoint viewPos = [view frame].origin;
    
    CGPoint selfPos = CGPointMake(viewPos.x+offset.x, viewPos.y+offset.y);
    
    [self setFrameWithOrigin:selfPos andSize:size];
}
-(void)sizeAdjustFromView:(id)view andScale:(CGPoint)scale{
    
    CGSize viewSize = [view frame].size;
    
    CGSize selfSize = CGSizeMake(viewSize.width*scale.x, viewSize.height*scale.y);
    
    [self setFrameSize:selfSize];
}
-(void)sizeAdjustFromView:(id)view andDiffValue:(CGPoint)diffValue{
    
    CGSize viewSize = [view frame].size;
    
    CGSize selfSize = CGSizeMake(viewSize.width+diffValue.x, viewSize.height+diffValue.y);
    
    [self setFrameSize:selfSize];
}


@end
