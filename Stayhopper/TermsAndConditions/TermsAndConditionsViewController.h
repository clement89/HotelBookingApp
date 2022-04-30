//
//  TermsAndConditionsViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAQTableViewCell.h"
#import "MBProgressHUD.h"
#import"RequestUtil.h"
@interface TermsAndConditionsViewController : UIViewController<WebData>
{
    IBOutlet UITextView* termsAndConditions;
    MBProgressHUD *hud;
    NSInteger selectedIndex;
}
@end
