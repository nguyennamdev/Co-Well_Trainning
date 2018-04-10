//
//  ViewController.m
//  Lesson2
//
//  Created by Nguyen Nam on 4/10/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UIDatePicker *datePicker;
NSArray<UITextField *> *textFields;
UIBarButtonItem *previousBarButton;
UIBarButtonItem *nextBarButton;

// local variable
int currentTextFieldIsEditting;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initToolBar];
    [self addDatePickerToBirthDayTextField];
    
    // some delegate of text field
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.birthDayTextField.delegate = self;
    self.numberCardTextField.delegate = self;
    self.addressTextField.delegate = self;
    // init array
    textFields = @[_firstNameTextField, _lastNameTextField, _birthDayTextField, _numberCardTextField, _addressTextField];
}

- (void)initToolBar{
    UIToolbar *tb = [[UIToolbar alloc]init];
    [tb sizeToFit];
    // make barButtonItems
    previousBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(handlePreviousTextField:)];
     UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    nextBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(handleNextTextField:)];
    tb.items = @[previousBarButton, space, nextBarButton];
    [self textFieldsSetInputAccessoryView:tb];
}

- (void)textFieldsSetInputAccessoryView:(UIToolbar *)tb{
    self.firstNameTextField.inputAccessoryView = tb;
    self.lastNameTextField.inputAccessoryView = tb;
    self.numberCardTextField.inputAccessoryView = tb;
    self.addressTextField.inputAccessoryView = tb;
}

- (void)addDatePickerToBirthDayTextField{
    datePicker = [[UIDatePicker alloc]init];
    datePicker = [[UIDatePicker alloc] init];
    datePicker.minimumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [self.birthDayTextField setInputView:datePicker];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.birthDayTextField setInputAccessoryView:toolBar];
}

- (void)handleNextTextField:(UIBarButtonItem *)sender {
    currentTextFieldIsEditting++;
    if (currentTextFieldIsEditting > sizeof(textFields) - 1){
        currentTextFieldIsEditting = sizeof(textFields) - 1;
    }
    [textFields[currentTextFieldIsEditting] becomeFirstResponder];
}

- (void)handlePreviousTextField:(UIBarButtonItem *)sender{
    currentTextFieldIsEditting--;
    if (currentTextFieldIsEditting < 0){
        currentTextFieldIsEditting = 0;
    }
    [textFields[currentTextFieldIsEditting] becomeFirstResponder];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

- (void)showSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY hh:mm:ss a"];
    self.birthDayTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.birthDayTextField resignFirstResponder];
}

// MARK: implement functions of textField
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@", textField.text);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // get tag and access to currentTextFieldIsEditting
    currentTextFieldIsEditting = (int) textField.tag;
    
    if (currentTextFieldIsEditting == 0){
        [previousBarButton setEnabled:false];
    }else {
        [previousBarButton setEnabled:true];
    }
    
    if (currentTextFieldIsEditting == 4){
        [nextBarButton setEnabled:false];
    }else{
        [nextBarButton setEnabled:true];
    }
}

@end
