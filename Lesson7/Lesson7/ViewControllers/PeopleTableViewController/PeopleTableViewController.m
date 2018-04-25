//
//  PeopleTableViewController.m
//  Lesson7
//
//  Created by Nguyen Nam on 4/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "PeopleTableViewController.h"
#import "DBManager.h"
#import "AddNewDelegate.h"
#import "AddPersonViewController.h"
#import "Person.h"

@interface PeopleTableViewController ()<AddNewDelegate>
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSArray *arrResults;
@property (strong, nonatomic) NSMutableArray<Person *> *arrPerson;
@property (nonatomic) int pIdToEdit;
@end

@implementation PeopleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // init dbManager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"mydatabase.sqlite"];
    
    [self loadDataFromDatabase];
}

// MARK: Functions
- (void)loadDataFromDatabase{
    // query string
    NSString *query = @"select * from Person";
    
    // get result
    if (self.arrResults != nil){
        self.arrResults = nil;
    }
    self.arrResults = [[NSArray alloc]initWithArray:[self.dbManager loadDataFromDB:query]];
    [self copyArrayResultToArrPerson:self.arrResults];
    // reload table
    [self.tableView reloadData];
}

// MARK: copy arrResult to arrPerson
- (void)copyArrayResultToArrPerson:(NSArray *)arrayResult{
    self.arrPerson = [[NSMutableArray alloc]init];
    for (int i = 0; i < arrayResult.count; i++) {
        NSInteger indexOfId = [self.dbManager.arrColumnNames indexOfObject:@"id"];
        NSInteger indexOfFirstName = [self.dbManager.arrColumnNames indexOfObject:@"firstName"];
        NSInteger indexOfLastName = [self.dbManager.arrColumnNames indexOfObject:@"lastName"];
        NSInteger indexOfAge = [self.dbManager.arrColumnNames indexOfObject:@"age"];
        Person *p = Person.new;
        p.pId = [arrayResult[i] objectAtIndex:indexOfId];
        p.firstName = [arrayResult[i] objectAtIndex:indexOfFirstName];
        p.lastName = [arrayResult[i] objectAtIndex:indexOfLastName];
        p.age = [arrayResult[i] objectAtIndex:indexOfAge];
        // get data to arrPerson
        [self.arrPerson addObject:p];
    }
}


// MARK: Actions

- (IBAction)addNewRecord:(UIBarButtonItem *)sender {
    self.pIdToEdit = -1;
    [self performSegueWithIdentifier:@"addEditSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrPerson.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    // set right arrow
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.arrPerson[indexPath.row].firstName, self.arrPerson[indexPath.row].lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %@", self.arrPerson[indexPath.row].age];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// MARK: Delete a person in database
- (void)deletePersonFromDB:(NSInteger)row{
    // get person id by row
    NSNumber *pId = self.arrPerson[row].pId;
    NSString *query = [NSString stringWithFormat:@"delete from Person where id = %@", pId];
    // execute query delete
    [self.dbManager executeQuery:query];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deletePersonFromDB:indexPath.row];
        [self.arrPerson removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self loadDataFromDatabase];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.pIdToEdit = [self.arrPerson[indexPath.row].pId intValue];
    [self performSegueWithIdentifier:@"addEditSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddPersonViewController *addNewPerson = [segue destinationViewController];
    addNewPerson.delegate = self;
    addNewPerson.pIdToEdit = self.pIdToEdit;
}

// MARK: AddNewDelegate
- (void)addedNewPerson{
    [self loadDataFromDatabase];
}





@end
