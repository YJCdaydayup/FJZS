//
//  WeightViewCell.m
//  pick_helper
//
//  Created by 杨力 on 15/12/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "WeightViewCell.h"

@interface WeightViewCell()

@property (nonatomic,strong,nullable) UILabel * pick_name;
@property (nonatomic,strong,nullable) UILabel * pick_bgCode;
@property (nonatomic,strong,nullable) UILabel * pick_srcCode;
@property (nonatomic,strong,nullable) UILabel * pick_qty;

@end

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
                self.pick_name = label;
                break;
            case 1:
                label.width = 110*S6;
                self.pick_bgCode = label;
                break;
            case 2:
                label.width = 75*S6;
                self.pick_srcCode = label;
                break;
            case 3:
                label.width = 60*S6;
                self.pick_qty = label;
                self.pick_qty.numberOfLines = 2;
                break;
            default:
                break;
        }
        sum = sum + label.width;
        label.layer.borderColor = [PICKER_BORDER_COLOR CGColor];
        label.layer.borderWidth = 0.5*S6;
        [self.contentView addSubview:label];
    }
}

-(void)setModel:(WeightModel *)model{
    
    self.pick_bgCode.text = model.package;
    self.pick_name.text = model.product;
    self.pick_qty.text = [NSString stringWithFormat:@"%@           (%@)",model.qty,model.uom];
    self.pick_srcCode.text = model.src_location;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
