//
//  NotificationsViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsTableViewCell.h"
#import "MBProgressHUD.h"
#import"RequestUtil.h"
@interface NotificationsViewController : UIViewController<WebData>
{
    NotificationsTableViewCell* cell;
    NSArray* listArray;
    IBOutlet UITableView* listingTableView;
    MBProgressHUD *hud;
    NSInteger selectedIndex;
    
    
    BOOL apiStaus;
}
@end
