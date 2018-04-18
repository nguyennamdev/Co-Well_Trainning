//
//  NSUserDefaults+Color.h
//  Lesson4
//
//  Created by Nguyen Nam on 4/16/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSUserDefaults (Color)

- (void)setColorForKey:(NSString *)key color:(UIColor *)color;

- (UIColor *)getColorForKey:(NSString *)key;

@end
