//
//  StudentTableViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "StudentTableViewController.h"
#import "DBManager.h"
#import "Student.h"
#import "Define.h"
#import "StudentTableViewCell.h"
#import "AddEditStudentViewController.h"
#import "UIViewController+LoadAllStudent.h"

@interface StudentTableViewController ()
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSArray<Student *> *arrStudent;
@property (nonatomic) NSInteger studentIdToEdit;

@end


@implementation StudentTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // init dbManager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:DATABASE_NAME];
    self.navigationItem.title = @"Students";
    
}

- (void)viewWillAppear:(BOOL)animated{
    _studentIdToEdit = -1;
    [self loadStudents];
}

// MARK: Functions
- (void)loadStudents{
    NSString *query = @"SELECT * FROM tblStudent";
    NSArray *arrResult = [self.dbManager loadDataFromDatabase:query];
    // init arrStudent
    self.arrStudent = [self loadAllStudent:self.dbManager byArrayResult:arrResult];
    [self.tableView reloadData];
}

- (NSString *)getRoomNameByRoomId:(NSNumber *)roomId{
    NSString *query = [NSString stringWithFormat:@"SELECT roomName FROM tblRoom where room_id = %ld", [roomId integerValue]];
    NSArray *arrResult =  [self.dbManager loadDataFromDatabase:query];
    NSString *strResult = [arrResult.firstObject objectAtIndex:0];
    return strResult;
}

// MARK: Actions

- (IBAction)addNewStudent:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addEditSegue" sender:nil];
}

// MARK: Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"addEditSegue"]){
        AddEditStudentViewController *addEditStudentVC;
        addEditStudentVC = segue.destinationViewController;
        addEditStudentVC.studentId = self.studentIdToEdit;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrStudent.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    // set right arrow
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    Student *student = _arrStudent[indexPath.row];
    cell.genderImageView.image = [student.gender  isEqual: @"Male"] ? [UIImage imageNamed:@"male"] : [UIImage imageNamed:@"female"];
    cell.studentNameLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.roomLabel.text = [self getRoomNameByRoomId:student.room_id];
    cell.classLabel.text = student._class;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// MARK: UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.studentIdToEdit = [self.arrStudent[indexPath.row].student_id integerValue];
    [self performSegueWithIdentifier:@"addEditSegue" sender:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

// MARK: funtion delete a student by studentId
- (void)deleteAStudentByStudentId:(NSInteger)studentId andRoomId:(NSInteger)roomId{
    NSString *query = [NSString stringWithFormat:@"Delete from tblStudent where student_id = %ld", studentId];
    // execute query
    [self.dbManager executeQuery:query];
    // update room current quantity
    NSString *query2 = [NSString stringWithFormat:@"Update tblRoom set currentQuantity = currentQuantity - 1, updatedDate = '%@' where room_id = %ld", [NSDate date], roomId];
    [self.dbManager executeQuery:query2];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger studentId = [self.arrStudent[indexPath.row].student_id integerValue];
        NSInteger roomId = [self.arrStudent[indexPath.row].room_id integerValue];
        [self deleteAStudentByStudentId:studentId andRoomId:roomId];
        [self loadStudents];
    }
}



@end

