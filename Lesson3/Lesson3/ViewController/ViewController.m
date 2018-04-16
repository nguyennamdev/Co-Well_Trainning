//
//  ViewController.m
//  Lesson3
//
//  Created by Nguyen Nam on 4/11/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "Define.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // init toolBar
    [self initToolBarForTextField];
    
    // set delegate for text field
    self.rollNoTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.emailTextField.delegate = self;
}

// MARK: Method
- (void)initToolBarForTextField{
    UIToolbar *tb = [[UIToolbar alloc]init];
    [tb sizeToFit];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // make done bar button
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"done" style:UIBarButtonItemStyleDone target:self action:@selector(handleTextFieldDoneEdit:)];
    // add to items of toolBar
    tb.items = @[space, doneButton];
    // assign tool bar to inputAccessoryView
    self.rollNoTextField.inputAccessoryView = tb;
    self.nameTextField.inputAccessoryView = tb;
    self.emailTextField.inputAccessoryView = tb;
}

// MARK: Actions
- (void)handleTextFieldDoneEdit:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
}

- (IBAction)ageSliderValueChanged:(UISlider *)sender {
    // get value changed
    self.ageValueLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (IBAction)genderSegmentValueChanged:(id)sender {
    UISegmentedControl *segmented = sender;
    // changed haveLoverLabel value
    NSString *label = segmented.selectedSegmentIndex == 0 ? @"have girlfriend?" : @"have boyfriend?";
    _haveLoverLabel.text = label;
}

- (IBAction)haveLoverSwitchValueChanged:(UISwitch *)sender {
    // findLoverSwitch changed value follow this switch
    if (sender.on) {
        [self.findLoverSwitch setOn:NO animated:true];
    }else{
        [self.findLoverSwitch setOn:YES animated:true];
    }
}

- (IBAction)findLoverSwitchValueChanged:(id)sender {
    UISwitch *sw = sender;
    if (sw.on) {
        [self.haveLoverSwitch setOn:NO animated:true];
    }else{
        [self.haveLoverSwitch setOn:YES animated:true];
    }
}

- (IBAction)yearStepperValueChanged:(UIStepper *)sender {
    self.yearsLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (IBAction)saveNewStudent:(id)sender {
    // get data
    NSString *rollNo = self.rollNoTextField.text;
    NSString *name = self.nameTextField.text;
    NSNumber *age =  [NSNumber numberWithInt:(int)self.ageSlider.value];
    NSString *gender = _genderSegment.selectedSegmentIndex == 0 ? @"Male" : @"Female";
    NSString *email = self.emailTextField.text;
    NSNumber *relationship = [NSNumber numberWithBool:_haveLoverSwitch.on];
    NSNumber *findLover = [NSNumber numberWithBool:_findLoverSwitch.on];
    NSNumber *year = [NSNumber numberWithDouble:_yearStepper.value];
    // init dictionary
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:rollNo,ROLL_NO,
                          name,NAME,
                          age,AGE,
                          gender,GENDER,
                          email,EMAIL,
                          relationship,RELATIONSHIP,
                          findLover,FIND_LOVER,
                          year,YEAR,
                          nil];
    // init student object and log information
    Student *student = [[Student alloc]initWithDict: dict];
    [student logMySelf];
}

// MARK: Implement methods of textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:true];
}

@end
