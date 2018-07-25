//
//  OTBageValue.m
//
//
//  Created by OUT MAN on 16/11/29.
//  Copyright © 2016年 OUT MAN. All rights reserved.
//

#import "OTBageValue.h"

@interface OTBageValue () {
//    UIView *_vSmallCircle;
}

@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation OTBageValue

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUIConfig];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIConfig];
    }
    return self;
}



- (void)initUIConfig {
    //不设置背景色默认红色
    if (self.backgroundColor) {
    } else {
       self.backgroundColor = [UIColor redColor];
    }
    
//    _vSmallCircle = [[UIView alloc] init];
//    _vSmallCircle.backgroundColor = self.backgroundColor;
    
    if (_isPan == YES) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //判断宽高, 取最小值
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat radius = width < height ? width : height;
    self.layer.cornerRadius = radius * 0.5;
    
//    _vSmallCircle.frame = self.frame;
//    _vSmallCircle.layer.cornerRadius = self.layer.cornerRadius;
//    [self.superview insertSubview:_vSmallCircle belowSubview:self];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint transPoint = [pan translationInView:self];
    CGPoint centerPoint = self.center;
    centerPoint.x += transPoint.x;
    centerPoint.y += transPoint.y;
    self.center = centerPoint;
    
    [pan setTranslation:CGPointZero inView:self];
    
    CGFloat distance = [self distanceWithSmallView:self bigCircle:self];
    
    CGFloat smallCircleRadius = self.bounds.size.width * 0.5;
    smallCircleRadius = smallCircleRadius - distance / 10.0;
    self.bounds = CGRectMake(0, 0, smallCircleRadius * 2, smallCircleRadius * 2);
    self.layer.cornerRadius = smallCircleRadius;
    
    if (self.hidden == NO) {
        UIBezierPath *path = [self pathWithSmallView:self bigCircle:self];
        self.shapeLayer.path = path.CGPath;
    }
    
    if (distance > 60) {
        self.hidden = YES;
        [self.shapeLayer removeFromSuperlayer];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (distance < 60) {
        
            [self.shapeLayer removeFromSuperlayer];
            [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = self.center;
            } completion:^(BOOL finished) {
                self.hidden = NO;
            }];
            
        } else {
//            UIImageView *img = [[UIImageView alloc] initWithFrame:self.bounds];
//            NSMutableArray *arrImages = [NSMutableArray array];
//            for (int i = 0; i < 8; i++) {
//                UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)(i + 1)]];
//                [arrImages addObject:img];
//            }
//            img.animationImages = arrImages;
//            [img setAnimationDuration:1.f];
//            [img startAnimating];
//            [self addSubview:img];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
    }
}


- (CGFloat)distanceWithSmallView:(UIView *)vSmallCircle bigCircle:(UIView *)vBigCircle {
    CGFloat offsetX = vBigCircle.center.x - vSmallCircle.center.x;
    CGFloat offsetY = vBigCircle.center.y - vSmallCircle.center.y;
    return sqrtf(powf(offsetX, 2) + powf(offsetY, 2));
}

- (UIBezierPath *)pathWithSmallView:(UIView *)vSmallCircle bigCircle:(UIView *)vBigCircle {
//    CGFloat smallCircleX = _vSmallCircle.center.x;
//    CGFloat smallCircleY = _vSmallCircle.center.y;
    CGFloat smallCircleX = self.center.x;
    CGFloat smallCircleY = self.center.y;
    
    CGFloat smallCircleRadius = self.bounds.size.width * 0.5;
    
    CGFloat bigCircleX = self.center.x;
    CGFloat bigCircleY = self.center.y;
    
    CGFloat bigCircleRadius = self.bounds.size.width * 0.5;
    CGFloat distance = [self distanceWithSmallView:self bigCircle:self];
    CGFloat cosΘ = (bigCircleY - smallCircleY) / distance;
    CGFloat sinΘ = (bigCircleX - smallCircleX) / distance;
    CGPoint pointA = CGPointMake(smallCircleX - cosΘ * smallCircleRadius, smallCircleY + sinΘ * smallCircleRadius);
    CGPoint pointB = CGPointMake(smallCircleX + cosΘ * smallCircleRadius, smallCircleY - sinΘ * smallCircleRadius);
    CGPoint pointC = CGPointMake(bigCircleX + cosΘ * bigCircleRadius, bigCircleY - sinΘ * bigCircleRadius);
    CGPoint pointD = CGPointMake(bigCircleX - cosΘ * bigCircleRadius, bigCircleY + sinΘ * bigCircleRadius);
    CGPoint pointO = CGPointMake(pointA.x + sinΘ * distance * 0.5, pointA.y + cosΘ * distance * 0.5);
    CGPoint pointP = CGPointMake(pointB.x + sinΘ * distance * 0.5, pointB.y + cosΘ * distance * 0.5);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:pointA];
    [bezierPath addLineToPoint:pointB];
    [bezierPath addQuadCurveToPoint:pointC controlPoint:pointP];
    [bezierPath addLineToPoint:pointD];
    [bezierPath addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return bezierPath;
}

#pragma mark - LazyLoad
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        self.shapeLayer = shapeLayer;
        _shapeLayer.fillColor = [UIColor redColor].CGColor;
        [self.superview.layer insertSublayer:_shapeLayer atIndex:0];
    }
    return _shapeLayer;
}

@end
