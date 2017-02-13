//
//  PKTransFinalController.m
//  pick_helper
//
//  Created by 杨力 on 13/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import "PKTransFinalController.h"
#import "PKTransController.h"

@interface PKTransFinalController ()

@property (nonatomic,strong) UILabel * totalLabel;

@end

@implementation PKTransFinalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pick_setNavWithTitle:@"调拨完成"];
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
    
    UILabel * titleLable = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+50*S6, Wscreen,26*S6) textContent:@"调拨出库已全部完成" withFont:[UIFont systemFontOfSize:26*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    titleLable.centerX = self.view.centerX;
    [self.view addSubview:titleLable];
    
    self.totalLabel = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(titleLable.frame)+30*S6, Wscreen-100*S6, 50*S6) textContent:@"" withFont:[UIFont systemFontOfSize:22*S6] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    self.totalLabel.centerX = self.view.centerX;
    self.totalLabel.layer.cornerRadius = 3*S6;
    self.totalLabel.layer.masksToBounds = YES;
    self.totalLabel.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
    self.totalLabel.layer.borderWidth = 1.0*S6;
    [self.view addSubview:self.totalLabel];
    
    UILabel * descripeLable = [Tools createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.totalLabel.frame)+20*S6, Wscreen-135*S6, 60*S6) textContent:@"请把已调拨出库的货品移交至验货台，并当场确认完成交交接。" withFont:[UIFont systemFontOfSize:17*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentLeft];
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
    
    NSDictionary * dict = @{@"model":@"internal.trans.mobile",@"method":@"get_state",@"args":@[@""],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        if(error == nil){
            
            if([responseObject integerValue]== 0){
                [self dealWithResult];
            }
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

-(void)dealWithResult{

    [KUSERDEFAUL setValue:self.responseObj[@"data"][@"id"] forKey:PKTransServerID];
    NSLog(@"最后界面的值: %@; 类型:%@",[KUSERDEFAUL objectForKey:PKTransServerID],[[KUSERDEFAUL objectForKey:SERVEALERTID] class]);
    [[NSNotificationCenter defaultCenter]postNotificationName:PKTransFinishedNotice object:nil];
    
    NSString * total = [NSString stringWithFormat:@"分拣盘内总数: %@",self.responseObj[@"data"][@"total"]];
    self.totalLabel.text = total;
}

-(void)checkAction{
    
    PKTransController * pickOutVc = [[PKTransController alloc]initWithData:self.responseObj fromVc:self];
    [self pushToViewControllerWithTransition:pickOutVc withDirection:@"left" type:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
