//
//  ReebookingViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 29/11/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"
#import"RequestUtil.h"
#import "HomeCollectionViewCell.h"
#import "TypeCollectionViewCell.h"
#import "RoomsListViewController.h"
#import "AboutPropertyViewController.h"
@interface ReebookingViewController : UIViewController<WebData>
{
    
    
    IBOutlet UITextField* firstNameTF;
    IBOutlet UITextField* lastNameTF;
    IBOutlet UITextField* cityNameTF;
    IBOutlet UITextField* mobileTF;
    IBOutlet UITextField* emailTF;
    IBOutlet UITextField* couponTF;
    
    NSMutableDictionary *reqData;
    IBOutlet UIScrollView* bgScrollView;
    IBOutlet UIScrollView*menuListingScrollview;
    IBOutlet UIButton* favoriteButton;
    IBOutlet UIButton* bookButton;
    IBOutlet UIView* topView;
    IBOutlet UILabel* countLBL;
    IBOutlet UILabel* userReviewLBL;
    IBOutlet UILabel* userReviewValueLBL;
    IBOutlet UIImageView* ratingImageView;
    IBOutlet UICollectionView* imageCollectionView;
    IBOutlet UILabel* propertyNameLBL;
    IBOutlet UILabel* adultsAndRoomsLBL;
    IBOutlet UILabel* ditanceLBL;
    IBOutlet UILabel*sloatDateLBL;
    IBOutlet UICollectionView* menuCollectionView;
    IBOutlet UIImageView *menuImageView;
    IBOutlet UIScrollView* menuDetailsScrolView;
    NSArray* menueArray;
    IBOutlet UILabel* dayLBL;
    IBOutlet UILabel* chekinTimeLBL;
    IBOutlet UILabel* packofhoursLBL;
    IBOutlet UILabel* roomsLBL;
    
    IBOutlet UIView* promotionView;
    IBOutlet UITextField* promotionCodeTF;
    
    
    IBOutlet UILabel* totalTariffLBL;
    IBOutlet UILabel* taxLBL;
    IBOutlet UILabel* grandTotalLBL;
    
    IBOutlet UILabel* bookingFeeLBL;
    IBOutlet UILabel* payathotelLBL;
    IBOutlet UILabel* nowPayLBL;
    IBOutlet UILabel* taxTextLBL;

    
    NSMutableArray *imageArray;
    TypeCollectionViewCell*typeCell;
    HomeCollectionViewCell*homeCell;
    NSInteger clickedIndex;
    MBProgressHUD *hud;
    RequestUtil *utilObj;
    IBOutlet UILabel* discountPercentageLBL;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIPickerView *pickerVieww;
    IBOutlet UIView *fieldView;
    
    IBOutlet UITextField *nationalityTextfd;
    IBOutlet UIButton *titleBtn;
    IBOutlet UIView *doneView;
    
    IBOutlet UIButton *businessBtn;
    IBOutlet UIButton *individualBtn;
    IBOutlet UIButton *rulesBtn;
    IBOutlet UIButton *termsBtn;
    NSString* typeValue;
    NSString* cleaningSloat;
    
    float totalPrice;
    float promoDiscount;
    float taxAmount;
    
    BOOL promoStatus;
    NSString* cCode;
    
    BOOL apiStatus;
}

@property(nonatomic,retain)NSString* rooCount;
@property(nonatomic,retain)NSString* proName;;
@property(nonatomic,retain)NSString* totPrice;
@property(nonatomic,retain)NSString* paid;
@property(nonatomic,retain)NSString* balance;
@property(nonatomic,retain)NSString* bookingIDVAl;


- (IBAction)done:(id)sender;
- (IBAction)lastnameEditEnd:(id)sender;
- (IBAction)lastnameEditBegin:(id)sender;
- (IBAction)selectTitle:(id)sender;
- (IBAction)selectNationality:(id)sender;
- (IBAction)emailEditEnd:(id)sender;
- (IBAction)emailEditBegin:(id)sender;
- (IBAction)mobileEditEnd:(id)sender;
- (IBAction)mobileEditBegin:(id)sender;
- (IBAction)cityEditEnd:(id)sender;
- (IBAction)cityEditBegin:(id)sender;
- (IBAction)firstNameEditBegin:(id)sender;
- (IBAction)firstNameEditEnd:(id)sender;
- (IBAction)applayPromocode:(id)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationTop;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuDetailsScrollViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topScrollViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgWidth;
@property (strong, nonatomic) NSDictionary* selectedProperty;
@property (strong, nonatomic) NSDictionary* loadedProperty;
@property (strong, nonatomic) NSMutableArray* selectedIDS;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgLeading;
@property (strong, nonatomic) NSString* selectionString;

-(IBAction)backFunction:(id)sender;
-(IBAction)shareFunction:(id)sender;
-(IBAction)checkFunction:(UIButton*)sender;
-(IBAction)favoriteFunction:(UIButton*)sender;
-(IBAction)payNowFunction:(UIButton*)sender;
-(IBAction)editFunction:(UIButton*)sender;




@property (strong, nonatomic) IBOutlet UIView *couponView;


@end
