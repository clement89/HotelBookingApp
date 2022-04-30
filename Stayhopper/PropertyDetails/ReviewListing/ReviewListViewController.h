//
//  ReviewListViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 23/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewTableViewCell.h"
@interface ReviewListViewController : UIViewController
{
    ReviewTableViewCell* cell;
    IBOutlet UITableView* listingTableView;
IBOutlet UILabel *roomsCount;
    IBOutlet UILabel *ratingValue;
    IBOutlet UILabel *ratingString;
    IBOutlet UILabel *ratingUserCount;

    IBOutlet UILabel *NOreviewratingValue;

    BOOL status;
}
@property(nonatomic,retain)NSMutableArray* dataArray;
@property(nonatomic,retain)NSString* ratingValue1;

@end
