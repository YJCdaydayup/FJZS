//
//  RootViewController.h
//  pick_helper
//
//  Created by 杨力 on 13/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetBundleIMG)(NSData *imgData);

@interface RootViewController : UIViewController

@property (nonatomic,strong) MBProgressHUD * hud;

-(void)pick_setNavWithTitle:(NSString *)title;
-(void)createView;
-(void)getBundleImg:(NSString *)imgName callback:(GetBundleIMG)block;

@end
