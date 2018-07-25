//
//  SelectCityViewController.m
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectProvinceTableViewCell.h"
#import "SelectCityTableViewCell.h"
#import "SelectProvinceModel.h"
#import "SelectCityModel.h"


static NSString *const SelectProvinceTableViewCellReuseID = @"SelectProvinceTableViewCell";
static NSString *const SelectCityTableViewCellReuseID = @"SelectCityTableViewCell";

@interface SelectCityViewController ()<UITableViewDelegate, UITableViewDataSource>
/* 第一个tableview */
@property (nonatomic, strong) UITableView *tabFirstLevel;
/* 第二个tableview */
@property (nonatomic, strong) UITableView *tabSecondLevel;
/* 选中按钮 */
@property (nonatomic, strong) UIButton *btnConfirm;
#pragma mark - 业务数据
/* 省份数据 */
@property (nonatomic, strong) NSArray<SelectProvinceModel *> *arrFirstLevel;
@property (nonatomic, strong) SelectProvinceModel *currentProvinceModel;
/* 城市数据 */
@property (nonatomic, strong) NSArray<SelectCityModel *> *arrSecondLevel;
/* 选中的城市 */
@property (nonatomic, strong) NSMutableArray<SelectCityModel *> *arrSelectCity;
/* 不可以取消的城市 */
@property (nonatomic, strong) NSArray<SelectCityModel *> *arrCannotCancelCity;
#pragma mark - UI数据
@property (nonatomic, assign) CGFloat tabFirstLevel_width;
@property (nonatomic, assign) CGFloat tabSecondLevel_width;
@property (nonatomic, assign) CGFloat tabFirstLevel_height;
@end

@implementation SelectCityViewController

- (instancetype)init {
    if (self = [super init]) {
        [self initalDefaultValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableLeftBackButton];
    [self createSubViewsAndConstraints];
    self.title = @"选择城市";
}

- (void)enableLeftBackButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"tab返回"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tab返回点击态"] forState:UIControlStateSelected];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [btn addTarget:self action:@selector(onClickBtnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)onClickBtnBack:(UIButton *)btn {
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Public

- (void)reloadSelectCityViewController {
    NSArray *cidArray = nil;
    if ([_delegate respondsToSelector:@selector(selectCityViewControllerSelectCityArrayDataSource)]) {
        cidArray = [_delegate selectCityViewControllerSelectCityArrayDataSource];
    }
    NSArray *cannotCancelCityArray = nil;
    if ([_delegate respondsToSelector:@selector(selectCityViewControllerCannotCancelCityArrayDataSource)]) {
        cannotCancelCityArray = [_delegate selectCityViewControllerCannotCancelCityArrayDataSource];
    }
    
    [self reloadSelectCityArray:cidArray cannotCancelCityArray:cannotCancelCityArray];
    
}
- (void)reloadSelectCityArray:(NSArray<SelectCityModel *> *)cidArray cannotCancelCityArray:(NSArray<SelectCityModel *> *)cannotCancelCityArray {
    [_arrSelectCity removeAllObjects];
    if (cannotCancelCityArray != nil) {
        _arrCannotCancelCity = cannotCancelCityArray;
    }
    
    if (cannotCancelCityArray.count > 0) {
        // 移动不可取消的城市为第一位
        NSMutableArray *arrFirstMutabel = [NSMutableArray arrayWithArray:_arrFirstLevel];
        NSMutableArray *arrFirstSelectCount = [NSMutableArray array];
        __block SelectProvinceModel *cannotCancelProvince = nil;
        [_arrFirstLevel enumerateObjectsUsingBlock:^(SelectProvinceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [cannotCancelCityArray enumerateObjectsUsingBlock:^(SelectCityModel * _Nonnull cannotCancelCity, NSUInteger idx, BOOL * _Nonnull stop) {
                if (cannotCancelCity.PI == obj.PI) {
                    cannotCancelProvince = obj;
                    [arrFirstMutabel removeObject:cannotCancelProvince];
                    [arrFirstSelectCount addObject:cannotCancelProvince];
                }
            }];
        }];
        NSIndexSet *indexset = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, arrFirstSelectCount.count)];
        [arrFirstMutabel insertObjects:arrFirstSelectCount atIndexes:indexset];
      
         _arrFirstLevel = arrFirstMutabel;
       
    }
    
    //赋值
    __weak typeof(self) weakSelf = self;
    self.currentProvinceModel = nil;
    [_arrFirstLevel enumerateObjectsUsingBlock:^(SelectProvinceModel * _Nonnull provinceModel, NSUInteger idx, BOOL * _Nonnull stop) {
        //赋值默认值
         provinceModel.selected = NO;
        [weakSelf selectArrayCityModelWithSelectCityArray:cidArray provinceModel:provinceModel];
    }];
    if (_currentProvinceModel == nil) {
        self.currentProvinceModel =  _arrFirstLevel.firstObject;
        self.currentProvinceModel.selected = YES;
    }
     _arrSecondLevel = _currentProvinceModel.cityarray;
    // 刷新
    [_tabFirstLevel reloadData];
    [_tabSecondLevel reloadData];
    [self uploadBtnConfirm];
}



- (void)selectArrayCityModelWithSelectCityArray:(NSArray<SelectCityModel *> *)cidArray provinceModel:(SelectProvinceModel*)provinceModel {
    NSMutableArray *arrCity = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [provinceModel.cityarray enumerateObjectsUsingBlock:^(SelectCityModel * _Nonnull cityModel, NSUInteger idx, BOOL * _Nonnull stop) {
        // 全部赋值默认值
        cityModel.isSelect = NO;
        if (cidArray.count > 0) {
            __strong typeof (self) self = weakSelf;
            [cidArray enumerateObjectsUsingBlock:^(SelectCityModel * _Nonnull selectCityModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectCityModel.CI == cityModel.CI && [arrCity containsObject:cityModel] == NO) {
                    cityModel.isSelect = YES;
                    [arrCity addObject:cityModel];
                    if (self.currentProvinceModel == nil) {
                        self.currentProvinceModel = provinceModel;
                        self.currentProvinceModel.selected = YES;
                    }
                }
            }];
        }
    }];
   
    // 选了全部的城市
    if (arrCity.count == provinceModel.cityarray.count - 1) {
        [provinceModel.cityarray enumerateObjectsUsingBlock:^(SelectCityModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.CI == 0 && [model.CN isEqualToString:@"全部"]) {
                model.isSelect = YES;
                *stop = YES;
            }
        }];
    }
    [_arrSelectCity addObjectsFromArray:arrCity];
    provinceModel.count = arrCity.count;
   
}

- (void)resetDefaultValue {
    [self reloadSelectCityArray:_arrCannotCancelCity cannotCancelCityArray:_arrCannotCancelCity];
}

#pragma mark - createSubViewsAndConstraints
- (void)createSubViewsAndConstraints {
    
    // (statusbar)
    CGRect rectOfStatusbar = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusbarHeight = rectOfStatusbar.size.height;
    //（navigationbar）
    CGRect rectOfNavigationbar = self.navigationController.navigationBar.frame;
    CGFloat navigationbarHeight = rectOfNavigationbar.size.height;
    
    UIView *headerView = nil;
    if ([_delegate respondsToSelector:@selector(selectCityViewControllerViewForHeader:)]) {
        headerView = [_delegate selectCityViewControllerViewForHeader:self];
        [self.view addSubview:headerView];
    }
    if ([_delegate respondsToSelector:@selector(selectCityViewControllerHeightForHeader:)]) {
        CGFloat height = [_delegate selectCityViewControllerHeightForHeader:self];
        headerView.frame = CGRectMake(0, statusbarHeight + navigationbarHeight, [UIScreen mainScreen].bounds.size.width, height);
    }
    
    CGFloat vBottom_height = 50;

    
    CGFloat tabFirstLevel_tableheight = self.view.bounds.size.height - statusbarHeight - navigationbarHeight - CGRectGetHeight(headerView.frame) - vBottom_height;
    _tabFirstLevel = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), self.tabFirstLevel_width, tabFirstLevel_tableheight) style:UITableViewStylePlain];
    _tabFirstLevel.delegate = self;
    _tabFirstLevel.dataSource = self;
    _tabFirstLevel.showsVerticalScrollIndicator = YES;
    _tabFirstLevel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tabFirstLevel registerClass:[SelectProvinceTableViewCell class] forCellReuseIdentifier:SelectProvinceTableViewCellReuseID];
    // (home Indicator)
//    if (@available(iOS 11.0, *)) {
//        self.tabFirstLevel.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
//    }
    [self.view addSubview:_tabFirstLevel];
    _tabSecondLevel = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tabFirstLevel.frame), CGRectGetMinY(_tabFirstLevel.frame), self.tabSecondLevel_width, CGRectGetHeight(_tabFirstLevel.frame)) style:UITableViewStylePlain];
    _tabSecondLevel.delegate = self;
    _tabSecondLevel.dataSource = self;
    _tabSecondLevel.showsVerticalScrollIndicator = YES;
    _tabSecondLevel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tabSecondLevel registerClass:[SelectCityTableViewCell class] forCellReuseIdentifier:SelectCityTableViewCellReuseID];
    [self.view addSubview:_tabSecondLevel];
    
    CGFloat vBottom_Y = self.view.bounds.size.height - vBottom_height;
    UIView *vBottom = [[UIView alloc] initWithFrame:CGRectMake(0, vBottom_Y, self.view.bounds.size.height, vBottom_height)];
    [self.view addSubview:vBottom];
    
    
    UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReset.frame = CGRectMake(0, 0, 104, vBottom_height);
    [btnReset setTitleColor:[UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
    [btnReset setTitle:@"重 置" forState:UIControlStateNormal];
    [btnReset.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [btnReset setBackgroundColor:[UIColor whiteColor]];
    [btnReset addTarget:self action:@selector(onClickBtnReset:) forControlEvents:UIControlEventTouchUpInside];
    [vBottom addSubview:btnReset];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnConfirm = btnConfirm;
    btnConfirm.frame = CGRectMake(CGRectGetMaxX(btnReset.frame), 0, self.view.bounds.size.width - btnReset.bounds.size.width, vBottom_height);
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm setTitle:@"选中个城市" forState:UIControlStateNormal];
    [btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [btnConfirm setBackgroundColor:[UIColor colorWithRed:40/255.0 green:115/255.0 blue:255/255.0 alpha:1]];
    [btnConfirm addTarget:self action:@selector(onClickBtnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [vBottom addSubview:btnConfirm];
    
    UIView *vlineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, vBottom.bounds.size.height - 0.5, self.view.bounds.size.width, 0.5)];
    vlineBottom.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [vBottom addSubview:vlineBottom];
    
    [_tabFirstLevel reloadData];
    [_tabSecondLevel reloadData];
    [self uploadBtnConfirm];
}

- (void)onClickBtnReset:(UIButton *)button {
    
    if ([_delegate respondsToSelector:@selector(selectCityViewControllerDidSelectedBySelf)]) {
        [_delegate selectCityViewControllerDidSelectedBySelf];
    }
    if ([_delegate respondsToSelector:@selector(selectCityViewControllerOnClickReset:)]) {
        [_delegate selectCityViewControllerOnClickReset:button];
    }
    [self resetDefaultValue];
}


- (void)onClickBtnConfirm:(UIButton *)button {
   
    if ([_delegate respondsToSelector:@selector(selectCityViewControll:selectCityArray:)]) {
        [_delegate selectCityViewControll:self selectCityArray:_arrSelectCity];
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)initalDefaultValue {
    CGFloat percentageWidth = 130/375.0;
    self.tabFirstLevel_width = percentageWidth * [UIScreen mainScreen].bounds.size.width;
    self.tabSecondLevel_width = [UIScreen mainScreen].bounds.size.width - self.tabFirstLevel_width;
    self.tabFirstLevel_height = 50;
    self.tabFirstLevel_width = 130;
    self.tabSecondLevel_width = 275;
    
    __weak typeof(self) weakSelf = self;
    NSArray *provinceArray = [SelectProvinceModel loadModel];
    NSMutableArray *arr = [NSMutableArray array];
    [provinceArray enumerateObjectsUsingBlock:^(SelectProvinceModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [arr addObject:model];
        if (idx == 0) {
            weakSelf.currentProvinceModel = model;
            weakSelf.currentProvinceModel.selected = YES;

        }
    }];
    _arrFirstLevel = arr;
    _arrSecondLevel = _currentProvinceModel.cityarray;
    _arrSelectCity = [NSMutableArray array];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tabFirstLevel) {
        return self.arrFirstLevel.count;
    } else if (tableView == self.tabSecondLevel) {
        return self.arrSecondLevel.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tabFirstLevel) {
        SelectProvinceModel *model = _arrFirstLevel[indexPath.row];
        SelectProvinceTableViewCell *cell = (SelectProvinceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SelectProvinceTableViewCellReuseID];
        [cell makeProvinceCellWithSelectProvinceModel:model indexPath:indexPath];
        return cell;
    } else if (tableView == self.tabSecondLevel) {
        SelectCityModel *model = _arrSecondLevel[indexPath.row];
        SelectCityTableViewCell *cell = (SelectCityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SelectCityTableViewCellReuseID];
        [cell makeCityCellWithSelectCityModel:model indexPath:indexPath];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tabFirstLevel) {
        
        SelectProvinceModel *model = _arrFirstLevel[indexPath.row];
        if (model == _currentProvinceModel) {
            return;
        }
        model.selected = YES;
        _currentProvinceModel.selected = NO;
        _currentProvinceModel = model;

        _arrSecondLevel = _currentProvinceModel.cityarray;
        [_tabFirstLevel reloadData];
        [_tabSecondLevel reloadData];
        
//        [_tabSecondLevel setContentOffset:CGPointMake(0,0) animated:YES];
        
    } else if (tableView == self.tabSecondLevel) {
        if ([_delegate respondsToSelector:@selector(selectCityViewControllerDidSelectedBySelf)]) {
            [_delegate selectCityViewControllerDidSelectedBySelf];
        }
        SelectCityModel *model = _arrSecondLevel[indexPath.row];
        if (model.CI == 0 && [model.CN isEqualToString:@"全部"]) {
            model.isSelect = !model.isSelect;
            //点击了全部
            __weak typeof(self) weakSelf = self;
             NSMutableArray *arrSelectCityID = [NSMutableArray array];
            [_arrSecondLevel enumerateObjectsUsingBlock:^(SelectCityModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.CI != 0 && model.isSelect == YES && ![weakSelf.arrSelectCity containsObject:obj]) {
                    obj.isSelect = YES;
                    [weakSelf.arrSelectCity addObject:obj];
                    [arrSelectCityID addObject:obj];
                } else if (obj.CI != 0 && model.isSelect == NO && [weakSelf.arrSelectCity containsObject:obj]) {
                    obj.isSelect = NO;
                    [weakSelf.arrSelectCity removeObject:obj];
                }
            }];

            _currentProvinceModel.count = model.isSelect ==  YES ? _arrSecondLevel.count - 1 : 0;

        } else {
            // 点击了其他省份
            model.isSelect = !model.isSelect;
            if (model.isSelect == YES && [_arrSelectCity containsObject:model] == NO) {
                [_arrSelectCity addObject:model];
            } else if (model.isSelect == NO && [_arrSelectCity containsObject:model] == YES) {
                [_arrSelectCity removeObject:model];
            }
            
            [self checkSelectAllCity];
            
        }
        [_tabFirstLevel reloadData];
        [_tabSecondLevel reloadData];
        [self uploadBtnConfirm];
    }
}

- (void)checkSelectAllCity {
    // 勾选全部
    NSMutableArray *arrSelectCityID = [NSMutableArray array];
    [_arrSecondLevel enumerateObjectsUsingBlock:^(SelectCityModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect == YES && obj.CI != 0) {
            [arrSelectCityID addObject:obj];
        }
    }];
    
    [_arrSecondLevel enumerateObjectsUsingBlock:^(SelectCityModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.CI == 0 && [model.CN isEqualToString:@"全部"]) {
            model.isSelect = (arrSelectCityID.count == _arrSecondLevel.count - 1) ? YES : NO;
            *stop = YES;
        }
    }];
    _currentProvinceModel.count = arrSelectCityID.count;
}

- (void)uploadBtnConfirm {
     // 更新确定按钮上的数据
    NSString *title = [NSString stringWithFormat:@"选中%ld个城市", _arrSelectCity.count];
    [_btnConfirm setTitle:title forState:UIControlStateNormal];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tabFirstLevel_height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
