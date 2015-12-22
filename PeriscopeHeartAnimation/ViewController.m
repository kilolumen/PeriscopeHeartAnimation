//
//  ViewController.m
//  PeriscopeHeartAnimation
//
//  Created by ldj on 4/28/15.
//  Copyright (c) 2015 ldj. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addHeart)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addHeart {

    CALayer *heartLayer=[[CALayer alloc]init];
    [heartLayer setFrame:CGRectMake(kScreenWidth / 2.0 - 14, kScreenHeight - 100, 28, 26)];
    heartLayer.contents=(__bridge id _Nullable)([[UIImage imageNamed:@"heart"] CGImage]);
    [self.view.layer addSublayer:heartLayer];
    __weak CALayer *weakHeartLayer=heartLayer;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^(){
        [weakHeartLayer removeFromSuperlayer];
    }];

    CAAnimationGroup *animation = [self createAnimation:heartLayer.frame];
    animation.duration = 5 + (arc4random() % 5 - 2);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [heartLayer addAnimation:animation forKey:nil];
    [CATransaction commit];
}

- (CAAnimationGroup *)createAnimation:(CGRect)frame {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    
    int height = -100 + arc4random() % 40 - 20;
    int xOffset = frame.origin.x;
    int yOffset = frame.origin.y;
    int waveWidth = 50;
    CGPoint p1 = CGPointMake(xOffset, height * 0 + yOffset);
    CGPoint p2 = CGPointMake(xOffset, height * 1 + yOffset);
    CGPoint p3 = CGPointMake(xOffset, height * 2 + yOffset);
    CGPoint p4 = CGPointMake(xOffset, height * 2 + yOffset);
    
    CGPathMoveToPoint(path, NULL, p1.x,p1.y);
    
    if (arc4random() % 2) {
        CGPathAddQuadCurveToPoint(path, NULL, p1.x - arc4random() % waveWidth, p1.y + height / 2.0, p2.x, p2.y);
        CGPathAddQuadCurveToPoint(path, NULL, p2.x + arc4random() % waveWidth, p2.y + height / 2.0, p3.x, p3.y);
        CGPathAddQuadCurveToPoint(path, NULL, p3.x - arc4random() % waveWidth, p3.y + height / 2.0, p4.x, p4.y);
    } else {
        CGPathAddQuadCurveToPoint(path, NULL, p1.x + arc4random() % waveWidth, p1.y + height / 2.0, p2.x, p2.y);
        CGPathAddQuadCurveToPoint(path, NULL, p2.x - arc4random() % waveWidth, p2.y + height / 2.0, p3.x, p3.y);
        CGPathAddQuadCurveToPoint(path, NULL, p3.x + arc4random() % waveWidth, p3.y + height / 2.0, p4.x, p4.y);
    }
    animation.path = path;
    animation.calculationMode = kCAAnimationCubicPaced;
    CGPathRelease(path);
    
    //透明渐变
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.95f;
    opacityAnimation.toValue  = @0.0f;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[animation, opacityAnimation];
    return animGroup;
}

@end
