//
//  ContactUsViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestUtil.h"
#import "MBProgressHUD.h"

@interface ContactUsViewController : UIViewController<WebData>
{
    IBOutlet UIImageView *namgeBgImageView;
    IBOutlet UIImageView *emailBgImageView;
    IBOutlet UIImageView *messageBgImageView;
    IBOutlet UITextField *nameTF;
    IBOutlet UITextField *emailTF;
    IBOutlet UITextView  *messageTV;
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UIButton* sendButton;
    MBProgressHUD *hud;

}
@property(nonatomic,retain) NSString* cancellationBookingID;
@end
