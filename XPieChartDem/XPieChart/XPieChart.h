//
//  XPieChart.h
//  gfsdhgasdfbbgf
//
//  Created by LiX i n long on 16/8/3.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPieChartObject;
@interface XPieChart : UIView

/**
 *  开始角度
 */
@property (nonatomic, assign) CGFloat beginAngle;
/**
 *  外环半径
 */
@property (nonatomic, assign) CGFloat outRadius;
/**
 *  内环半径
 */
@property (nonatomic, assign) CGFloat inRadius;
/**
 *  draw时长
 */
@property (nonatomic, assign) CFTimeInterval drawDuration;
/**
 *  转动方向 逆时针还是顺时针 默认逆时针
 */
@property (nonatomic, assign) BOOL isClockwise;
/**
 *  draw结束之后是否需要转动到最大比例中间位置 默认yes
 */
@property (nonatomic, assign) BOOL needTransform;
/**
 *  最大比例点的中心角度0-M_PI 默认M_PI_4 || M_PI_4 * 3
 */
@property (nonatomic, assign) CGFloat transformAngle;
/**
 *  转动时长 默认一秒
 */
@property (nonatomic, assign) CFTimeInterval transformDuration;
/**
 *  排序规则
 */
@property (nonatomic) NSComparisonResult sortWay;
/**
 *  比例数组
 */
//@property (nonatomic, strong) NSArray <NSNumber *>*ratioArray;
///**
// *  颜色数组
// */
//@property (nonatomic, strong) NSArray <UIColor *>*colorArray;

@property (nonatomic, strong) NSArray <XPieChartObject *>*pieArray;

/**
 *  设置结束后开始动画
 */
- (void)beginAnimation;

@end

@interface XPieChartObject : NSObject

@property (nonatomic, assign) CGFloat pieRatio;  //比例
@property (nonatomic, strong) UIColor *pieColor; //颜色

@property (nonatomic, assign) CGFloat pieAngle;

@end
