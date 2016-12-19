//
//  PickingOutViewController.m
//  pick_helper
//
//  Created by 杨力 on 19/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "PickingOutViewController.h"

@interface PickingOutViewController (){
    
    UIButton * changePlateBtn;
    
    
}

@end

@implementation PickingOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self pick_setNavWithTitle:@"分拣任务"];
    [self pick_configViewWithPickOutImg:@"jianchu"];
}

-(void)createView{
    
    changePlateBtn = [Tools createNormalButtonWithFrame:CGRectMake(10, 10, 50*S6, 25*S6) textContent:@"换盘" withFont:[UIFont systemFontOfSize:16*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentRight];
    [changePlateBtn setTitleColor:RGB_COLOR(23, 23, 23, 0.8) forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:changePlateBtn];
    [changePlateBtn addTarget:self action:@selector(changePlate) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray * formArray = @[@"产品名称",@"",@"产品编码",@"",@"从库位",@"",@"数量",@"",@"到盘位",@"",@"分拣盘内总数",@""];
    for(int i=0;i<formArray.count;i++){
        
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(10*S6+i%2*163*S6,NAV_BAR_HEIGHT+50*S6+i/2*75*S6+1.5*S6, 163*S6, 76*S6) textContent:formArray[i] withFont:[UIFont systemFontOfSize:20*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentCenter];
        if(i%2 == 0){
            label.width = 163*S6;
        }else{
            label.width = 192*S6;
        }
        switch (i) {
            case 1:
                break;
            case 3:
                break;
            case 4:
                break;
            case 5:
                break;
            case 7:
                break;
            case 8:
                break;
            case 9:
                break;
            case 11:
                break;
            default:
                break;
        }
        label.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
        label.layer.borderWidth = 0.5*S6;
        label.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:label];
    }
    
    [self createBottomView];
//    self.currentDict = self.responseObj[@"data"];
//    [self setValueToLabel:self.currentDict];
}

-(void)createBottomView{
    
    NSArray * array = @[@"查看上一条",@"查看下一条"];
    for(int i=0;i<array.count;i++){
        
        UIButton * btn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen/2.0*i,Hscreen- 50*S6, Wscreen/2.0, 50*S6) textContent:array[i] withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        if(i == 0){
            btn.backgroundColor = RGB_COLOR(220, 119, 40, 1);
        }else{
            btn.backgroundColor = PICKER_NAV_COLOR;
        }
        btn.tag = i;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)checkAction:(UIButton *)btn{

    
    
}

-(void)changePlate{
    
    
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
