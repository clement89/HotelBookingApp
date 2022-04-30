//
//  AvailabilityViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "AvailabilityViewController.h"
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
#import "SinglePropertyDetailsViewController.h"
#import "PropertyDetailsViewController.h"
#import "MessageViewController.h"
#import "StayDateTimeViewController.h"

@interface AvailabilityViewController()<APIPostingDelegate>{
    ApiCalling *ac;
    DiscoverCollectionViewCell*cell;
    IBOutlet NSLayoutConstraint *bestPropertyHeight;
    IBOutlet NSLayoutConstraint *citiesHeight;
    CalendarDiscoverCollectionViewCell*calendar;
    OptionsCollectionViewCell*optionsCell;
    NSArray*optionsArr,*timingIntervalArr;
    
    NSMutableArray*slotsArr;
    
    NSMutableArray*daysWordsArr,*daysNumArr,*datesArr;
    NSInteger selectedDayIndex,selectedSlotIndex,selectedTimeSlotIndex;
    BOOL isOptionsCollectionShowing,isTimeOrRooms;
    NSDateFormatter *timePicker;
    CLLocationManager *locationManager;
    
}

@end

@implementation AvailabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    slotsArr=[[NSMutableArray alloc]init];
  //  optionsArr=[[NSArray alloc]init];
timingIntervalArr=[[NSArray alloc]initWithObjects:@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30", nil];    daysWordsArr=[[NSMutableArray alloc]init];
    daysNumArr=[[NSMutableArray alloc]init];
    datesArr=[[NSMutableArray alloc]init];
    popularByArray=[[NSMutableArray alloc]init];
    cityArray=[[NSMutableArray alloc]init];
    nearByArray=[[NSMutableArray alloc]init];
    apiStatus=YES;
    
    if([self.locationDic objectForKey:@"timeslots"])
    for(NSString *sloatValue in [self.locationDic objectForKey:@"timeslots"])
    {
        [slotsArr addObject:[NSString stringWithFormat:@"%@h",sloatValue]];
    }
    
    if(slotsArr.count==0)
    {
       // slotsArr=@[@"3h",@"6h",@"12h",@"24h"];
        [slotsArr addObjectsFromArray:@[@"3h",@"6h",@"12h",@"24h"]];
    }
    
  //  slotsArr=self.timeSloatArray;
    
    if(slotsArr.count!=0)
    [[NSUserDefaults standardUserDefaults]setObject:[slotsArr objectAtIndex:0] forKey:@"selectedSloat"];
    else
        [[NSUserDefaults standardUserDefaults]setObject:@"3h" forKey:@"selectedSloat"];
    optionsArr=[[NSArray alloc]initWithObjects:@"Rooms",@"Adults",@"Children", nil];
//    timingIntervalArr= @[@"00:00",@"00:30",@"01:00",@"01:30",@"02:00",@"02:30",@"03:00",@"03:30",@"04:00",@"04:30",@"05:00",@"05:30",@"06:00",@"06:30",@"07:00",@"07:30",@"08:00",@"08:30",@"09:00",@"09:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00",@"22:30",@"23:00",@"23:30"];
    [[NSUserDefaults standardUserDefaults]setObject:@"09:30" forKey:@"selectedTime"];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"selectedRooms"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"selectedChild"];
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"selectedAdults"];
    
    
    
    propertyNameLBL.text=[self.locationDic valueForKey:@"name"];
    
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
    
    if(nextDateVal)
    {
        
        NSString* nextSTRINGVALUE=[dateFormatter stringFromDate:nextDay];
        
        [[NSUserDefaults standardUserDefaults]setObject:nextSTRINGVALUE forKey:@"selectedDate"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
        
    }    [[NSUserDefaults standardUserDefaults]synchronize];
    [self dateLBLFuncrion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateLBLFuncrionOne)   name:@"reloadDateLBL" object:nil];
    // [datesArr removeObjectAtIndex:1];
    
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
    
    _placeSelectionView.layer.cornerRadius=8;
    _placeSelectionView.clipsToBounds=YES;
    
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
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestLocation];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    _mapView.showsUserLocation=YES;
    [_mapView setMapType:MKMapTypeStandard];
    [self loadLocation];
    
}
-(void)loadLocation
{
    locationName.text=[self.locationDic valueForKey:@"name"];
    if([self.locationDic objectForKey:@"image"])
    {
        
        if([self.locationDic objectForKey:@"image"] >0)
        {
            NSString*imgName=[self.locationDic objectForKey:@"image"];
            NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
            [locationPic sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
        }
    }
}
-(void)reloadRooms
{
    
    
    /*
     NSString *roomsString=@"ROOM";
     NSString *adultsString=@"ADULT";
     NSString *childString=@"CHILD";
     
     if(roomsCount>1)
     {
     roomsString=@"ROOMS";
     }
     if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue]>1)
     {
     adultsString=@"ADULTS";
     }
     if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"] integerValue]>1)
     {
     childString=@"CHILDREN'S";
     }
     */
   
     NSString *roomsString=@"Room";
     NSString *adultsString=@"Adult";
    // NSString *childString=@"Child";
     
//     if(roomsCount>1)
//     {
//     roomsString=@"ROOMS";
//     }
     if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue]>1)
     {
     adultsString=@"Adults";
     }
     if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"] integerValue]>1)
     {
     roomsString=@"Rooms";
     }
    
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
    //        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    //        acController.delegate = self;
    //        [self.navigationController presentViewController:acController animated:YES completion:nil];
}

//- (void)viewController:(GMSAutocompleteViewController *)viewController
//didAutocompleteWithPlace:(GMSPlace *)place {
//    // Do something with the selected place.
//    NSLog(@"Place name %@", place.name);
//    NSLog(@"Place address %@", place.formattedAddress);
//    NSLog(@"Place attributions %@", place.attributions.string);
//
//    NSString *lat =[NSString stringWithFormat:@"%f",place.coordinate.latitude];
//    NSString *lon =[NSString stringWithFormat:@"%f",place.coordinate.longitude];
//    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"pickupLat"];
//    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"pickupLongt"];
//    NSString *placeString =[NSString stringWithFormat:@"%@",place.formattedAddress];
//    [[NSUserDefaults standardUserDefaults]setObject:placeString forKey:@"pickupLocationName"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    self.placeTxt.text=placeString;
//    [self dismissViewControllerAnimated:YES completion:nil];
//    //[self.mapView addSubview:placePicker.view];
//
//
//}

//- (void)viewController:(GMSAutocompleteViewController *)viewController
//didFailAutocompleteWithError:(NSError *)error {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    // TODO: handle the error.
//    NSLog(@"Error: %@", [error description]);
//}
//
//    // User canceled the operation.
//- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//    // Turn the network activity indicator on and off again.
//- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//}
//
//- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//}
//
//
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PlacePickerViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PlacePickerViewController"];
//    vc.providesPresentationContextTransitionStyle = YES;
//    vc.definesPresentationContext = YES;
//    [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    [self.view endEditing:YES];
//    return YES;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    /*if(textField==self.confirmPassword)
//     {
//     NSString*str= [textField.text stringByReplacingCharactersInRange:range withString:string];
//     BOOL showAlert=NO;
//     NSString*msg;
//     if(self.confirmPassword.text.length>=self.password.text.length)
//     {
//     if([self.password.text isEqualToString:str])
//     {
//
//     }
//     else{
//     showAlert=YES;
//     msg=@"Passwords do not match";
//     if(selectedLang)
//     {
//     msg=@"";
//     }
//     }
//
//     if(showAlert){
//     showAlert=NO;
//     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//     hud.mode = MBProgressHUDModeText;
//     hud.label.text = msg;
//     hud.mode=MBProgressHUDModeText;
 //   hud.margin = 0.f;
//     hud.yOffset = 200.f;
//     hud.removeFromSuperViewOnHide = YES;
//     hud.userInteractionEnabled=YES;
//     [hud hideAnimated:YES afterDelay:2];
//     }
//     }
//     }*/
//
//    return YES;
//}



- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
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
    
    
    return 3;
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if(collectionView==_optionsCollection){
//        if(isTimeOrRooms)
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
//cell.transform = CGAffineTransformMakeTranslation(100.f, 100);
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//
//    //2. Define the final state (After the animation) and commit the animation
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.3];
//    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView==_slotCollection){
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoverCollectionViewCell" forIndexPath:indexPath];
       
        if(selectedSlotIndex==indexPath.item){
            cell.slotView.backgroundColor=[UIColor colorWithRed:245/255.0f green:30/255.0f blue:54/255.0f alpha:1];
            cell.slotView.layer.borderColor=[UIColor colorWithRed: 0.718 green: 0.831 blue: 0.867 alpha:0].CGColor;
        }
        else{
            cell.slotView.backgroundColor=[UIColor clearColor];
            cell.slotView.layer.borderColor=[UIColor colorWithRed: 0.718 green: 0.831 blue: 0.867 alpha:1].CGColor;
        }
        cell.slotLbl.text=[slotsArr objectAtIndex:indexPath.item];
        
        return cell;
        
    }
    else if(collectionView==_calenderCollection){
        calendar=[collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarDiscoverCollectionViewCell" forIndexPath:indexPath];
        calendar.dayNum.text=[daysNumArr objectAtIndex:indexPath.item];
        
        if(selectedDayIndex==indexPath.item){
            calendar=[collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarDiscoverCollectionViewCell1" forIndexPath:indexPath];
            calendar.selectedDay.text=[daysNumArr objectAtIndex:indexPath.item];
        }
        
        calendar.dayWords.text=[daysWordsArr objectAtIndex:indexPath.item];
        
        
        
        return calendar;
    }
    else {
        if(isTimeOrRooms)
        {
            optionsCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"OptionsCollectionViewCell1" forIndexPath:indexPath];
            
            optionsCell.timeLbl.text=[timingIntervalArr objectAtIndex:indexPath.item];
            
            if(selectedTimeSlotIndex==indexPath.item){
                optionsCell.timebgImageView.backgroundColor=[UIColor colorWithRed:245/255.0f green:30/255.0f blue:54/255.0f alpha:1];
                optionsCell.timebgImageView.layer.borderColor=[UIColor colorWithRed: 0.718 green: 0.831 blue: 0.867 alpha:0].CGColor;
            }
            else{
                optionsCell.timebgImageView.backgroundColor=[UIColor clearColor];
                optionsCell.timebgImageView.layer.borderColor=[UIColor colorWithRed: 0.718 green: 0.831 blue: 0.867 alpha:1].CGColor;
            }
            
            
        }
        else{
            optionsCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"OptionsCollectionViewCell" forIndexPath:indexPath];
            
            optionsCell.optionName.text=[optionsArr objectAtIndex:indexPath.item];
            optionsCell.subtract.tag=indexPath.item;
            optionsCell.add.tag=indexPath.item;
            if(indexPath.item==0)
            {
                optionsCell.optionSelected.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"];
            }else if(indexPath.item==1)
            {
                optionsCell.optionSelected.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"];
            }else if(indexPath.item==2)
            {
                optionsCell.optionSelected.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"];
            }
        }
        
        return optionsCell;
    }//PopularCollectionViewCell
    
    
    
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

            //[self optionsCollectionExpand];
            
        }
        else{
            
        }
        
        
    }
    else if(collectionView==_popularCollection){
        
    }
    else if(collectionView==_bestPropertiesCollection){
        
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
    
    
    
    
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.height);
    
}

-(void)timeConversion:(NSString*)time{
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    // [locationManager startUpdatingLocation];
    
    _containerViewOfScrollViewHt.constant= _view1Ht.constant+_view2Ht.constant+_view3Ht.constant+_view4Ht.constant+40;
    _scrollView.contentSize=CGSizeMake(0,_containerViewOfScrollViewHt.constant);
    [self setDate:[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedTime"]];

    
}

-(void)loadApi
{
    
    //    if(apiStatus)
    //    {
    //    loadingLBL.hidden=NO;
    //
    //    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //    hud.label.text = @"Loading";
    //
    //    hud.mode=MBProgressHUDModeText;
 //   hud.margin = 0.f;
    //    hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
    //    hud.removeFromSuperViewOnHide = YES;
    //    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    //
    //    NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];
    //
    //        locationString=@"9.9312,76.2673";
    //
    //
    //   // [reqData setObject:locationString forKey:@"location"];
    //
    //    //        "location:10.5276416, 76.21443490000001
    //    //    selected_hours:24
    //    //    checkin_time:10:30
    //    //    checkin_date:2018-08-11
    //    //    number_rooms:1
    //    //    number_adults:3
    //    //    number_childs:1
    //
    //
    //    [self.view endEditing:YES];
    //
    //    RequestUtil *util = [[RequestUtil alloc]init];
    //    util.webDataDelegate=(id)self;
    //    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"properties/homedata?location=%@",locationString] type:@"GET"];
    //    }
    //    apiStatus=NO;
}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    //    loadingLBL.hidden=YES;
    //
    //    [hud hideAnimated:YES afterDelay:0];
    //    [cityArray removeAllObjects];
    //    [popularByArray removeAllObjects];
    //    [nearByArray removeAllObjects];
    //
    //    if([rawData objectForKey:@"data"])
    //    {
    //        if([[rawData objectForKey:@"data"] objectForKey:@"cities"])
    //        for(NSDictionary* dicValue in [[rawData objectForKey:@"data"] objectForKey:@"cities"])
    //        {
    //            [cityArray addObject:dicValue];
    //        }
    //        if([[rawData objectForKey:@"data"] objectForKey:@"nearby"])
    //            for(NSDictionary* dicValue in [[rawData objectForKey:@"data"] objectForKey:@"nearby"])
    //            {
    //                [nearByArray addObject:dicValue];
    //            }
    //        if([[rawData objectForKey:@"data"] objectForKey:@"popular"])
    //            for(NSDictionary* dicValue in [[rawData objectForKey:@"data"] objectForKey:@"popular"])
    //            {
    //                [popularByArray addObject:dicValue];
    //            }
    //
    //
    //    }
    //    else
    //    {
    //       // loadingLBL.hidden=NO;
    //        //loadingLBL.text=@"There are no available rooms with your search criteria";
    //
    //    }
    //
    //
    //    if([popularByArray count]>2)
    //    {
    //    }
    //    else if([popularByArray count]>=1)
    //    {
    //        bestPropertyHeight.constant=_popularCollection.frame.size.height/2;
    //    }else
    //    {
    //        bestPropertyHeight.constant=20;
    //
    //    }
    //
    //    [self addPins:0];
    //    [self.popularCollection reloadData];
    //    [self.bestPropertiesCollection reloadData];
    // [listingTBV reloadData];
}
-(IBAction)backFunction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    // loadingLBL.text=@"There are no available rooms with your search criteria";
//    hud.margin = 10.f;
//    hud.label.text = response;
//    [hud hideAnimated:YES afterDelay:2];
    hud.margin = 10.f;
    //hud.label.text = response;
    [hud hideAnimated:YES afterDelay:0];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=response;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    
    
}
-(void)webRawDataReceivedWithError:(NSString *)errorMessage
{
    // loadingLBL.text=@"There are no available rooms with your search criteria";
    hud.margin = 10.f;
    //hud.label.text = response;
    [hud hideAnimated:YES afterDelay:0];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=errorMessage;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
}


-(void)viewDidLayoutSubviews{
    
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
            DurationSelectionViewController *sd =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
            sd.placeName = @"";
            sd.latitude = @"";
            sd.longitude = @"";
            sd.formattedAddress = @"";
           // sd.isMonthlySelected = false;
            sd.cityIdString =@"";
            sd.selectionString = @"";
            sd.isHotelSelected = TRUE;
            sd.selectedHotel = self.locationDic;
            [self.navigationController pushViewController:sd animated:TRUE];
            //TODO: OLD FLOW
            return;
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PropertyDetailsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
            NSString* loadingString;
            
            if([self.pastVal isEqualToString:@"YES"])
            {
            loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[self.locationDic valueForKey:@"id"]];
                vc.pastString=@"YES";

            }else
            {
                loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[self.locationDic valueForKey:@"_id"]];
                vc.pastString=@"NO";

                
            }
            
           
            vc.selectedProperty=self.locationDic;
            vc.selectionString=loadingString;
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

    
    
//    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    ListHotelsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"ListHotelsViewController"];
//
//
//    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
//
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"] forKey:@"number_adults"];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"] forKey:@"number_rooms"];
//
//    [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
//
//    // NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLat"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLongt"]];
//
//    // locationString=@"9.9312,76.2673";
//    [[NSUserDefaults standardUserDefaults]setObject:[self.locationDic valueForKey:@"name"] forKey:@"pickupLocationName"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//
//    //
//    //         [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"currentLatitude"];
//    //         [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"currentLongitude"];
//    //         [[NSUserDefaults standardUserDefaults]synchronize];
//
//    [reqData setObject:[self.locationDic valueForKey:@"_id"] forKey:@"city"];
//
//    vc.searchDic=reqData;
//    [self.navigationController pushViewController:vc animated:YES];
    
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
        isTimeOrRooms=NO;
        //   [_optionsCollection reloadData];
        
        [self optionsCollectionExpand];
        
    }else{
        isTimeOrRooms=NO;
        
        if(!isOptionsCollectionShowing)
        {
            
            [self optionsCollectionExpand];
        }
        
    }
    [_optionsCollection reloadData];
    
}

- (IBAction)timePickAction:(id)sender {
    //[_datePicker setHidden:NO];
    //[_pickTime setHidden:NO];
    
    if(isOptionsCollectionShowing && isTimeOrRooms){
        isTimeOrRooms=YES;
        
        
        [self optionsCollectionExpand];
        
    }else{
        isTimeOrRooms=YES;
        
        if(!isOptionsCollectionShowing)
        {
            
            //[_optionsCollection reloadData];
            
            [self optionsCollectionExpand];
        }
    }
    [_optionsCollection reloadData];
    
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
//        [self optionsCollectionExpand];
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
    [timePicker setDateFormat:@"hh:mm"];
    NSString*selectedTime=[timePicker stringFromDate:datePassed];
    _timeLbl.text=selectedTime;
    
    [timePicker setDateFormat:@"hh:mm a"];
    NSString*amOrPm=[timePicker stringFromDate:datePassed];
    if([amOrPm containsString:@"AM"])
        _amPmLbl.text=@"AM";
    else
        _amPmLbl.text=@"PM";
    
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
    // [locationManager requestLocation];
    //if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    //   [locationManager requestLocation];
    // }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //    CLLocation *location = [locations firstObject];
    //
    //    NSString *lat =[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    //    NSString *lon =[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    //    [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"currentLatitude"];
    //    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"currentLongitude"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    //    [self loadApi];
    //
    //    MKCoordinateSpan span;
    //    span.latitudeDelta = .4f;
    //    span.longitudeDelta = .4f;
    //    MKCoordinateRegion region;
    //    region.center = _mapView.userLocation.coordinate;
    //    region.span = span;
    //    //[_mapView setRegion:region animated:TRUE];
    //    [_mapView setRegion:region];
    //    //[locationManager stopUpdatingLocation];
    //    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    //    CLLocation *LocationAtual=[[CLLocation alloc] initWithLatitude:location.coordinate.latitude
    //                                                         longitude:location.coordinate.longitude];
    //
    //    NSLog(@"loc %@", LocationAtual);
    //
    //    [ceo reverseGeocodeLocation:LocationAtual  completionHandler:^(NSArray *placemarks, NSError *error)
    //     {
    //
    //         CLPlacemark *placemark = [placemarks objectAtIndex:0];
    //
    //         // NSDictionary *currentLocationDictionary = @{@"CLPlacemark":CLPlacemark};
    //         NSLog(@"placemark %@",placemark);
    //         //String to hold address
    //         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    //         NSLog(@"addressDictionary %@", placemark.addressDictionary);
    //
    //         NSLog(@"placemark %@",placemark.region);
    //         NSLog(@"placemark %@",placemark.country);  // Give Country Name
    //         NSLog(@"placemark %@",placemark.locality); // Extract the city name
    //         NSLog(@"location %@",placemark.name);
    //         NSLog(@"location %@",placemark.ocean);
    //         NSLog(@"location %@",placemark.postalCode);
    //         NSLog(@"location %@",placemark.subLocality);
    //
    //         NSLog(@"location %@",placemark.location);
    //
    //         MKCoordinateSpan span;
    //         span.latitudeDelta = .4f;
    //         span.longitudeDelta = .4f;
    //         MKCoordinateRegion region;
    //         region.center = _mapView.userLocation.coordinate;
    //         region.span = span;
    //         //[_mapView setRegion:region animated:TRUE];
    //         [_mapView setRegion:region];
    //
    //          NSString *place =[NSString stringWithFormat:@"%@,%@",[placemark.addressDictionary valueForKey:@"SubAdministrativeArea" ],[placemark.addressDictionary valueForKey:@"State" ]];
    //         [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"pickupLat"];
    //         [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"pickupLongt"];
    //         [[NSUserDefaults standardUserDefaults]setObject:place forKey:@"pickupLocationName"];
    //
    //         [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"currentLatitude"];
    //         [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"currentLongitude"];
    //         [[NSUserDefaults standardUserDefaults]synchronize];
    //
    //         self.placeTxt.text=place;
    //         self.weatherLbl.text=place;
    //         //userPlace=place;
    //
    //         [locationManager stopUpdatingLocation];
    //
    //     }
    //     ];
    //
    
    //  [_map setRegion:region animated:true];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}
-(void)addPins:(NSInteger)tag
{
    //    propertyTag=0;
    //
    //    for(NSDictionary* dicValue in nearByArray)
    //    {
    //        if([dicValue objectForKey:@"contactinfo"])
    //        {
    //            if([[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"])
    //
    //            {
    //
    //                if([[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] count]>1)
    //                {
    //                    MKPointAnnotation *mapPin1 = [[MKPointAnnotation alloc] init];
    //
    //                    // clear out any white space
    //
    //                    // convert string into actual latitude and longitude values
    //
    //                    double latitude1 = [[[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:0] doubleValue];
    //                    double longitude1 = [[[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:1] doubleValue];
    //                    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1);
    //
    //                    MKCoordinateSpan span;
    //                    span.latitudeDelta = .4f;
    //                    span.longitudeDelta = .4f;
    //                    MKCoordinateRegion region;
    //                    region.center = coordinate1;
    //                    region.span = span;
    //                    //[_mapView setRegion:region animated:TRUE];
    //                    [_mapView setRegion:region];
    //                    // setup the map pin with all data and add to map view
    //
    //                    mapPin1.coordinate = coordinate1;
    //
    //                    [self.mapView addAnnotation:mapPin1];
    //                }
    //
    //            }
    //
    //        }
    //        // propertyTag++;
    //    }
    //
    //
    //
    
    
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    //    if(annotation == _mapView.userLocation)
    //    {
    //        return nil;
    //        //        static NSString *defaultPinID = @"com.iROID.StayHopper";
    //        //        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    //        //        if ( pinView == nil )
    //        //            pinView = [[MKAnnotationView alloc]
    //        //                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    //        //
    //        //        //pinView.pinColor = MKPinAnnotationColorGreen;
    //        //        pinView.canShowCallout = NO;
    //        //        //pinView.animatesDrop = YES;
    //        //        pinView.image = [UIImage imageNamed:@"close"];    //as suggested by Squatch
    //    }
    //    else {
    //
    //        static NSString *defaultPinID = @"com.iROID.StayHopper";
    //        pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    //        if ( pinView == nil )
    //            pinView = [[MKAnnotationView alloc]
    //                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    //
    //        pinView.canShowCallout = NO;
    //        pinView.userInteractionEnabled=YES;
    //        pinView.enabled=YES;
    //        // UIButton* mapButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //        // [mapButton setBackgroundColor:[UIColor blueColor]];
    //        UIView*containerView=[[UIView alloc]initWithFrame:CGRectMake(-8, -10, 40,40)];
    //        //  mapButton.frame=containerView.frame;
    //        //  [mapButton addTarget:self action:@selector(clickFunction:) forControlEvents:UIControlEventTouchUpInside];
    //        containerView.tag=propertyTag;
    //        // mapButton.enabled=YES;
    //        // mapButton.userInteractionEnabled=YES;
    //        propertyTag++;
    //        [containerView setBackgroundColor:[UIColor clearColor]];
    //        UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 40,40)];
    //        imgView.image=[UIImage imageNamed:@"annotation"];
    //        // UIImageView*hotelImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20,17, 40,40)];
    //        // hotelImgView.image=[UIImage imageNamed:@"venice-italy.jpg"];
    //        // hotelImgView.layer.cornerRadius=hotelImgView.frame.size.width/2;
    //        //  hotelImgView.clipsToBounds=YES;
    //        [containerView addSubview:imgView];
    //        //  [containerView addSubview:hotelImgView];
    //        // [containerView addSubview:mapButton];
    //        containerView.userInteractionEnabled=YES;
    //        // pinView.rightCalloutAccessoryView = mapButton;
    //        //pinView.annotation.title=@"test";
    //        pinView.image=[UIImage imageNamed:@"annotation"];
    //        [pinView addSubview:containerView];
    //        //[containerView setBackgroundColor:[UIColor blueColor]];
    //        //[imgView setBackgroundColor:[UIColor yellowColor]];
    //        //[hotelImgView setBackgroundColor:[UIColor whiteColor]];
    //
    //    }
    return pinView;
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
-(IBAction)popularPropertiesViewAll:(id)sender
{
    //    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    PopularPropertiesViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PopularPropertiesViewController"];
    //    [self.navigationController pushViewController:vc animated:YES];
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
@end

