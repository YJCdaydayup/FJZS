//
//  RootViewController.m
//  pick_helper
//
//  Created by 杨力 on 13/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self createView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(instancetype)initWithData:(id)responseObject tag:(BOOL)fromTag{
    
    if(self = [super init]){
       
    }
    return self;
}

-(void)pick_setNavWithTitle:(NSString *)title{
    
    [self.navigationController.navigationBar setBarTintColor:PICKER_NAV_COLOR];
    self.title = title;
    self.view.backgroundColor = PICKER_BG_COLOR;
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
