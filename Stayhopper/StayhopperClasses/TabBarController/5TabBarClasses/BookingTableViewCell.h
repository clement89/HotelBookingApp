//
//  BookingTableViewCell.h
//  Stayhopper
//
//  Created by iROID Technologies on 21/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *contentVieww;
@property (strong, nonatomic) IBOutlet UIImageView *propertyImageVieww;
@property (strong, nonatomic) IBOutlet UILabel* propertyName;
@property (strong, nonatomic) IBOutlet UILabel* propertyLocation;
@property (strong, nonatomic) IBOutlet UILabel* roomsLabel;
@property (strong, nonatomic) IBOutlet UILabel* dateLBL;
@property (strong, nonatomic) IBOutlet UILabel* cancelLBL;

@property (strong, nonatomic) IBOutlet UILabel* bookingIDLBL;

@end
