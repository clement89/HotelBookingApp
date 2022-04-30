//
//  InitialViewController.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 23/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MBProgressHUD.h"
#import"RequestUtil.h"
@interface InitialViewController : UIViewController<WebData>
{
    
    IBOutlet UIView *fb_View;
    IBOutlet UIView *sign_up_View;
    IBOutlet UIView *lower_view;
    MBProgressHUD *hud;

    NSArray* imageArray;
    NSArray* titleArray;
    NSArray* descriptionArray;
    
    IBOutlet UILabel* guestLBL;
    IBOutlet UIButton* skipButtopn;
    FBSDKLoginButton *connectButtopn;

    
}
- (IBAction)signUpAction:(id)sender;
- (IBAction)connectAction:(id)sender;
- (IBAction)skipAction:(id)sender;
- (IBAction)signInAction:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *signUp;
@property (strong, nonatomic) IBOutlet UIButton *connect;
@property (strong, nonatomic) IBOutlet UIButton *skip;
@property (strong, nonatomic) NSString* fromString;

@end
