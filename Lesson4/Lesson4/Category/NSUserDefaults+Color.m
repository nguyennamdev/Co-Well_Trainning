//
//  NSUserDefaults+Color.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/16/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "NSUserDefaults+Color.h"

@implementation NSUserDefaults (Color)

- (void)setColorForKey:(NSString *)key color:(UIColor *)color{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:key];
}

- (UIColor *)getColorForKey:(NSString *)key{
    NSData *colorData = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    UIColor *colorResult = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    return colorResult;
}

@end
