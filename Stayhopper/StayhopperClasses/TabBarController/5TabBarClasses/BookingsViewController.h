//
//  BookingsViewController.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import"RequestUtil.h"
@interface BookingsViewController : UIViewController<WebData>
{
    IBOutlet UIButton *pastBtn;
    IBOutlet UIButton *cuurentBtn;
    
    NSMutableArray* currentBookingArray;
    NSMutableArray* pastBookingArray;
    MBProgressHUD *hud;
    
    RequestUtil *utilObj;

    IBOutlet UITableView* listingTableView;
    NSString * selectedIndex;
    NSDateFormatter* timePicker;
    
    
    BOOL alredyLoaded;
    BOOL alredyCALLED;

}
- (IBAction)currentBtnClick:(id)sender;
- (IBAction)pastBtnClick:(id)sender;
@end
