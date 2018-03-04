//
//  ViewController.m
//  ShowLageImage
//
//  Created by 小点草 on 2018/3/2.
//  Copyright © 2018年 小点草. All rights reserved.
//

#import "ViewController.h"
#import "LargeImageView.h"
#import "UIImage+YEImage.h"
#import "BaseButton.h"
#import "YeFileManager.h"

@interface ViewController ()

@end

@implementation ViewController{
    LargeImageView *largeImageView;
    BaseButton *button36;
    BaseButton *button64;
    BaseButton *button100;
    UILabel *label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**截取按钮图片**/
    UIImage *image = [UIImage imageNamed:@"按钮.png"];
    CGSize btnImageSize = CGSizeMake(image.size.width, (image.size.height-32)/2);
    UIImage *btnImage = [image getSubImage:CGRectMake(0, 0, btnImageSize.width, btnImageSize.height)];
    /**截取按钮图片**/
    
    CGPoint center = self.view.center;
    button36 = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"36" andAction:@selector(buttonAction:) andTarget:self];
    [button36 setUpImage:btnImage andDownImage:btnImage];
    center.y -= 200;
    button36.center = center;
    
    [self.view addSubview:button36];
    button64 = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"64" andAction:@selector(buttonAction:) andTarget:self];
    [button64 setUpImage:btnImage andDownImage:btnImage];
    center.y += 50;
    button64.center = center;
    [self.view addSubview:button64];
    button100 = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"100" andAction:@selector(buttonAction:) andTarget:self];
    [button100 setUpImage:btnImage andDownImage:btnImage];
    center.y += 50;
    button100.center = center;
    [self.view addSubview:button100];
    
    UILabel *label = [BaseButton createLableWithFrame:CGRectZero andName:@"说明"];
    label.text = @"三个按钮分别代表切片数量，可以这样理解，切片越多，内存峰值越低，绘制速度越慢，反之，切片越少，内存峰值越高，绘制速度越快";
    label.frame = CGRectMake(0, 0, 300, 300);
    label.textAlignment = NSTextAlignmentCenter;
    center.y += 150;
    label.center = center;
    
    [self.view addSubview:label];
    
    
}

-(void)buttonAction:(BaseButton*)button{
    
    UIImage *btnImage = [UIImage imageNamed:@"按钮.png"];
    CGSize btnImageSize = CGSizeMake(btnImage.size.width, (btnImage.size.height-32)/2);
    UIImage *image = [btnImage getSubImage:CGRectMake(0, btnImageSize.height+32, btnImageSize.width, btnImageSize.height)];
    [button36 removeFromSuperview];
    [button64 removeFromSuperview];
    [button100 removeFromSuperview];
    
    BaseButton *clearButton = [BaseButton createButton:CGRectMake(0, 0, 100, 50) name:@"清除" andAction:@selector(clearButtonAction:) andTarget:self];
    [clearButton setUpImage:image andDownImage:image];
    [self.view addSubview:clearButton];
    NSInteger tileCount = [button.name integerValue];
    
    largeImageView = [[LargeImageView alloc]initWithImageName:@"zz.jpg" andTileCount:tileCount];
    [self.view addSubview:largeImageView];
    
    largeImageView.center = self.view.center;
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureAction:)];
    
    [self.view addGestureRecognizer:pinch];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:pan];
}

-(void)clearButtonAction:(BaseButton*)button{
    
    [largeImageView removeFromSuperview];
    largeImageView = nil;
    
    [self.view addSubview:button36];
    [self.view addSubview:button64];
    [self.view addSubview:button100];
    
    [button removeFromSuperview];
    
}

static CGPoint originCenter;
-(void)panGestureAction:(UIPanGestureRecognizer*)gesture{
    //拖拽的距离(距离是一个累加)
    CGPoint trans = [gesture translationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(trans));
    
    //设置图片移动
    CGPoint center =  largeImageView.center;
    center.x += trans.x;
    center.y += trans.y;
    largeImageView.center = center;
    
    NSLog(@"%@",NSStringFromCGRect(largeImageView.frame));
    //清除累加的距离
    [gesture setTranslation:CGPointZero inView:self.view];
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        originCenter = largeImageView.center;
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        CGPoint move = CGPointMake(center.x-originCenter.x, center.y-originCenter.y);
        largeImageView.center = originCenter;
        CGRect frame = largeImageView.frame;
        frame.origin.x += move.x;
        frame.origin.y += move.y;
        largeImageView.frame = frame;
    }
    
}
-(void)pinchGestureAction:(UIPinchGestureRecognizer*)gesture{
    
    
    largeImageView.transform = CGAffineTransformScale(largeImageView.transform, gesture.scale, gesture.scale);
    NSLog(@"%@",NSStringFromCGRect(largeImageView.frame));
    
    gesture.scale = 1;
    
    if(gesture.state == UIGestureRecognizerStateEnded){
        CGRect newFrame = largeImageView.frame;
        largeImageView.transform = CGAffineTransformIdentity;
        largeImageView.frame = newFrame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
