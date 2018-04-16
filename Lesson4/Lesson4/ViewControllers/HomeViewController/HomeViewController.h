//
//  FirstViewController.h
//  Lesson4
//
//  Created by Nguyen Nam on 4/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSArray<UIImage *> *arrImage;
}

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;


@end

