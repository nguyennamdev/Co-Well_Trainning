//
//  DBManager+Tables.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "DBManager+Tables.h"
#import "DBManager.h"

@implementation DBManager (Tables)

- (void)showTables{
    NSString *query = @"\
    SELECT tbl_name, sql FROM sqlite_master \
    where type = 'table' \
    and name != 'sqlite_sequence'";
    for (NSString *s in [self loadDataFromDatabase:query]) {
        NSLog(@"%@", s);
    }
}

@end
