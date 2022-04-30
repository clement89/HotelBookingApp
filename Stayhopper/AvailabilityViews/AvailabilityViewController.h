//
//  AvailabilityViewController.h
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import"RequestUtil.h"
@import GooglePlaces;
@import GooglePlacePicker;
@import GoogleMaps;
@interface AvailabilityViewController : UIViewController<GMSAutocompleteViewControllerDelegate,CLLocationManagerDelegate,WebData>
{
    MBProgressHUD *hud;
    NSMutableArray* cityArray;
    NSMutableArray* nearByArray;
    NSMutableArray* popularByArray;
    IBOutlet UILabel* loadingLBL;
    NSInteger propertyTag;
    BOOL apiStatus;
    
    IBOutlet UIView* locationView;
    IBOutlet UIImageView* locationPic;
    IBOutlet UILabel* locationName;
    IBOutlet UILabel* selectedDateLBL;
    IBOutlet UILabel* propertyNameLBL;

}
@property(strong,nonatomic)NSDictionary* locationDic;
@property(strong,nonatomic)NSArray* timeSloatArray;
@property (strong, nonatomic) IBOutlet UICollectionView *slotCollection;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *containerViewOfScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view1Ht;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view2Ht;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view3Ht;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view4Ht;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerViewOfScrollViewHt;
@property (strong, nonatomic) IBOutlet UICollectionView *calenderCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *optionsCollection;
- (IBAction)searchHotelAction:(id)sender;
- (IBAction)seeOtherDatesAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *searchHotel;
@property (strong, nonatomic) IBOutlet UIButton *seeOtherDates;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *optionsViewHt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *optionsContainerHt;
- (IBAction)roomsOptionsAction:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *popularCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *bestPropertiesCollection;
@property (strong, nonatomic) IBOutlet UIView *placeSelectionView;
@property (strong, nonatomic) IBOutlet UIImageView *redDot;
@property (strong, nonatomic) IBOutlet UITextField *placeTxt;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)timePickAction:(id)sender;
- (IBAction)pickAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *pickTime;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *weatherLbl;
@property (strong, nonatomic) IBOutlet UILabel *roomsAndPersonsLbl;
@property (strong, nonatomic)NSString* pastVal;
@property (strong, nonatomic) IBOutlet UILabel *amPmLbl;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *annotaionVieww;

@end

