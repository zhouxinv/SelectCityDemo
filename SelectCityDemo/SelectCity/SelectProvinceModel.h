//
//  SelectProvinceModel.h
//  SelectCityDemo
//
//  Created by GeWei on 2018/7/16.
//  Copyright © 2018年 GeWei. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SelectCityModel;
@interface SelectProvinceModel : NSObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) NSArray<SelectCityModel *> *cityarray;

@property (nonatomic, strong) NSString       *FL;
@property (nonatomic, strong) NSString       *PN;
@property (nonatomic        ) NSInteger      PI;
@property (nonatomic        ) double         lat;
@property (nonatomic        ) double         lng;

+ (NSArray *)loadModel;
@end
