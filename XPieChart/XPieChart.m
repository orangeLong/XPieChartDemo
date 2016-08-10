//
//  XPieChart.m
//  gfsdhgasdfbbgf
//
//  Created by LiX i n long on 16/8/3.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import "XPieChart.h"

#define X_ARC_Color [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]

@interface XPieChart ()

@property (nonatomic, assign) CGFloat drawAngle; //当前角度
@property (nonatomic, strong) CALayer *bgLayer; //draw的layer
@property (nonatomic, strong) NSArray *sortPieArray;

@property (nonatomic, assign) CGFloat maxAngle;
@property (nonatomic, assign) CGFloat maxBeginAngle;

@end

@implementation XPieChart


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
static NSInteger count = 0;

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.beginAngle = 0;
        self.outRadius = 100;
        self.inRadius = 50;
        self.isClockwise = NO;
        
        self.drawDuration = 2.f;
        self.transformDuration = 1.f;
        self.transformAngle = M_PI_2;
        self.needTransform = YES;
        
        self.bgLayer = [CALayer layer];
        self.bgLayer.frame = self.bounds;
        self.bgLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:self.bgLayer];
    }
    return self;
}

/**
 *  开始动画
 */
- (void)beginAnimation
{
    count = 0;
    [self.bgLayer removeAllAnimations];
    self.bgLayer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    if (!self.pieArray && self.pieArray.count == 0) {
        NSLog(@"比例数组不能为空");
        return;
    }
    CGFloat total = 0;
    for (XPieChartObject *pieObj in self.pieArray) {
        total += pieObj.pieRatio;
    }
    if (total != 1) {
        NSLog(@"比例不正确，总和必须为1");
        return;
    }
    NSInteger count = self.bgLayer.sublayers.count;
    for (int i = 0; i < count; i++) {
        CALayer *layer = self.bgLayer.sublayers.firstObject;
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
    [self originPieArray];
    for (XPieChartObject *obj in self.sortPieArray) {
        [self initShaplayerWithPieObj:obj];
    }
    [self performSelector:@selector(transformAnimation) withObject:nil afterDelay:self.drawDuration];
}
/**
 *  初始化layer
 *
 *  @param angle 角度
 */
- (void)initShaplayerWithPieObj:(XPieChartObject *)obj
{
    CAShapeLayer *shaplayer = [CAShapeLayer layer];
    shaplayer.path = [self getPathWithAngle:obj.pieAngle];
    shaplayer.lineWidth = self.outRadius - self.inRadius;
    shaplayer.strokeColor = obj.pieColor.CGColor;
    shaplayer.fillColor = [UIColor clearColor].CGColor;
    [self.bgLayer addSublayer:shaplayer];
    
    [shaplayer addAnimation:[self strokeAnimation] forKey:@"strokeAnimation"];
}
/**
 *  创建动画路径
 *
 *  @param angle 角度
 *
 *  @return 路径
 */
- (CGPathRef)getPathWithAngle:(CGFloat)angle
{
    CGPoint point = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:point radius:(self.outRadius + self.inRadius) / 2 startAngle:self.beginAngle endAngle:self.beginAngle + angle clockwise:self.isClockwise];
    return bezierPath.CGPath;
}
/**
 *  绘制动画
 *
 *  @return 动画
 */
- (CABasicAnimation *)strokeAnimation
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    baseAnimation.delegate = self;
    baseAnimation.duration = self.drawDuration;
    baseAnimation.repeatCount = 1;
    baseAnimation.fromValue = @0;
    baseAnimation.toValue = @1;
    return baseAnimation;
}

/**
 *  根据属性判断是否需要对比例进行排序呢
 *
 *  @return 排序后的数组
 */
- (NSArray *)sortArray
{
    if (self.sortWay == NSOrderedSame) {
        return self.pieArray;
    } else {
        return [self.pieArray sortedArrayUsingComparator:^NSComparisonResult(XPieChartObject *  _Nonnull obj1, XPieChartObject *  _Nonnull obj2) {
            if (self.sortWay == NSOrderedAscending) {
                return obj1.pieRatio < obj2.pieRatio;
            } else {
                return obj2.pieRatio < obj1.pieRatio;
            }
        }];
    }
}
/**
 *  对数据进行排序 赋值
 */
- (void)originPieArray
{
    self.sortPieArray = [self sortArray];
    for (int i = 0; i < self.sortPieArray.count; i++) {
        XPieChartObject *obj = self.sortPieArray[i];
        if (i == 0) {
            obj.pieAngle = 2 * M_PI;
        } else if (i == self.sortPieArray.count - 1) {
            CGFloat angle = M_PI * obj.pieRatio * 2;
            if (!self.isClockwise) {
                angle = -angle;
            }
            obj.pieAngle = angle;
        } else {
            CGFloat angle = M_PI * 2 - self.drawAngle;
            if (!self.isClockwise) {
                angle = -angle;
            }
            obj.pieAngle = angle;
        }
        self.drawAngle += obj.pieRatio * M_PI * 2;
    }
}

/**
 *  计算最大角度等
 */
- (void)computeMaxAngle
{
    NSArray *sortArray = self.sortPieArray;
    NSInteger index = 0;
    CGFloat max = 0;
    for (int i = 0; i < sortArray.count; i++) {
        XPieChartObject *obj = sortArray[i];
        if (max < obj.pieRatio) {
            max = obj.pieRatio;
            index = i;
        }
    }
    self.maxAngle = max * 2 * M_PI;
    CGFloat beginMax = 0.f;
    for (int i = 0; i < index; i++) {
        XPieChartObject *obj = sortArray[i];
        beginMax += obj.pieRatio;
    }
    self.maxBeginAngle = beginMax * 2 * M_PI;
}
/**
 *  旋转动画
 */
- (void)transformAnimation
{
    if (!self.needTransform) {
        return;
    }
    [self computeMaxAngle];
    CGFloat moveAngle = 0.f;
    if (self.isClockwise) {
        moveAngle = self.transformAngle - self.beginAngle + self.maxBeginAngle + self.maxAngle / 2;
    } else {
        moveAngle = self.transformAngle - self.beginAngle + 2 * M_PI - self.maxAngle / 2 - self.maxBeginAngle;
    }

    CATransform3D transform = CATransform3DRotate(self.bgLayer.transform,  moveAngle, 0, 0, 1);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:self.bgLayer.transform];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = self.transformDuration;
    animation.repeatCount = 1.f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.bgLayer addAnimation:animation forKey:@"transformAnimation"];
}

@end

@implementation XPieChartObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pieAngle = 0.f;
        self.pieColor = X_ARC_Color;
        self.pieRatio = 0.f;
    }
    return self;
}

@end
