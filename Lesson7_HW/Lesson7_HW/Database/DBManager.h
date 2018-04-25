//
//  DBManager.h
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSString *documentDirectory;
@property (nonatomic, strong) NSString *databaseFileName;
@property (nonatomic, strong) NSMutableArray *arrResults;
@property (nonatomic, strong) NSMutableArray *arrColumnsName;
@property (nonatomic) int affectedRow;

- (instancetype)initWithDatabaseFileName:(NSString *)fileName;

- (void)copyDatabaseIntoDocumentDirectory;

- (void)runQuery:(NSString *)query isQueryExecutable:(BOOL)isExecutable;

- (void)executeQuery:(NSString *)query;

- (NSArray *) loadDataFromDatabase:(NSString *)query;

@end
