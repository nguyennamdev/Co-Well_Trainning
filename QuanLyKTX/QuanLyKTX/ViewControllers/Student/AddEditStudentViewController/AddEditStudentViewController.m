//
//  AddEditStudentViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "AddEditStudentViewController.h"
#import "Room.h"
#import "DBManager.h"
#import "Define.h"
#import "UIViewController+Alert.h"
#import "UIViewController+LoadAllStudent.h"

@interface AddEditStudentViewController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    NSInteger currentTextFieldIsShowing;
    UIBarButtonItem *previousButton;
    UIBarButtonItem *nextButton;
}

@property (strong, nonatomic) NSMutableArray<Room *> *arrRoom;
@property (strong, nonatomic) DBManager *dbManager;
@property (nonatomic) NSInteger roomIdToIncreseCurrentQuantity;
@property (nonatomic) NSInteger roomIdToReduceCurrentQuantity;
@property (strong, nonatomic) NSArray<UITextField *> *arrTextFields;



@end

@implementation AddEditStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init dbManager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:DATABASE_NAME];
    
    // custom navigation bar
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRootView:)];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    [self setDatePickerForBirthDayTextField];
    
    // set delegate for roomPickerView
    _roomPickerView.delegate = self;
    
    // equal -1 it will load data to edit
    if (_studentId != -1){
        NSLog(@"Editing ");
        [self loadDataToEdit];
    }
    
    // init arrTextFields
    self.arrTextFields = @[_firstNameTextField, _lastNameTextField, _birthdayTextField, _hometownTextField, __classTextField];
    // invoke func set delegate  and set tool bar of text fields
    [self setupDelegateForTextField];
    [self initToolBarForTextField];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadRoom];
}

// MARK: Load room is also anti
- (void)loadRoom{
    NSString *query = @"select * from tblRoom where currentQuantity < maxQuantity;";
    NSArray *arrayResult = [self.dbManager loadDataFromDatabase:query];
    // init arrRoom
    self.arrRoom = [[NSMutableArray alloc]init];
    
    NSInteger indexOfRoomId = [self.dbManager.arrColumnsName indexOfObject:ROOM_ID];
    NSInteger indexOfIdManager = [self.dbManager.arrColumnsName indexOfObject:ROOM_ID_MANAGER];
    NSInteger indexOfRoomName = [self.dbManager.arrColumnsName indexOfObject:ROOM_NAME];
    NSInteger indexOfMaxQuantity = [self.dbManager.arrColumnsName indexOfObject:ROOM_MAX_QUANTITY];
    NSInteger indexOfCurrentQuantity = [self.dbManager.arrColumnsName indexOfObject:ROOM_CURRENT_QUANTITY];
    NSInteger indexOfCreatedDate = [self.dbManager.arrColumnsName indexOfObject:CREATED_DATE];
    NSInteger indexOfUpdatedDate = [self.dbManager.arrColumnsName indexOfObject:UPDATED_DATE];
    
    for (int i = 0; i < arrayResult.count; i++) {
        Room *room = Room.new;
        room.roomId = [arrayResult[i] objectAtIndex:indexOfRoomId];
        room.managerId = [NSNumber numberWithInteger:[[arrayResult[i] objectAtIndex:indexOfIdManager] integerValue]];
        room.roomName = [arrayResult[i] objectAtIndex:indexOfRoomName];
        room.maxQuantity = [arrayResult[i] objectAtIndex:indexOfMaxQuantity];
        room.currentQuantity = [arrayResult[i] objectAtIndex:indexOfCurrentQuantity];
        room.createdDate = [arrayResult[i] objectAtIndex:indexOfCreatedDate];
        room.updatedDate = [arrayResult[i] objectAtIndex:indexOfUpdatedDate];
        [_arrRoom addObject:room];
    }
    [self.roomPickerView reloadAllComponents];
    // set default roomId by first elements
    if (_arrRoom.count > 0){
        self.roomIdToIncreseCurrentQuantity = [_arrRoom[0].roomId integerValue];
    }
}

// MARK: Load student to edit
- (void)loadDataToEdit{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM tblStudent where student_id = %ld", self.studentId];
    NSArray *arrResult = [self.dbManager loadDataFromDatabase:query];
    Student *student = [self loadAllStudent:self.dbManager byArrayResult:arrResult].firstObject;
    //
    self.firstNameTextField.text = student.firstName;
    self.lastNameTextField.text = student.lastName;
    self.birthdayTextField.text = [NSString stringWithFormat:@"%@", student.birthday];
    self.hometownTextField.text = student.homeTown;
    self._classTextField.text = student._class;
    self.genderSegment.selectedSegmentIndex = [student.gender  isEqual: @"Male"] ? 0 : 1;
    // invoke load room id
    self.roomIdToReduceCurrentQuantity = [self loadRoomIdToEdit];
}

- (NSInteger)loadRoomIdToEdit{
    // this function return room id by student id
    // then use it to update current quantity when student switchs room
    NSString *query = [NSString stringWithFormat:@"Select room_id from tblStudent where student_id = %ld", self.studentId];
    NSInteger oldRoomId = [[[self.dbManager loadDataFromDatabase:query].firstObject objectAtIndex:0] integerValue];
    return oldRoomId;
}

// MARK: set up text fields
- (void)setupDelegateForTextField{
    for (UITextField *textFiels in self.arrTextFields) {
        textFiels.delegate = self;
    }
}

- (void)initToolBarForTextField{
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [toolBar sizeToFit];
    // init buttons on tool bar
    previousButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"up-arrows"] style:UIBarButtonItemStylePlain target:self action:@selector(handlePreviousTextField:)];
    nextButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"down-arrow"]
        style:UIBarButtonItemStylePlain target:self action:@selector(handleNextTextField:)];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[previousButton, fixedSpace, nextButton]];
    [self setInputAccessoryViewTextField:toolBar];
}

- (void)setInputAccessoryViewTextField:(UIToolbar *)toolBar{
    self.firstNameTextField.inputAccessoryView = toolBar;
    self.lastNameTextField.inputAccessoryView = toolBar;
    self.hometownTextField.inputAccessoryView = toolBar;
    self._classTextField.inputAccessoryView = toolBar;
}

- (void)setDatePickerForBirthDayTextField{
    datePicker = [[UIDatePicker alloc]init];
    // init format date to set maximun date
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    NSDate *date = [formatter dateFromString:@"01/01/2000"];
    datePicker.maximumDate = [NSDate dateWithTimeInterval:10 sinceDate:date];
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.birthdayTextField setInputView:datePicker];
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [toolBar sizeToFit];
    previousButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"up-arrows"] style:UIBarButtonItemStylePlain target:self action:@selector(handlePreviousTextField:)];
    nextButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"down-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(handleNextTextField:)];
    UIBarButtonItem *doneButton  = [[UIBarButtonItem alloc]initWithTitle:@"done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[previousButton, nextButton,space, doneButton]];
    [self.birthdayTextField setInputAccessoryView:toolBar];
}

// MARK: Actions

- (void)showSelectedDate{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY"];
    self.birthdayTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.birthdayTextField resignFirstResponder];
}

- (void)handlePreviousTextField:(UIBarButtonItem *)sender{
    currentTextFieldIsShowing--;
    if (currentTextFieldIsShowing < 0){
        currentTextFieldIsShowing = 0;
    }
    // showing text field
    [self.arrTextFields[currentTextFieldIsShowing] becomeFirstResponder];
}

- (void)handleNextTextField:(UIBarButtonItem *)sender{
    currentTextFieldIsShowing++;
    if (currentTextFieldIsShowing > self.arrTextFields.count - 1){
        currentTextFieldIsShowing = self.arrTextFields.count - 1;
    }
    [self.arrTextFields[currentTextFieldIsShowing] becomeFirstResponder];
}

- (void)backToRootView:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)completeAddNewStudent:(UIBarButtonItem *)sender {
    if ([_firstNameTextField.text isEqualToString:@""] || [_lastNameTextField.text isEqualToString:@""] || [_birthdayTextField.text isEqualToString:@""] || [_hometownTextField.text isEqualToString:@""] || [self._classTextField.text isEqualToString:@""]){
        [self presentAlertControllerWithCancelAction:@"Missing data" andMessage:@"You must enter enough data"];
    }else{
        // get data on view
        NSString *firstName = self.firstNameTextField.text;
        NSString *lastName = self.lastNameTextField.text;
        NSString *birthday = self.birthdayTextField.text;
        NSString *gender = self.genderSegment.selectedSegmentIndex == 0 ? @"Male" : @"Female";
        NSString *hometown = self.hometownTextField.text;
        NSString *class = self._classTextField.text;
        NSString *query;
        if (self.studentId == -1){ // as add new student
            query = [NSString stringWithFormat:@"Insert into tblStudent values (null, %ld, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", self.roomIdToIncreseCurrentQuantity, firstName, lastName, birthday, gender, hometown, class, [NSDate date], [NSDate date]];
        }else{ // as edit student
            query = [NSString stringWithFormat:@"Update tblStudent set room_id = %ld, firstName = '%@', lastName = '%@', birthday = '%@', gender = '%@', homeTown = '%@', class = '%@', updatedDate = '%@'", self.roomIdToIncreseCurrentQuantity, firstName, lastName, birthday, gender, hometown, class, [NSDate date]];
        }
        [self executeQuery:query];
    }
}

- (void)executeQuery:(NSString *)query{
    [self.dbManager executeQuery:query];
    if (self.dbManager.affectedRow > 0){
        [self.navigationController popViewControllerAnimated:true];
    }
    [self updateRoomCurrentQuantity];
}

- (void)updateRoomCurrentQuantity{
    if (self.studentId == -1){
        // student don't switch room
        NSString *query = [NSString stringWithFormat:@"Update tblRoom set currentQuantity = currentQuantity + 1, updatedDate = '%@' where room_id = %ld", [NSDate date],self.roomIdToIncreseCurrentQuantity];
        [self.dbManager executeQuery:query];
        if (self.dbManager.affectedRow > 0){
            NSLog(@"updated");
        }
    }else{
         // check room id if they not equal, room will change current quantity
         // student do switch room
        if (_roomIdToIncreseCurrentQuantity != _roomIdToReduceCurrentQuantity){
            // To reduce current quantity of old room
            NSString *query =  [NSString stringWithFormat:@"Update tblRoom set currentQuantity = currentQuantity - 1, updatedDate = '%@' where room_id = %ld", [NSDate date], self.roomIdToReduceCurrentQuantity];
            [self.dbManager executeQuery:query];
       
            // To increase current quantity of new room
            NSString *query2 = [NSString stringWithFormat:@"Update tblRoom set currentQuantity = currentQuantity + 1, updatedDate = '%@' where room_id = %ld", [NSDate date],self.roomIdToIncreseCurrentQuantity];
            [self.dbManager executeQuery:query2];
        }
    }
}


// MARK: Touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

// MARK: Implement UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextFieldIsShowing = textField.tag;
    // enable a button when current out of range of array text fields
    if (currentTextFieldIsShowing == 0){
        [previousButton setEnabled:false];
    }else{
        [previousButton setEnabled:true];
    }
    
    if (currentTextFieldIsShowing == self.arrTextFields.count - 1){
        [nextButton setEnabled:false];
    }else{
        [nextButton setEnabled:true];
    }
    
}

// MARK: Implement UIPickerDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrRoom.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Room *room = _arrRoom[row];
    return room.roomName;
}

// MARK: Implement UIPickerDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    // get room id when user did select row
    self.roomIdToIncreseCurrentQuantity = [self.arrRoom[row].roomId integerValue];
}

@end
