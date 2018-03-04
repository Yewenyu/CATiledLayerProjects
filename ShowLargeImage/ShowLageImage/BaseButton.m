//
//  BaseButton.m
//  ProductModifier
//
//  Created by 小点草 on 2017/4/8.
//  Copyright © 2017年 . All rights reserved.
//

#import "BaseButton.h"

@implementation UILabel (FitFontSize)

/**获取Label文字自适应的Size**/
-(CGSize)FitWithToFontWithFontSize:(float)fontSize{
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]};
    CGSize size=[self.text sizeWithAttributes:attrs];
    return size;
}

@end

@implementation BaseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    
    [super setBackgroundImage:image forState:state];
    
    if(!self.upImage)
        self.upImage = image;
}
-(void)setIsDown:(BOOL)isDown{
    
    _isDown = isDown;
    
    if(_isDown){
        [self setBackgroundImage:self.downImage forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:self.upImage forState:UIControlStateNormal];
    }
}
-(void)setUpImageWithName:(NSString *)upImageName andDownImageWithName:(NSString *)downImageName{
    
    
    self.upImage = [UIImage imageNamed:upImageName];
    self.downImage = [UIImage imageNamed:downImageName];
    
    [self setBackgroundImage:self.upImage forState:UIControlStateNormal];
}
-(void)setUpImage:(UIImage *)upImage andDownImage:(UIImage *)downImage{
    self.upImage = upImage;
    self.downImage = downImage;
    
    [self setBackgroundImage:upImage forState:UIControlStateNormal];
}
-(void)setFrame:(CGRect)frame{
//    if(self.tag == 1002){
//        CGRect navFrame = [[UIApplication sharedApplication]statusBarFrame];
//        CGFloat btnHeight = navFrame.size.height;
//        frame.size = CGSizeMake(btnHeight, btnHeight);
//    }
    [super setFrame:frame];
}


+(id)createButton:(CGRect)frame name:(NSString*)name andAction:(SEL)action andTarget:(id)target{
    
    id button = [self buttonWithType:UIButtonTypeRoundedRect];
    [button setIsDown:NO];
    [button setFrame:frame];
    [button setTitle:name forState:UIControlStateNormal];
    [button setName:name];
    [button setBackgroundImage:[UIImage imageNamed:@"圆实心"] forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont fontWithName:@"Arial" size:20.0f]];
    [button titleLabel].adjustsFontSizeToFitWidth = YES;
    [[button titleLabel] setTextColor:[UIColor blackColor]];
    [[button titleLabel] setTextAlignment:NSTextAlignmentCenter];
    
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    
    
    return button;
}

+(UILabel*)createLableWithFrame:(CGRect)frame andName:(NSString*)labelName{
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    label.adjustsFontSizeToFitWidth = YES;
    //label.minimumScaleFactor = 10.0f;
    label.font = [UIFont fontWithName:@"Arial" size:30.0f];
    label.textColor = [UIColor blackColor];
    //输入框中一开始就有的文字
    label.text = [NSString stringWithFormat:@"%@",labelName];;
    //内容对齐方式
    label.textAlignment = NSTextAlignmentNatural;
    label.numberOfLines = 0;
    
    return label;
}
+(NSArray*)createSwitchWithFrame:(CGRect)frame andName:(NSString*)name{
    
    CGSize size = frame.size;
    CGPoint origin = frame.origin;
    
    CGSize labelSize = CGSizeMake(size.width/3, size.height);
    CGSize switchSize = CGSizeMake(size.width-labelSize.width, labelSize.height);
    CGPoint offset = CGPointMake(origin.x+labelSize.width, 0);
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    UILabel *label = [self createLableWithFrame:CGRectZero andName:name];
    [label setFrameWithOrigin:CGPointMake(0, 0) andSize:labelSize];
    [view addSubview:label];
    
    UISwitch *newSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    [newSwitch setFrameSize:switchSize];
    [newSwitch posAdjustFromView:label andOffset:offset];
    [view addSubview:newSwitch];
    
    newSwitch.on=NO;
    
    [newSwitch setOnTintColor:[UIColor orangeColor]];
    //设置开关圆按钮的风格颜色
    [newSwitch setThumbTintColor:[UIColor blueColor]];
    //设置整体风格颜色,按钮的白色是整个父布局的背景颜色
    [newSwitch setTintColor:[UIColor greenColor]];
    
    return @[view,label,newSwitch];
}



@end
