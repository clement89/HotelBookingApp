//
//  BookingDetailsViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 13/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>

#import"RequestUtil.h"
#import "HomeCollectionViewCell.h"
#import "TypeCollectionViewCell.h"
#import "RoomsListViewController.h"
#import "AboutPropertyViewController.h"
@import GoogleMaps;

@interface BookingDetailsViewController : UIViewController<WebData>
{
    GMSMapView* mapView;

    
    IBOutlet UITextField* firstNameTF;
    IBOutlet UITextField* lastNameTF;
    IBOutlet UITextField* cityNameTF;
    IBOutlet UITextField* mobileTF;
    IBOutlet UITextField* emailTF;
    IBOutlet UIImageView* dirImageView;
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
    NSDateFormatter* timePicker;

    IBOutlet UILabel* totalTariffLBL;
    IBOutlet UILabel* taxLBL;
    IBOutlet UILabel* grandTotalLBL;
    
    
    
    NSMutableArray *imageArray;
    TypeCollectionViewCell*typeCell;
    HomeCollectionViewCell*homeCell;
    NSInteger clickedIndex;
    MBProgressHUD *hud;
    RequestUtil *utilObj;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIPickerView *pickerVieww;
    IBOutlet UIView *fieldView;
    
    IBOutlet UITextField *nationalityTextfd;
    IBOutlet UIButton *titleBtn;
    IBOutlet UIView *customMapView;
    
    IBOutlet UIButton *businessBtn;
    IBOutlet UIButton *individualBtn;
    IBOutlet UIButton *rulesBtn;
    IBOutlet UIButton *termsBtn;
    NSString* typeValue;
   IBOutlet UILabel* bookingIDLBL;

    float totalPrice;
}
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
- (IBAction)directionClick:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *availabilityButtonWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollTop;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationTop;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuDetailsScrollViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topScrollViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgWidth;
@property (strong, nonatomic) NSDictionary* selectedProperty;
@property (strong, nonatomic) NSDictionary* loadedProperty;
@property (strong, nonatomic) NSMutableArray* selectedIDS;

@property (strong, nonatomic) IBOutlet UILabel* cancelLBL;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgLeading;
@property (strong, nonatomic) NSString* selectionString;
@property (strong, nonatomic) NSString* distanceString;
@property (strong, nonatomic) NSString* roomString;
@property (strong, nonatomic) NSString* dateString;
@property (strong, nonatomic) NSString* bookingIDVAl;
@property (strong, nonatomic) NSString* cancelVAL;


-(IBAction)backFunction:(id)sender;
-(IBAction)shareFunction:(id)sender;
-(IBAction)checkFunction:(UIButton*)sender;
-(IBAction)favoriteFunction:(UIButton*)sender;
-(IBAction)payNowFunction:(UIButton*)sender;




@property (strong, nonatomic) IBOutlet UIView *couponView;


@end

