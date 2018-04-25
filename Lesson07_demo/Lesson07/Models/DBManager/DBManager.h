//
//  DBManager.h
//  Lesson07
//
//  Created by Nguyen Xuan Hung on 23/4/18.
//  Copyright © 2018 Nguyen Xuan Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;//
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

@property (nonatomic, strong) NSMutableArray *arrResults;

-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

-(void) executeQueryCreateTable;


@end

