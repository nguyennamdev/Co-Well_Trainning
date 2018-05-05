//
//  UITextField+PlaceHolder.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "UITextField+PlaceHolder.h"

@implementation UITextField (PlaceHolder)

- (void)setColorForPlaceholder:(NSString *)placeholderText withColor:(UIColor *)color{
    self.placeholder = placeholderText;
    self.textColor = color;
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

@end
