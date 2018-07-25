//
//  SelectCityTableViewCell.m
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import "SelectCityTableViewCell.h"
#import "SelectCityModel.h"

@interface SelectCityTableViewCell ()
@property (nonatomic, strong) UIImageView *imgChose;
@property (nonatomic, strong) UILabel *labCityName;
@end

@implementation SelectCityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViewsAndConstraints];
    }
    return self;
}


#pragma mark - createSubViewsAndConstraints
- (void)createSubViewsAndConstraints {
    UIImage *imgNotSelect = [UIImage imageNamed:@"未选中状态"];
    _imgChose = [[UIImageView alloc] initWithFrame:CGRectMake(24, (self.contentView.bounds.size.height - imgNotSelect.size.height) * 0.5, imgNotSelect.size.width, imgNotSelect.size.height)];
    _imgChose.image = imgNotSelect;
    [self.contentView addSubview:_imgChose];
    
    _labCityName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgChose.frame) + 20 , 0, self.contentView.bounds.size.width - 20 - imgNotSelect.size.width - 24 , self.contentView.bounds.size.height)];
    _labCityName.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    _labCityName.font = [UIFont systemFontOfSize:16];
    _labCityName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_labCityName];
    
    UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - 0.5, self.contentView.bounds.size.width, 0.5)];
    vline.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
    [self.contentView addSubview:vline];
    
}

- (void)makeCityCellWithSelectCityModel:(SelectCityModel *)model indexPath:(NSIndexPath *)indexPath {
    if (model.isSelect == YES) {
         UIImage *imgSelect = [UIImage imageNamed:@"选中状态"];
         _imgChose.image = imgSelect;
    } else {
        UIImage *imgNotSelect = [UIImage imageNamed:@"未选中状态"];
        _imgChose.image = imgNotSelect;
    }
    
    _labCityName.text = model.CN;
}






@end
