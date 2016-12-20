//
//  PickingOutFinisedViewController.m
//  pick_helper
//
//  Created by 杨力 on 19/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "PickingOutFinisedViewController.h"
#import "PickingOutViewController.h"

@interface PickingOutFinisedViewController ()

@property (nonatomic,strong) UILabel * totalLabel;

@end

@implementation PickingOutFinisedViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pick_setNavWithTitle:@"分拣完成"];
}

-(void)createView{
    
    for(UIView * subView in self.view.subviews){
        [subView removeFromSuperview];
    }
    
    [self pick_configViewWithPickOutImg:@"finish"];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NAV_BAR_HEIGHT+100*S6,147/2*S6, 73*S6)];
    imgView.centerX = self.view.centerX;
    [self getBundleImg:@"duigou" callback:^(NSData *imgData) {
        imgView.image = [UIImage imageWithData:imgData];
    }];
    [self.view addSubview:imgView];
    
    UILabel * titleLable = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+50*S6, Wscreen,26*S6) textContent:@"分拣任务已全部完成" withFont:[UIFont systemFontOfSize:26*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    titleLable.centerX = self.view.centerX;
    [self.view addSubview:titleLable];
    
    self.totalLabel = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(titleLable.frame)+30*S6, Wscreen-100*S6, 50*S6) textContent:@"" withFont:[UIFont systemFontOfSize:22*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    self.totalLabel.centerX = self.view.centerX;
    self.totalLabel.layer.cornerRadius = 3*S6;
    self.totalLabel.layer.masksToBounds = YES;
    self.totalLabel.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
    self.totalLabel.layer.borderWidth = 1.0*S6;
    [self.view addSubview:self.totalLabel];
    
    UILabel * descripeLable = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.totalLabel.frame)+20*S6, Wscreen-135*S6, 52*S6) textContent:@"请把已分拣的货品移交至验货台，并当场确认完成交交接。" withFont:[UIFont systemFontOfSize:18*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentLeft];
    descripeLable.centerX = self.view.centerX;
    descripeLable.numberOfLines = 0;
    [self.view addSubview:descripeLable];
    
    UIButton * checkBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, CGRectGetMaxY(descripeLable.frame)+50*S6, 280*S6, 35*S6) textContent:@"查看已完成任务" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    checkBtn.centerX = self.view.centerX;
    [checkBtn setTitleColor:RGB_COLOR(29, 29, 29, 0.8) forState:UIControlStateHighlighted];
    checkBtn.backgroundColor = PICKER_NAV_COLOR;
    checkBtn.layer.cornerRadius = 35/2.0*S6;
    checkBtn.layer.masksToBounds = YES;
    [self.view addSubview:checkBtn];
    
    [checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self createData];
}

-(void)createData{
    
    NSDictionary * dict = @{@"model":@"batar.mobile.task",@"method":@"get_task",@"args":@[@""],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        if(error == nil){
            
            NSInteger code_int = [responseObject[@"code"]integerValue];
            if(code_int == 400){
                [self dealWithResult:responseObject];
            }
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

-(void)dealWithResult:(id)responseObject{
    
    self.responseObj = responseObject;
    [KUSERDEFAUL setValue:responseObject[@"data"][@"id"] forKey:SERVEALERTID];
    NSLog(@"最后界面的值: %@; 类型:%@",[KUSERDEFAUL objectForKey:SERVEALERTID],[[KUSERDEFAUL objectForKey:SERVEALERTID] class]);
    [[NSNotificationCenter defaultCenter]postNotificationName:SERVEALERT object:nil];
    
    NSString * total = [NSString stringWithFormat:@"分拣盘内总数: %@",self.responseObj[@"data"][@"total"]];
    self.totalLabel.text = total;
}

-(void)checkAction{
    
    PickingOutViewController * pickOutVc = [[PickingOutViewController alloc]initWithData:self.responseObj fromVc:self];
    [self pushToViewControllerWithTransition:pickOutVc withDirection:@"left" type:NO];
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
