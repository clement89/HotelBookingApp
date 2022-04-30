//
//  FacilitiesViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 28/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacilitiesCellTableViewCell.h"
@interface FacilitiesViewController : UIViewController
{
    IBOutlet UITableView* facilitiesTBV;
    FacilitiesCellTableViewCell* cell;
}
@property(nonatomic,retain)NSDictionary* dataDIC;
@property(nonatomic,retain)NSArray* availableServices;
@end
