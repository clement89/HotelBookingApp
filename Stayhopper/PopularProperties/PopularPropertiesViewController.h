//
//  PopularPropertiesViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 14/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import"RequestUtil.h"
@interface PopularPropertiesViewController : UIViewController<WebData>
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
    RequestUtil *utilObj;

    MBProgressHUD *hud;
    NSMutableArray* propertyArray;
    NSInteger currentIndexValue;

}
@property (strong, nonatomic)  NSArray *popularPropertiesArray;
@property (assign, nonatomic)  BOOL isCheapest;


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *annotaionVieww;
-(IBAction)whenFunction:(id)sender;
-(IBAction)whereFunction:(id)sender;
-(IBAction)sortFunction:(id)sender;
-(IBAction)filterFunction:(id)sender;
-(IBAction)listTypeFunction:(id)sender;



////

@property (strong, nonatomic) IBOutlet UIImageView* timeBgImageview;
@property (strong, nonatomic) IBOutlet UIImageView* reviewBgImageview;
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


////

@end

