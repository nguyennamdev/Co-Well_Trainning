//
//  DBManager.h
//  Lesson7
//
//  Created by Nguyen Nam on 4/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject


@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFileName;
@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRow;
@property (nonatomic) long long lastInsertedRowID;


- (instancetype)initWithDatabaseFileName:(NSString *)dbFileName;
- (void) copyDatabaseIntoDocumentsDirectory;
- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

- (NSArray *)loadDataFromDB:(NSString *)query;
- (void)executeQuery:(NSString *)query;

@end
