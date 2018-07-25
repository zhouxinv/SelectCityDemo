# SelectCityDemo
选择城市的两级控件

# 依赖第三方
FMDB
MJExtension
这两个第三方可以根据项目要求自己进行添加

下面是效果图👇


代理方法的使用
1.设置HeaderView
需要同时实现这两种方式, 并且headerView的高度固定(和屏幕等宽)
```
/// 自定义headerView
- (UIView *)selectCityViewControllerViewForHeader:(SelectCityViewController *)selectCityViewController;
//headerView的高度
- (CGFloat)selectCityViewControllerHeightForHeader:(SelectCityViewController *)selectCityViewController;
```
2. 多选完成后的结果回调
返回的是SelectCityModel类型的model数组
```
- (void)selectCityViewControll:(SelectCityViewController *)selectCityViewController selectCityArray:(NSArray<SelectCityModel *> *)selectCityArray;
```

3.点击了重置按钮
如果外面需要点击重置的回调
```
///点击了重置按钮
- (void)selectCityViewControllerOnClickReset:(UIButton *)button;
```

4.需要展示的全部省份
可以根据项目传入你指定的省份, Demo中是使用了数据库中的全国省份(出去港澳台)
```
//数据源选择的城市
- (NSArray<SelectCityModel *> *)selectCityViewControllerSelectCityArrayDataSource;
```

5.不可以取消的省份
指定用户无法取消的省份, 为个别业务设置, 并且把这个不可以取消的省份排在首位.
```
//不可以取消的城市
- (NSArray<SelectCityModel *> *)selectCityViewControllerCannotCancelCityArrayDataSource;
```

6.用户手动点击过城市选择按钮
为埋点设计
```
//点击了城市
- (void)selectCityViewControllerDidSelectedBySelf;
```
