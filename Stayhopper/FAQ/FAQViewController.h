//
//  FAQViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAQTableViewCell.h"
#import "MBProgressHUD.h"
#import"RequestUtil.h"
@interface FAQViewController : UIViewController<WebData>
{
    FAQTableViewCell* cell;
    NSArray* listArray;
    IBOutlet UITableView* listingTableView;
    MBProgressHUD *hud;
    NSInteger selectedIndex;
}

@end
