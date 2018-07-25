//
//  SelectProvinceTableViewCell.m
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import "SelectProvinceTableViewCell.h"
#import "OTBageValue.h"
#import "SelectProvinceModel.h"

static CGFloat const selectProvinceTableViewCell_width = 130;
static CGFloat const selectProvinceTableViewCell_height = 50;
@interface SelectProvinceTableViewCell ()
@property (nonatomic, strong) UILabel *labProvinceName;
@property (nonatomic, strong) OTBageValue *btnBageValue;
@end

@implementation SelectProvinceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViewsAndConstraints];
    }
    return self;
}

#pragma mark - createSubViewsAndConstraints
- (void)createSubViewsAndConstraints {
    _labProvinceName = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, selectProvinceTableViewCell_width, selectProvinceTableViewCell_height)];
    _labProvinceName.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    _labProvinceName.font = [UIFont systemFontOfSize:16];
    _labProvinceName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_labProvinceName];
    
    OTBageValue *btnBageValue = [[OTBageValue alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
    _btnBageValue = btnBageValue;
    btnBageValue.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:btnBageValue];
    
    UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - 0.5, selectProvinceTableViewCell_width, 0.5)];
    vline.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    [self.contentView addSubview:vline];
    
}

- (void)makeProvinceCellWithSelectProvinceModel:(SelectProvinceModel *)model indexPath:(NSIndexPath *)indexPath {
    _labProvinceName.text = model.PN;
    [self updateProvinceSelectCityCount:model.count];
    if (model.selected == YES) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1];
    }
}

-(void)updateProvinceSelectCityCount:(NSInteger)count {
    if (count > 0) {
        _btnBageValue.hidden = NO;
        NSString *strCount = [NSString stringWithFormat:@"%ld", count];
        [_btnBageValue setTitle:strCount forState:UIControlStateNormal];
        CGFloat width = [strCount sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].width;
        width = width < 16 ? 16 : width;
        CGFloat labWidth = [_labProvinceName.text boundingRectWithSize:CGSizeMake(130, 50) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.width;
  
        CGFloat x = (selectProvinceTableViewCell_width - labWidth) * 0.5 + labWidth;
        _btnBageValue.frame = CGRectMake(x, 7, width, 16);
    } else {
        _btnBageValue.hidden = YES;
    }
    
}

@end
