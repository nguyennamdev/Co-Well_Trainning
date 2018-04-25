//
//  DBManager.m
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@implementation DBManager

- (instancetype)initWithDatabaseFileName:(NSString *)fileName{
    self = [super init];
    if (self){
        // set document directory
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentDirectory = path[0];
        
        // keep database file name
        self.databaseFileName = fileName;
        [self copyDatabaseIntoDocumentDirectory];
    }
    return self;
}

- (void)copyDatabaseIntoDocumentDirectory{
    // check if the database file exist in document directory
    NSString *destinationPath = [self.documentDirectory stringByAppendingPathComponent:self.databaseFileName];
    if (![[NSFileManager alloc] fileExistsAtPath:destinationPath]){
        // file isn't exist
        NSString *source = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFileName];
        NSError *err;
        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destinationPath error:&err];
        
        if (err != nil){
            NSLog(@"%@", [err description]);
        }
     }
}

- (void)runQuery:(NSString *)query isQueryExecutable:(BOOL)isExecutable{
    // create instance of sqlite3 class
    sqlite3 *sqlite3Database;
    // get path to database
    NSString *databasePath = [self.documentDirectory stringByAppendingPathComponent:self.databaseFileName];
    
    // init array result
    if (self.arrResults.count > 0){
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = NSMutableArray.new;
    
    // init array column name
    if (self.arrColumnsName.count > 0){
        [self.arrColumnsName removeAllObjects];
        self.arrColumnsName = nil;
    }
    self.arrColumnsName = NSMutableArray.new;
    
    // 2: open database
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if (openDatabaseResult == SQLITE_OK){
        // create sqlite_sttm to store query before execute
        sqlite3_stmt *sqlite3_stmt;
        // format query string to query statement
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, [query UTF8String], -1, &sqlite3_stmt, NULL);
        if (prepareStatementResult == SQLITE_OK){
            // check if the isExecutale = no, it will access data and read data
            if (!isExecutable){
                // create a array to store info query
                NSMutableArray *arrDataRow;
                while (sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
                    // init arrDataRow;
                    arrDataRow = NSMutableArray.new;
                    
                    // result total column
                    int totalColumnResult = sqlite3_column_count(sqlite3_stmt);
                    for (int i = 0; i < totalColumnResult; i++) {
                        char *dbDataAsChars = (char *)sqlite3_column_text(sqlite3_stmt, i);
                        if (dbDataAsChars != NULL){
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // save name of columns
                        if (self.arrColumnsName.count != totalColumnResult){
                           [self.arrColumnsName addObject:[NSString stringWithUTF8String:sqlite3_column_name(sqlite3_stmt, i)]];
                        }
                    }
                    if (arrDataRow.count > 0){
                        [self.arrResults addObject:arrDataRow];
                    }
                }
                
            }else{
                // only execute query INSERT, UPDATE etc
                int executeQueryResult = sqlite3_step(sqlite3_stmt);
                if (executeQueryResult == SQLITE_DONE){
                    // result affected row
                    self.affectedRow = sqlite3_changes(sqlite3Database);
                }else{
                    NSLog(@"DB ERROR: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }else {
            // In the database cannot be opened then show the error message on the debugger.
            // Nếu xảy ra lỗi mô tả sqlite.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        // release query
        sqlite3_finalize(sqlite3_stmt);
    }
    sqlite3_close(sqlite3Database);
}

- (void)executeQuery:(NSString *)query{
    [self runQuery:query isQueryExecutable:YES];
}

- (NSArray *)loadDataFromDatabase:(NSString *)query{
    [self runQuery:query isQueryExecutable:NO];
    return (NSArray *)self.arrResults;
}


@end
