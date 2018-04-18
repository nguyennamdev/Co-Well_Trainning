//
//  SecoundViewController.m
//  Lesson5
//
//  Created by Nguyen Nam on 4/18/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "SecoundViewController.h"
#import "UIImage+OnlineImage.h"

@interface SecoundViewController ()

@end

@implementation SecoundViewController

// default images
UIImage *defaultImage;
UIImage *highlightImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup default image
    defaultImage = [UIImage imageNamed:@"hummingbird2"];
    highlightImage = [UIImage imageNamed:@"hummingbird"];
    
    // setup imageView
    _imageView.image = defaultImage;
    _imageView.highlightedImage = highlightImage;
    _imageView.userInteractionEnabled = true;
    
    [self setupImageAnimation];
}

// MARK: Actions

- (IBAction)loadImageByURL:(id)sender {
    UIImage *image = [[UIImage alloc]init];
    // create default urlString
    NSString *urlString = @"http://file.vforum.vn/hinh/2016/04/girl-xinh-gai-dep-2016-2.jpg";
    [image loadImageWithURL:urlString handler:^(UIImage *img) {
        self.imageView.image = img;
    }];
}

- (IBAction)loadDefaultImage:(UIButton *)sender {
    _imageView.image = defaultImage;
}

- (IBAction)startAnimation:(UIButton *)sender {
    [self.imageView startAnimating];
}
- (IBAction)stopAnimation:(UIButton *)sender {
    [self.imageView stopAnimating];
}

// MARK: Methods

- (void)setupImageAnimation{
    // create array image
    UIImage *img = [UIImage imageNamed:@"04"];
    UIImage *img2 = [UIImage imageNamed:@"05"];
    UIImage *img3 = [UIImage imageNamed:@"06"];
    UIImage *img4 = [UIImage imageNamed:@"07"];
    UIImage *img5 = [UIImage imageNamed:@"08"];
    UIImage *img6 = [UIImage imageNamed:@"09"];

    self.imageView.animationImages = @[img, img2, img3, img4, img5, img6];
    self.imageView.animationDuration = 3;
    self.imageView.animationRepeatCount = 2;
    
}

- (void)checkView:(NSSet<UITouch *> *)touches{
    for (UITouch *touch in touches){
        CGPoint point = [touch locationInView:self.view];
        UIView *view = [self.view hitTest:point withEvent:nil];
    
        if (view == _imageView){
            [_imageView setHighlighted:YES];
        }else{
            [_imageView setHighlighted:NO];
        }
    }
}

// MARK: Touchs

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch began");
    [self checkView:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch ended");
    [self.imageView setHighlighted:NO];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch moved");
    [self checkView:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch cancelled");
    [self.imageView setHighlighted:NO];
}


@end
