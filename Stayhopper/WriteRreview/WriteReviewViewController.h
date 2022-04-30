//
//  WriteReviewViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 19/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestUtil.h"
#import "MBProgressHUD.h"
@interface WriteReviewViewController : UIViewController<WebData>
{
    IBOutlet UITextView* commentTV;
    IBOutlet UIView* ratingView;
    IBOutlet UIView* ratingSubView;
    IBOutlet UILabel* ratingLBL;
    IBOutlet UIButton *Button1;
    MBProgressHUD *hud;

    IBOutlet UIButton *Button2;
    IBOutlet UIButton *Button3;
    IBOutlet UIButton *Button4;
    IBOutlet UIButton *Button5;
    IBOutlet UIButton *Button6;
    IBOutlet UIButton *Button7;
    IBOutlet UIButton *Button8;
    IBOutlet UIButton *Button9;
    IBOutlet UIButton *Button10;
    NSInteger selectedValue;
    IBOutlet UIButton *submitButton;

}
@property (strong, nonatomic) IBOutlet UISlider *slider1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonwidth;

@property(nonatomic,retain)NSString *propertyName;
@property(nonatomic,retain)NSString *propertyID;
@property(nonatomic,retain)NSString *bookingID;
@property(nonatomic,retain)NSString *ub_id;

-(IBAction)submitAction:(id)sender;
-(IBAction)buttonCliak:(UIButton*)sender;
@end
