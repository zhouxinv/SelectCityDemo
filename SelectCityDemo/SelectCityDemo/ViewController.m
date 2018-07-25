//
//  ViewController.m
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/24.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import "ViewController.h"
#import "SelectCityViewController.h"

@interface ViewController ()<SelectCityViewControllerDelegate>
@property (nonatomic, strong) UIButton *btnCommitEdit;
@property (nonatomic, strong) UILabel *choseLabel;
@property (nonatomic, strong) NSMutableArray<SelectCityModel *> *arrChoseCity;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrChoseCity = [NSMutableArray array];
    _btnCommitEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCommitEdit.frame = CGRectMake(0, 0, 100, 50);
    _btnCommitEdit.center = self.view.center;
    [_btnCommitEdit setBackgroundColor:[UIColor colorWithRed:40/255.0 green:115/255.0 blue:255/255.0 alpha:1]];
    [_btnCommitEdit setTitle:@"选择城市" forState:UIControlStateNormal];
    _btnCommitEdit.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnCommitEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnCommitEdit addTarget:self action:@selector(onClickBtnCommitEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCommitEdit];
    
    
    UILabel *labContent = [[UILabel alloc] init];
    labContent.frame = CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width - 30, 100);
    labContent.numberOfLines = 0;
    _choseLabel = labContent;
    labContent.textAlignment = NSTextAlignmentLeft;
    labContent.font = [UIFont systemFontOfSize:14];
    labContent.textColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    [self.view addSubview:labContent];
    
}

- (void)reloadRecommendCityContent:(NSString *)content {
    _choseLabel.text = content;
}

- (void)onClickBtnCommitEdit:(UIButton*)btn {
    
    // 跳转推荐城市
    SelectCityViewController *selectCarVC = [[SelectCityViewController alloc] init];
    selectCarVC.delegate = self;
    [self.navigationController pushViewController:selectCarVC animated:YES];
    [selectCarVC reloadSelectCityViewController];
}


#pragma mark - SelectCityViewControllerDelegate
- (UIView *)selectCityViewControllerViewForHeader:(SelectCityViewController *)selectCityViewController {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 36)];
    headerView.backgroundColor = [UIColor colorWithRed:230/255.0 green:239/255.0 blue:255/255.0 alpha:1];
    UILabel *labBlueTip = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.bounds.size.width - 30, headerView.bounds.size.height)];
    labBlueTip.font = [UIFont systemFontOfSize:14];
    labBlueTip.textColor = [UIColor colorWithRed:40/255.0 green:115/255.0 blue:255/255.0 alpha:1];
    [headerView addSubview:labBlueTip];
    labBlueTip.text = @"这里设置的headerView";
    
    
    UIView *vSeparate = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), headerView.bounds.size.width, 10)];
    vSeparate.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [headerView addSubview:vSeparate];
    
    return headerView;
}

- (CGFloat)selectCityViewControllerHeightForHeader:(SelectCityViewController *)selectCityViewController {
    return 46;
}

- (void)selectCityViewControll:(SelectCityViewController *)selectCityViewController selectCityArray:(NSArray<SelectCityModel *> *)selectCityArray {
    [_arrChoseCity removeAllObjects];
    [_arrChoseCity addObjectsFromArray: selectCityArray];
    NSMutableArray *arrCityName = [NSMutableArray array];
    for ( SelectCityModel *mItem in _arrChoseCity) {
        [arrCityName addObject:mItem.CN];
    }
    NSString *strCommendCity = [arrCityName componentsJoinedByString:@"、"];
    [self reloadRecommendCityContent:strCommendCity];
    
}

- (void)selectCityViewControllerOnClickReset:(UIButton *)button {
    //点击了重置按钮的逻辑 (记录埋点等)
}

- (NSArray<SelectCityModel *> *)selectCityViewControllerSelectCityArrayDataSource {
    return _arrChoseCity;
}

/*
 // 返回不可以取消的城市
- (NSArray<SelectCityModel *> *)selectCityViewControllerCannotCancelCityArrayDataSource {
    NSArray *cannotCannelArray = [self getArrCannotCannelArray];
    return cannotCannelArray;
}

- (NSArray<SelectCityModel *>*)getArrCannotCannelArray{
    SelectCityModel * select1 = [[SelectCityModel alloc] init];
    select1.CI = 320100;
    select1.CN = @"南京";
    select1.PI = 320000;
    SelectCityModel * select2 = [[SelectCityModel alloc] init];
    select2.CI = 330700;
    select2.CN = @"金华";
    select2.PI = 330000;
    NSArray *noCancelArray = @[select1, select2];
    [_arrChoseCity removeAllObjects];
    [_arrChoseCity addObjectsFromArray:noCancelArray];
    return noCancelArray;
}

*/
- (void)selectCityViewControllerDidSelectedBySelf {
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
