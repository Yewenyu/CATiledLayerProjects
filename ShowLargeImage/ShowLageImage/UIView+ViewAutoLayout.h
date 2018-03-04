//
//  UIView+ViewAutoLayout.h
//  ProductModifier
//
//  Created by 小点草 on 2017/6/24.
//  Copyright © 2017年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewAutoLayout)

-(void)setFrameOrigin:(CGPoint)pos;
-(void)setFrameSize:(CGSize)size;
-(void)setFrameWithOrigin:(CGPoint)pos andSize:(CGSize)size;
-(void)posAdjustFromView:(id)view andOffset:(CGPoint)offset;
-(void)setSize:(CGSize)size posAdjustFromView:(id)view andOffset:(CGPoint)offset;
-(void)sizeAdjustFromView:(id)view andScale:(CGPoint)scale;
-(void)sizeAdjustFromView:(id)view andDiffValue:(CGPoint)diffValue;

@end
