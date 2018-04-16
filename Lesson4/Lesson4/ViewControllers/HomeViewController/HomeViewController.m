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
