//
//  StudentTableViewCell.h
//  QuanLyKTX
//
//  Created by Nguyen Nam on 5/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;

@end
