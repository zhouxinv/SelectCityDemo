//
//  SelectCityModel.m
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import "SelectCityModel.h"
#import "SQLDatabaseHelper.h"
#import "MJExtension.h"
@implementation SelectCityModel
+ (NSArray *)loadModelByProvinceId:(NSInteger)provinceId {
    return [self loadModelByProvinceId:provinceId withNoLimit:YES];
}

+ (NSArray *)loadModelByProvinceId:(NSInteger)provinceId withNoLimit:(BOOL)withNoLimit {
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"ChinaCountry" ofType:@"db"];
    SQLDatabaseHelper *dbHelper = [[SQLDatabaseHelper alloc] initWithDbPath:dbPath];
    
    NSString *strQuery = [NSString stringWithFormat:@"select CityId as CI, CityName as CN, FirstCharacter as FL, lat, lng from City where ProvinceId = %ld order by CityId;", (long)provinceId];
    if (!withNoLimit) {
        strQuery = [NSString stringWithFormat:@"select CityId as CI, CityName as CN, FirstCharacter as FL, lat, lng from City where ProvinceId = %ld and CItyId != 0 order by CityId;", (long)provinceId];
    }
    
    NSArray *dicArray = [dbHelper querryTable:strQuery];
    if (dicArray.count > 0) {
        NSArray *arrCity = [SelectCityModel mj_objectArrayWithKeyValuesArray:dicArray];
        return arrCity;
    }
    else {
        return nil;
    }
}
@end
