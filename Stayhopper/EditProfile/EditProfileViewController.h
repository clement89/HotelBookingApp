//
//  EditProfileViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 23/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestUtil.h"
#import "MBProgressHUD.h"
@interface EditProfileViewController : UIViewController<WebData,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    IBOutlet UIScrollView* bgScrollView;
    
    IBOutlet UITextField* firstNameTF;
    IBOutlet UITextField* lastNameTF;
    IBOutlet UITextField* countryTF;
    IBOutlet UITextField* emailTF;

    IBOutlet UITextField* mobileNumberTF;
    IBOutlet UITextField* cityNameTF;
    IBOutlet UIImageView* profilePic;
    IBOutlet UIView *doneView;
    IBOutlet UIPickerView *pickerVieww;

    
   IBOutlet UIView* passwordView;
    
    IBOutlet UITextField* oldPasswordTF;;
    IBOutlet UITextField* newPasswordTF;;
    
    
    IBOutlet UIButton* passwordButton;
    IBOutlet UIButton* profileButton;
    
    UIImagePickerController *imagePickerController;
    NSData *imageData;

    MBProgressHUD *hud;
    NSString* cCode;
    IBOutlet UIButton* countryCodeBTN;
    BOOL apiStatus;

    BOOL ststusCountry;
 }
@property (strong, nonatomic) IBOutlet UIButton* countryCode;

-(IBAction)countryCodeFunction:(id)sender;

-(IBAction)saveProfileFunction:(id)sender;
-(IBAction)savePasswordFunction:(id)sender;
-(IBAction)backFunction:(id)sender;
-(IBAction)countryCodeFunction:(id)sender;
@end
