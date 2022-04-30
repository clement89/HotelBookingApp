//
//  CalendarDiscoverCollectionViewCell.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDiscoverCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *dayWords;
@property (strong, nonatomic) IBOutlet UILabel *dayNum;
@property (strong, nonatomic) IBOutlet UILabel *selectedDay;
@property (strong, nonatomic) IBOutlet UIImageView *cirlceRed;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectedDayHt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectedDayWdth;


@end
