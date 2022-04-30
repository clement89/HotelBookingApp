//
//  ListHotelsViewController.h
//  Stayhopper
//
//  Created by iROID Technologies on 08/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MBProgressHUD.h"
#import"RequestUtil.h"
#import "FiltersViewController.h"
#import "SortViewController.h"
@interface ListHotelsViewController : UIViewController<WebData,FilterDelegate,SortDelegate>
{

    IBOutlet UILabel* scheduleLBL;
    IBOutlet UILabel* sortLBL;
    IBOutlet UILabel* filterLBL;
    IBOutlet UILabel* loadingLBL;

    IBOutlet UIImageView* listTypeImageView;

    IBOutlet UITableView* listingTBV;
    BOOL mapLoadedStayus;
    BOOL listingType;
    NSInteger propertyTag;
    NSInteger currentIndexValue;
    RequestUtil *utilObj;

    MBProgressHUD *hud;
    NSMutableArray* propertyArray;
    NSString* listingString;
    
    NSString* minString;
    NSString* maxString;
    BOOL firstTime;
    
    
    NSString* sortString;

    
    NSString* originalAPI;
    BOOL tableLoaded;


}
@property(strong,nonatomic)NSMutableArray*  ratingArray;
@property(strong,nonatomic)NSMutableArray*  serviceArray;
@property(strong,nonatomic)NSDate* checkinDateSelected;
@property(strong,nonatomic)NSDate* checkoutDateSelected;
 
@property(assign,nonatomic)BOOL isHourly;

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
@property (strong, nonatomic) NSString* selectionString;



//////





@end
