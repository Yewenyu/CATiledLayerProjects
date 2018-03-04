//
//  YEImageView.h
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/3.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YEImageView : UIView

@property (strong,nonatomic)NSString *imageName;
@property NSInteger tileCount;
-(id)initWithImageName:(NSString*)imageName andFrame:(CGRect)frame;
-(id)initWithImageName:(NSString *)imageName andFrame:(CGRect)frame andTileCount:(NSInteger)tileCount;

-(CGSize)returnTileSize;

@end
