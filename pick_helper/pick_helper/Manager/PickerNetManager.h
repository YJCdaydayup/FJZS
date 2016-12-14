//
//  PickerNetManager.h
//  pick_helper
//
//  Created by 杨力 on 13/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFJSONRPCClient/AFJSONRPCClient.h>

typedef void(^PickerNetBlock)(id responseObject,NSError * error);
@interface PickerNetManager : NSObject

+(instancetype)sharePickerManager;
+(void)pick_requestPickerDataWithURL:(NSString *)urlString param:(NSDictionary *)dict callback:(PickerNetBlock)block;

@end
