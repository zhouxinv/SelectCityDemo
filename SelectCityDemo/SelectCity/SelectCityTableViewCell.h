//
//  SelectCityTableViewCell.h
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectCityModel;
@interface SelectCityTableViewCell : UITableViewCell
- (void)makeCityCellWithSelectCityModel:(SelectCityModel *)model indexPath:(NSIndexPath *)indexPath;
@end
