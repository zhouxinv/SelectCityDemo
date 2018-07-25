//
//  SelectCityViewController.h
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCityModel.h"
@class SelectCityViewController;
@class SelectCityModel;
@protocol SelectCityViewControllerDelegate <NSObject>
@optional
/// 自定义headerView
- (UIView *)selectCityViewControllerViewForHeader:(SelectCityViewController *)selectCityViewController;
///headerView的高度
- (CGFloat)selectCityViewControllerHeightForHeader:(SelectCityViewController *)selectCityViewController;
///选择的城市
- (void)selectCityViewControll:(SelectCityViewController *)selectCityViewController selectCityArray:(NSArray<SelectCityModel *> *)selectCityArray;
///点击了重置按钮
- (void)selectCityViewControllerOnClickReset:(UIButton *)button;
//数据源选择的城市
- (NSArray<SelectCityModel *> *)selectCityViewControllerSelectCityArrayDataSource;
//不可以取消的城市
- (NSArray<SelectCityModel *> *)selectCityViewControllerCannotCancelCityArrayDataSource;
//点击了城市
- (void)selectCityViewControllerDidSelectedBySelf;
@end

@interface SelectCityViewController : UIViewController
@property (nonatomic, weak) id<SelectCityViewControllerDelegate> delegate;

/**
 刷新当前选中的数组
 */
- (void)reloadSelectCityViewController;

@end
