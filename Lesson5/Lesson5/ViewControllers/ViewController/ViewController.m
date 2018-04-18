//
//  ViewController.m
//  Lesson5
//
//  Created by Nguyen Nam on 4/17/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
// other pageControl which set up by code
@property (nonatomic) UIPageControl *pageControl2;

@end

@implementation ViewController
NSArray<UIColor *> *arrBackgroundColor;
NSArray<UIImage *> *arrImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up  array background color
    arrBackgroundColor = @[[UIColor blueColor],
                           [UIColor purpleColor],
                           [UIColor orangeColor],
                           [UIColor greenColor]];
    self.view.backgroundColor = arrBackgroundColor[0]; // setup default background
    
    // set up array image
    arrImage = @[[UIImage imageNamed:@"01"],
                 [UIImage imageNamed:@"02"],
                 [UIImage imageNamed:@"03"]];
    [self setupPageControl];
    [self setupPageControl2];
    _imageView.image = arrImage[_pageControl.currentPage]; // setup default image
}

// set up pageControl1
- (void)setupPageControl{
    _pageControl.numberOfPages = [arrImage count];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPage = 2;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
}

- (void)setupPageControl2{
    _pageControl2 = [[UIPageControl alloc]init];
    // view add subview
    [self.view addSubview:_pageControl2];
    // set auto layout
    _pageControl2.translatesAutoresizingMaskIntoConstraints = NO;
    // x,y,w,h
    [_pageControl2.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_pageControl2.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20].active = YES;
    [_pageControl2.widthAnchor constraintEqualToConstant:200].active = YES;
    [_pageControl2.heightAnchor constraintEqualToConstant:30].active = YES;
    // set numberOfPages = length of arrBackgroundColor
    _pageControl2.numberOfPages = [arrBackgroundColor count];
    _pageControl2.currentPage = 0;
    _pageControl2.defersCurrentPageDisplay = YES;
    // set color
    _pageControl2.pageIndicatorTintColor = [UIColor brownColor];
    _pageControl2.currentPageIndicatorTintColor = [UIColor redColor];
    // set action
    [_pageControl2 addTarget:self action:@selector(changeBackgroundColor:) forControlEvents:UIControlEventValueChanged];
}
// MARK: Actions

- (void)changeBackgroundColor:(UIPageControl *)sender{
    NSLog(@"currentPage2: %ld", sender.currentPage);
    // get color by currentPage
    UIColor *colorResult = arrBackgroundColor[sender.currentPage];
    self.view.backgroundColor = colorResult;
}
- (IBAction)changeImage:(UIPageControl *)sender {
    NSLog(@"currentPage1: %ld", sender.currentPage);
    // get image in arrImage by currentPage
    UIImage *imageResult = arrImage[sender.currentPage];
    _imageView.image = imageResult;
}

- (IBAction)updateCurrentPageControl:(UIButton *)sender {
    [_pageControl2 updateCurrentPageDisplay];
}

@end
