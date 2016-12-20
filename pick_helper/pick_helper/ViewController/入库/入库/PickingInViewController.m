//
//  PickingInViewController.m
//  pick_helper
//
//  Created by 杨力 on 15/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "PickingInViewController.h"
#import "WeightViewController.h"
#import "FinishInputViewController.h"

typedef enum : NSInteger {
    PickerNextTaskType,//查看下一条
    PickerBeforeTaskType,//查看上一条
    PickerSeperateType,//拆分后的订单
    PickerFinishedType,//已经完成
} PickerType;

@interface PickingInViewController ()<UITextFieldDelegate>{
    
    UILabel * pick_product;
    UILabel * pick_default_code;
    UILabel * pick_location_id;//库位
    UITextField * pick_qty;
    UILabel * pick_src_location;//盘位
    
    UIButton * addBtn;
    UIButton * loseBtn;
    
    UITextField * pick_left_tf;
    UITextField * pick_right_tf;
}

@property (nonatomic,strong) NSNumber * currentQty;
@property (nonatomic,strong) NSNumber * initialQty;
@property (nonatomic,strong) NSDictionary * currentDict;
@property (nonatomic,assign) PickerType pickerType;

@property (nonatomic,strong) NSMutableDictionary * backToCurrentDict;
@property (nonatomic,strong) UIButton * checkNextBtn;

@end

@implementation PickingInViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [pick_qty addTarget:self action:@selector(test) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pick_setNavWithTitle:@"入库分拣任务"];
    [self pick_configViewWithImg:@"jianru" isWeight:NO];
}

-(void)test{
    
    CGFloat tf_text = [pick_qty.text floatValue];
    CGFloat initialQty = [self.initialQty floatValue];
    if(tf_text < 0||tf_text>initialQty){
        [self showAlertView:@"输入数量非法，请重新输入!" time:1.0];
        pick_qty.text = GETSTRING(self.initialQty);
        self.currentQty = self.initialQty;
    }
}

-(void)createView{
    
    NSArray * formArray = @[@"产品名称",@"",@"产品编码",@"",@"盘位号",@"",@"数量",@"",@"到库位",@""];
    for(int i=0;i<formArray.count;i++){
        
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(10*S6+i%2*163*S6,NAV_BAR_HEIGHT+50*S6+i/2*75*S6+1.5*S6, 163*S6, 76*S6) textContent:formArray[i] withFont:[UIFont systemFontOfSize:20*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentCenter];
        if(i%2 == 0){
            label.width = 163*S6;
        }else{
            label.width = 192*S6;
        }
        switch (i) {
            case 1:
                pick_product = label;
                break;
            case 3:
                pick_default_code = label;
                break;
            case 5:
                pick_src_location = label;
                break;
            case 7:
                [self resetQtyLabel:label];
                break;
            case 9:
                [self resetStoreLabel:label];
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
    self.currentDict = self.responseObj[@"data"];
    [self setValueToLabel:self.currentDict];
}

-(void)createBottomView{
    
    NSArray * array = @[@"查看上一条",@"查看下一条"];
    for(int i=0;i<array.count;i++){
        
        UIButton * btn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen/2.0*i,Hscreen- 50*S6, Wscreen/2.0, 50*S6) textContent:array[i] withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        if(i == 0){
            btn.backgroundColor = RGB_COLOR(231, 140, 59, 1);
        }else{
            btn.backgroundColor = PICKER_NAV_COLOR;
            self.checkNextBtn = btn;
        }
        btn.tag = i;
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)checkAction:(UIButton *)btn{
    
    if(btn.tag == 0){
        //查看上一条
        [self checkBeforeTask];
    }else{
        //查看下一条
        [self checkNextTask];
    }
}

#pragma mark - 下一条
-(void)checkNextTask{
    
    if(self.pickerType == PickerBeforeTaskType){
        
        self.pickerType = PickerNextTaskType;
        self.currentDict = self.backToCurrentDict;
        [self setValueToLabel:self.currentDict];
        return;
    }else if(self.pickerType == PickerFinishedType){
        
        [self popToViewControllerWithDirection:@"right" type:NO];
        return;
    }
    
    NSDictionary * dict = @{@"model":@"batar.input.mobile",@"method":@"get_next_line",@"args":@[self.currentDict[@"id"],self.currentQty,[self pickLocaion]],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            
            NSInteger code_int = [responseObject[@"code"]integerValue];
            switch (code_int) {
                case 501:
                    [self showAlertView:@"库位不存在,请重新输入!" time:1.0];
                    break;
                case 502:
                    [self showAlertView:@"库位已预占,请重新输入!" time:1.0];
                    break;
                case 201:
                {
                    [self.backToCurrentDict removeAllObjects];
                    self.pickerType = PickerNextTaskType;
                    self.currentDict = responseObject[@"data"];
                    [self setValueToLabel:self.currentDict];
                }
                    break;
                case 203:
                {
                    WeightViewController * weightVc = [[WeightViewController alloc]initWithData:responseObject tag:YES];
                    [self pushToViewControllerWithTransition:weightVc withDirection:@"right" type:NO];
                }
                    break;
                case 400:
                {
                    FinishInputViewController * finishedVc = [[FinishInputViewController alloc]initWithData:responseObject fromVc:self];
                    [self pushToViewControllerWithTransition:finishedVc withDirection:@"right" type:NO];
                }
                    break;
                default:
                    break;
            }
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

#pragma mark - 上一条
-(void)checkBeforeTask{
    
    if(self.backToCurrentDict.allKeys.count == 0){
        self.backToCurrentDict = [[NSMutableDictionary alloc]initWithDictionary:self.currentDict];
    }
    
    NSDictionary * dict = @{@"model":@"batar.input.mobile",@"method":@"get_pre_line",@"args":@[self.currentDict[@"id"]],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            
            NSInteger code_int = [responseObject[@"code"]integerValue];
            switch (code_int) {
                case 500:
                    [self showAlertView:@"已经是第一条" time:0.5];
                    break;
                case 201:
                {
                    self.pickerType = PickerBeforeTaskType;
                    self.currentDict = responseObject[@"data"];
                    [self setValueToLabel:self.currentDict];
                }
                    break;
                case 203:
                {
                    WeightViewController * weightVc = [[WeightViewController alloc]initWithData:responseObject tag:YES];
                    [self pushToViewControllerWithTransition:weightVc withDirection:@"right" type:NO];
                }
                    break;
                default:
                    break;
            }
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

-(NSString *)pickLocaion{
    
    return [NSString stringWithFormat:@"%@-%@",pick_left_tf.text,pick_right_tf.text];
}

-(void)resetStoreLabel:(UILabel *)label{
    
    label.userInteractionEnabled = YES;
    pick_left_tf = [Tools createTextFieldFrame:CGRectMake(25*S6, 17*S6, 55*S6, 45*S6) placeholder:nil bgImageName:nil leftView:nil rightView:nil isPassWord:NO];
    pick_left_tf.textAlignment = NSTextAlignmentCenter;
    pick_left_tf.returnKeyType = UIReturnKeyDone;
    pick_left_tf.delegate = self;
    [self setObjAppearance:pick_left_tf];
    [label addSubview:pick_left_tf];
    
    pick_right_tf = [Tools createTextFieldFrame:CGRectMake(111*S6, 17*S6, 55*S6, 45*S6) placeholder:nil bgImageName:nil leftView:nil rightView:nil isPassWord:NO];
    pick_right_tf.textAlignment = NSTextAlignmentCenter;
    pick_right_tf.returnKeyType = UIReturnKeyDone;
    pick_right_tf.delegate = self;
    [self setObjAppearance:pick_right_tf];
    [label addSubview:pick_right_tf];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(90*S6, 37*S6, 12*S6, 2*S6)];
    line.backgroundColor = PICKER_TETMAIN_COLOR;
    [label addSubview:line];
}

-(void)resetQtyLabel:(UILabel *)label{
    
    label.userInteractionEnabled = YES;
    pick_qty = [Tools createTextFieldFrame:CGRectMake(70*S6, 17*S6, label.width-140*S6, 45*S6) placeholder:nil bgImageName:nil leftView:nil rightView:nil isPassWord:NO];
    pick_qty.textAlignment = NSTextAlignmentCenter;
    pick_qty.returnKeyType = UIReturnKeyDone;
    pick_qty.delegate = self;
    [self setObjAppearance:pick_qty];
    [label addSubview:pick_qty];
    
    addBtn = [Tools createButtonNormalImage:@"add_btn" selectedImage:nil tag:1 addTarget:self action:@selector(addClick)];
    addBtn.frame = CGRectMake(20*S6, 22*S6, 35*S6, 35*S6);
    addBtn.enabled = NO;
    [label addSubview:addBtn];
    
    loseBtn = [Tools createButtonNormalImage:@"lose_btn" selectedImage:nil tag:1 addTarget:self action:@selector(loseClick)];
    loseBtn.frame = CGRectMake(CGRectGetMaxX(pick_qty.frame)+15*S6, 22*S6, 35*S6, 35*S6);
    [label addSubview:loseBtn];
}

-(void)setObjAppearance:(UIView *)view{
    
    view.layer.borderWidth = 0.5*S6;
    view.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
    view.layer.cornerRadius = 3*S6;
    view.layer.masksToBounds = YES;
    view.backgroundColor = RGB_COLOR(234, 234, 234, 1);
}

-(void)addClick{
    
    float qty = [self.currentQty floatValue];
    qty = qty + 1.0;
    self.currentQty = [NSNumber numberWithFloat:qty];
    pick_qty.text = GETSTRING(self.currentQty);
    [self changeAddBtnState:self.currentQty];
    [self changeLoseBtnState:self.currentQty];
}

-(void)loseClick{
    
    float qty = [self.currentQty floatValue];
    qty = qty-1.0;
    self.currentQty = [NSNumber numberWithFloat:qty];
    pick_qty.text = GETSTRING(self.currentQty);
    [self changeLoseBtnState:self.currentQty];
    [self changeAddBtnState:self.currentQty];
}

-(void)changeAddBtnState:(NSNumber *)currentQty{
    
    CGFloat qty = [currentQty floatValue]+1;
    CGFloat initialQty = [self.initialQty floatValue];
    if(qty>initialQty){
        addBtn.enabled = NO;
    }else{
        addBtn.enabled = YES;
    }
}

-(void)changeLoseBtnState:(NSNumber *)currentQty{
    
    CGFloat qty = [currentQty floatValue]-1;
    if(qty<0){
        loseBtn.enabled = NO;
    }else{
        loseBtn.enabled = YES;
    }
}

-(void)setValueToLabel:(NSDictionary *)dict{
    
    pick_product.text = dict[@"product"];
    pick_default_code.text = dict[@"default_code"];
    pick_src_location.text = dict[@"src_location"];
    pick_qty.text = [NSString stringWithFormat:@"%@",dict[@"qty"]];
    
    self.currentQty = dict[@"qty"];
    self.initialQty = dict[@"qty"];
    
    if([self.destinateVc isKindOfClass:[FinishInputViewController class]]){
        self.pickerType = PickerFinishedType;
    }else{
        NSString * locationId = dict[@"location_id"];
        if(locationId.length>0&&self.pickerType != PickerBeforeTaskType){
            self.pickerType = PickerSeperateType;
        }
    }

    if(self.pickerType == PickerFinishedType){
     
        [self setLocationValue:dict[@"location_id"]];
        [self changeAbleState:NO];
        [self.checkNextBtn setTitle:@"任务已完成" forState:UIControlStateNormal];
    }else if(self.pickerType == PickerNextTaskType){
        
        pick_left_tf.text = nil;
        pick_right_tf.text = nil;
        [self changeAbleState:YES];
        [self.checkNextBtn setTitle:@"查看下一条" forState:UIControlStateNormal];
    }else if (self.pickerType == PickerSeperateType){
        
        [self setLocationValue:dict[@"location_id"]];
        [self changeAbleState:YES];
        [self.checkNextBtn setTitle:@"查看下一条" forState:UIControlStateNormal];
    }else if (self.pickerType == PickerBeforeTaskType){
        
        [self setLocationValue:dict[@"location_id"]];
        [self changeAbleState:NO];
        [self.checkNextBtn setTitle:@"返回当前任务" forState:UIControlStateNormal];
    }
}

-(void)changeAbleState:(BOOL)state{
    
    pick_left_tf.enabled = state;
    pick_right_tf.enabled = state;
    pick_qty.enabled = state;
    addBtn.enabled = state;
    loseBtn.enabled = state;
    
    if(self.pickerType == PickerNextTaskType||self.pickerType == PickerSeperateType){
        //修改按钮的状态
        [self changeAddBtnState:self.currentQty];
        [self changeLoseBtnState:self.currentQty];
    }
}

-(void)setLocationValue:(NSString *)str{
    
    NSArray * array = [str componentsSeparatedByString:@"-"];
    pick_left_tf.text = array[0];
    pick_right_tf.text = array[1];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == pick_qty){
        [UIView animateWithDuration:0.2 animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, -150*S6);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, -130*S6);
        }];
    }
    return YES;
}

-(void)keyBoardWillHide{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    
    if([pick_qty.text intValue]==0){
        
        [self showAlertView:@"输入数量非法，请重新输入!" time:1.0];
        pick_qty.text = GETSTRING(self.initialQty);
        self.currentQty = self.initialQty;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
