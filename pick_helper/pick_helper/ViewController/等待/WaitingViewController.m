//
//  WaitingViewController.m
//  pick_helper
//
//  Created by 杨力 on 14/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "WaitingViewController.h"
#import "PickingInViewController.h"
#import "WeightViewController.h"

@interface WaitingViewController(){
    
    NSTimer * timer;
}
@end

@implementation WaitingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)createView{
    
    self.view.backgroundColor = RGB_COLOR(131, 25, 28, 1);
    
    UILabel * waitLabel = [Tools createLabelWithFrame:CGRectMake(10, 150*S6, Wscreen-10, 30*S6) textContent:@"等待分配分拣任务" withFont:[UIFont systemFontOfSize:30*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    waitLabel.centerX = self.view.centerX;
    [self.view addSubview:waitLabel];
    
    //获取本地图片
    GifView * dataView = [[GifView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(waitLabel.frame)+30*S6,380/2.0*S6,94/2.0*S6) filePath:[[NSBundle mainBundle] pathForResource:@"waiting" ofType:@"gif"]];
    dataView.backgroundColor = [UIColor clearColor];
    dataView.centerX = self.view.centerX;
    [self.view addSubview:dataView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)getData{
    
    NSDictionary * dict = @{@"model":@"batar.mobile.task",@"method":@"get_task",@"args":@[@""],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        if(error == nil){
            NSString * type = responseObject[@"type"];
            if([type isEqualToString:@"input"]){
                //入库任务
                [self inputTask:responseObject];
            }else{
                //出库任务
                [self pickTask:responseObject];
            }
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

-(void)inputTask:(id)responseObj{
    
    NSInteger code_int = [responseObj[@"code"]integerValue];
    switch (code_int) {
        case 200://首条任务
        {
            
        }
            break;
        case 201://获取当前任务
        {
            [self stop];
            PickingInViewController * inputVc = [[PickingInViewController alloc]initWithData:responseObj tag:NO];
            [self pushToViewControllerWithTransition:inputVc withDirection:@"right" type:NO];
        }
            break;
        case 203://获取称重明细
        {
            [self stop];
            WeightViewController * weightVc = [[WeightViewController alloc]initWithData:responseObj tag:YES];
            [self pushToViewControllerWithTransition:weightVc withDirection:@"right" type:NO];
        }
            break;
        case 400://finished
            break;
        case 500://keep waiting
            break;
        default:
            break;
    }
}

-(void)pickTask:(id)responseObj{
    
}

-(void)stop{
    
    self.navigationController.navigationBar.hidden = NO;
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)start{
    [timer setFireDate:[NSDate distantPast]];
}

@end
