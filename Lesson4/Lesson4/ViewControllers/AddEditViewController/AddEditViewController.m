//
//  AddEditViewController.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "AddEditViewController.h"
#import "Student.h"
#import "Define.h"

@interface AddEditViewController ()

@end

@implementation AddEditViewController

// MARK: Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set delegate for textFields
    self.rollNoTextField.delegate = self;
    self.profileNameTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;

    if (_isAddNewStudent == YES){
        self.navigationItem.title = @"Add Student";
    }else{
        self.navigationItem.title = @"Detail Student";
    }
    [self initBackButton];
}

- (void)viewWillAppear:(BOOL)animated{
    if (_student != NULL){
        _rollNoTextField.text = _student.rollNo;
        _profileNameTextField.text = _student.name;
        _ageSlider.value = _student.age.floatValue;
        _genderSegmentedControl.selectedSegmentIndex = _student.gender.integerValue;
        // if student image is null, profileImageView will set image default;
        if (_student.image != NULL){
            _profileImageView.image = _student.image;
        }
    }
}


- (void)initBackButton{
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(backToRootView)];
    myBackButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = myBackButton;
}

// MARK: Actions
- (void)backToRootView{
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)addEditStudentComplete:(UIBarButtonItem *)sender {
    // get data
    NSString *rollNo = _rollNoTextField.text;
    NSString *name = _profileNameTextField.text;
    NSNumber *age = [NSNumber numberWithFloat:_ageSlider.value];
    NSNumber *gender = [NSNumber numberWithInteger:_genderSegmentedControl.selectedSegmentIndex];
    NSString *phoneNumber = _phoneNumberTextField.text;

    if (_student == NULL){
        _student = Student.new;
    }
    _student.rollNo = rollNo;
    _student.name = name;
    _student.age = age;
    _student.gender = gender;
    _student.phoneNumber = phoneNumber;
    _student.image = _profileImageView.image;
    
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)ageSliderValueChanged:(UISlider *)sender {
    _profileAgeLabel.text = [NSString stringWithFormat:@"%d",(int)sender.value];
}

- (IBAction)genderSegmentedValueChanged:(id)sender {
    
}

// MARK: Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:TRUE];
}

- (IBAction)tapSelectImage:(UITapGestureRecognizer *)sender {
    // hide textFields
    [_rollNoTextField resignFirstResponder];
    [_profileNameTextField resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
    // init imagePicker to use pick media photos
    imagePickerController = [[UIImagePickerController alloc]init];
    // set source type
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    // present it
    [self presentViewController:imagePickerController animated:true completion:nil];
}


// MARK: Implement textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_rollNoTextField resignFirstResponder];
    [_profileNameTextField resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
    return TRUE;
}

// MARK: Implement imagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image != NULL){
        // access to profileImageView
        _profileImageView.image = image;
    }
    // dismiss the picker
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
