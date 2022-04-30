//
//  BookingDetailsViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 13/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>
#import "ServicesCollectionViewCell.h"

#import"RequestUtil.h"
#import "HomeCollectionViewCell.h"
#import "TypeCollectionViewCell.h"
#import "RoomsListViewController.h"
#import "AboutPropertyViewController.h"
#import "ServicesCollectionViewCell.h"

@import GoogleMaps;

@interface SingleRoomViewController : UIViewController<WebData>
{
    GMSMapView* mapView;
    
    
    IBOutlet UITextField* firstNameTF;
    IBOutlet UITextField* lastNameTF;
    IBOutlet UITextField* cityNameTF;
    IBOutlet UITextField* mobileTF;
    IBOutlet UITextField* emailTF;
    
    
    IBOutlet UIScrollView* bgScrollView;
    IBOutlet UIScrollView*menuListingScrollview;
    IBOutlet UIButton* favoriteButton;

    IBOutlet UIButton* bookButton;
    IBOutlet UIImageView* bottomImageView;

    IBOutlet UIView* topView;
    IBOutlet UILabel* countLBL;
    IBOutlet UILabel* userReviewLBL;
    IBOutlet UILabel* userReviewValueLBL;
    IBOutlet UIImageView* ratingImageView;
    IBOutlet UICollectionView* imageCollectionView;
    IBOutlet UICollectionView* servicesCollectionView;

    IBOutlet UILabel* roomNameLBL;
    IBOutlet UILabel* guestRoomsLBL;
    IBOutlet UILabel* bedLBL;
    IBOutlet UILabel* roomsizeLBL;
    IBOutlet UILabel* numberofRoomsLBL;
    
    IBOutlet UILabel *priceLBL;
    IBOutlet UILabel *sloatBL;

    IBOutlet UIView* BGVIEW;
   
   IBOutlet UIImageView* bedTypeImageView;

    
    
    NSMutableArray *imageArray;
    NSMutableArray *serviceArray;

    TypeCollectionViewCell*typeCell;
    HomeCollectionViewCell*homeCell;
    NSInteger clickedIndex;
    MBProgressHUD *hud;
    RequestUtil *utilObj;
    
    IBOutlet UIScrollView *scrollView;
    
    ServicesCollectionViewCell* serviceCell;
    
    float totalPrice;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuDetailsScrollViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topScrollViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgWidth;
@property (strong, nonatomic) NSDictionary* selectedRoomDic;
@property (strong, nonatomic) NSDictionary* loadedProperty;
@property (strong, nonatomic) NSDictionary* selectedProperty;

@property (strong, nonatomic) NSMutableArray* selectedIDS;
@property (strong, nonatomic) NSMutableArray* roomsArrayTemp;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgLeading;
@property (strong, nonatomic) NSString* selectionString;
@property (strong, nonatomic) NSString* distanceString;
@property (strong, nonatomic) NSString* roomTypeString;
@property (strong, nonatomic) NSString* roomNumberString;

@property (strong, nonatomic) NSString* roomString;

@property (strong, nonatomic) NSString* dateString;

-(IBAction)backFunction:(id)sender;





@property (strong, nonatomic) IBOutlet UIView *couponView;


@end


