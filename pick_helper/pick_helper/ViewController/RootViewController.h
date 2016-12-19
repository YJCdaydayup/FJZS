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
@property (nonatomic,strong) id responseObj;
@property (nonatomic,strong) id destinateVc;

-(instancetype)initWithData:(id)responseObject tag:(BOOL)fromTag;
-(instancetype)initWithData:(id)responseObject fromVc:(id)Vc;
-(void)pick_configViewWithImg:(NSString *)imgName isWeight:(BOOL)isWeight;
-(void)pick_setNavWithTitle:(NSString *)title;
-(void)createView;
-(void)getBundleImg:(NSString *)imgName callback:(GetBundleIMG)block;
-(void)showAlertView:(NSString *)alertStr time:(NSInteger)time;
-(void)pick_loginByThirdParty:(NSError *)error;//根据不同的error，弹出不同的警告

@end
