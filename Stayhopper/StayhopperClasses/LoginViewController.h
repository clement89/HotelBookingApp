//
//  LoginViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 14/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import"RequestUtil.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController : UIViewController<WebData>
{
    MBProgressHUD *hud;
    FBSDKLoginButton *connectButtopn;
    IBOutlet UIButton* connectButtonBTN;


}

- (IBAction)backAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *topImg;
@property (strong, nonatomic) IBOutlet UIImageView *stayhopperImg;
@property (strong, nonatomic) IBOutlet UIView *signUpView;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)signUpAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *signUp;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *containerViewOfScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerViewOfScrollViewHt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *signUpViewHt;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSString* fromString;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginActionn;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;


@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *dummyView;



@end
