//
//  PropertyDetailsViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 12/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import"RequestUtil.h"
#import "HomeCollectionViewCell.h"
#import "TypeCollectionViewCell.h"
#import "RoomsListViewController.h"
#import "AboutPropertyViewController.h"
@interface PropertyDetailsViewController : UIViewController<WebData>
{
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
    IBOutlet UILabel* propertyNameLBL;
    IBOutlet UILabel* adultsAndRoomsLBL;
    IBOutlet UILabel* ditanceLBL;
    IBOutlet UILabel*sloatDateLBL;
    IBOutlet UICollectionView* menuCollectionView;
    IBOutlet UIImageView *menuImageView;
    IBOutlet UIScrollView* menuDetailsScrolView;
    IBOutlet UIView* navigationView;
    
    
    NSMutableArray* menueArray;
    NSMutableArray *imageArray;
    TypeCollectionViewCell*typeCell;
    HomeCollectionViewCell*homeCell;
    NSInteger clickedIndex;
    MBProgressHUD *hud;
    RequestUtil *utilObj;
    NSMutableArray* roomsArray;
    BOOL pushStatus;
    NSMutableArray* roomsArrayTemp;

}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *navigationTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuDetailsScrollViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topScrollViewTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgWidth;
@property (strong, nonatomic) NSDictionary* selectedProperty;
//@property (strong, nonatomic) NSDictionary* loadedProperty;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slideImgLeading;
@property (strong, nonatomic) NSString* selectionString;
@property (strong, nonatomic) NSString* pastString;
@property (strong, nonatomic) NSString* property_id;
@property (strong, nonatomic) NSString* cityname;

@property(strong,nonatomic)NSDate* checkinDateSelected;
@property(strong,nonatomic)NSDate* checkoutDateSelected;
 

@property (strong, nonatomic) NSMutableAttributedString* attributedTitle;

@property (strong, nonatomic) NSDictionary* selectedDetails;

-(IBAction)backFunction:(id)sender;
-(IBAction)shareFunction:(id)sender;
-(IBAction)favoriteFunction:(UIButton*)sender;
-(IBAction)bookNowFunction:(UIButton*)sender;

@end
