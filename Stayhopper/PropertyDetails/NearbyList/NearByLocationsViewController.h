//
//  NearByLocationsViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 23/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearByPropertyTableViewCell.h"
@interface NearByLocationsViewController : UIViewController
{
    IBOutlet UITableView* locationListTable;
    NearByPropertyTableViewCell* cell;
    BOOL status;
 
}
@property(nonatomic,retain)NSArray* dataArray;
@property (assign, nonatomic) BOOL shouldHideTopView;
@property(nonatomic,retain)NSString* titleString;
@property (weak, nonatomic) IBOutlet UITableView *tblNearby;

@end
