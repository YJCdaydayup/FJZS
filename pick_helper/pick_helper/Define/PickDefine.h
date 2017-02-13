//
//  PickDefine.h
//  pick_helper
//
//  Created by 杨力 on 13/2/2017.
//  Copyright © 2017 杨力. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickDefine : NSObject

UIKIT_EXTERN NSString * const PICKER_USER;

UIKIT_EXTERN NSString * const PICKER_PSW;

UIKIT_EXTERN NSString * const SERVEALERTNOTICE;//出库完成后，发出通知

UIKIT_EXTERN NSString * const SERVEALERTID;

UIKIT_EXTERN NSString * const PKTransFinishedNotice; //调拨出库完成，发出通知

UIKIT_EXTERN NSString * const PKTransServerID; //调拨出库完成，服务器确认ID

@end
