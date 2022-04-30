//
//  SelectGuestsViewController.m
//  Stayhopper
//
//  Created by antony on 12/08/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "SelectGuestsViewController.h"
#import "ListHotelsViewController.h"
#import "Commons.h"
#import "SinglePropertyDetailsViewController.h"
#import "PropertyDetailsViewController.h"
#import "URLConstants.h"
@import Firebase;



@interface SelectGuestsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAdults;
@property (weak, nonatomic) IBOutlet UILabel *lblRooms;
@property (weak, nonatomic) IBOutlet UILabel *lblChildren;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@end

@implementation SelectGuestsViewController

 
- (void)viewDidLoad {
    [super viewDidLoad];
    
        _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
       _lblTitle.superview.layer.shadowOpacity = 0.3;
       _lblTitle.superview.layer.shadowRadius = 2.0;
       _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
       _btnNext.enabled = FALSE;
    _btnNext.clipsToBounds = TRUE;
    _btnNext.layer.cornerRadius = 5.;
    
    [_btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorProfilePages;
    _lblAdults.text = @"2";
    _lblRooms.text = @"1";
    _btnNext.enabled = TRUE;


}
- (IBAction)backBtnClikd:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)nextButtonAction:(id)sender {
    /*{
        "checkin_date" = "2020-08-13";
        "checkin_time" = "01:30";
        location = "37.774929,-122.419415";
        "number_adults" = 2;
        "number_childs" = 0;
        "number_rooms" = 1;
        "selected_hours" = 3;
    }
     */
    
    NSTimeInterval distanceBetweenDates = [self.endTime timeIntervalSinceDate:self.startTime];
    double secondsInAnHour = 3600.;
    float hoursBetweenDates = (float)distanceBetweenDates / (float)secondsInAnHour;
    NSLog(@"self.endTime %@ self.startTime %@ hoursBetweenDates %.1f",self.endTime,self.startTime,hoursBetweenDates);

    [[NSUserDefaults standardUserDefaults] setObject:_lblChildren.text forKey:@"selectedChild"];
    [[NSUserDefaults standardUserDefaults] setObject:_lblAdults.text forKey:@"selectedAdults"];
    [[NSUserDefaults standardUserDefaults] setObject:_lblRooms.text forKey:@"selectedRooms"];
    [[NSUserDefaults standardUserDefaults] setObject:[Commons stringFromDate:_startTime Format:@"hh:mm"] forKey:@"selectedTime"];

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.1f",hoursBetweenDates] forKey:@"selectedSloat"];
    [[NSUserDefaults standardUserDefaults] setObject:_latitude forKey:@"pickupLat"];
    [[NSUserDefaults standardUserDefaults] setObject:_longitude forKey:@"pickupLongt"];
    [[NSUserDefaults standardUserDefaults] setObject:_placeName forKey:@"pickupLocationName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_isHotelSelected)
    {
        NSString* loadingString;
        loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],_selectedHotel[@"_id"]];
        
        PropertyDetailsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
            vc.selectedProperty=_selectedHotel;
        vc.checkinDateSelected =_startTime;
        vc.checkoutDateSelected =_endTime;
        vc.cityname = _placeName;
            vc.selectionString=loadingString;
        NSString *type= @"";
        
        
        if (_isMonthlySelected) {
            type = @"monthly";
            
            //CJC 14
            [FIRAnalytics logEventWithName:@"monthly_selection"
                                parameters:@{
                                             @"selection": @"monthly"
                                             }];
            
 
        }
        else
        {
            //CJC 14
            type = @"hourly";
            [FIRAnalytics logEventWithName:@"hourly_selection"
                                parameters:@{
                                             @"selection": @"hourly"
                                             }];
 
        }
        vc.selectedDetails = @{@"property_id":_selectedHotel[@"_id"],
                               @"checkinDate":[Commons stringFromDate:_startTime Format:@"dd/MM/yyyy"],
                               @"checkinTime":[Commons stringFromDate:_startTime Format:@"HH:mm"],
                               @"checkoutDate":[Commons stringFromDate:_endTime Format:@"dd/MM/yyyy"],
                               @"checkoutTime":[Commons stringFromDate:_endTime Format:@"HH:mm"],
                               @"numberRooms":_lblRooms.text,
                               @"numberChildren":_lblChildren.text,

                               @"numberAdults":_lblAdults.text,
                               @"bookingType":type
        };
        
        [self.navigationController pushViewController:vc animated:YES];

        
        
//        SinglePropertyDetailsViewController *vc = [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil]   instantiateViewControllerWithIdentifier:@"SinglePropertyDetailsViewController"];
//              vc.selectedProperty=_selectedHotel;
//              vc.selectionString=loadingString;
//              [self.navigationController pushViewController:vc animated:YES];


    }
    else{
            NSMutableDictionary *reqData = [NSMutableDictionary dictionary];

                UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
                 ListHotelsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"ListHotelsViewController"];
        
                if ([self.selectionString isKindOfClass:[NSString class]]&&self.selectionString.length>0)
                    {
                         vc.selectionString=self.selectionString;
                        if (_cityIdString) {
                             [reqData setObject:_cityIdString forKey:@"city"];

                        }

                    }
                    else
                    {
                        vc.selectionString=@"Search";
#ifndef DEBUG
                        NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLat"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLongt"]];
               [reqData setObject:locationString forKey:@"location"];

#endif

                               


                    }
        
        [reqData setObject:_lblRooms.text forKey:@"numberRooms"];
        [reqData setObject:_lblAdults.text forKey:@"numberAdults"];
        [reqData setObject:_lblChildren.text forKey:@"numberChildren"];
        vc.isHourly = !_isMonthlySelected;

        if (_isMonthlySelected) {
            [reqData setObject:@"monthly" forKey:@"bookingType"];

        }
        else
        {
            [reqData setObject:@"hourly" forKey:@"bookingType"];

        }
        [reqData setObject:[Commons stringFromDate:_endTime Format:@"HH:mm"] forKey:@"checkoutTime"];
        [reqData setObject:[Commons stringFromDate:_endTime Format:@"dd/MM/yyyy"] forKey:@"checkoutDate"];
       
        [reqData setObject:[Commons stringFromDate:_startTime Format:@"HH:mm"] forKey:@"checkinTime"];
        [reqData setObject:[Commons stringFromDate:_startTime Format:@"dd/MM/yyyy"] forKey:@"checkinDate"];

        if (_latitude) {
            [reqData setObject:[NSString stringWithFormat:@"%@,%@",_latitude,_longitude] forKey:@"location"];

        }

        vc.checkinDateSelected =_startTime;
        vc.checkoutDateSelected =_endTime;
        
        /*
         vc.selectedDetails = @{@"property_id":_selectedHotel[@"_id"],
         @"checkinDate":[Commons stringFromDate:_startTime Format:@"dd/MM/yyyy"],
         @"checkinTime":[Commons stringFromDate:_startTime Format:@"HH:mm"],
         @"checkoutDate":[Commons stringFromDate:_endTime Format:@"dd/MM/yyyy"],
         @"checkoutTime":[Commons stringFromDate:_endTime Format:@"HH:mm"],
         @"numberRooms":_lblRooms.text,
         @"numberChildren":_lblChildren.text,

         @"numberAdults":_lblAdults.text,
         @"bookingType":type
};
         */

        //FIXME:number_childs
             //    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
       
           /*
                 [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
                 [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
                 [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkoutTime"];
            */
        // [reqData setObject:@"1" forKey:@"sort_rating"];

                // &sort_rating=1
                 vc.searchDic=reqData;
        
        NSLog(@"reqData %@",reqData);
                 [self.navigationController pushViewController:vc animated:YES];

    }
    
}

- (IBAction)plusBtnClikd:(UIButton*)sender {
    [self addValuesToLabel:[sender.superview viewWithTag:-2] withValue:1];

}
- (IBAction)minusBtnClikd:(UIButton*)sender {
    [self addValuesToLabel:[sender.superview viewWithTag:-2] withValue:-1];
}
-(void)addValuesToLabel:(UILabel*)lbl withValue:(int)val
{
    int curVal = [lbl.text intValue];
    curVal = curVal+val;
    if (curVal<0) {
        curVal = 0;
    }
    if (curVal>8) {
        return;
    }
    if (lbl==_lblRooms &&curVal>4) {
        return;
    }
    lbl.text = [NSString stringWithFormat:@"%d",curVal];
    if ([_lblRooms.text intValue]>[_lblAdults.text intValue]) {
        _lblAdults.text = _lblRooms.text;
    }
    if ([_lblAdults.text intValue]<[_lblRooms.text intValue]) {
        _lblRooms.text = _lblAdults.text;
    }
    //[_lblChildren.text intValue]
    if ([_lblRooms.text intValue]>0&&([_lblAdults.text intValue]>=1 ))
    {
        _btnNext.enabled = TRUE;
    }
    else{
        _btnNext.enabled = FALSE;

    }
}
@end
