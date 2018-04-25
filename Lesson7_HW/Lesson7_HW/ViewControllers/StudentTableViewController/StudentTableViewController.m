//
//  StudentTableViewController.m
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "StudentTableViewController.h"
#import "DBManager.h"
#import "Student.h"
#import "AddEditStudentViewController.h"
#import "AddEditStudentDelegate.h"

@interface StudentTableViewController ()<AddEditStudentDelegate>

@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSMutableArray<Student *> *arrStudents;
@property (strong, nonatomic) NSArray *arrResults;

@end

@implementation StudentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.dbManager  = [[DBManager alloc]initWithDatabaseFileName:@"student.sqlite"];
    [self loadDataFromDatabase];
    
    self.studentIdToEdit = -1;
}

// MARK: load data from database
- (void)loadDataFromDatabase{
    NSString *query = @"SELECT * FROM Student";
    if (self.arrResults != nil){
        self.arrResults = nil;
    }
    self.arrResults = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDatabase:query]];
    [self copyArrToArrStudent:self.arrResults];
    [self.tableView reloadData];
}

// MARK:  copy arrResult to arrStudent
- (void)copyArrToArrStudent:(NSArray *)array{
    self.arrStudents = NSMutableArray.new;
    // get index by column name
    NSInteger indexOfId = [self.dbManager.arrColumnsName indexOfObject:@"id"];
    NSInteger indexOfFirstName = [self.dbManager.arrColumnsName indexOfObject:@"firstName"];
    NSInteger indexOfLastName = [self.dbManager.arrColumnsName indexOfObject:@"lastName"];
    NSInteger indexOfAge = [self.dbManager.arrColumnsName indexOfObject:@"age"];
    NSInteger indexOfGender = [self.dbManager.arrColumnsName indexOfObject:@"gender"];
    // loop
    for (int j = 0; j < array.count; j++) {
        // init student to add into arrayStudent
        Student *student = Student.new;
        student.studentId = [[array[j] objectAtIndex:indexOfId] integerValue];
        student.firstName = [array[j] objectAtIndex:indexOfFirstName];
        student.lastName = [array[j] objectAtIndex:indexOfLastName];
        student.age = [[array[j] objectAtIndex:indexOfAge] integerValue];
        student.gender = [array[j] objectAtIndex:indexOfGender];
        [self.arrStudents addObject:student];
    }
}


// MARK: Actions

- (IBAction)addNewStudent:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addEditSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"addEditSegue"]){
        AddEditStudentViewController *addEditViewController = [segue destinationViewController];
        addEditViewController.delegate = self;
        addEditViewController.studentIdToEdit = self.studentIdToEdit;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrStudents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    // set right arrow for cell
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    Student *student = self.arrStudents[indexPath.row];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    NSString *ageAndGender = [NSString stringWithFormat:@"Age: %ld, Gender: %@", student.age, student.gender];
    cell.textLabel.text = fullName;
    cell.detailTextLabel.text = ageAndGender;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// MARK: funtion delete a student by studentId
- (void)deleteAStudentByStudentId:(NSInteger)studentId{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM Student where id = %ld", studentId];
    // execute query
    [self.dbManager executeQuery:query];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteAStudentByStudentId:self.arrStudents[indexPath.row].studentId];
        [self loadDataFromDatabase];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.studentIdToEdit = self.arrStudents[indexPath.row].studentId;
    [self performSegueWithIdentifier:@"addEditSegue" sender:self];
}

// MARK: AddEditStudentDelegate
- (void)addEditedStudent{
    [self loadDataFromDatabase];
}


@end
