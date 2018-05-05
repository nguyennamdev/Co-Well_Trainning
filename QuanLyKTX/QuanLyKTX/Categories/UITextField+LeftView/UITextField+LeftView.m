//
//  UITextField+LeftView.m
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "UITextField+LeftView.h"

@implementation UITextField (LeftView)

- (void)setImageForLeftView:(UIImage *)image leftViewFrame:(CGRect)viewFrame andImageFrame:(CGRect)imageImage{
    UIView *leftView = [[UIView alloc]initWithFrame:viewFrame];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageImage];
    [leftView addSubview:imageView];
    imageView.center = leftView.center;
    imageView.image = image;
    [self setLeftView:leftView];
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
