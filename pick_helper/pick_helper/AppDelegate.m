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
    
    NSLog(@"%@",[[KUSERDEFAUL objectForKey:SERVEALERTID]class]);
    NSDictionary * dict = @{@"model":@"batar.mobile.picking",@"method":@"get_task_state",@"args":@[[KUSERDEFAUL objectForKey:SERVEALERTID]],@"kwargs":@{}};
    [PickerNetManager pick_requestPickerDataWithURL:PICKER_TASK param:dict callback:^(id responseObject, NSError *error) {
        
        if(error == nil){
            BOOL state = [responseObject boolValue];
            if(state){
                //交付
                [self stop];
                WaitingViewController * waitingVc = [[WaitingViewController alloc]init];
                [self.window.rootViewController pushToViewControllerWithTransition:waitingVc withDirection:@"left" type:NO];
            }
        }else{
            [self stop];
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
