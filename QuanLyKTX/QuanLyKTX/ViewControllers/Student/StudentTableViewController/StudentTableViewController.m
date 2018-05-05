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

@interface StudentTableViewController ()
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSMutableArray<Student *> *arrStudent;

@end


@implementation StudentTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // init dbManager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"quanly.sqlite"];
    self.navigationItem.title = @"Students";

}

- (void)viewWillAppear:(BOOL)animated{
    [self loadStudents];
}

// MARK: Functions
- (void)loadStudents{
    NSString *query = @"SELECT * FROM tblStudent";
    NSArray *arrResult = [self.dbManager loadDataFromDatabase:query];
    // init arrStudent
    self.arrStudent = [[NSMutableArray alloc]init];
    
    NSInteger indexOfStudentId = [self.dbManager.arrColumnsName indexOfObject:STUDENT_ID];
    NSInteger indexOfRoomId = [self.dbManager.arrColumnsName indexOfObject:ROOM_ID];
    NSInteger indexOfFirstName = [self.dbManager.arrColumnsName indexOfObject:FIRST_NAME];
    NSInteger indexOfLastName = [self.dbManager.arrColumnsName indexOfObject:LAST_NAME];
    NSInteger indexOfBirthday = [self.dbManager.arrColumnsName indexOfObject:BIRHDAY];
    NSInteger indexOfGender = [self.dbManager.arrColumnsName indexOfObject:GENDER];
    NSInteger indexOfHometown = [self.dbManager.arrColumnsName indexOfObject:HOME_TOWN];
    NSInteger indexOfClass = [self.dbManager.arrColumnsName indexOfObject:CLASS];
    NSInteger indexOfCreatedDate = [self.dbManager.arrColumnsName indexOfObject:CREATED_DATE];
    NSInteger indexOfUpdatedDate = [self.dbManager.arrColumnsName indexOfObject:UPDATED_DATE];
    
    for (int i = 0; i < arrResult.count; i++) {
        Student *student = Student.new;
        student.student_id = [arrResult[i] objectAtIndex:indexOfStudentId];
        student.room_id = [arrResult[i] objectAtIndex:indexOfRoomId];
        student.firstName = [arrResult[i] objectAtIndex:indexOfFirstName];
        student.lastName = [arrResult[i] objectAtIndex:indexOfLastName];
        student.birthday = [arrResult[i] objectAtIndex:indexOfBirthday];
        student.gender = [arrResult[i] objectAtIndex:indexOfGender];
        student.homeTown = [arrResult[i] objectAtIndex:indexOfHometown];
        student._class = [arrResult[i] objectAtIndex:indexOfClass];
        student.createdDate = [arrResult[i] objectAtIndex:indexOfCreatedDate];
        student.updatedDate = [arrResult[i] objectAtIndex:indexOfUpdatedDate];
        [self.arrStudent addObject:student];
    }
    [self.tableView reloadData];
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
    Student *student = _arrStudent[indexPath.row];
    cell.genderImageView.image = [student.gender  isEqual: @"male"] ? [UIImage imageNamed:@""] : [UIImage imageNamed:@""];
    cell.studentNameLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
