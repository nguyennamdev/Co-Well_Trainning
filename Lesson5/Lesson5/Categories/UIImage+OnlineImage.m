//
//  UIImage+OnlineImage.m
//  Lesson5
//
//  Created by Nguyen Nam on 4/18/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "UIImage+OnlineImage.h"

@implementation UIImage (OnlineImage)

- (void)loadImageWithURL:(NSString *)url handler:(void (^)(UIImage *))completeHandler{
    // create NSURL by url string
    NSURL *URL = [NSURL URLWithString:url];
    
    if (URL == nil){
        return ;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:URL];
        if (imageData == nil){
            return ;
        }
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        completeHandler(image);
    });
}

@end
