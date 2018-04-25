//
//  DBManager.m
//  Lesson7
//
//  Created by Nguyen Nam on 4/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@implementation DBManager




- (instancetype)initWithDatabaseFileName:(NSString *)dbFileName{
    self = [super init];
    if (self) {
        // set document directory path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // and keep the database file name
        self.databaseFileName = dbFileName;
        
        // copy the database file into the documents directory
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

- (void)copyDatabaseIntoDocumentsDirectory{
    
    // 1: check if the database file exist in document directory
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]){
        // the database isn't exist
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFileName];
        NSError *err;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&err];
        
        if (err != nil){
            NSLog(@"%@", [err localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Khởi tạo một đối tượng của class sqlite.
    sqlite3 *sqlite3Database;
    // Lấy đường dẫn đích đến file.sqlite
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFileName];
    
    // Khởi tạo mảng kết quả
    if (self.arrResults != nil) {// nếu mảng tồn tại(lưu) đối tượng
        [self.arrResults removeAllObjects];//xoá tất cả đối tượng
        self.arrResults = nil;// set về nil
    }
    self.arrResults = [[NSMutableArray alloc] init];// khởi tạo lại vùng nhớ cho mảng
    
    // Tương tự đối với mảng chứa các trường tên cột
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];

    // Mở cơ sở dữ liệu
    // truyền vào 2 tham số đường dẫn đích đến file định dạng UTF8, Đối tượng sqlite
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {// nếu mở csdl thành công
        // Đối tượng lưu trữ các truy vấn prepare statement
        sqlite3_stmt *compiledStatement;
        
        // Chuyển đổi câu truy vấn ở định dạng chuỗi sang câu truy vấn mà sqlite3 có thể nhận dạng được!
        // các tham số truyền vào đối tượng sqlite3, câu truy vấn,Lấy độ dài câu truy vấn, ở đây -1 độ dài tuỳ ý, đối tượng sqlite3_stmt lưu trữ truy vấn, Con trỏ trỏ tới phần chưa sử dụng của câu truy vấn Sql.
        // sau khi chuyển đổi câu truy vấn được lưu lại trong compiledStatement
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        // Nếu câu truy vấn được chuyển đổi thành công sang dạng sqlite nhận dạng đc.
        if(prepareStatementResult == SQLITE_OK) {
            // Kiểm tra nếu truyền vào QueryExecutable NO thì ta cần trích lọc dữ liệu , đọc dữ liệu ra.
            if (!queryExecutable){
                // Tạo một mảng lưu lại thông tin truy vấn!
                NSMutableArray *arrDataRow;
                
                // Thực thi truy vấn cho phép đọc thành công!
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Khởi tạo mảng.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // trả về tổng số cột
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    //lặp hết các cột
                    for (int i=0; i<totalColumns; i++){
                        // Trả về nội dung một cột kiểu char
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // chuyển đổi định sang kiểu string
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Lưu tên của các cột !
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {// môt đối tượng trong arrResults là một mảng!.
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // Nếu chỉ truy vấn Update , Delete, insert không cần đưa ra dữ liệu
                
                // Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {// Nếu truy vấn thành công "chỉ truy vấn không đọc dữ liệu".
                    //                    // Trả về  số lượng hàng bị ảnh hưởng.
                    self.affectedRow = sqlite3_changes(sqlite3Database);
                    //
                    //                    // trả về số đối tượng được chèn vào ở dòng cuối cùng.
                    //                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // Lỗi mô tả sqlite.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            // Nếu xảy ra lỗi mô tả sqlite.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Giải phóng một truy vấn được chuẩn bị
        sqlite3_finalize(compiledStatement);
    }
    
    // Đóng lại CSDL
    sqlite3_close(sqlite3Database);
}

- (void)executeQuery:(NSString *)query{
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

- (NSArray *)loadDataFromDB:(NSString *)query{
    // run the query and indicate that is not executable
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    // return array
    return (NSArray *)self.arrResults;
}


@end
