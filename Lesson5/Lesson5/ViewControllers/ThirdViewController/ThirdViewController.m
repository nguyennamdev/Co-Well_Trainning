//
//  ThirdViewController.m
//  Lesson5
//
//  Created by Nguyen Nam on 4/18/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()<UITextViewDelegate>

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.delegate = self;
    [self setupTextView];
    
}

// MARK: setup textView
- (void)setupTextView{
    self.textView.text = @"Hello i am a 🐶. i not only bark but also cover home. However i also a food";
    self.textView.font = [UIFont boldSystemFontOfSize:20];
    self.textView.textColor = [UIColor purpleColor];
    [self.textView setEditable:YES]; // it allow user edit content in textView
    self.textView.textAlignment = NSTextAlignmentCenter;
}



// MARK: textView delegate

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"did change %@", textView.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"did end editting " );
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"did begin editting");
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}



@end
