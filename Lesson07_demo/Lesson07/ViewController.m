//
//  ViewController.m
//  Lesson07
//
//  Created by Nguyen Xuan Hung on 23/4/18.
//  Copyright © 2018 Nguyen Xuan Hung. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"infor.sql"];
    // self.dbManager=[[DBManager alloc]init];
    [self executeQueryInsert];
    [self loadDataInfor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) loadDataInfor{
    // Form the query.
    NSString *query = @"SELECT * FROM ThongTin";
    //NSString *query = @"select * from peopleInfo";
    NSArray *arr;//=[[NSArray alloc]init];
    arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"%@",arr);
    // Reload the table view.
}


-(void) executeQueryInsert{
    NSString *query=@"INSERT INTO ThongTin VALUES ('5','Nam','22')";
    NSArray *arr;//=[[NSArray alloc]init];
    arr = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
}
-(void) executeQueryUpdate{
    NSString *query=@"UPDATE ThongTin SET Name='Mai',Age='24' WHERE id=4;";
    [self.dbManager executeQuery:query];
    
}
-(void) executeQueryDelete{
    NSString *query=@"DELETE FROM ThongTin WHERE id='5';";
    [self.dbManager executeQuery:query];
}
-(void) executeQueryCreateTable{
    NSString *query=@"CREATE TABLE InforDevelopper( id int, Name varchar(255), Age varchar(255))";
    [self.dbManager executeQuery:query];
}
@end

