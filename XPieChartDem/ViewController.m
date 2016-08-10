//
//  ViewController.m
//  XPieChartDem
//
//  Created by LiX i n long on 16/8/10.
//  Copyright © 2016年 LiX i n long. All rights reserved.
//

#import "ViewController.h"

#import "XPieChart.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    XPieChartObject *obj1 = [[XPieChartObject alloc] init];
    obj1.pieRatio = 0.12;
    obj1.pieColor = [UIColor redColor];
    XPieChartObject *obj2 = [[XPieChartObject alloc] init];
    obj2.pieRatio = 0.34;
    obj2.pieColor = [UIColor greenColor];
    XPieChartObject *obj3 = [[XPieChartObject alloc] init];
    obj3.pieRatio = 0.25;
    obj3.pieColor = [UIColor orangeColor];
    XPieChartObject *obj4 = [[XPieChartObject alloc] init];
    obj4.pieRatio = 0.08;
    obj4.pieColor = [UIColor yellowColor];
    XPieChartObject *obj5 = [[XPieChartObject alloc] init];
    obj5.pieRatio = 0.21;
    obj5.pieColor = [UIColor blackColor];
    
    XPieChart *pieView = [[XPieChart alloc] initWithFrame:self.view.bounds];
    pieView.outRadius = 100;
    pieView.inRadius = 0;
    pieView.pieArray = @[obj1, obj2, obj3, obj4, obj5];
    pieView.sortWay = NSOrderedDescending;
    pieView.isClockwise = YES;
    [self.view addSubview:pieView];
    
    [pieView beginAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
