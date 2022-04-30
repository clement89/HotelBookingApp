//
//  ForgotpasswordViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 19/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestUtil.h"
#import "MBProgressHUD.h"
@interface ForgotpasswordViewController : UIViewController<WebData>
{
    IBOutlet UITextField* emailTF;
    IBOutlet UIButton* sendButton;
    MBProgressHUD *hud;
    IBOutlet UIImageView* bgImage;

    
}
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
-(IBAction)sendFunction:(id)sender;
@end
