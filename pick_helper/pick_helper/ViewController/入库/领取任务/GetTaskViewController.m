//
//  GetTaskViewController.m
//  pick_helper
//
//  Created by 杨力 on 16/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "GetTaskViewController.h"
#import "PickingInViewController.h"

@interface GetTaskViewController ()

@end

@implementation GetTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self pick_setNavWithTitle:@"入库分拣"];
    [self pick_configViewWithImg:@"jieshou" isWeight:NO];
}

-(void)createView{
    
    NSDictionary * dict = self.responseObj[@"data"];
    NSArray * array = @[@"验货员",dict[@"user_id"],@"盘号",dict[@"plate"]];
    CGFloat sum = 0;
    for(int i=0;i<4;i++){
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(10*S6+(i%2)*(Wscreen-30*S6)/2.0+(i%2)*(-0.2)*S6,i/2*(-0.5)*S6+NAV_BAR_HEIGHT+50*S6+(i/2)*60*S6, (Wscreen-30*S6)/2.0, 60*S6) textContent:array[i] withFont:[UIFont systemFontOfSize:20*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentCenter];
        sum = sum + label.width;
        label.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
        label.layer.borderWidth = 0.5*S6;
        label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:label];
        
        if(i == 3){
            [self createLabel:label];
        }
    }
}

-(void)createLabel:(UILabel *)label{
    
    NSString * text = @"请到验货台领取需要分拣入库的货品，当场确认后点击领取货品，开始入库分拣";
    UILabel * labels = [Tools createLabelWithFrame:CGRectMake(23*S6, CGRectGetMaxY(label.frame)+10*S6, Wscreen-60*S6,[self getLabelHeight:text]) textContent:text withFont:[UIFont systemFontOfSize:15*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentLeft];
    labels.numberOfLines = 0;
    [self.view addSubview:labels];
    
    UIButton * getTaskBtn = [Tools createNormalButtonWithFrame:CGRectMake(0, CGRectGetMaxY(labels.frame)+130*S6, Wscreen-90*S6, 35*S6) textContent:@"领取货品" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    getTaskBtn.centerX = self.view.centerX;
    getTaskBtn.backgroundColor = PICKER_NAV_COLOR;
    getTaskBtn.layer.cornerRadius = 17.5*S6;
    getTaskBtn.layer.masksToBounds = YES;
    [self.view addSubview:getTaskBtn];
    [getTaskBtn addTarget:self action:@selector(getTaskAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)getTaskAction{
    
    NSDictionary * dict = @{@"model":@"batar.input.mobile",@"method":@"get_input_plate",@"args":@[self.responseObj[@"data"][@"id"]],@"kwargs":@{}};
    self.hud.labelText = @"正在获取数据...";
    [self.hud show:YES];
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        
        [self.hud hide:YES];
        if([GETSTRING(responseObject[@"code"])isEqualToString:@"201"])
        {
            PickingInViewController * pickVc = [[PickingInViewController alloc]initWithData:responseObject tag:NO];
            [self pushToViewControllerWithTransition:pickVc withDirection:@"right" type:NO];
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

-(CGFloat)getLabelHeight:(NSString *)text{
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(Wscreen-60*S6, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15*S6]} context:nil].size;
    return size.height;
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
