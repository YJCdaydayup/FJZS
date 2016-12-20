//
//  LoginViewController.m
//  pick_helper
//
//  Created by 杨力 on 13/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "LoginViewController.h"
#import "WaitingViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong,nullable) UITextField * pick_user_tf;
@property (nonatomic,strong,nullable) UITextField * pick_psw_tf;

@end

@implementation LoginViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide) name:UIKeyboardWillHideNotification object:nil];
    [self pick_setNavWithTitle:@"登录"];
}

-(void)pickCantainText{
    
    NSString * str = [KUSERDEFAUL objectForKey:PICKER_USER];
    if(str.length > 0){
        self.pick_user_tf.text = [KUSERDEFAUL objectForKey:PICKER_USER];
        self.pick_psw_tf.text = [KUSERDEFAUL objectForKey:PICKER_PSW];
    }
}

-(void)createView{
    
    UIImageView * logo_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70*S6+NAV_BAR_HEIGHT, 295/2.0*S6, 63*S6)];
    logo_image.centerX = self.view.centerX;
    [self.view addSubview:logo_image];
    [self getBundleImg:@"logo" callback:^(NSData *imgData) {
        logo_image.image = [UIImage imageWithData:imgData];
    }];
    
    UIImageView * sub_logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logo_image.frame)+22.5*S6, 376/2.0*S6, 47/2.0*S6)];
    sub_logoImg.centerX = self.view.centerX;
    [self getBundleImg:@"name" callback:^(NSData *imgData) {
        sub_logoImg.image = [UIImage imageWithData:imgData];
    }];
    [self.view addSubview:sub_logoImg];
    
    self.pick_user_tf = [Tools createTextFieldFrame:CGRectMake(0, CGRectGetMaxY(sub_logoImg.frame)+60*S6, 280*S6, 35*S6) placeholder:@"请输入用户名" bgImageName:nil leftView:nil rightView:nil isPassWord:NO];
    [self configTf:self.pick_user_tf withView:@"user"];
    [self.view addSubview:self.pick_user_tf];
    
    self.pick_psw_tf = [Tools createTextFieldFrame:CGRectMake(CGRectGetMinX(self.pick_user_tf.frame), CGRectGetMaxY(self.pick_user_tf.frame)+22.5*S6, 280*S6, 35*S6) placeholder:@"请输入密码" bgImageName:nil leftView:nil rightView:nil isPassWord:YES];
    [self configTf:self.pick_psw_tf withView:@"password"];
    [self.view addSubview:self.pick_psw_tf];
    
    UIButton * loginBtn = [Tools createNormalButtonWithFrame:CGRectMake(CGRectGetMinX(self.pick_psw_tf.frame), CGRectGetMaxY(self.pick_psw_tf.frame)+50*S6, 280*S6, 35*S6) textContent:@"登录使用" withFont:[UIFont systemFontOfSize:15*S6] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    loginBtn.backgroundColor = PICKER_NAV_COLOR;
    [self.view addSubview:loginBtn];
    loginBtn.layer.cornerRadius = 35/2.0*S6;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self pickCantainText];
}

-(void)configTf:(UITextField *)tf withView:(NSString *)imgName{
    
    tf.delegate = self;
    tf.backgroundColor = [UIColor whiteColor];
    tf.centerX = self.view.centerX;
    tf.layer.borderWidth = 1*S6;
    tf.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
    tf.layer.cornerRadius = 35/2.0*S6;
    tf.layer.masksToBounds = YES;
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40*S6, 35*S6)];
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView * placeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    placeImg.frame = CGRectMake(10*S6, 8*S6, 17*S6, 17*S6);
    [leftView addSubview:placeImg];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(placeImg.frame)+5*S6, 8*S6, 1*S6, 17*S6)];
    lineView.backgroundColor = PICKER_BORDER_COLOR;
    [leftView addSubview:lineView];
    
    //改变输入框placeholder的字体大小和颜色
    [tf setValue:PICKER_TEXT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    tf.font = [UIFont systemFontOfSize:14];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)loginAction{
    
    if(self.pick_psw_tf.text.length==0||self.pick_user_tf.text.length==0){
        [self showAlertView:@"请输入用户名或密码!" time:0.5];
        return;
    }
    
    self.hud.labelText = @"正在登录,请稍后...";
    [self.hud show:YES];
    
    __block typeof(self)weakSelf = self;
    NSDictionary * dict = @{@"db":PICKER_DATABASE,@"login":self.pick_user_tf.text,@"password":self.pick_psw_tf.text};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_LOGIN param:dict callback:^(id responseObject, NSError *error) {
        if(error==nil){
            [weakSelf.hud hide:YES];
            //登录成功
            [KUSERDEFAUL setObject:self.pick_user_tf.text forKey:PICKER_USER];
            [KUSERDEFAUL setObject:self.pick_psw_tf.text forKey:PICKER_PSW];
            
            WaitingViewController * waitingVc = [[WaitingViewController alloc]init];
            [self pushToViewControllerWithTransition:waitingVc withDirection:@"right" type:NO];
        }else{
            //登录失败
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.hud hide:YES];
                [self showAlertView:@"登录失败,请检查网络或重新输入" time:0.8];
            });
        }
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == self.pick_user_tf){
        
        textField.returnKeyType = UIReturnKeyDefault;
        [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -50*S6);
        }];
    }else if (textField == self.pick_psw_tf){
        textField.returnKeyType = UIReturnKeyGo;
        [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -50*S6);
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == self.pick_user_tf){
        [self.pick_user_tf resignFirstResponder];
        [self.pick_psw_tf becomeFirstResponder];
    }else{
        [self.pick_user_tf resignFirstResponder];
        [self.pick_psw_tf resignFirstResponder];
        //登录
        [self loginAction];
    }
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
