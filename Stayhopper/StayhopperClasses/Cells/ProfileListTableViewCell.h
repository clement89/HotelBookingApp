//
//  ProfileListTableViewCell.h
//  Stayhopper
//
//  Created by Bryno Baby on 04/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileListTableViewCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UIImageView* iconImage;
@property(nonatomic,retain)IBOutlet UILabel* listTitle;
@property(nonatomic,retain)IBOutlet UIView* bgView;

@end
