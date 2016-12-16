//
//  WeightModel.h
//  pick_helper
//
//  Created by 杨力 on 15/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "JSONModel.h"

@interface WeightModel : JSONModel
//"default_code" = "502/20";
//id = 56;
//"net_weight" = 0;
//package = P22;
//product = "TEST\Uff0812-13\Uff09";
//qty = "0.16";
//sequence = 4;
//"src_location" = C5;
//uom = g;

@property (nonatomic,copy,nullable) NSString * product;
@property (nonatomic,copy,nullable) NSString * package;
@property (nonatomic,copy,nullable) NSString * src_location;
@property (nonatomic,copy,nullable) NSString * qty;
@property (nonatomic,copy,nullable) NSString * uom;


@end
