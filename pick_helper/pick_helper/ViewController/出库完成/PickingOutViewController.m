//
//  PickingOutViewController.m
//  pick_helper
//
//  Created by 杨力 on 19/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "PickingOutViewController.h"
#import "PickingOutFinisedViewController.h"

typedef enum : NSInteger{
    PickerCheckNextType,
    PickerCheckBeforeType,
    PickerFromFinishType,
    
}PickerOutType;

@interface PickingOutViewController ()<UITextFieldDelegate>{
    
    UIButton * changePlateBtn;
    
    UILabel * pick_product;
    UILabel * pick_default_code;
    
    UILabel * pick_src_location_title;//库位
    UILabel * pick_src_location;
    
    UITextField * pick_qty;
    UIButton * addBtn;
    UIButton * loseBtn;
    
    UILabel * pick_des_location_title;//盘位
    UILabel * pick_des_location;
    
    UIButton * checkNextBtn;
}

@property (nonatomic,assign) PickerOutType pickOutType;

@property (nonatomic,strong) NSDictionary * currentDict;
@property (nonatomic,strong) NSNumber * currentQty;
@property (nonatomic,strong) NSNumber * initialQty;

@property (nonatomic,strong) NSMutableDictionary * backToCurrentDict;
@end

@implementation PickingOutViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [pick_qty addTarget:self action:@selector(test) forControlEvents:UIControlEventEditingChanged];
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
    
    NSArray * formArray = @[@"产品名称",@"",@"产品编码",@"",@"从库位",@"",@"数量",@"",@"到盘位",@""];
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
            case 4:
                pick_src_location_title= label;
                break;
            case 5:
                pick_src_location = label;
                pick_src_location.numberOfLines = 0;
                break;
            case 7:
                //数量
                [self resetQtyLabel:label];
                break;
            case 8:
                pick_des_location_title = label;
                break;
            case 9:
                pick_des_location = label;
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

-(void)createBottomView{
    
    NSArray * array = @[@"查看上一条",@"查看下一条"];
    for(int i=0;i<array.count;i++){
        
        UIButton * btn = [Tools createNormalButtonWithFrame:CGRectMake(Wscreen/2.0*i,Hscreen- 50*S6, Wscreen/2.0, 50*S6) textContent:array[i] withFont:[UIFont systemFontOfSize:17*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        if(i == 0){
            btn.backgroundColor = RGB_COLOR(220, 119, 40, 1);
        }else{
            btn.backgroundColor = PICKER_NAV_COLOR;
            checkNextBtn = btn;
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

#pragma mark - 查看上一条
-(void)checkBeforeTask{
    
    if(self.backToCurrentDict.allKeys.count == 0){
        self.backToCurrentDict = [[NSMutableDictionary alloc]initWithDictionary:self.currentDict];
    }
    
    NSDictionary * dict = @{@"model":@"batar.mobile.picking",@"method":@"get_pre_line",@"args":@[self.currentDict[@"id"]],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            
            NSInteger code_int = [responseObject[@"code"]integerValue];
            switch (code_int) {
                case 201:
                    if(self.pickOutType != PickerFromFinishType){
                        self.pickOutType = PickerCheckBeforeType;
                    }
                    self.currentDict = responseObject[@"data"];
                    [self setValueToLabel:self.currentDict];
                    break;
                case 500:
                    [self showAlertView:@"已经是第一条" time:1.0];
                    break;
                default:
                    break;
            }
            
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

#pragma mark - 查看下一条
-(void)checkNextTask{
    
    if(self.pickOutType == PickerFromFinishType){
        
        [self popToViewControllerWithDirection:@"right" type:NO];
        return;
    }
    
    if(self.pickOutType == PickerCheckBeforeType){
        self.pickOutType = PickerCheckNextType;
        self.currentDict = self.backToCurrentDict;
        [self setValueToLabel:self.currentDict];
        return;
    }
    
    NSDictionary * dict = @{@"model":@"batar.mobile.picking",@"method":@"get_next_line",@"args":@[self.currentDict[@"id"],self.currentQty],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            
            NSInteger code_int = [responseObject[@"code"]integerValue];
            switch (code_int) {
                case 201:
                {
                    [self.backToCurrentDict removeAllObjects];
                    self.currentDict = responseObject[@"data"];
                    [self setValueToLabel:self.currentDict];
                }
                    break;
                case 400:
                {
                    PickingOutFinisedViewController * pickVc = [[PickingOutFinisedViewController alloc]initWithData:responseObject fromVc:self];
                    [self pushToViewControllerWithTransition:pickVc withDirection:@"left" type:NO];
                }
                default:
                    break;
            }
            
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

#pragma mark - 换盘
-(void)changePlate{
    
    NSDictionary * dict = @{@"model":@"batar.mobile.picking",@"method":@"change_tuopan",@"args":@[self.currentDict[@"id"]],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            
            self.currentDict = responseObject[@"data"];
            pick_des_location.text = self.currentDict[@"des_location"];
        }else{
            [self pick_loginByThirdParty:error];
        }
    }];
}

-(void)setValueToLabel:(NSDictionary *)dict{
    
    pick_product.text = dict[@"product"];
    pick_default_code.text = dict[@"default_code"];
    pick_src_location.text = dict[@"src_location"][1];
    pick_qty.text = GETSTRING(dict[@"qty"]);
    pick_des_location.text = dict[@"des_location"];
    
    self.currentQty = dict[@"qty"];
    self.initialQty = dict[@"qty"];
    
    [self changeAddBtnState:self.currentQty];
    [self changeLoseBtnState:self.currentQty];
    
    if([self.currentDict[@"total"]integerValue]>0||self.pickOutType == PickerFromFinishType){
        self.pickOutType = PickerFromFinishType;
    }else{
        
        if(self.pickOutType == PickerCheckBeforeType){
            
            [checkNextBtn setTitle:@"返回当前任务" forState:UIControlStateNormal];
            [self changeState:NO];
        }else if (self.pickOutType == PickerCheckNextType){
            
            [checkNextBtn setTitle:@"下一条任务" forState:UIControlStateNormal];
        }
    }
    
    if (self.pickOutType == PickerFromFinishType){
        
        [checkNextBtn setTitle:@"任务已完成" forState:UIControlStateNormal];
        [self changeState:NO];
    }
}

-(void)changeState:(BOOL)state{
    
    addBtn.enabled = state;
    loseBtn.enabled = state;
    pick_qty.enabled = state;
    changePlateBtn.hidden = state;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -60*S6);
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
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
