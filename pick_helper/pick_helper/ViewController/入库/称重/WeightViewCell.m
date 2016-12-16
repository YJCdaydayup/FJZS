//
//  WeightViewCell.m
//  pick_helper
//
//  Created by 杨力 on 15/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "WeightViewCell.h"

@implementation WeightViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self createView];
    }
    return self;
}

-(void)createView{
    
    CGFloat sum = 0;
    for(int i=0;i<4;i++){
        
        UILabel * label = [Tools createLabelWithFrame:CGRectMake(sum+(i%4)*(-0.2)*S6,i/4*(-0.5)*S6, 163*S6, 60.5*S6) textContent:nil withFont:[UIFont systemFontOfSize:14*S6] textColor:PICKER_TETMAIN_COLOR textAlignment:NSTextAlignmentCenter];
        switch (i) {
            case 0:
                label.width = 110*S6;
                break;
            case 1:
                label.width = 110*S6;
                break;
            case 2:
                label.width = 75*S6;
                break;
            case 3:
                label.width = 60*S6;
                break;
            default:
                break;
        }
        sum = sum + label.width;
        label.backgroundColor = [UIColor whiteColor];
        label.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
        label.layer.borderWidth = 0.5*S6;
        [self.contentView addSubview:label];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
