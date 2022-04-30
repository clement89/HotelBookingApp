//
//  DiscoverViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "DiscoverViewController.h"
#import "ApiCalling.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "DiscoverCollectionViewCell.h"
#import "CalendarDiscoverCollectionViewCell.h"
#import "OptionsCollectionViewCell.h"
#import "PopularCollectionViewCell.h"
#import "CalendarViewController.h"
#import "PlacePickerViewController.h"
#import "ListHotelsViewController.h"
#import "PopularPropertiesViewController.h"
#import "SearchWithLOcation.h"
#import "SinglePropertyDetailsViewController.h"
#import "MessageViewController.h"
#import "NotificationsViewController.h"
#import "CitiesCollectionViewCell.h"
#import <Crashlytics/Crashlytics.h>
#import "DurationSelectionViewController.h"
#import "URLConstants.h"
#import "PropertyDetailsViewController.h"
#import "StayDateTimeViewController.h"
#import "BookingConfirmationNewViewController.h"
#import <SafariServices/SafariServices.h>
#import "TERMSWEBViewController.h"
@interface DiscoverViewController ()<APIPostingDelegate>{
    ApiCalling *ac;
    DiscoverCollectionViewCell*cell;
    IBOutlet NSLayoutConstraint *bestPropertyHeight;
    IBOutlet NSLayoutConstraint *citiesHeight;
    CalendarDiscoverCollectionViewCell*calendar;
    OptionsCollectionViewCell*optionsCell;
    PopularCollectionViewCell*popularCell;
    
    CitiesCollectionViewCell *citiesCell;
    BOOL isWsLoadedSuccesFully;
    
    NSArray*slotsArr,*optionsArr,*timingIntervalArr;
    NSMutableArray*daysWordsArr,*daysNumArr,*datesArr;
    NSInteger selectedDayIndex,selectedSlotIndex,selectedTimeSlotIndex;
    BOOL isOptionsCollectionShowing,isTimeOrRooms;
    NSDateFormatter *timePicker;
    CLLocationManager *locationManager;
    BOOL isLoadingAPI;
    NSDictionary *responseDictionaryOld;
}
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *cvOffersMore;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title =@"\nFIND YOUR FLEXIBLE\nSHORT STAY";
    NSString *subtitle = [NSString stringWithFormat:@"HOURLY/ MONTHLY"];
    
    NSString *completeStr =[NSString stringWithFormat:@"%@\n%@",title,subtitle];
    NSMutableAttributedString *compAttr =[[NSMutableAttributedString alloc] initWithString:completeStr];
    [compAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:28] range:NSMakeRange(0, completeStr.length)];
   [compAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:17] range:NSMakeRange(completeStr.length-subtitle.length, subtitle.length)];
    
    [compAttr addAttribute:NSForegroundColorAttributeName value:kColorDarkBlueThemeColor range:NSMakeRange(0, completeStr.length)];
    [compAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    _lblHeader.attributedText = compAttr;
    slotsArr=[[NSArray alloc]init];
    
    // NSString* SS=[slotsArr objectAtIndex:0];
    
    popHeight=_popularCollection.frame.size.height;
    if (@available(iOS 11.0, *)) {
        [self.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        // Fallback on earlier versions
    }
    _popularCollection.superview.hidden = TRUE;
    _cvOffersMore.superview.hidden = TRUE;

        _bestPropertiesCollection.superview.hidden = TRUE;
    offersArray = [[NSMutableArray alloc] init];
    optionsArr=[[NSArray alloc]initWithObjects:@"Rooms",@"Adults",@"Children", nil];
timingIntervalArr=[[NSArray alloc]initWithObjects:@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30", nil];    daysWordsArr=[[NSMutableArray alloc]init];
    daysNumArr=[[NSMutableArray alloc]init];
    datesArr=[[NSMutableArray alloc]init];
    popularByArray=[[NSMutableArray alloc]init];
    cheapestArray=[[NSMutableArray alloc]init];

    cityArray=[[NSMutableArray alloc]init];
    nearByArray=[[NSMutableArray alloc]init];
    apiStatus=YES;
    slotsArr=@[@"3h",@"6h",@"12h",@"24h"];
    [[NSUserDefaults standardUserDefaults]setObject:[slotsArr objectAtIndex:0] forKey:@"selectedSloat"];
  //  optionsArr=@[@"Rooms",@"Adults",@"Children"];
//    timingIntervalArr= @[@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30"];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"selectedRooms"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"selectedChild"];
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"selectedAdults"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"currentLocationName"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"pickupLocationName"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    utilObj = [[RequestUtil alloc]init];
//    [utilObj callFavoriteApi];
    
    [utilObj pushRegistration];

    isTimeOrRooms=YES;
    [_optionsCollection reloadData];
    [_slotCollection reloadData];
    
    selectedDayIndex=0;
    selectedSlotIndex=0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate*currentDate=[NSDate date];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString*nextDayStringtem;

    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];

    nextDayStringtem=[dateFormatter2 stringFromDate:currentDate];
    
    NSString*nextDayStringtem1;

    nextDayStringtem1=[dateFormatter2 stringFromDate:currentDate];

    NSArray* timeArray=[nextDayStringtem componentsSeparatedByString:@":"];
    NSInteger time;
    NSInteger minitue;

    if([[timeArray objectAtIndex:1] integerValue]<=30)
    {
        if([[timeArray objectAtIndex:0] integerValue]<23)
        {
            time=[[timeArray objectAtIndex:0] integerValue]+1;
            minitue=00;
        }
        else
        {
            time=12;
            minitue=00;


        }
    }
    else
    {
        if([[timeArray objectAtIndex:0] integerValue]<23)
        {
            time=[[timeArray objectAtIndex:0] integerValue]+1;
            minitue=30;
        }
        else
        {
            time=12;
            minitue=30;
            
            
        }
    }
    
    
    if(time>=10 && minitue>=10)
    {
        nextDayStringtem=[NSString stringWithFormat:@"%ld:%ld",(long)time,(long)minitue];
    }
    else
    {
        if(time>=10)
        {
            nextDayStringtem=[NSString stringWithFormat:@"%ld:0%ld",(long)time,(long)minitue];
        }
        else if(minitue>=10)
        {
            nextDayStringtem=[NSString stringWithFormat:@"0%ld:%ld",(long)time,(long)minitue];

        }
        else
            nextDayStringtem=[NSString stringWithFormat:@"0%ld:0%ld",(long)time,(long)minitue];

        
    }
    self.amPmLbl.text=@"AM";
    BOOL nextDateVal=NO;
    if(time>=12)
    {
        self.amPmLbl.text=@"PM";
        if([[timeArray objectAtIndex:0] isEqualToString:@"23"])
        {
            nextDateVal=YES;
            self.amPmLbl.text=@"AM";
            nextDayStringtem=[NSString stringWithFormat:@"00:00"];
            
            if([[timeArray objectAtIndex:1] integerValue] >=30)
            {
                nextDayStringtem=[NSString stringWithFormat:@"00:30"];

            }

        }
    }
    else
    {
        
    }
    
    self.timeLbl.text=nextDayStringtem;
    
    if(time>12)
    {
        
        NSUInteger timeDiff=time-12;
        if(timeDiff>=10 && minitue>=10)
        {
            self.timeLbl.text=[NSString stringWithFormat:@"%ld:%ld",(long)timeDiff,(long)minitue];
        }
        else
        {
            if(timeDiff>=10)
            {
                self.timeLbl.text=[NSString stringWithFormat:@"%ld:0%ld",(long)timeDiff,(long)minitue];
            }
            else if(minitue>=10)
            {
                self.timeLbl.text=[NSString stringWithFormat:@"0%ld:%ld",(long)timeDiff,(long)minitue];
                
            }
            else
                self.timeLbl.text=[NSString stringWithFormat:@"0%ld:0%ld",(long)timeDiff,(long)minitue];
            
            
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:nextDayStringtem forKey:@"selectedTime"];
    [[NSUserDefaults standardUserDefaults]setObject:nextDayStringtem forKey:@"currentSlotTime"];

    currentSlot=nextDayStringtem;
    int timeToAdd=24*60*60;
    NSDate*nextDay;
    NSString*nextDayString;
    nextDay=[currentDate dateByAddingTimeInterval:timeToAdd];
    nextDayString=[dateFormatter stringFromDate:currentDate];
    if(nextDateVal)
    {
        [datesArr addObject:nextDay];

    }
    else
    {
    [datesArr addObject:currentDate];
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRooms)   name:@"reloadRooms" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateLBLFuncrionOne)   name:@"reloadDateLBL" object:nil];
    if(nextDateVal)
    {
        
        NSString* nextSTRINGVALUE=[dateFormatter stringFromDate:nextDay];
        
        [[NSUserDefaults standardUserDefaults]setObject:nextSTRINGVALUE forKey:@"selectedDate"];

    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];

    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self dateLBLFuncrion];

    for(int days=0;days<20;days++){
        
        if(days==0)
        {
             nextDay=[datesArr objectAtIndex:days];
                
            }
        else
        {
        nextDay=[[dateFormatter dateFromString:[datesArr objectAtIndex:days]] dateByAddingTimeInterval:timeToAdd];
        }
        nextDayString=[dateFormatter stringFromDate:nextDay];
        [datesArr addObject:[NSString stringWithFormat:@"%@",nextDayString]];
        
     //   [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
        [self getDateDetails:[NSString stringWithFormat:@"%@",nextDayString]];
    }
    [datesArr removeObjectAtIndex:0];
    [_calenderCollection reloadData];
    
    _searchHotel.layer.cornerRadius=4;
    _searchHotel.clipsToBounds=YES;
    
    _redDot.layer.cornerRadius=_redDot.frame.size.width/2;
    _redDot.clipsToBounds=YES;
    
    _placeSelectionView.layer.cornerRadius=4;
    _placeSelectionView.clipsToBounds=YES;
    bestPropertyHeight.constant=20;
    _optionsViewHt.constant=0;
    _optionsContainerHt.constant=75;
    _view2Ht.constant=_view2Ht.constant-65;
    isOptionsCollectionShowing=NO;
    [_datePicker setHidden:YES];
    [_pickTime setHidden:YES];
    [_datePicker setBackgroundColor:[UIColor whiteColor]];
    _datePicker.layer.cornerRadius=8;
    _datePicker.clipsToBounds=YES;
    timePicker= [[NSDateFormatter alloc]init];
    [timePicker setDateFormat:@"hh:mm"];
    [timePicker setTimeZone:[NSTimeZone localTimeZone]];
   // [self setDate:currentDate];
    
   
    _mapView.showsUserLocation=YES;
    [_mapView setMapType:MKMapTypeStandard];
    
   
#if TARGET_IPHONE_SIMULATOR
    
    NSLog(@"Running in Simulator - no app store or giro");
    
#else
    
    
//                hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//                hud.label.text = @"";
//                hud.mode=MBProgressHUDModeText;
//                progress=0;
//                hud.progress=0;
//                //        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Uploadprogress) userInfo:nil repeats:NO];
//                [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                    hud.progress=hud.progress+0.05;
//                    if(hud.progress>1)
//                    {
//                        [timer invalidate];
//                    }
//                }];
//                hud.margin = 0.f;
//                hud.offset = CGPointMake(0,[UIScreen mainScreen].bounds.size.height);
//                hud.removeFromSuperViewOnHide = YES;
    
#endif
//    NSString *model = [[UIDevice currentDevice] model];
//    if ([model isEqualToString:@"iPhone Simulator"]) {
//        //device is simulator
//    }
//    else
//    {
////        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
////        hud.label.text = @"";
////        hud.mode=MBProgressHUDModeText;
////        progress=0;
////        hud.progress=0;
////        //        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Uploadprogress) userInfo:nil repeats:NO];
////        [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
////            hud.progress=hud.progress+0.05;
////            if(hud.progress>1)
////            {
////                [timer invalidate];
////            }
////        }];
////        hud.margin = 0.f;
////        hud.offset = CGPointMake(0,[UIScreen mainScreen].bounds.size.height);
////        hud.removeFromSuperViewOnHide = YES;
//    }
    
    self.weatherImageView.hidden=YES;;
    
    self.degreeLBL.hidden=YES;
    self.celciousLBL.hidden=YES;
    
    self.valueLBL.hidden=YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushClick)   name:@"pushClick" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toHome)   name:@"toHome" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GUSTBACK)   name:@"GUSTBACK" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookingDone)   name:@"bookingDone" object:nil];
    
    _placeSelectionView.layer.masksToBounds = false;
    _placeSelectionView.layer.shadowOffset = CGSizeMake(0, 2);
    _placeSelectionView.layer.shadowOpacity = 0.3;
    _placeSelectionView.layer.shadowRadius = 2.0;
    _placeSelectionView.layer.shadowColor = [UIColor grayColor].CGColor;
    
    

}
- (void)viewDidLayoutSubviews
{
   // if (!additionalAdded) {
       
    // }               if (@available(iOS 11.0, *)) {
//    if (@available(iOS 11.0, *)) {
//        NSLog(@"topview additional == %f and keywindow == %f",self.additionalSafeAreaInsets.top,[UIApplication sharedApplication].keyWindow.safeAreaInsets.top);
//            if (self.additionalSafeAreaInsets.top != [UIApplication sharedApplication].keyWindow.safeAreaInsets.top)
//            {
//                self.additionalSafeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
//        } else {
//            // Fallback on earlier versions
//        }
//    } else {
//        // Fallback on earlier versions
//    }


 }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(didenterForeGround:)
        name:UIApplicationWillEnterForegroundNotification
      object:nil];

    [self checkLocationServicesAndStartUpdates];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void) didenterForeGround:(NSNotification *) note
{
[self checkLocationServicesAndStartUpdates];

}
-(void) checkLocationServicesAndStartUpdates
{
    if (isWsLoadedSuccesFully) {
        return;
    }
    if (!locationManager)
    {
            locationManager = [[CLLocationManager alloc] init];
               locationManager.delegate = self;
               locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [locationManager requestLocation];

    }
   [locationManager requestWhenInUseAuthorization];

  //
//       [locationManager requestWhenInUseAuthorization];
   //    [locationManager startUpdatingLocation];
    
    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

//    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]||[locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
//    {
//        [locationManager requestWhenInUseAuthorization];
//    }

    //Checking authorization status
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        
        UIAlertController * alert = [UIAlertController
                        alertControllerWithTitle:@"Location Services Disabled!"
                                         message:@"Please enable location services for better results!"
                                  preferredStyle:UIAlertControllerStyleAlert];



        UIAlertAction* yesButton = [UIAlertAction
                            actionWithTitle:@"Settings"
                                      style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
            //TODO if user has not given permission to device
                   if (![CLLocationManager locationServicesEnabled])
                   {
                       NSString* url = SYSTEM_VERSION_LESS_THAN(@"10.0") ? @"prefs:root=LOCATION_SERVICES" :@"App-Prefs:root=Privacy&path=LOCATION";

                       NSURL *URL = [NSURL URLWithString:url];
                       [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                           if (success) {
                                NSLog(@"Opened url");
                           }
                       }];
                       
//                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];

                   }
                   //TODO if user has not given permission to particular app
                   else
                   {
                       NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                       [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                           if (success) {
                                NSLog(@"Opened url");
                           }
                       }];

                   }
            
                                    }];

        UIAlertAction* noButton = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                          style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                           //Handle no, thanks button
            [self.navigationController popViewControllerAnimated:TRUE];
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"InitialViewController"];
            [self.navigationController setViewControllers:@[vc]];

            
            
                                        }];

        [alert addAction:yesButton];
        [alert addAction:noButton];

        [self presentViewController:alert animated:YES completion:nil];

        
        


        return;
    }
    else
    {
        //Location Services Enabled, let's start location updates
        [locationManager startUpdatingLocation];
    }
}




-(void)toHome
{
    UITabBarController *tab=self.tabBarController;
    
    if (tab)
    {
        
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"bookingDone1" object:nil];

        [self.tabBarController setSelectedIndex:0];
        
    }
}
-(void)bookingDone
{
    UITabBarController *tab=self.tabBarController;
    
    if (tab){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bookingDone1" object:nil];

        [self.tabBarController setSelectedIndex:2];
        
    }
}
-(void)dateLBLFuncrionOne
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MMM-dd-yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate*currentDate=[dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedDate"]];
    
    NSString*nextDayString;
    
    nextDayString=[dateFormatter stringFromDate:currentDate];
    // [datesArr addObject:nextDay];
    selectedDateLBL.text=[NSString stringWithFormat:@"%@",[dateFormatter2 stringFromDate:currentDate] ];
    selectedDayIndex=-1;
    int i=0;
    for(NSString* str in datesArr)
    {
        if([str isEqualToString:nextDayString])
        {
            selectedDayIndex=i;
        }
        i++;
    }
    [_calenderCollection reloadData];
    //    [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

-(void)dateLBLFuncrion
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MMM-dd-yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate*currentDate=[dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedDate"]];
    
    NSString*nextDayString;
   
    nextDayString=[dateFormatter stringFromDate:currentDate];
    // [datesArr addObject:nextDay];
    selectedDateLBL.text=[NSString stringWithFormat:@"%@",[dateFormatter2 stringFromDate:currentDate] ];
   // selectedDayIndex=-1;
    [_calenderCollection reloadData];
//    [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(void)reloadRooms
{
    
    
    NSString *roomsString=@"Room";
    NSString *adultsString=@"Adult";
//    NSString *childString=@"CHILD";
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"] integerValue]>1)
    {
        roomsString=@"Rooms";
    }
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue]>1)
    {
        adultsString=@"Adults";
    }
//    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"] integerValue]>1)
//    {
//        childString=@"CHILDREN'S";
//    }
    
    
   
    self.roomsAndPersonsLbl.text=[NSString stringWithFormat:@"%@ %@ in %@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"],adultsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"],roomsString];
    
    
    for (OptionsCollectionViewCell *cell in [self.optionsCollection visibleCells]) {
        NSIndexPath *indexPath = [self.optionsCollection indexPathForCell:cell];
        if(indexPath.row==1)
            cell.optionSelected.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"]];
        if(indexPath.row==0)
            cell.optionSelected.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"]];
    }
    
}
-(void)getDateDetails:(NSString*)datePassed{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString*strt=datePassed;
    NSDate *date =[[NSDate alloc]init];
    date=[dateFormatter dateFromString:strt];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE"];
    NSString* myDayString = [[df stringFromDate:date] uppercaseString];
    [daysWordsArr addObject:myDayString];
    [df setDateFormat:@"dd"];
    NSString* myDay= [df stringFromDate:date];
    [daysNumArr addObject:myDay];
//    [df setDateFormat:@"MMM"];
  //  NSString* myMonthString = [df stringFromDate:date];
    
    
}
    -(IBAction)PickLocation:(id)sender
    {
        [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"PlaceSearchViewController"] animated:TRUE];
        return;
        
        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.tintColor = [UIColor whiteColor];
        acController.tableCellBackgroundColor = [UIColor whiteColor];
        acController.tableCellSeparatorColor = [UIColor colorWithRed:232./255. green:232./255. blue:232./255. alpha:1.];

        acController.delegate = self;
        acController.modalPresentationStyle = UIModalPresentationFullScreen;
        GMSPlaceField gmsPlaceField=(GMSPlaceFieldName | GMSPlaceFieldFormattedAddress | GMSPlaceFieldPlaceID | GMSPlaceFieldCoordinate);
        acController.placeFields=gmsPlaceField;
        [self.navigationController presentViewController:acController animated:YES completion:nil];
    }
    
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);

    NSString *lat =[NSString stringWithFormat:@"%f",place.coordinate.latitude];
    NSString *lon =[NSString stringWithFormat:@"%f",place.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"pickupLat"];
    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"pickupLongt"];
   
    //FIXME:todo
    
   // [self weatherApi:place.coordinate.latitude longitude:place.coordinate.longitude];
    NSString *placeString =[NSString stringWithFormat:@"%@",place.formattedAddress];
    [[NSUserDefaults standardUserDefaults]setObject:[place.name uppercaseString] forKey:@"pickupLocationName"];
     [[NSUserDefaults standardUserDefaults]setObject:[place.formattedAddress uppercaseString] forKey:@"chkingstring"];
//    [self setLocationImage];

    [[NSUserDefaults standardUserDefaults]synchronize];
//    self.placeTxt.text=placeString;
//    self.weatherLbl.text=[place.name uppercaseString];
//  
    
    
    
    
    DurationSelectionViewController *durn =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
    durn.latitude = lat;
    durn.longitude = lon;
    durn.formattedAddress = [place.formattedAddress uppercaseString];
    durn.placeName = [place.name uppercaseString];

    [self dismissViewControllerAnimated:FALSE completion:^{
        [self.navigationController pushViewController:durn animated:TRUE];

    }];
    //[self.mapView addSubview:placePicker.view];
    
    
}
    
- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}
    
    // User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
    // Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}



- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    return;
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlacePickerViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PlacePickerViewController"];
    vc.providesPresentationContextTransitionStyle = YES;
    vc.definesPresentationContext = YES;
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    /*if(textField==self.confirmPassword)
     {
     NSString*str= [textField.text stringByReplacingCharactersInRange:range withString:string];
     BOOL showAlert=NO;
     NSString*msg;
     if(self.confirmPassword.text.length>=self.password.text.length)
     {
     if([self.password.text isEqualToString:str])
     {
     
     }
     else{
     showAlert=YES;
     msg=@"Passwords do not match";
     if(selectedLang)
     {
     msg=@"";
     }
     }
     
     if(showAlert){
     showAlert=NO;
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.mode = MBProgressHUDModeText;
     hud.label.text = msg;
     hud.mode=MBProgressHUDModeText;
    hud.margin = 0.f;
     hud.yOffset = 200.f;
     hud.removeFromSuperViewOnHide = YES;
     hud.userInteractionEnabled=YES;
     [hud hideAnimated:YES afterDelay:2];
     }
     }
     }*/
    
    return YES;
}



- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==_slotCollection)
        return slotsArr.count;
    if(collectionView==_calenderCollection)
        return datesArr.count;
    if(collectionView==_optionsCollection)
    {
        if(isTimeOrRooms){
            return timingIntervalArr.count;
        }
        else{
            return optionsArr.count;
        }
    }
    if(collectionView==_popularCollection)
        return [popularByArray count];
    if(collectionView == _cheapCollection)
        return [cheapestArray count];

    else if(collectionView==_cvOffersMore)
    {
        return [offersArray count];
    }
    else if(collectionView==_bestPropertiesCollection)
        return [cityArray count];
    
    return 3;
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    {
//        if(collectionView==_optionsCollection){
//            if(isTimeOrRooms)
//            {
//                cell.transform = CGAffineTransformMakeTranslation(100.f, 0);
//                cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//                cell.layer.shadowOffset = CGSizeMake(10, 10);
//                cell.alpha = 0;
//                
//                //2. Define the final state (After the animation) and commit the animation
//                [UIView beginAnimations:@"rotation" context:NULL];
//                [UIView setAnimationDuration:0.3];
//                cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
//                cell.alpha = 1;
//                cell.layer.shadowOffset = CGSizeMake(0, 0);
//                [UIView commitAnimations];
//            }
//        }
//        else
//        {
//            cell.transform = CGAffineTransformMakeTranslation(100.f, 0);
//            cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//            cell.layer.shadowOffset = CGSizeMake(10, 10);
//            cell.alpha = 0;
//            
//            //2. Define the final state (After the animation) and commit the animation
//            [UIView beginAnimations:@"rotation" context:NULL];
//            [UIView setAnimationDuration:0.3];
//            cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
//            cell.alpha = 1;
//            cell.layer.shadowOffset = CGSizeMake(0, 0);
//            [UIView commitAnimations];
//        }
//        //cell.transform = CGAffineTransformMakeTranslation(100.f, 100);
//        //    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//        //    cell.layer.shadowOffset = CGSizeMake(10, 10);
//        //    cell.alpha = 0;
//        //
//        //    //2. Define the final state (After the animation) and commit the animation
//        //    [UIView beginAnimations:@"rotation" context:NULL];
//        //    [UIView setAnimationDuration:0.3];
//        //    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
//        //    cell.alpha = 1;
//        //    cell.layer.shadowOffset = CGSizeMake(0, 0);
//        //    [UIView commitAnimations];
//    }
    
    
//    if(collectionView==_optionsCollection){
//    }
//    else
//    {
//        cell.transform = CGAffineTransformMakeTranslation(100.f, 0);
//        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//        cell.layer.shadowOffset = CGSizeMake(10, 10);
//        cell.alpha = 0;
//
//        //2. Define the final state (After the animation) and commit the animation
//        [UIView beginAnimations:@"rotation" context:NULL];
//        [UIView setAnimationDuration:0.3];
//        cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
//        cell.alpha = 1;
//        cell.layer.shadowOffset = CGSizeMake(0, 0);
//        [UIView commitAnimations];
//    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView == _cheapCollection){
        
        popularCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PopularCollectionViewCell" forIndexPath:indexPath];
       
        NSString* price=@"0";
        NSString* discountPrice=@"0";
        popularCell.priceLbl.text=@"";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
        {
            popularCell.favButtonSlotLbl.hidden=NO;
            
        }else
        {
            popularCell.favButtonSlotLbl.hidden=YES;
            
        }
        
        
        
        if([utilObj checkFavorites:[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"_id"] ])
        {
            popularCell.favButtonSlotLbl.selected=YES;
        }
        else
        {
            popularCell.favButtonSlotLbl.selected=NO;
            
        }
        if([[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"images"])
        {
            if([[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"images"] count]>0)
            {
                NSString*imgName=[[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"images"]objectAtIndex:0];
                NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
                [popularCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
            }
            else
            {
                popularCell.img.image = [UIImage imageNamed:@"QOMPlaceholder1"];
            }
        }
        else
        {
            popularCell.img.image = [UIImage imageNamed:@"QOMPlaceholder1"];
            
        }
        
        popularCell.addressLbl.text = @"";
        
        if([[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"location"])
        {
            if([[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"address"])
                
                popularCell.addressLbl.text=[[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"address"];
        }
        else
            popularCell.addressLbl.text=@"";
        if([[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"name"])
            popularCell.nameLbl.text=[[cheapestArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        else
            popularCell.nameLbl.text=@"";
        ////
        BOOL statusValue=NO;
        price=@"";
        popularCell.timeSlotLbl.layer.cornerRadius=5;
        popularCell.timeSlotLbl.clipsToBounds=YES;
        //  popularCell.timeSlotBGLbl.backgroundColor=[UIColor redColor];
        popularCell.timeSlotLbl.text=@"";
        if ([[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"stayDuration"])
        {
            popularCell.timeSlotLbl.text = [NSString stringWithFormat:@" %@ ",[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"stayDuration"][@"label"]];
            
        }
        
        price = [NSString stringWithFormat:@"%@",[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"priceSummary"][@"base"][@"amount"]];
        
        
        
        popularCell.priceLbl.text = [NSString stringWithFormat:@"%@",price];
        
        popularCell.propertyID=[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"_id"];
        if([[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
        {
            popularCell.ratingImg.image=[UIImage imageNamed:[utilObj checkRating:[[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"rating"] objectForKey:@"value"] ]];
        }
        else
            popularCell.ratingImg.image=[UIImage imageNamed:[utilObj checkRating:[[cheapestArray objectAtIndex:indexPath.row] objectForKey:@"rating"] ]];
        
        if (popularCell.timeSlotLbl.text.length>0) {
            NSString *hrlbl = popularCell.timeSlotLbl.text;
            
            hrlbl = [NSString stringWithFormat:@".  %@  .",hrlbl];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FontMedium size:12]}];
            
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
            popularCell.timeSlotLbl.attributedText = attr;
            popularCell.timeSlotLbl.backgroundColor = UIColorFromRGB(0xFF4848);
            
        }
        
        
        return popularCell;
    }
    
    else if(collectionView==_popularCollection){
        popularCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PopularCollectionViewCell" forIndexPath:indexPath];
        ///
        
        ///
        
        NSString* price=@"0";
        NSString* discountPrice=@"0";
        popularCell.priceLbl.text=@"";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
        {
            popularCell.favButtonSlotLbl.hidden=NO;
            
        }else
        {
            popularCell.favButtonSlotLbl.hidden=YES;
            
        }
        
        
        
        if([utilObj checkFavorites:[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"_id"] ])
        {
            popularCell.favButtonSlotLbl.selected=YES;
        }
        else
        {
            popularCell.favButtonSlotLbl.selected=NO;
            
        }
        if([[popularByArray objectAtIndex:indexPath.row] objectForKey:@"images"])
        {
            if([[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"images"] count]>0)
            {
                NSString*imgName=[[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"images"]objectAtIndex:0];
                NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
                [popularCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
            }
            else
            {
                popularCell.img.image = [UIImage imageNamed:@"QOMPlaceholder1"];
            }
        }
        else
        {
            popularCell.img.image = [UIImage imageNamed:@"QOMPlaceholder1"];
            
        }
        
        popularCell.addressLbl.text = @"";
        
        if([[popularByArray objectAtIndex:indexPath.row] objectForKey:@"location"])
        {
            if([[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"address"])
                
                popularCell.addressLbl.text=[[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"location"] objectForKey:@"address"];
        }
        else
            popularCell.addressLbl.text=@"";
        if([[popularByArray objectAtIndex:indexPath.row] objectForKey:@"name"])
            popularCell.nameLbl.text=[[popularByArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        else
            popularCell.nameLbl.text=@"";
        ////
        BOOL statusValue=NO;
        price=@"";
        popularCell.timeSlotLbl.layer.cornerRadius=5;
        popularCell.timeSlotLbl.clipsToBounds=YES;
        //  popularCell.timeSlotBGLbl.backgroundColor=[UIColor redColor];
        popularCell.timeSlotLbl.text=@"";
        if ([[popularByArray objectAtIndex:indexPath.row] objectForKey:@"stayDuration"])
        {
            popularCell.timeSlotLbl.text = [NSString stringWithFormat:@" %@ ",[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"stayDuration"][@"label"]];
            
        }
        /*   if ([[popularByArray objectAtIndex:indexPath.row] objectForKey:@"rooms"]) {
         for(NSDictionary* dic in [[popularByArray objectAtIndex:indexPath.row] objectForKey:@"rooms"])
         {
         if([dic isKindOfClass:[NSDictionary class]])
         {
         
         if([[dic objectForKey:@"price"] isKindOfClass:[NSDictionary class]])
         {
         
         if([[dic objectForKey:@"price"] objectForKey:@"h3"])
         {
         price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
         popularCell.timeSlotLbl.text=@"3h";
         
         
         }
         else   if([[dic objectForKey:@"price"] objectForKey:@"h6"])
         {
         price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
         
         popularCell.timeSlotLbl.text=@"6h";
         }
         
         else   if([[dic objectForKey:@"price"] objectForKey:@"h12"])
         {
         price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
         popularCell.timeSlotLbl.text=@"12h";
         
         }
         else
         if([[dic objectForKey:@"price"] objectForKey:@"h24"])
         {
         price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
         
         popularCell.timeSlotLbl.text=@"24h";
         
         }
         
         // break;
         }
         else
         {
         price=[dic valueForKey:@"price"];
         //break;
         }
         
         ////
         if([dic objectForKey:@"custom_price"])
         {
         statusValue=YES;
         if([[dic objectForKey:@"custom_price"] isKindOfClass:[NSDictionary class]])
         {
         
         if([[dic objectForKey:@"custom_price"] objectForKey:@"h3"])
         {
         price=[[dic objectForKey:@"custom_price"] valueForKey:@"h3"];
         
         
         
         }
         else   if([[dic objectForKey:@"custom_price"] objectForKey:@"h6"])
         {
         price=[[dic objectForKey:@"custom_price"] valueForKey:@"h6"];
         
         
         
         }
         else
         if([[dic objectForKey:@"custom_price"] objectForKey:@"h12"])
         {
         price=[[dic objectForKey:@"custom_price"] valueForKey:@"h12"];
         
         
         }
         else  if([[dic objectForKey:@"custom_price"] objectForKey:@"h24"])
         {
         price=[[dic objectForKey:@"custom_price"] valueForKey:@"h24"];
         
         
         
         }
         
         break;
         }else
         {
         price=[dic valueForKey:@"custom_price"];
         break;
         }
         }
         else
         {
         break;
         }
         
         ///
         
         
         
         
         
         }
         
         }
         }*/
        
        ///
        
        price = [NSString stringWithFormat:@"%@",[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"priceSummary"][@"base"][@"amount"]];
        
        
        
        popularCell.priceLbl.text = [NSString stringWithFormat:@"%@",price];
        
        //  NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" AED 1200 "]];
        
        //  [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:9.0] range:NSMakeRange(0, 4)];
        // cell.discountPriceLBL.attributedText = str1;
        // cell.featuredImageView.hidden=YES;
        // cell.discountPriceLBL.hidden=YES;
        //  cell.hourLBL.text=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]] uppercaseString];
        popularCell.propertyID=[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"_id"];
        if([[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
        {
            popularCell.ratingImg.image=[UIImage imageNamed:[utilObj checkRating:[[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"rating"] objectForKey:@"value"] ]];
        }
        else
            popularCell.ratingImg.image=[UIImage imageNamed:[utilObj checkRating:[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"rating"] ]];
        ////
        
        if (popularCell.timeSlotLbl.text.length>0) {
            NSString *hrlbl = popularCell.timeSlotLbl.text;
            
            hrlbl = [NSString stringWithFormat:@".  %@  .",hrlbl];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FontMedium size:12]}];
            
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
            popularCell.timeSlotLbl.attributedText = attr;
            popularCell.timeSlotLbl.backgroundColor = UIColorFromRGB(0xFF4848);
            
        }
        
        
        return popularCell;
    }
    else if(collectionView==_cvOffersMore){
        PopularCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"OffersCollectionViewCell" forIndexPath:indexPath];
        
        NSLog(@"%@",offersArray[indexPath.item]);
        
        if([[offersArray objectAtIndex:indexPath.item] objectForKey:@"image"])
            
        {
            NSString*imgName=[[offersArray objectAtIndex:indexPath.item] objectForKey:@"image"];
            NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
            [cell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
        }
        else
        {
            cell.img.image = [UIImage imageNamed:@"QOMPlaceholder1"];
        }
        
        
        
        if (indexPath.item%2==0) {
            cell.addressLbl.superview.backgroundColor = UIColorFromRGB(0xdef7ff);
        }
        else{
            cell.addressLbl.superview.backgroundColor = UIColorFromRGB(0xfff7d4);
            
        }
        cell.nameLbl.text = offersArray[indexPath.item][@"title"];
        cell.addressLbl.text = offersArray[indexPath.item][@"subtitle"];
        
        return cell;
        
    }
    
    else{//} if(collectionView==_popularCollection){
        
        //        City
        citiesCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CitiesCollectionViewCell" forIndexPath:indexPath];
        
        if([[cityArray objectAtIndex:indexPath.row] objectForKey:@"image"])
        {
            
            
            NSString*imgName=[[cityArray objectAtIndex:indexPath.row] objectForKey:@"image"];
            NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
            [citiesCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder"]];
        }
        else
        {
            citiesCell.img.image =  [UIImage imageNamed:@"QOMPlaceholder"];
        }
        citiesCell.unitsLbl.hidden = FALSE;
        citiesCell.nameLbl.text=[[cityArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        if([[cityArray objectAtIndex:indexPath.row] objectForKey:@"averagePrice"])
            citiesCell.unitsLbl.text=[NSString stringWithFormat:@"AED %@ / night avg.",[[cityArray objectAtIndex:indexPath.row] objectForKey:@"averagePrice"]];
        return citiesCell;
    }
    
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
   
    if(collectionView==_slotCollection){
        
        selectedSlotIndex=indexPath.item;
        [[NSUserDefaults standardUserDefaults]setObject:[slotsArr objectAtIndex:indexPath.row] forKey:@"selectedSloat"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [_slotCollection reloadData];
    }
    else if(collectionView==_calenderCollection){
        selectedDayIndex=indexPath.item;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
        [dateFormatter2 setDateFormat:@"dd - MMM - YY"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSDate*currentDate=[dateFormatter dateFromString:[datesArr objectAtIndex:indexPath.item]];
        
        NSString*nextDayString;
        nextDayString=[dateFormatter stringFromDate:currentDate];
        // [datesArr addObject:nextDay];
       // selectedDateLBL.text=[dateFormatter2 stringFromDate:currentDate];
        
        
        [[NSUserDefaults standardUserDefaults]setObject:[datesArr objectAtIndex:indexPath.item] forKey:@"selectedDate"];
        
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self dateLBLFuncrion];

        [_calenderCollection reloadData];
    }
    else if(collectionView==_optionsCollection){
        
        if(isTimeOrRooms){
            selectedTimeSlotIndex=indexPath.item;
            [self setDate:[timingIntervalArr objectAtIndex:indexPath.item]];
            [[NSUserDefaults standardUserDefaults]setObject:[timingIntervalArr objectAtIndex:indexPath.item] forKey:@"selectedTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [_optionsCollection reloadData];

           // [self optionsCollectionExpand];
            
        }
        else{
            
        }
        
        
    }
    else if(collectionView==_popularCollection){
        
       
        
        NSString* loadingString;
        
        NSString *small=[NSString stringWithFormat:@"%@",[[popularByArray objectAtIndex:indexPath.item]valueForKey:@"smallest_timeslot"] ];
        
        loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",small,[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[[popularByArray objectAtIndex:indexPath.item]valueForKey:@"_id"]];
        
        DurationSelectionViewController *sd =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
        sd.placeName = @"";
        sd.latitude = @"";
        sd.longitude = @"";
        sd.formattedAddress = @"";
       // sd.isMonthlySelected = false;
        sd.cityIdString =@"";
        sd.selectionString = @"";
        sd.isHotelSelected = TRUE;
        sd.selectedHotel = [popularByArray objectAtIndex:indexPath.item];
        [self.navigationController pushViewController:sd animated:TRUE];
        //TODO: OLD FLOW
        
       /*
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PropertyDetailsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
        vc.selectedProperty=[popularByArray objectAtIndex:indexPath.item];
        vc.selectionString=loadingString;
        vc.property_id =[popularByArray objectAtIndex:indexPath.item][@"_id"];
        [self.navigationController pushViewController:vc animated:YES];*/
        
    }
    else if( collectionView == _cheapCollection){
        
       
        
        NSString* loadingString;
        
        NSString *small=[NSString stringWithFormat:@"%@",[[cheapestArray objectAtIndex:indexPath.item]valueForKey:@"smallest_timeslot"] ];
        
        loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",small,[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[[cheapestArray objectAtIndex:indexPath.item]valueForKey:@"_id"]];
        
        DurationSelectionViewController *sd =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
        sd.placeName = @"";
        sd.latitude = @"";
        sd.longitude = @"";
        sd.formattedAddress = @"";
       // sd.isMonthlySelected = false;
        sd.cityIdString =@"";
        sd.selectionString = @"";
        sd.isHotelSelected = TRUE;
        sd.selectedHotel = [cheapestArray objectAtIndex:indexPath.item];
        [self.navigationController pushViewController:sd animated:TRUE];
        
    
    }
    else if(collectionView==_bestPropertiesCollection){
        
        
        DurationSelectionViewController *durn =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
        durn.latitude = @"";
        durn.longitude = @"";
        durn.formattedAddress = [[NSString stringWithFormat:@"%@",[cityArray objectAtIndex:indexPath.item][@"name"]] capitalizedString];
        durn.placeName = durn.formattedAddress;
        durn.cityIdString =[NSString stringWithFormat:@"%@",[cityArray objectAtIndex:indexPath.item][@"_id"]];
        durn.selectionString = @"popular";
        [self.navigationController pushViewController:durn animated:YES];
        return;
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchWithLOcation *vc = [y   instantiateViewControllerWithIdentifier:@"SearchWithLOcation"];
        vc.locationDic=[cityArray objectAtIndex:indexPath.item];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"selectedRooms"];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"selectedChild"];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"selectedAdults"];
       
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(collectionView==_cvOffersMore){
        
        NSLog(@"%@",offersArray[indexPath.item]);
        NSString* directionsURL = offersArray[indexPath.item][@"link"];
     //   if (directionsURL && [directionsURL hasPrefix:@"http"])
        {
         //   NSURL *urlll =   [NSURL URLWithString: directionsURL];
            
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
                   
                   TERMSWEBViewController *vc = [y   instantiateViewControllerWithIdentifier:@"TERMSWEBViewController"];
           //        vc.WEBSTRING=@"https://stayhopper.com/terms.html#noheader";
                   vc.titleString = @"Offers";
            vc.isForOffers = TRUE;
            vc.WEBSTRING=directionsURL;//@"https://stayhopper.com/privacy.html#noheader";
            [self.navigationController pushViewController:vc animated:TRUE];
//                   vc.modalPresentationStyle = UIModalPresentationFullScreen;
//                   [self presentViewController:vc animated:TRUE completion:^{
//
//                   }];
//
            
/*
            SFSafariViewController *viewController = [[SFSafariViewController alloc] initWithURL:urlll];
            viewController.modalPresentationStyle = UIModalPresentationPopover;
               [self.navigationController presentViewController:viewController animated:YES completion:nil];
            */
//            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL] options:@{} completionHandler:^(BOOL success) {}];
//         } else {
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString: directionsURL]];
//         }
             
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==_slotCollection)
        return CGSizeMake(collectionView.frame.size.width/4.5, collectionView.frame.size.height);
    if(collectionView==_calenderCollection)
        return CGSizeMake(collectionView.frame.size.width/8.3, collectionView.frame.size.height);
    if(collectionView==_optionsCollection){
        if(isTimeOrRooms){
            return CGSizeMake(collectionView.frame.size.width/4.5, collectionView.frame.size.height);
        }
        else{
            return CGSizeMake(collectionView.frame.size.width/3.2, collectionView.frame.size.height);
        }
    }
    
    if(collectionView==_popularCollection || collectionView == _cheapCollection)
    {
        float ht = collectionView.frame.size.height;
        return CGSizeMake(ht*255./200., ht);

    }
    else if(collectionView==_cvOffersMore)
    {
        float ht = collectionView.frame.size.height;
        return CGSizeMake(ht*255./265., ht);

    }
    if(collectionView==_bestPropertiesCollection)
    {
        float ht = collectionView.frame.size.height;

        return CGSizeMake(ht*160./65., ht);
    }
    
    
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.height);
    
}

-(void)timeConversion:(NSString*)time{
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    

  /*  if([UIApplication sharedApplication].applicationIconBadgeNumber==0)
    {
        self.redDot.alpha=0;
        
        
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:self.tabBarController.tabBar.items.count-1];
        
                item.image =[Commons image:[[UIImage imageNamed:@"ProActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] fromColor:kColorTabNormalColor];
                item.selectedImage  = [[UIImage imageNamed:@"ProActive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 
 
    }
    else
    {
        self.redDot.alpha=1;
        UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:self.tabBarController.tabBar.items.count-1];
        item.image = [UIImage imageNamed:@"HomeProfileNormal"];
        item.selectedImage = [UIImage imageNamed:@"HomeProfileActive"];
    }*/
   // [locationManager startUpdatingLocation];
    _view3Ht.constant=bestPropertyHeight.constant+356+80;

//    _containerViewOfScrollViewHt.constant= _view1Ht.constant+_view2Ht.constant+_view3Ht.constant+_view4Ht.constant+40;
//    _scrollView.contentSize=CGSizeMake(0,_containerViewOfScrollViewHt.constant-30);
//    [UIView animateWithDuration:0.2 animations:^{    _scrollView.contentOffset=CGPointMake(0, 0 );
//}];
    [_popularCollection reloadData];
  ///  [self.cvOffersMore reloadData];

    [self reloadRooms];
    [self dateLBLFuncrion];
    
   [self setDate:[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedTime"]];
    
    
   
    if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"fromClickNoti"] uppercaseString] isEqualToString:@"YES"])
    {
        [self pushClick];
    }
    
    [self loadApi];

}

-(void)GUSTBACK
{
    UITabBarController *tab=self.tabBarController;
    
    if (tab){
        
        [self.tabBarController setSelectedIndex:0];
        
    }
    
    else{
        
    }
}
-(void)pushClick
{
    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fromClickNoti"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"])
    {
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"type"])
    {
        if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] uppercaseString] isEqualToString:@"REBOOKING"])
        {
            UITabBarController *tab=self.tabBarController;
            
            if (tab){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bookingDone2" object:nil];

                [self.tabBarController setSelectedIndex:2];
                
            }
            
            else{
                
            }
        }else if(![[[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] uppercaseString] isEqualToString:@"REVIEW"] && ![[[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] uppercaseString] isEqualToString:@"YES"] && ![[[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] uppercaseString] isEqualToString:@"NO"])
        
        {
            UITabBarController *tab=self.tabBarController;
            
            if (tab){
               // book_id
                [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"book_id"] forKey:@"booking_ID"];
                [[NSUserDefaults standardUserDefaults]synchronize];
               

                [self.tabBarController setSelectedIndex:2];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"bookingDone1" object:nil];
              
            }
            
            else{
                
            }
           // [self notificationFunction:nil];
        }else if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] uppercaseString] isEqualToString:@"REVIEW"])
            {
                UITabBarController *tab=self.tabBarController;
                
                if (tab){
                    // book_id
//                    [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"book_id"] forKey:@"booking_ID"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
                    

                  [self.tabBarController setSelectedIndex:2];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookingDone1" object:nil];
                    
                }
                
                else{
                    
                }
            }
    }
    }
    else
    {
        [self notificationFunction:nil];

    }
}

- (void)Uploadprogress
{
  //  hud.progress = progress=hud.progress+0.05;
    hud.progress=hud.progress+0.05;
//    if(hud.progress>1)
//        hud.progress=0;
}
-(void)loadApi
{
    if (isLoadingAPI) {
        return;
    }
    isLoadingAPI = TRUE;
  //  if(apiStatus)
    {
    loadingLBL.hidden=NO;
        if (hud) {
            [hud hideAnimated:NO afterDelay:0];

        }
        if (!responseDictionaryOld) {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                  hud.label.text = @"";
                  
                  hud.mode=MBProgressHUDModeText;
              hud.margin = 0.f;
                  hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
                  hud.removeFromSuperViewOnHide = YES;
                  [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                      hud.progress=hud.progress+0.05;
                      if(hud.progress>1)
                      {
                          [timer invalidate];
                      }
                  }];
            
        }
      


        
   
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];

//    NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];
//
      //  locationString=@"9.9312,76.2673";
      // locationString=@"25.2048,55.2708";


   // [reqData setObject:locationString forKey:@"location"];
    
    //        "location:10.5276416, 76.21443490000001
    //    selected_hours:24
    //    checkin_time:10:30
    //    checkin_date:2018-08-11
    //    number_rooms:1
    //    number_adults:3
    //    number_childs:1
    
    
    [self.view endEditing:YES];
        
    NSLog(@"Posting...");
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    
    //CIC
        
    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"main/v2/hotels-popular"] type:@"GET"];
    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"main/v2/hotels-cheapest"] type:@"GET"];
    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"main/v2/offers"] type:@"GET"];
    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"main/v2/cities"] type:@"POST"];
        
        
        
//    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"main/home"] type:@"GET"];
        
        
    }
    apiStatus=NO;
    isLoadingAPI =FALSE;
}

-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    // loadingLBL.text=@"There are no available rooms with your search criteria";
//    hud.progress = 1.0;
//hud.margin = 10.f;
//    hud.label.text = response;
//    [hud hideAnimated:YES afterDelay:2];
    
    hud.margin = 10.f;
    //hud.label.text = response;
    [hud hideAnimated:NO afterDelay:0];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=response;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    isLoadingAPI = FALSE;
}
-(void)webRawDataReceivedWithError:(NSString *)errorMessage
{
    // loadingLBL.text=@"There are no available rooms with your search criteria";
//
//    hud.progress = 1.0;
//
//    hud.label.text = errorMessage;
//    [hud hideAnimated:YES afterDelay:2];
  //  hud.margin = 10.f;
    //hud.label.text = response;
    if (hud) {
        [hud hideAnimated:NO afterDelay:0];

    }
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=errorMessage;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    isLoadingAPI = FALSE;
}



-(void)weatherApi:(double)latitude longitude:(double)longitude
{
    
    self.weatherImageView.hidden=YES;;
    
    self.degreeLBL.hidden=YES;
    self.celciousLBL.hidden=YES;
    
    self.valueLBL.hidden=YES;
    {
        // [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //Do UI stuff here

        NSString* urlString=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=d6061820d9e33cc1ef538f8cc7416e34&units=metric" ,latitude,longitude];

        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

        if(data!=nil)
        {
            NSError *localError = nil;

            NSDictionary *parsedObject;
            if (!parsedObject) {
                parsedObject =[[NSDictionary alloc]init];
            }

            parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];

            if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  )
            {




//                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",[[[parsedObject valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"icon"]]]];
//                self.weatherImageView.image = [UIImage imageWithData:imageData];
                self.valueLBL.text=[[[parsedObject valueForKey:@"main"] valueForKey:@"temp"] stringValue];
                //description
               
                
                self.weatherImageView.hidden=NO;;
                
                self.degreeLBL.hidden=NO;
                self.celciousLBL.hidden=NO;
                
                self.valueLBL.hidden=NO;
            }
            else
            {


            }
        }

        // }];

    }
}
-(void)setLocationImage
{
  return;
  NSString* pickedLocationName= [[NSUserDefaults standardUserDefaults] valueForKey:@"chkingstring"];
    
   // NSArray * firstArray=[pickedLocationName componentsSeparatedByString:@","];
    _topImageView.image=[UIImage imageNamed:@"panorama-default.png"];
    
//if(firstArray.count>0)
//{
//  NSArray * finalArray = [[firstArray objectAtIndex:0] componentsSeparatedByString:@" "];
//    if(finalArray.count>0)
//    {
//        pickedLocationName=[finalArray objectAtIndex:0];
//    }
//
//}
    for(NSDictionary* dic in cityArray)
    {
        
//        if([[cityArray objectAtIndex:indexPath.row] objectForKey:@"image"])
//        {
//
//
//            NSString*imgName=[[cityArray objectAtIndex:indexPath.row] objectForKey:@"image"];
//            NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
//            [popularCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder"]];
//        }
//        popularCell.nameLbl.text=[[cityArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        if([pickedLocationName containsString:[[dic valueForKey:@"name"] uppercaseString]])
        {
                    if([dic objectForKey:@"image"])
                    {
                        NSString*imgName=[dic objectForKey:@"image"];
                        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
                        [_topImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"panorama-default.png"]];
                    }
            break;
        }
        
    }
    
    _popularCollection.contentOffset=CGPointMake(0, 0);

}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    //CIC
    
    NSLog(@"kk--- %@",rawData);
    
    loadingLBL.hidden=YES;
    if (![rawData isEqualToDictionary:responseDictionaryOld]) {
        responseDictionaryOld = rawData;
        [nearByArray removeAllObjects];

        if ([rawData[@"cheapestProperties"] isKindOfClass:[NSDictionary class]]) {
            NSArray *list =rawData[@"cheapestProperties"][@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                [cheapestArray removeAllObjects];
                [cheapestArray addObjectsFromArray:list];
            }
        }
        
        if ([rawData[@"popularProperties"] isKindOfClass:[NSDictionary class]]) {
            NSArray *list =rawData[@"popularProperties"][@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                [popularByArray removeAllObjects];
                [popularByArray addObjectsFromArray:list];

            }
        }
        
        if ([rawData[@"cities"] isKindOfClass:[NSDictionary class]]) {
            NSArray *list =rawData[@"cities"][@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                [cityArray removeAllObjects];
                [cityArray addObjectsFromArray:list];

            }
        }
        if ([rawData[@"offers"] isKindOfClass:[NSDictionary class]]) {
            NSArray *list =rawData[@"offers"][@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                [offersArray removeAllObjects];
                [offersArray addObjectsFromArray:list];

            }
        }
      
        
        if([popularByArray count]>2)
        {
            bestPropertyHeight.constant=popHeight;
        }
        else if([popularByArray count]>=1)
        {
            bestPropertyHeight.constant=popHeight/2;
        }else
        {
            bestPropertyHeight.constant=20;

        }
        _popularCollection.contentOffset=CGPointMake(0, 0);
        [self addPins:0];
        [self.popularCollection reloadData];
        [self.cheapCollection reloadData];
        [self.cvOffersMore reloadData];

        [self.bestPropertiesCollection reloadData];
        _view3Ht.constant=bestPropertyHeight.constant+356+80;

      // _containerViewOfScrollViewHt.constant= _view1Ht.constant+_view2Ht.constant+_view3Ht.constant+_view4Ht.constant+40;
        
        
    //      _scrollView.contentSize=CGSizeMake(0,_containerViewOfScrollViewHt.constant-30);
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"pushClick"] isEqualToString:@"YES"])
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NotificationsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
            
            // vc.fromString=@"presentViewTab";
           // [self.navigationController pushViewController:vc animated:YES];
        }
        
        hud.progress = 1.0;
        _popularCollection.superview.hidden = FALSE;
        _cvOffersMore.superview.hidden = FALSE;
        _cvOffersMore.hidden = FALSE;

            _bestPropertiesCollection.superview.hidden = FALSE;
    }
  
   // [listingTBV reloadData];
    
    
    //CJC commented
    if (hud) {
        [hud hideAnimated:NO afterDelay:0];

    }

}
-(IBAction)backFunction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)searchHotelAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    {
        NSString* selecteddateString=[NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"], [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"]];
        NSString* currentdateString=[dateFormatter stringFromDate:[NSDate date]];
        
        if ([[dateFormatter dateFromString:selecteddateString] compare:[dateFormatter dateFromString:currentdateString]] == NSOrderedDescending) {
            
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
            ListHotelsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"ListHotelsViewController"];
            
            vc.selectionString=@"Search";
            NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
            
            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"] forKey:@"number_adults"];
            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"] forKey:@"number_rooms"];
            
            [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
            NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLat"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLongt"]];
            
         //   locationString=@"9.9312,76.2673";
          //  locationString=@"25.2048,55.2708";
            [[NSUserDefaults standardUserDefaults]setObject:[_weatherLbl.text uppercaseString] forKey:@"pickupLocationName"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [reqData setObject:locationString forKey:@"location"];
           // [reqData setObject:@"1" forKey:@"sort_rating"];

           // &sort_rating=1
            vc.searchDic=reqData;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Failed";
            vc.messageString=@"Searching with past date/time not allowed";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
        
        
    }

    
   
}

- (IBAction)seeOtherDatesAction:(id)sender {
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CalendarViewController *vc = [y   instantiateViewControllerWithIdentifier:@"CalendarViewController"];
    vc.providesPresentationContextTransitionStyle = YES;
    vc.definesPresentationContext = YES;
    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
- (IBAction)roomsOptionsAction:(id)sender {
    
    if(isOptionsCollectionShowing && !isTimeOrRooms){
       // isTimeOrRooms=NO;
        //   [_optionsCollection reloadData];
        
        [self optionsCollectionExpand];
        
    }else{
        isTimeOrRooms=NO;
        
        if(!isOptionsCollectionShowing)
        {
            
            [self optionsCollectionExpand];
        }
        [_optionsCollection reloadData];

        
    }
    
}

- (IBAction)timePickAction:(id)sender {
    //[_datePicker setHidden:NO];
    //[_pickTime setHidden:NO];
    
    if(isOptionsCollectionShowing && isTimeOrRooms){
        //isTimeOrRooms=YES;
        
        
        [self optionsCollectionExpand];
        
    }else{
        isTimeOrRooms=YES;
        
        if(!isOptionsCollectionShowing)
        {
            
            //[_optionsCollection reloadData];
            
            [self optionsCollectionExpand];
        }
        [_optionsCollection reloadData];

    }
    
}
//- (IBAction)roomsOptionsAction:(id)sender {
//    isTimeOrRooms=NO;
//    [_optionsCollection reloadData];
//    if(isOptionsCollectionShowing){
//
//    }else{
//        [self optionsCollectionExpand];
//    }
//
//}
//
//- (IBAction)timePickAction:(id)sender {
//    //[_datePicker setHidden:NO];
//    //[_pickTime setHidden:NO];
//    isTimeOrRooms=YES;
//    [_optionsCollection reloadData];
//    if(isOptionsCollectionShowing){
//
//    }else{
//         [self optionsCollectionExpand];
//    }
//
//}

-(void)optionsCollectionExpand{
    if(isOptionsCollectionShowing){
        [UIView animateWithDuration:3 animations:^{
            _optionsViewHt.constant=0;
            _optionsContainerHt.constant=_optionsContainerHt.constant-65;
            _view2Ht.constant=_view2Ht.constant-65;
        } completion:NULL];
        isOptionsCollectionShowing=NO;
    }
    else{
        [UIView animateWithDuration:3 animations:^{
            _optionsViewHt.constant=65;
            _optionsContainerHt.constant=_optionsContainerHt.constant+65;
            _view2Ht.constant=_view2Ht.constant+65;
        } completion:NULL];
        isOptionsCollectionShowing=YES;
    }
    
    _containerViewOfScrollViewHt.constant= _view1Ht.constant+_view2Ht.constant+_view3Ht.constant+_view4Ht.constant+40;
    [self.view layoutIfNeeded];
    
}


- (IBAction)pickAction:(id)sender {
    //[self setDate:_datePicker.date];
    //[_datePicker setHidden:YES];
    //[_pickTime setHidden:YES];
    
}

-(void)setDate:(NSString*)time{
    
    
    [timePicker setDateFormat:@"HH:mm"];

    NSDate*datePassed=[timePicker dateFromString:time];
    
    NSString*selectedTime1=[timePicker stringFromDate:datePassed];

    [timePicker setDateFormat:@"hh:mm"];
    NSString*selectedTime=[timePicker stringFromDate:datePassed];
    _timeLbl.text=selectedTime;
    
    [timePicker setDateFormat:@"hh:mm a"];
    NSString*amOrPm=[timePicker stringFromDate:datePassed];
    if([amOrPm containsString:@"AM"])
        _amPmLbl.text=@"AM";
    else
    {
        _amPmLbl.text=@"PM";
        
        
    }
    
    [timePicker setDateFormat:@"hh:mm"];
}

//-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    MKAnnotationView *pinView = nil;
//    if(annotation != _mapView.userLocation)
//    {
//        static NSString *defaultPinID = @"com.invasivecode.pin";
//        pinView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//        if ( pinView == nil )
//            pinView = [[MKAnnotationView alloc]
//                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
//
//        //pinView.pinColor = MKPinAnnotationColorGreen;
//        pinView.canShowCallout = YES;
//        //pinView.animatesDrop = YES;
//        pinView.image = [UIImage imageNamed:@"close"];    //as suggested by Squatch
//    }
//    else {
//        //[_mapView.userLocation setTitle:@"I am here"];
//        static NSString *defaultPinID = @"com.invasivecode.pin";
//        pinView = (MKAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//        if ( pinView == nil )
//            pinView = [[MKAnnotationView alloc]
//                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
//
//        pinView.canShowCallout = YES;
//        UIView*containerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40,40)];
//        [containerView setBackgroundColor:[UIColor clearColor]];
//        UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 40,40)];
//        imgView.image=[UIImage imageNamed:@"annotation"];
//       // UIImageView*hotelImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20,17, 40,40)];
//       // hotelImgView.image=[UIImage imageNamed:@"venice-italy.jpg"];
//       // hotelImgView.layer.cornerRadius=hotelImgView.frame.size.width/2;
//       // hotelImgView.clipsToBounds=YES;
//        [containerView addSubview:imgView];
//       // [containerView addSubview:hotelImgView];
//        [pinView addSubview:containerView];
//        //[containerView setBackgroundColor:[UIColor blueColor]];
//        //[imgView setBackgroundColor:[UIColor yellowColor]];
//        //[hotelImgView setBackgroundColor:[UIColor whiteColor]];
//
//    }
//    return pinView;
//}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
           // The user denied authorization
        isWsLoadedSuccesFully = FALSE;
        [self checkLocationServicesAndStartUpdates];

       }
       else  {
           // The user accepted authorization
           [locationManager requestLocation];

       }
    
   
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    
    NSString *lat =[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *lon =[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    //CJC 12 b [self weatherApi:location.coordinate.latitude longitude:location.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"currentLatitude"];
    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"currentLongitude"];
    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"mapLatitude"];
    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"mapLongitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self loadApi];

    MKCoordinateSpan span;
    span.latitudeDelta = .4f;
    span.longitudeDelta = .4f;
    MKCoordinateRegion region;
    region.center = _mapView.userLocation.coordinate;
    region.span = span;
    //[_mapView setRegion:region animated:TRUE];
    [_mapView setRegion:region];
    //[locationManager stopUpdatingLocation];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *LocationAtual=[[CLLocation alloc] initWithLatitude:location.coordinate.latitude
                                                         longitude:location.coordinate.longitude];
    
    NSLog(@"loc %@", LocationAtual);
    
    [ceo reverseGeocodeLocation:LocationAtual  completionHandler:^(NSArray *placemarks, NSError *error)
     {

         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         // NSDictionary *currentLocationDictionary = @{@"CLPlacemark":CLPlacemark};
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"addressDictionary %@", placemark.addressDictionary);
         
         NSLog(@"placemark %@",placemark.region);
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         NSLog(@"placemark %@",placemark.locality); // Extract the city name
         NSLog(@"location %@",placemark.name);
         NSLog(@"location %@",placemark.ocean);
         NSLog(@"location %@",placemark.postalCode);
         NSLog(@"location %@",placemark.subLocality);
         
         NSLog(@"location %@",placemark.location);
         
         MKCoordinateSpan span;
         span.latitudeDelta = .4f;
         span.longitudeDelta = .4f;
         MKCoordinateRegion region;
         region.center = _mapView.userLocation.coordinate;
         region.span = span;
         //[_mapView setRegion:region animated:TRUE];
         [_mapView setRegion:region];
         
          NSString *place =[NSString stringWithFormat:@"%@,%@",placemark.locality,placemark.country];
         [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"pickupLat"];
         [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"pickupLongt"];

         [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"currentLatitude"];
         [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"currentLongitude"];
        // locatedAt
         if(placemark!=nil)
         {
             
              [[NSUserDefaults standardUserDefaults]setObject:[locatedAt uppercaseString] forKey:@"chkingstring"];
         [[NSUserDefaults standardUserDefaults]setObject:[[NSString stringWithFormat:@"%@",placemark.locality]uppercaseString] forKey:@"pickupLocationName"];
         [[NSUserDefaults standardUserDefaults]setObject:[[NSString stringWithFormat:@"%@",placemark.locality]uppercaseString] forKey:@"currentLocationName"];
            // self.placeTxt.text=place;
          //   self.weatherLbl.text=[[NSString stringWithFormat:@"%@",placemark.locality] uppercaseString];
         }
         else
         {
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"pickupLocationName"];
             [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"currentLocationName"];
              [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"chkingstring"];
         }
         [[NSUserDefaults standardUserDefaults]synchronize];

        
         //userPlace=place;
        
         [locationManager stopUpdatingLocation];

     }
     ];
    

    //  [_map setRegion:region animated:true];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}
-(void)addPins:(NSInteger)tag
{
    propertyTag=0;
    
    
    
    
    for(NSDictionary* dicValue in nearByArray)
    {
        if([dicValue objectForKey:@"contactinfo"])
        {
            if([[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"])
                
            {
                
                if([[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] count]>1)
                {
                    MKPointAnnotation *mapPin1 = [[MKPointAnnotation alloc] init];
                    mapPin1.title=[NSString stringWithFormat:@"%ld",(long)propertyTag];
                    propertyTag++;
                    
                    // clear out any white space
                    
                    // convert string into actual latitude and longitude values
                    
                    double latitude1 = [[[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:0] doubleValue];
                    double longitude1 = [[[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:1] doubleValue];
                    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1);
                    
                  //  MKCoordinateSpan span;
                  //  span.latitudeDelta = .4f;
                   // span.longitudeDelta = .4f;
                   // MKCoordinateRegion region;
                   // region.center = coordinate1;
                   // region.span = span;
                    //[_mapView setRegion:region animated:TRUE];
                  //  [_mapView setRegion:region];
                    // setup the map pin with all data and add to map view
                    
                    mapPin1.coordinate = coordinate1;
                    
                    [self.mapView addAnnotation:mapPin1];
                }
                
            }
            
        }
        // propertyTag++;
    }
    
    
    
    
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation == _mapView.userLocation)
    {
        return nil;
        //        static NSString *defaultPinID = @"com.iROID.StayHopper";
        //        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        //        if ( pinView == nil )
        //            pinView = [[MKAnnotationView alloc]
        //                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        //
        //        //pinView.pinColor = MKPinAnnotationColorGreen;
        //        pinView.canShowCallout = NO;
        //        //pinView.animatesDrop = YES;
        //        pinView.image = [UIImage imageNamed:@"close"];    //as suggested by Squatch
    }
    else {
        
        static NSString *defaultPinID = @"com.iROID.StayHopper";
        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = NO;
        pinView.userInteractionEnabled=YES;
        pinView.enabled=YES;
        // UIButton* mapButton=[UIButton buttonWithType:UIButtonTypeCustom];
        // [mapButton setBackgroundColor:[UIColor blueColor]];
        UIView*containerView=[[UIView alloc]initWithFrame:CGRectMake(-8, -10, 40,40)];
        //  mapButton.frame=containerView.frame;
        //  [mapButton addTarget:self action:@selector(clickFunction:) forControlEvents:UIControlEventTouchUpInside];
        containerView.tag=[annotation.title integerValue];
        // mapButton.enabled=YES;
        // mapButton.userInteractionEnabled=YES;
        propertyTag++;
        [containerView setBackgroundColor:[UIColor clearColor]];
        UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 40,40)];
        imgView.image=[UIImage imageNamed:@"annotation"];
        // UIImageView*hotelImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20,17, 40,40)];
        // hotelImgView.image=[UIImage imageNamed:@"venice-italy.jpg"];
        // hotelImgView.layer.cornerRadius=hotelImgView.frame.size.width/2;
        //  hotelImgView.clipsToBounds=YES;
        [containerView addSubview:imgView];
        //  [containerView addSubview:hotelImgView];
        // [containerView addSubview:mapButton];
        containerView.userInteractionEnabled=YES;
        // pinView.rightCalloutAccessoryView = mapButton;
        //pinView.annotation.title=@"test";
        pinView.image=[UIImage imageNamed:@"annotation"];
        [pinView addSubview:containerView];
        //[containerView setBackgroundColor:[UIColor blueColor]];
        //[imgView setBackgroundColor:[UIColor yellowColor]];
        //[hotelImgView setBackgroundColor:[UIColor whiteColor]];
        
    }
    return pinView;
}

-(IBAction)popularPropertiesViewAll:(id)sender
{
    //CJC
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopularPropertiesViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PopularPropertiesViewController"];
    vc.popularPropertiesArray = popularByArray;
    vc.isCheapest = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)cheapPropertiesViewAll:(id)sender
{
    //CJC
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PopularPropertiesViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PopularPropertiesViewController"];
    vc.popularPropertiesArray = cheapestArray;
    vc.isCheapest = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    ListHotelsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"ListHotelsViewController"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate*currentDate=[NSDate date];
    NSString*nextDayString;
    nextDayString=[dateFormatter stringFromDate:currentDate];
    // [datesArr addObject:nextDay];
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRooms)   name:@"reloadRooms" object:nil];
    
    [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
    
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"] forKey:@"number_adults"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"] forKey:@"number_rooms"];
    
    [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
    
//    NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLat"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLongt"]];
    
     NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];
    

    // locationString=@"9.9312,76.2673";
   // locationString=@"25.2048,55.2708";
 
    [[NSUserDefaults standardUserDefaults]setObject:[_weatherLbl.text uppercaseString] forKey:@"pickupLocationName"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    [reqData setObject:locationString forKey:@"location"];
    
    vc.searchDic=reqData;
    vc.selectionString=@"Near";
    [self.navigationController pushViewController:vc animated:YES];
  
    
    //here you action
}

/*- (void)mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views{
 if (views.count > 0){
 UIView* tView = [views objectAtIndex:0];
 
 UIView* parView = [tView superview];
 UIView* overlay = [tView viewWithTag:2000];
 if (overlay == nil){
 //overlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"venice-italy.jpg"]];
 overlay.frame = parView.frame; //frame equals to (0,0,16384,16384)
 overlay.tag = 2000;
 overlay.alpha = 0.7;
 [parView addSubview:overlay];
 }
 
 for (UIView* view in views)
 [parView bringSubviewToFront:view];
 }
 }
 */
-(IBAction)notificationFunction:(id)sender
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NotificationsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
    
    // vc.fromString=@"presentViewTab";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
