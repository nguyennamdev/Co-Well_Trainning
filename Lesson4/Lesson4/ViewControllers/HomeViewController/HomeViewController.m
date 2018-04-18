//
//  FirstViewController.m
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "HomeViewController.h"
#import "ImageCollectionViewCell.h"
#import "Define.h"
#import "NSUserDefaults+Color.h"


@interface HomeViewController ()
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set up image collection view
    _imageCollectionView.delegate = self;
    _imageCollectionView.dataSource = self;
    _imageCollectionView.alwaysBounceVertical = YES;
    [self initArrImage];
    
    // hide navigationBar
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    // get UIColor by NSUserDefaults
    UIColor *colorResult = [[NSUserDefaults standardUserDefaults]getColorForKey:COLOR_SETTING];
    if (colorResult == NULL){
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        self.view.backgroundColor = colorResult;
    }
    [self getTextByNSUserDefaults];
}

// MARK: get text by NSUserDefaults
- (void)getTextByNSUserDefaults{
    NSString *introText = [[NSUserDefaults standardUserDefaults] objectForKey:INTRO_SETTING];
    NSString *contactText = [[NSUserDefaults standardUserDefaults] objectForKey:CONTACT_SETTING];
    if (introText != NULL){
        self.introTextView.text = introText;
    }
    if (contactText != NULL){
        self.contactTextView.text = contactText;
    }
}

// MARK: init arrImage
- (void)initArrImage{
    // create image element
    UIImage *first = [UIImage imageNamed:@"1"];
    UIImage *second = [UIImage imageNamed:@"2"];
    UIImage *third = [UIImage imageNamed:@"3"];
    arrImage = [[NSArray alloc]initWithObjects:first, second, third, nil];
}

// MARK: implement delegate and dataSource for imageCollectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.imageView.image = arrImage[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrImage.count;
}

@end
