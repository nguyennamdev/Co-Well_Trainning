//
//  ContactViewController.m
//  Lesson6
//
//  Created by Nguyen Nam on 4/22/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ContactViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <UIKit/UIKit.h>

@interface ContactViewController ()<CNContactPickerDelegate, CNContactViewControllerDelegate>
{
    CNContactPickerViewController *contactPicker;
}
@property (weak, nonatomic) IBOutlet UITextField *givenNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *familyNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dayOfBirthDatePicker;

@end

@implementation ContactViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    contactPicker
    contactPicker = [[CNContactPickerViewController alloc]init];
    contactPicker.delegate = self;
    contactPicker.displayedPropertyKeys = @[CNContactGivenNameKey, CNContainerNameKey, CNContactImageDataAvailableKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactIdentifierKey, CNContactBirthdayKey, CNContactEmailAddressesKey];
    
    _dayOfBirthDatePicker.datePickerMode = UIDatePickerModeDate;
    _dayOfBirthDatePicker.maximumDate = [NSDate date];
}

// MARK: setup contact
- (CNMutableContact *)setupContact{
    CNMutableContact *contact = [[CNMutableContact alloc]init];
    contact.givenName = _givenNameTextField.text;
    contact.familyName = _familyNameTextField.text;
    contact.phoneNumbers = @[[CNLabeledValue labeledValueWithLabel:@"telephone" value:[CNPhoneNumber phoneNumberWithStringValue:_phoneNumberTextField.text]]];
    contact.emailAddresses = @[[CNLabeledValue labeledValueWithLabel:@"email" value:[NSString localizedStringWithFormat:@"%@", _emailTextField.text]]];
    // handle birth day
    NSDateComponents *birthDay = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:_dayOfBirthDatePicker.date];
    contact.birthday = birthDay;
    return contact;
}

// MARK: check contact number exist
- (void)checkContactExist:(NSString *)strPhoneNumber withHandle:(void (^)(BOOL))complete{
    CNContactStore *contactStore = [[CNContactStore alloc]init];
    NSArray *keyToFetch = @[CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc]initWithKeysToFetch:keyToFetch];
    // fetch
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull con, BOOL * _Nonnull stop) {
        NSArray *phoneNumbers =  [[con.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == [c] %@", strPhoneNumber];
        NSArray *filtered = [phoneNumbers filteredArrayUsingPredicate:predicate];
        if ([filtered count] > 0)
        {
            // contact is exist
            complete(YES);
            *stop = YES;
        }else{
            complete(NO);
        }
    }];
}


// MARK: Actions

- (IBAction)showContacts:(UIBarButtonItem *)sender {
    [self presentViewController:contactPicker animated:true completion:nil];
}

- (IBAction)addNewContact:(UIBarButtonItem *)sender {
    if ([_givenNameTextField.text isEqualToString:@""] && [_familyNameTextField.text isEqualToString:@""] && [_phoneNumberTextField.text isEqualToString:@""]){
        NSLog(@"missing data");
    }else{
        CNMutableContact *contact = [self setupContact];
        // init contactViewController
        CNContactViewController *contactViewController = [CNContactViewController viewControllerForNewContact:contact];
        contactViewController.delegate = self;
        contactViewController.allowsActions = true;
        [self.navigationController pushViewController:contactViewController animated:true];
    }
}


// MARK: ContactPickerViewDelegate

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    NSLog(@"did cancel");
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    CNContactViewController *contactViewController = [CNContactViewController viewControllerForContact:contact];
    contactViewController.delegate = self;
    contactViewController.allowsActions = true;
    [self.navigationController pushViewController:contactViewController animated:true];
}

// MARK: ContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact{
    [self.navigationController popViewControllerAnimated:true];
    NSLog(@"did complete with contact");
}

- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property{
    NSLog(@"should perform default action for contact");
    return YES;
}




@end
