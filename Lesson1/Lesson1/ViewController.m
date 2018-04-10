//
//  ViewController.m
//  Lesson1
//
//  Created by Nguyen Nam on 4/9/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *petNameTextFeild;

@end

@implementation ViewController

// declare pet array
 NSMutableArray<NSString *> *pets;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // init pet array
    pets = [[NSMutableArray alloc]init];
}

// MARK: Actions
- (IBAction)savePetToArray:(UIButton *)sender {
    if ([_petNameTextFeild.text  isEqualToString:@""]) {
        NSLog(@"value is nil");
    }else{
        // append new pet name
        NSString *name = _petNameTextFeild.text;
        [pets addObject:name];
        // clear current text of text feild
        _petNameTextFeild.text = @"";
        [self showNamePets:pets];
    }
}

- (void)showNamePets:(NSMutableArray *)array{
    NSLog(@"Pets:");
    for (NSString *element in array) {
        NSLog(@"%@,", element);
    }
}


@end























