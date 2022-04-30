//
//  NowViewController.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import"RequestUtil.h"
#import "FiltersViewController.h"
#import "SortViewController.h"
@interface NowViewController : UIViewController<WebData,FilterDelegate,SortDelegate>
{
    IBOutlet UILabel* locationLBL;
    IBOutlet UILabel* scheduleLBL;
    IBOutlet UILabel* sortLBL;
    IBOutlet UILabel* filterLBL;
    IBOutlet UILabel* loadingLBL;
    
    IBOutlet UIImageView* listTypeImageView;
    
    IBOutlet UITableView* listingTBV;
    BOOL mapLoadedStayus;
    BOOL listingType;
    NSInteger propertyTag;
    
    MBProgressHUD *hud;
    NSMutableArray* propertyArray;
    NSInteger currentIndexValue;
    RequestUtil *utilObj;
    NSString* listingString;
    BOOL newStatus;
    NSString* minString;
    NSString* maxString;
    BOOL firstTime;
    BOOL tableLoaded;
}
@property(strong,nonatomic)NSMutableArray*  ratingArray;
@property(strong,nonatomic)NSMutableArray*  serviceArray;
@property(strong,nonatomic)NSMutableDictionary* searchDic;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *annotaionVieww;
-(IBAction)whenFunction:(id)sender;
-(IBAction)whereFunction:(id)sender;
-(IBAction)sortFunction:(id)sender;
-(IBAction)filterFunction:(id)sender;
-(IBAction)listTypeFunction:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView* timeBgImageview;
@property (strong, nonatomic) IBOutlet UIImageView* reviewBgImageview;
//////// FOR MAP
@property (strong, nonatomic) IBOutlet UIView* BGView;

@property (strong, nonatomic) IBOutlet UIImageView* whiteImageView;
@property (strong, nonatomic) IBOutlet UIImageView* featuredImageView;
@property (strong, nonatomic) IBOutlet UIButton* favoriteButton;
@property (strong, nonatomic) IBOutlet UIImageView* propertyImageView;

@property (strong, nonatomic) IBOutlet UILabel* discountPriceLBL;
@property (strong, nonatomic) IBOutlet UILabel* priceLBL;
@property (strong, nonatomic) IBOutlet UILabel* hourLBL;
@property (strong, nonatomic) IBOutlet UILabel* propertyNameLBL;
@property (strong, nonatomic) IBOutlet UILabel* propertyLocationLBL;
@property (strong, nonatomic) IBOutlet UILabel* userReviewLBL;
@property (strong, nonatomic) IBOutlet UILabel* userRatingValueLBL;
@property (strong, nonatomic) IBOutlet UIImageView* propertyRatingImageview;



//////





@end

