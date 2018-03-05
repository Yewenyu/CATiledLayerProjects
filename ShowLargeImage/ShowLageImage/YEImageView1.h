//
//  YEImageView1.h
//  ShowLageImage
//
//  Created by 叶文宇 on 2018/3/5.
//  Copyright © 2018年 叶文宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YEImageView1 : UIView

@property (strong,nonatomic)NSString *imageName;
@property NSInteger tileCount;
-(id)initWithImageName:(NSString*)imageName andFrame:(CGRect)frame;
-(id)initWithImageName:(NSString *)imageName andFrame:(CGRect)frame andTileCount:(NSInteger)tileCount;

@end
