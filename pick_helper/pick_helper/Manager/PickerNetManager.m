//
//  PickerNetManager.m
//  pick_helper
//
//  Created by 杨力 on 13/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "PickerNetManager.h"

@implementation PickerNetManager

+(instancetype)sharePickerManager{
    
    static PickerNetManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PickerNetManager alloc]init];
    });
    return manager;
}

+(void)pick_requestPickerDataWithURL:(NSString *)urlString param:(NSDictionary *)dict callback:(PickerNetBlock)block{
    
        AFJSONRPCClient * client = [[AFJSONRPCClient alloc]initWithEndpointURL:[NSURL URLWithString:urlString]];
        [client invokeMethod:@"nil" withParameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(nil,error);
        }];
}


@end
