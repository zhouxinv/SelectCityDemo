//
//  SelectProvinceModel.m
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import "SelectProvinceModel.h"
#import "SelectCityModel.h"
#import "MJExtension.h"
#import "SQLDatabaseHelper.h"
#import "sqlite3.h"
@implementation SelectProvinceModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cityarray" : @"SelectCityModel"};
}
static NSArray *_arrProvince = nil;
+ (NSArray *)loadModel {
    if (_arrProvince && _arrProvince.count > 0) {
        return _arrProvince;
    } else {
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"ChinaCountry" ofType:@"db"];
        SQLDatabaseHelper *dbHelper = [[SQLDatabaseHelper alloc] initWithDbPath:dbPath];
        NSArray *dicArray = [dbHelper querryTable:@"select ProvinceId as PI, ProvinceName as PN, FirstCharacter as FL, lat, lng, ProvinceSample as NumberPlate from Province where Provinceid not in (820000, 710000, 810000) order by FL;"];
        if (dicArray.count > 0) {
            _arrProvince = [SelectProvinceModel mj_objectArrayWithKeyValuesArray:dicArray];
            [_arrProvince enumerateObjectsUsingBlock:^(SelectProvinceModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *arrCity = [SelectCityModel loadModelByProvinceId:obj.PI];
                obj.cityarray = [SelectCityModel mj_objectArrayWithKeyValuesArray:arrCity];
            }];
            return _arrProvince;
        }
        else {
            return nil;
        }
    }
}


@end
