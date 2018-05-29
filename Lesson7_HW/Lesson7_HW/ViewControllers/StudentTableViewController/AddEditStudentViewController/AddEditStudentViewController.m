//
//  AddEditStudentViewController.m
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "AddEditStudentViewController.h"
#import "AddEditStudentDelegate.h"
#import "DBManager.h"

@interface AddEditStudentViewController ()

@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) DBManager *dbManager;

@end

@implementation AddEditStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:@"student.sqlite"];
    
    if (self.studentIdToEdit != -1){
        [self loadInfoToEdit];
    }
}


// load info to edit
- (void)loadInfoToEdit{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Student where id = %ld", self.studentIdToEdit];
    
    // load the relevant data
    NSArray *result = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDatabase:query]];
    self.firstNameTextField.text = [result[0] objectAtIndex:[self.dbManager.arrColumnsName indexOfObject:@"firstName"]];
    self.lastNameTextField.text = [result[0] objectAtIndex:[self.dbManager.arrColumnsName indexOfObject:@"lastName"]];
    NSInteger age = [[result[0] objectAtIndex:[self.dbManager.arrColumnsName indexOfObject:@"age"]] integerValue];
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",age];
    [self.ageSlider setValue:age];
    NSString *gender = [result[0] objectAtIndex:[self.dbManager.arrColumnsName indexOfObject:@"gender"]];
    self.genderSegment.selectedSegmentIndex = [gender  isEqualToString: @"Male"] ? 0 : 1;
}

// MARK: Actions

- (IBAction)handleStudent:(UIBarButtonItem *)sender {
    // get data on view
    NSString *firstName = self.firstNameTextField.text;
    NSString *lastName = self.lastNameTextField.text;
    NSInteger age = (NSInteger)self.ageSlider.value;
    NSString *gender = self.genderSegment.selectedSegmentIndex == 0 ? @"Male" : @"Female";
    NSString *query;
    if (_studentIdToEdit == -1){
        query = [NSString stringWithFormat: @"Insert into Student values (null, '%@', '%@', %ld, '%@')", firstName, lastName, age, gender];
    }else{
        query = [NSString stringWithFormat:@"Update Student set firstName = '%@', lastName = '%@', age = %ld, gender = '%@'", firstName, lastName, age, gender];
    }
    // Execute query
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRow != 0){
        NSLog(@"Query was executed ");
        [self.delegate addEditedStudent];
        // pop to root view
        [self.navigationController popViewControllerAnimated:true];
    }else{
        NSLog(@"Could not execute the query ");
    }
    
    
}
- (IBAction)ageSliderValueChanged:(UISlider *)sender {
    NSInteger value = (NSInteger )sender.value;
    _ageLabel.text = [NSString stringWithFormat:@"%ld",value];
}
- (IBAction)genderSementValueChanged:(UISegmentedControl *)sender {
}



@end
