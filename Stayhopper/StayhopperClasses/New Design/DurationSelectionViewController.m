//
//  DurationSelectionViewController.m
//  Stayhopper
//
//  Created by antony on 11/08/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "DurationSelectionViewController.h"
#import "StayDateTimeViewController.h"
#import "URLConstants.h"
@interface DurationSelectionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;


@end

@implementation DurationSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
    _lblTitle.superview.layer.shadowOpacity = 0.3;
    _lblTitle.superview.layer.shadowRadius = 2.0;
    _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    self.view.backgroundColor = kColorProfilePages;

    

    
    // Do any additional setup after loading the view.
}
- (IBAction)backBtnClikd:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)hourlyButtonSelected:(id)sender {
    [self gotStayDateTimeViewController:FALSE];
}
- (IBAction)monthlyButtonSelected:(id)sender {
    [self gotStayDateTimeViewController:TRUE];

}
-(void)gotStayDateTimeViewController:(BOOL)isMonthly
{
    StayDateTimeViewController *sd =[self.storyboard instantiateViewControllerWithIdentifier:@"StayDateTimeViewController"];
    sd.placeName = _placeName;
    sd.latitude = _latitude;
    sd.longitude = _longitude;
    sd.formattedAddress = _formattedAddress;
    sd.isMonthlySelected = isMonthly;
    sd.cityIdString =_cityIdString;
    sd.selectionString = _selectionString;
    sd.isHotelSelected = _isHotelSelected;
    sd.selectedHotel = _selectedHotel;
    [self.navigationController pushViewController:sd animated:TRUE];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
