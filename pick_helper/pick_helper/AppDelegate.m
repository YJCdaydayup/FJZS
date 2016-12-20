//
//  AppDelegate.m
//  pick_helper
//
//  Created by 杨力 on 13/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WaitingViewController.h"

@interface AppDelegate ()

@property (nonatomic,strong) NSTimer * taskTimer;
@property (nonatomic,strong) UIAlertController * alertVc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start) name:SERVEALERT object:nil];
    
    [self createTimer];
    [self commonSetting];
    
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    self.window.rootViewController = nvc;
    
    return YES;
}

-(void)createTimer{
    
    self.taskTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(serverCheck) userInfo:nil repeats:YES];
    [self stop];
}

-(void)serverCheck{
    
    NSLog(@"通知收到的值: %@; 类型:%@",[KUSERDEFAUL objectForKey:SERVEALERTID],[[KUSERDEFAUL objectForKey:SERVEALERTID] class]);
    NSDictionary * dict = @{@"model":@"batar.mobile.picking",@"method":@"get_task_state",@"args":@[[KUSERDEFAUL objectForKey:SERVEALERTID]],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            BOOL state = [responseObject boolValue];
            if(state){
                //交付
                [self stop];
                WaitingViewController * waitingVc = [[WaitingViewController alloc]init];
                UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:waitingVc];
                [Tools presentFromWindow:self.window forward:nvc];
            }
        }else{
            [self stop];
            [self pick_loginByThirdParty:error];
        }
    }];
}

-(void)stop{
    
    [self.taskTimer setFireDate:[NSDate distantFuture]];
}

-(void)start{
    
    [self.taskTimer setFireDate:[NSDate distantPast]];
}

-(void)commonSetting{
    
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)pick_loginByThirdParty:(NSError *)error{
    
    if([error.description containsString:@"404"]){
        
        [Tools presentFromWindow:self.window forward:self.alertVc];
        
    }else{
        //请求错误
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"获取数据失败!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self.window.rootViewController presentViewController:alertVc animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertVc dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
}

-(UIAlertController *)alertVc{
    
    if(!_alertVc){
        _alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前账号被其他手机登录" preferredStyle:UIAlertControllerStyleAlert];
        //被其他用户登录
        UIAlertAction * exitBtn = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [Tools exit];
        }];
        UIAlertAction * reLoginBtn = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            LoginViewController * loginVc = [[LoginViewController alloc]init];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:loginVc];
            [Tools presentFromWindow:self.window forward:nvc];
        }];
        [_alertVc addAction:exitBtn];
        [_alertVc addAction:reLoginBtn];
    }
    return _alertVc;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
