//
//  SelectCityModel.h
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectCityModel : NSObject

@property (nonatomic, strong) NSString  *FL;
@property (nonatomic, strong) NSString  *CN;
@property (nonatomic        ) NSInteger CI;
@property (nonatomic        ) double    lat;
@property (nonatomic        ) double    lng;

@property (nonatomic, assign) NSInteger PI;
@property (nonatomic, assign) BOOL isSelect;


/**
 *  根据省份 ID 返回城市 列表
 *
 *  @param provinceId 省份 ID
 *
 *  @return  城市 Model 列表
 */
+ (NSArray *)loadModelByProvinceId:(NSInteger)provinceId;
@end
