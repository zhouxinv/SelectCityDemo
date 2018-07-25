

#import <UIKit/UIKit.h>


@interface SQLDatabaseHelper : NSObject

- (id)initWithDbName:(NSString *)dbName;
- (id)initWithDbPath:(NSString *)dbPath;
- (BOOL)openOrCreateDatabase;
- (void)closeDatabase;
- (BOOL)beginTransaction;
- (BOOL)rollbackTransaction;
- (BOOL)commitTransaction;
- (BOOL)createTable:(NSString *)sqlCreateTable;
- (BOOL)insertTable:(NSString *)sqlInsert;
- (BOOL)insertTable:(NSString *)sqlInsert isOpenAndClose:(BOOL)isOpenAndClose;
- (BOOL)isExistColumn:(NSString *)sqlInsert isOpenAndClose:(BOOL)isOpenAndClose;
- (BOOL)updataTable:(NSString *)sqlUpdata;
- (NSMutableArray *)querryTable:(NSString *)sqlQuerry;
- (NSMutableArray *)querryTableByCallBack:(NSString *)sqlQuerry;

@end
