//
//  RootViewController.m
//  pick_helper
//
//  Created by 杨力 on 13/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RootViewController.h"
#import "WaitingViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide) name:UIKeyboardWillHideNotification object:nil];
    [self createView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)pick_configViewWithImg:(NSString *)imgName isWeight:(BOOL)isWeight{
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10*S6, 10*S6+NAV_BAR_HEIGHT, 550/2.0*S6, 30*S6)];
    [self getBundleImg:imgName callback:^(NSData *imgData) {
        imgView.image = [UIImage imageWithData:imgData];
    }];
    [self.view addSubview:imgView];
    
    UIImageView * weihgtImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+17*S6, CGRectGetMinY(imgView.frame), 115/2.0*S6, 30*S6)];
    if(isWeight){
        [self getBundleImg:@"weight_sel" callback:^(NSData *imgData) {
            weihgtImg.image = [UIImage imageWithData:imgData];
        }];
    }else{
        [self getBundleImg:@"weight_nor" callback:^(NSData *imgData) {
            weihgtImg.image = [UIImage imageWithData:imgData];
        }];
    }
    [self.view addSubview:weihgtImg];
}

-(void)pick_configViewWithPickOutImg:(NSString *)imgName{
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10*S6, 10*S6+NAV_BAR_HEIGHT, 427/2.0*S6, 30*S6)];
    [self getBundleImg:imgName callback:^(NSData *imgData) {
        imgView.image = [UIImage imageWithData:imgData];
    }];
    [self.view addSubview:imgView];
}

-(void)keyBoardWillHide{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

-(instancetype)initWithData:(id)responseObject tag:(BOOL)fromTag{
    
    if(self = [super init]){
        self.responseObj = responseObject;
    }
    return self;
}

-(instancetype)initWithData:(id)responseObject fromVc:(id)Vc{
    
    if(self = [super init]){
        self.responseObj = responseObject;
        self.destinateVc = Vc;
    }
    return self;
}

-(void)pick_setNavWithTitle:(NSString *)title{
    
    [self.navigationController.navigationBar setBarTintColor:PICKER_NAV_COLOR];
    self.title = title;
    self.view.backgroundColor = PICKER_BG_COLOR;
    self.navigationItem.hidesBackButton = YES;
}

-(void)createView{
    
}

-(void)getBundleImg:(NSString *)imgName callback:(GetBundleIMG)block{
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    UIImage * img= [UIImage imageNamed:imgName];
    NSData * data = UIImagePNGRepresentation(img);
    dispatch_async(dispatch_get_main_queue(), ^{
        block(data);
    });
    //    });
}

-(MBProgressHUD *)hud{
    
    if(!_hud){
        
        _hud = [[MBProgressHUD alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_hud];
    }
    return _hud;
}

-(void)showAlertView:(NSString *)alertStr time:(NSInteger)time{
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:alertStr message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVc animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

-(void)pick_loginByThirdParty:(NSError *)error{
    
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
