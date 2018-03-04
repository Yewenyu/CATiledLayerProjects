//
//  LargeImageView.h
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/3.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImageView : UIView

@property (strong,nonatomic)NSString *imageName;
@property NSInteger tileCount;
@property CGSize maxSize;
-(id)initWithImageName:(NSString*)imageName andTileCount:(NSInteger)tileCount;

@end
