//
//  UIImage+OnlineImage.h
//  Lesson5
//
//  Created by Nguyen Nam on 4/18/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OnlineImage)

- (void)loadImageWithURL:(NSString *)url handler:(void (^)(UIImage *))completeHandler;

@end
