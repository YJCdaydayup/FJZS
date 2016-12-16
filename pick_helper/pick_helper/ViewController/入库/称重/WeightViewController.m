
//
//  WeightViewController.m
//  pick_helper
//
//  Created by 杨力 on 15/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "WeightViewController.h"
#import "WeightModel.h"
#import "WeightViewCell.h"
#import "PickingInViewController.h"

@interface WeightViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView * weightTableView;
}

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation WeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pick_setNavWithTitle:@"需称重任务"];
    [self pick_configViewWithImg:@"jianru" isWeight:YES];
}

-(void)createView{
    
    weightTableView = [[UITableView alloc]initWithFrame:CGRectMake(10*S6, 50*S6+NAV_BAR_HEIGHT, Wscreen-20*S6, Hscreen-NAV_BAR_HEIGHT-100*S6)];
    weightTableView.delegate = self;
    weightTableView.dataSource = self;
    weightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    weightTableView.tableFooterView = [UIView new];
    weightTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:weightTableView];
    
    [self createData];
}

-(void)createData{
    
    self.dataArray = [NSMutableArray array];
    NSArray * array = self.responseObj[@"data"];
    for(NSDictionary * dict in array){
        WeightModel * model = [[WeightModel alloc]initWithDictionary:dict error:nil];
        [self.dataArray addObject:model];
    }
    [weightTableView reloadData];
    
    [self createBottomView];
}

-(void)createBottomView{
    
    NSArray * array = @[@"查看上一条",@"查看下一条"];
    for(int i=0;i<array.count;i++){
        
        UIButton * btn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen/2.0*i,Hscreen- 50*S6, Wscreen/2.0, 50*S6) textContent:array[i] withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        if(i == 0){
            btn.backgroundColor = RGB_COLOR(29, 29, 29, 0.5);
            btn.enabled = NO;
        }else{
            btn.backgroundColor = PICKER_NAV_COLOR;
        }
        btn.tag = i;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)checkAction:(UIButton *)btn{
 
    if(btn.tag == 1){
     
        NSDictionary * dict = @{@"model":@"batar.mobile.task",@"method":@"get_task",@"args":@[@""],@"kwargs":@{}};
        [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
            if(error == nil){
                [self inputTask:responseObject];
            }else{
                [self pick_loginByThirdParty:error];
            }
        }];
    }
}

-(void)inputTask:(id)responseObj{
    
    NSInteger code_int = [responseObj[@"code"]integerValue];
    switch (code_int) {
        case 201://获取当前任务
        {
            PickingInViewController * inputVc = [[PickingInViewController alloc]initWithData:responseObj tag:NO];
            [self pushToViewControllerWithTransition:inputVc withDirection:@"right" type:NO];
        }
            break;
        case 203://获取称重明细
            break;
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

#define CELLID @"cell"
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeightViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if(cell == nil){
        cell = [[WeightViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.model = self.dataArray[indexPath.row];
    cell.userInteractionEnabled = NO;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59.5*S6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, Wscreen-20*S6, 40*S6)];
    bgView.backgroundColor = [UIColor whiteColor];
    NSArray * array = @[@"产品名称",@"产品编号",@"库位",@"数量"];
    float sum = 0;
    for(int i=0;i<array.count;i++){
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(sum+(i%4)*(-0.2)*S6,i/4*(-0.5)*S6, 163*S6, 40.5*S6) textContent:array[i] withFont:[UIFont systemFontOfSize:14*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentCenter];
        switch (i) {
            case 0:
                label.width = 110*S6;
                break;
            case 1:
                label.width = 110*S6;
                break;
            case 2:
                label.width = 75*S6;
                break;
            case 3:
                label.width = 60*S6;
                break;
            default:
                break;
        }

        sum = sum + label.width;
        label.backgroundColor = [UIColor whiteColor];
        label.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
        label.layer.borderWidth = 0.5*S6;
        [bgView addSubview:label];
    }
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*S6;
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
