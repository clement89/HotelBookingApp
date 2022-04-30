//
//  SignUpViewController.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 23/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import"RequestUtil.h"
@interface SignUpViewController : UIViewController<WebData>
{
    MBProgressHUD *hud;

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
@property (strong, nonatomic) NSString* fromString;
@property (strong, nonatomic) IBOutlet UIButton* countryCode;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthDate;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtNationality;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumer;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;

@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
-(IBAction)countryCodeFunction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@end
