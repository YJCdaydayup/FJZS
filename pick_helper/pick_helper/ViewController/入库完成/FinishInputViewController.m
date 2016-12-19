//
//  FinishInputViewController.m
//  pick_helper
//
//  Created by 杨力 on 16/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "FinishInputViewController.h"
#import "PickingInViewController.h"
#import "WaitingViewController.h"

@interface FinishInputViewController ()

@end

@implementation FinishInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pick_setNavWithTitle:@"入库分拣完成"];
}

-(void)createView{
    
    for(UIView * subView in self.view.subviews){
        [subView removeFromSuperview];
    }
    [self pick_configViewWithImg:@"wancheng" isWeight:NO];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(10*S6, NAV_BAR_HEIGHT+50*S6, Wscreen-20*S6, Hscreen-90*S6-NAV_BAR_HEIGHT-50*S6)];
    bgView.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
    bgView.layer.borderWidth = 1.0*S6;
    [self.view addSubview:bgView];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT+100*S6,147/2*S6, 73*S6)];
    imgView.centerX = self.view.centerX;
    [self getBundleImg:@"duigou" callback:^(NSData *imgData) {
        imgView.image = [UIImage imageWithData:imgData];
    }];
    [self.view addSubview:imgView];
    
    UILabel * titleLable = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+50*S6, Wscreen,26*S6) textContent:@"分拣任务已全部完成" withFont:[UIFont systemFontOfSize:26*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    titleLable.centerX = self.view.centerX;
    [self.view addSubview:titleLable];
    
    UILabel * descripLabel = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(titleLable.frame)+20*S6, Wscreen-150*S6, 60*S6) textContent:@"入库分拣任务已全部完成，请确认所有货品都已正确入库。" withFont:[UIFont systemFontOfSize:17*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentLeft];
    descripLabel.centerX = self.view.centerX;
    descripLabel.numberOfLines = 2;
    [self.view addSubview:descripLabel];
    
    UIButton * checkBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, CGRectGetMaxY(descripLabel.frame)+30*S6, Wscreen-130*S6, 35*S6) textContent:@"查看已完成任务" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    checkBtn.centerX = self.view.centerX;
    checkBtn.backgroundColor = PICKER_NAV_COLOR;
    [self.view addSubview:checkBtn];
    
    UIButton * finishedBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, CGRectGetMaxY(checkBtn.frame)+20*S6, checkBtn.width, checkBtn.height) textContent:@"确定完成任务" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    finishedBtn.centerX = self.view.centerX;
    finishedBtn.backgroundColor = RGB_COLOR(125, 17, 20, 1);
    [self.view addSubview:finishedBtn];
    
    [self configBtn:checkBtn withTag:0];
    [self configBtn:finishedBtn withTag:1];
}

-(void)configBtn:(UIButton *)btn withTag:(NSInteger)tag{
    
    btn.layer.cornerRadius = 35/2.0*S6;
    btn.layer.masksToBounds = YES;
    btn.tag = tag;
    [btn setTitleColor:RGB_COLOR(29, 29, 29, 0.5) forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClicks:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClicks:(UIButton *)btn{
    
    if(btn.tag == 0){
        //查看完成任务
        PickingInViewController * pickVc = [[PickingInViewController alloc]initWithData:self.responseObj fromVc:self];
        [self pushToViewControllerWithTransition:pickVc withDirection:@"left" type:NO];
    }else{
        //确定完成任务
        self.hud.labelText = @"正在提交任务,请稍后...";
        [self.hud show:YES];
        NSDictionary * dict = @{@"model":@"batar.input.mobile",@"method":@"confirm_putaway",@"args":@[self.responseObj[@"data"][@"input_id"]],@"kwargs":@{}};
        [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
            
            if(error == nil){
                if(responseObject){
                    //完成
                    [self.hud hide:YES];
                    WaitingViewController * waitingVc = [[WaitingViewController alloc]initWithData:responseObject fromVc:self];
                    [self presentViewController:waitingVc animated:YES completion:^{
                        [self removeFromParentViewController];
                    }];
                }else{
                    //失败
                    [self showAlertView:@"确认失败，请重试!" time:1.0];
                }
            }else{
                [self pick_loginByThirdParty:error];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
