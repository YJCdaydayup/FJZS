
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
    weightTableView.backgroundColor = [UIColor redColor];
    weightTableView.delegate = self;
    weightTableView.dataSource = self;
    weightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    cell.textLabel.text = @"123";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59.5*S6;
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
