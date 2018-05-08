//
//  AddNewAccountViewController.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "AddNewAccountViewController.h"
#import "DBManager.h"
#import "UIViewController+Alert.h"
#import "UITextField+PlaceHolder.h"
#import "Define.h"

@interface AddNewAccountViewController ()<UITextFieldDelegate>{
    UIBarButtonItem *previousButton;
    UIBarButtonItem *nextButton;
    NSInteger currentTextFieldIsShowing;
}

@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSArray<UITextField *> *arrTextFields;

@end

@implementation AddNewAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init dbManager
    self.dbManager = [[DBManager alloc]initWithDatabaseFileName:DATABASE_NAME];
    // custom navigation bar
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRootView)];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.title = @"Add new account";
    
    // init arrTextFields
    self.arrTextFields = @[_firstNameTextField, _lastNameTextField, _userNameTextField, _passwordTextField, _confirmPasswordTextField];
    
    // set delegate and tool bar of text fields
    [self setDelegateTextField];
    [self initToolBarForTextField];
    
}

// MARK: some method to set up text fields
- (void)setDelegateTextField{
    for (UITextField *tf in self.arrTextFields) {
        tf.delegate = self;
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
    self.userNameTextField.inputAccessoryView = toolBar;
    self.passwordTextField.inputAccessoryView = toolBar;
    self.confirmPasswordTextField.inputAccessoryView = toolBar;
}



// MARK: Actions
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

- (IBAction)createNewAccount:(UIButton *)sender {
    if ([_firstNameTextField.text isEqualToString:@""] || [_lastNameTextField.text isEqualToString:@""] || [_userNameTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""] || [_confirmPasswordTextField.text isEqualToString:@""]){
        [self presentAlertControllerWithCancelAction:@"Missing data" andMessage:@"You must enter enough information."];
    }else{
        // check length password
        if ([_passwordTextField.text length] < 8){
            _passwordTextField.tintColor = [UIColor redColor];
            _passwordTextField.text = @"";
            [_passwordTextField setColorForPlaceholder:@"Length of password must more than 8 characters" withColor:[UIColor redColor]];
        }else if (_confirmPasswordTextField.text != _passwordTextField.text){
            // confirm password don't match
            _confirmPasswordTextField.text = @"";
            [_confirmPasswordTextField setColorForPlaceholder:@"Your password don't match" withColor:[UIColor redColor]];
        }else{
            // accept to insert 
            NSDate *createdDate = [NSDate date];
            NSDate *updatedDate = [NSDate date];
            NSString *query = [NSString stringWithFormat:@"INSERT INTO tblAdmin values (null, '%@', '%@', '%@', '%@', '%@', '%@')", _userNameTextField.text, _passwordTextField.text, _firstNameTextField.text, _lastNameTextField.text, createdDate, updatedDate];
            [self.dbManager executeQuery:query];
            if (self.dbManager.affectedRow != 0){
                NSLog(@"Inserted");
                [self.navigationController popViewControllerAnimated:true];
            }
        }
    }
}

- (void)backToRootView{
    [self.navigationController popViewControllerAnimated:true];
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
    
    // set text color again when user entered wrong
    if ([textField isEqual:_passwordTextField]){
        _passwordTextField.textColor = [UIColor blackColor];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}


@end
