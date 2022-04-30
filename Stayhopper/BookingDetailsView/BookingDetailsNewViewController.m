//
//  BookingDetailsNewViewController.m
//  Stayhopper
//
//  Created by antony on 18/11/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "BookingDetailsNewViewController.h"
#import "URLConstants.h"
#import <MapKit/MapKit.h>
#import "UIImageView+WebCache.h"
#import "ContactUsViewController.h"
#import "WriteReviewViewController.h"
@interface BookingDetailsNewViewController ()
{
    
    __weak IBOutlet NSLayoutConstraint *constraintBottomCentrer;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintConfContainerHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgHotelImage;
@property (weak, nonatomic) IBOutlet UILabel *lblBookingConfirmationTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBookingId;
@property (weak, nonatomic) IBOutlet UILabel *lblHotelName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblHours;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UIView *viewConfirmationContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblGuestCount;
@property (weak, nonatomic) IBOutlet UIView *viewShadow;
@property (weak, nonatomic) IBOutlet UIButton *btnViewMap;

@end

@implementation BookingDetailsNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblHours.layer.cornerRadius = 5.0;
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _btnCancel.layer.borderColor = kColorDarkBlueThemeColor.CGColor;
    _btnCancel.layer.borderWidth = 1.;
    _btnCancel.layer.cornerRadius = 6.;
    
    
    _lblAddress.superview.layer.cornerRadius = 6.0;
    
//    _lblAddress.font  = [UIFont fontWithName:FontMedium size:_lblAddress.font.pointSize];
//    _lblHotelName.font  = [UIFont fontWithName:FontMedium size:_lblHotelName.font.pointSize];
//    _lblBookingId.font  = [UIFont fontWithName:FontMedium size:_lblBookingId.font.pointSize];
//    _lblBookingConfirmationTitle.font  = [UIFont fontWithName:FontMedium size:_lblBookingConfirmationTitle.font.pointSize];
//    _lblAddress.font  = [UIFont fontWithName:FontRegular size:_lblAddress.font.pointSize];

    /*
     @property(nonatomic,retain) NSString *bookingID;
     @property(nonatomic,retain) NSString *hotelName;
     @property(nonatomic,retain) NSString *hotelAddress;
     @property(nonatomic,retain) NSString *guestCount;
     @property(nonatomic,retain) NSString *timeString;
     @property(nonatomic,retain) NSString *latitude;
     @property(nonatomic,retain) NSString *longitude;
     @property(nonatomic,retain) NSString *imageURL;
     @property(nonatomic,assign) BOOL isPastBookingOrCancelled;

*/
    _imgHotelImage.image = [UIImage imageNamed:@"QOMPlaceholder1"];
    if (_imageURL.length>0) {
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,_imageURL]];

         [_imgHotelImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];

    }
    if ([NSString stringWithFormat:@"%@",_latitude].length>0&&[NSString stringWithFormat:@"%@",_longitude].length>0) {
            // plot map
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([_latitude floatValue], [_longitude floatValue]);

        MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
        MKCoordinateRegion region = {coord, span};

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = _hotelName;
        
        [annotation setCoordinate:coord];
//        region.center = self.mapView.userLocation.coordinate;

        [self.mapView setRegion:region];
        [self.mapView addAnnotation:annotation];
        
        
        
//        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//        CLLocationCoordinate2D centerCoordinate =CLLocationCoordinate2DMake([_latitude floatValue], [_longitude floatValue]);
//        [annotation setCoordinate:centerCoordinate];
//        [annotation setTitle:@""]; //You can set the subtitle too
//        [self.mapView addAnnotation:annotation];

        
    }


    _lblAddress.text = _hotelAddress;
    _lblHotelName.text = _hotelName;
    _lblBookingId.text = _bookingID;
    _lblTitle.text  =_bookingID;
    _lblDateTime.text = _timeString;
    _lblGuestCount.text = _guestCount;
    if (_hoursString) {
        _lblHours.text = _hoursString;
        if (self.lblHours.text.length>0)
        {
                   NSString *hrlbl = self.lblHours.text;
                   hrlbl = [NSString stringWithFormat:@".  %@  .",hrlbl];
                   NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FontMedium size:12]}];
        
                   [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
                   [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
                    self.lblHours.attributedText = attr;
                    self.lblHours.backgroundColor = UIColorFromRGB(0xFF4848);
                   
               }
        
    }
    else{
        _lblHours.hidden = TRUE;
    }
  
    //guestCount
    
    if (_isPastBookingOrCancelled) {
        _btnCancel.hidden = TRUE;
        [_btnViewMap setTitle:@"WRITE REVIEW" forState:UIControlStateNormal];
         constraintBottomCentrer.constant = -1*([UIScreen mainScreen].bounds.size.width/2 - 20 -10);
    }
    if (_isForCompletion) {
        _lblTitle.text = @"Payment Completed";
        _constraintConfContainerHeight.constant = 115;
        _viewConfirmationContainer.hidden = FALSE;
    }
    _lblHotelName.superview.clipsToBounds = TRUE;
    _lblHotelName.superview.layer.masksToBounds = TRUE;
    _lblHotelName.superview.layer.cornerRadius = 10.;
    _viewShadow.backgroundColor = [UIColor whiteColor];
    _viewShadow.clipsToBounds = TRUE;
    _viewShadow.layer.masksToBounds = FALSE;

    _viewShadow.layer.cornerRadius =  _lblHotelName.superview.layer.cornerRadius;
    _viewShadow.layer.shadowOffset = CGSizeMake(0, 2);
    _viewShadow.layer.shadowOpacity = 0.3;
    _viewShadow.layer.shadowRadius = 2.0;
    _viewShadow.layer.shadowColor = [UIColor grayColor].CGColor;
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}
- (IBAction)backBtnPressed:(id)sender {
    if (_isForCompletion) {
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
    else
    {
    [self.navigationController popViewControllerAnimated:TRUE];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelBookingAction:(id)sender {
    ContactUsViewController *cus =   [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    cus.cancellationBookingID = _bookingID;
    [self.navigationController pushViewController:cus animated:TRUE];
}

- (IBAction)viewOnMapAction:(id)sender {
    if (_isPastBookingOrCancelled) {
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
            
            WriteReviewViewController *vc = [y   instantiateViewControllerWithIdentifier:@"WriteReviewViewController"];
            vc.propertyID=_propertyId;
            vc.propertyName=_hotelName;
            vc.bookingID = _bookingID;
            vc.ub_id = _ub_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    if ([NSString stringWithFormat:@"%@",_latitude].length>0&&[NSString stringWithFormat:@"%@",_longitude].length>0) {
            // plot map
        ///saddr=%f,%f&
        NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f", [_latitude floatValue],[_longitude floatValue]];
     //   NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", self.mapView.userLocation.coordinate.longitude, self.mapView.userLocation.coordinate.longitude, [_latitude floatValue],[_longitude floatValue]];


        
//        NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f",[_latitude floatValue], [_longitude floatValue]];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:@{} completionHandler:^(BOOL success) {}];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL]];
        }
        
    }
    
}
@end
