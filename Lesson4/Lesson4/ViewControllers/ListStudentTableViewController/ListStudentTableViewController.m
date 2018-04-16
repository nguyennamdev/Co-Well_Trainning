//
//  SecondViewController.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ListStudentTableViewController.h"
#import "Define.h"

@interface ListStudentTableViewController ()

@end

@implementation ListStudentTableViewController

// MARK: Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup navigation bar
    self.navigationItem.title = @"List Student";
    
    // init array student
    students = NSMutableArray.new;
    [self initAddBarButtonItem];
    
    [self.navigationController.navigationBar setBarTintColor:DEFAULT_COLOR_BLUE];
}

- (void)viewWillAppear:(BOOL)animated{
    // check this things for add new student
    if (_aeViewController != NULL && _aeViewController.isAddNewStudent == TRUE && _aeViewController.student != NULL) {
        Student *student = _aeViewController.student;
        [students addObject:student];
    }
    [self.tableView reloadData];
}

// MARK: init right bar button item
- (void)initAddBarButtonItem{
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addNewStudent:)];
    button.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:button];
}

// MARK: Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"addEditSegue"]){
        self.aeViewController = (AddEditViewController *)segue.destinationViewController;
        self.aeViewController.student = students[self.tableView.indexPathForSelectedRow.row];
        self.aeViewController.isAddNewStudent = NO;
    }
}

// MARK: Actions
- (void)addNewStudent:(UIBarButtonItem *)sender{
    _aeViewController = (AddEditViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddEditViewController"];
    _aeViewController.isAddNewStudent = YES;
    [self.navigationController pushViewController:_aeViewController animated:true];
}

// MARK: Implement delegate and datasource tableViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    // set arrow ">" in right cell
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    // check image is nil to set image default
    if (students[indexPath.row].image == NULL) {
        cell.imageView.image = [UIImage imageNamed:@"user"];
    }else{
        cell.imageView.image = students[indexPath.row].image;
    }
    cell.textLabel.text = students[indexPath.row].name;
    return cell;
}

// MARK: TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        // make alert to confirm delete
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete student" message:@"Do you want to delete ?" preferredStyle:UIAlertControllerStyleAlert];
        // add actions to alert
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // remove that object in array student
            Student *studentWillRemove = students[indexPath.row];
            [students removeObject:studentWillRemove];
            [self.tableView reloadData];
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:yes];
        [alert addAction:no];
        [self presentViewController:alert animated:true completion:nil];
    }
}



@end
