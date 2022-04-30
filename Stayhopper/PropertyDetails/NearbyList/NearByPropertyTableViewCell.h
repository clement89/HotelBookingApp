//
//  NearByPropertyTableViewCell.h
//  Stayhopper
//
//  Created by Bryno Baby on 23/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByPropertyTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel* locationNameLBL;
@property(nonatomic,strong)IBOutlet UIView* bgView;

@property(nonatomic,strong)IBOutlet UIImageView* locationImageView;
@end
