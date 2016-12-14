//
//  WaitingViewController.m
//  pick_helper
//
//  Created by 杨力 on 14/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "WaitingViewController.h"

@implementation WaitingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)createView{
    
    self.view.backgroundColor = PICKER_NAV_COLOR;
    
    UILabel * waitLabel = [Tools createLabelWithFrame:CGRectMake(10, 150*S6, Wscreen-10, 30*S6) textContent:@"等待分配分拣任务" withFont:[UIFont systemFontOfSize:30*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    waitLabel.centerX = self.view.centerX;
    waitLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:waitLabel];
    
    //获取本地图片
    GifView * dataView = [[GifView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(waitLabel.frame)+30*S6,290*S6,157/2.0*S6) filePath:[[NSBundle mainBundle] pathForResource:@"waiting" ofType:@"gif"]];
    [self.view addSubview:dataView];

}

@end
