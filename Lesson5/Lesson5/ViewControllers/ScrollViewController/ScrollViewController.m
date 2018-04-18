//
//  ScrollViewController.m
//  Lesson5
//
//  Created by Nguyen Nam on 4/18/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupScrollView];
    [self scrollViewAddSubViews];
    
}

// MARK: setup scrollView
- (void)setupScrollView{
    self.scrollView.layer.borderColor = [UIColor blueColor].CGColor;
    self.scrollView.layer.borderWidth = 0.5;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 3, self.scrollView.bounds.size.height);
    self.scrollView.contentInset = UIEdgeInsetsMake(8, 12, 8, 12);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    
    self.scrollView.delegate = self;
}

// MARK: scrollView add subviews
- (void)scrollViewAddSubViews{
    UIView *redView = [[UIView alloc]init];
    UIView *blueView = [[UIView alloc]init];
    UIView *greenView = [[UIView alloc]init];
    
    redView.backgroundColor = [UIColor redColor];
    greenView.backgroundColor = [UIColor greenColor];
    blueView.backgroundColor = [UIColor blueColor];
    
    CGFloat height = self.scrollView.bounds.size.height;
    CGFloat width = self.scrollView.bounds.size.width;
    // set frame for subviews
    redView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, height);
    greenView.frame = CGRectMake(self.scrollView.bounds.size.width, 0, width, height);
    blueView.frame = CGRectMake(self.scrollView.bounds.size.width * 2, 0, width, height);
    
    [self.scrollView addSubview:redView];
    [self.scrollView addSubview:greenView];
    [self.scrollView addSubview:blueView];
    
    
}

// MARK: scrollView delegate
// MARK: - scroll
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"scrollViewWillEndDragging");
    NSLog(@"velocity:(%f,%f)", velocity.x, velocity.y);
    NSLog(@"targetContentOffset:(%f,%f)", targetContentOffset->x, targetContentOffset->y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
    NSLog(decelerate ? @"willDecelerate" : @"won't decelerate");
}

// MARK: - Decelerating
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDecelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
}



@end
