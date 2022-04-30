//
//  BookingsViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "BookingsViewController.h"
#import "BookingTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BookingDetailsViewController.h"
#import "LoginViewController.h"
#import "InitialViewController.h"
#import "MessageViewController.h"
#import "ReebookingViewController.h"
#import "ListHostelsTableViewCell.h"
#import "BookingDetailsNewViewController.h"
#import "DVSwitch.h"
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

@interface BookingsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BookingTableViewCell *cell;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatter2;
    BOOL loginAlertShowed;

}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *_btnLogin;
@property (weak, nonatomic) IBOutlet UIView *switchHeader;
@property (weak, nonatomic) IBOutlet UISegmentedControl

*segmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightValue;
@property (strong, nonatomic) DVSwitch *switcher;

@end

@implementation BookingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    alredyLoaded=NO;
    

        
        _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
        _lblTitle.superview.layer.shadowOpacity = 0.3;
        _lblTitle.superview.layer.shadowRadius = 2.0;
        _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
        _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
        _lblTitle.textColor = kColorDarkBlueThemeColor;
    UIFont *font = [UIFont fontWithName:FontRegular size:16];
    NSDictionary *attributesNormal =@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithRed:0.102 green:0.118 blue:0.4 alpha:0.5]};
    NSDictionary *attributesSelected =@{NSFontAttributeName:font,NSForegroundColorAttributeName:kColorDarkBlueThemeColor};

    [_segmentControl setTitleTextAttributes:attributesNormal
                                    forState:UIControlStateNormal];
    [_segmentControl setTitleTextAttributes:attributesSelected
                                    forState:UIControlStateSelected];

  
        self.view.backgroundColor = kColorProfilePages;//CJC changed kColorCommonBG
        listingTableView.backgroundColor = self.view.backgroundColor;
    
  //  listingTableView.backgroundColor = [UIColor redColor];

    _segmentControl.superview.backgroundColor =[UIColor clearColor];

    UIColor *borderr = UIColorFromRGB(0xb0b0b0);
  //  _segmentControl.backgroundColor = [UIColor clearColor];
    
    _segmentControl.superview.clipsToBounds  =TRUE;
    _segmentControl.superview.layer.cornerRadius = _segmentControl.superview.frame.size.height/2.0;
//    _segmentControl.layer.borderColor = borderr.CGColor;
  //  _segmentControl.layer.borderWidth = 0.75;
    self.segmentControl.tintColor = [UIColor whiteColor];

    if (@available(iOS 13.0, *)) {
    _segmentControl.selectedSegmentTintColor = [UIColor whiteColor];
    } else {

        // Fallback on earlier versions
    }

    
    loginAlertShowed = NO;

    
        
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    timePicker= [[NSDateFormatter alloc]init];

  
    dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MMM dd"];
    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
  //   utilObj = [[RequestUtil alloc]init];
    selectedIndex=@"Current";
    alredyCALLED=YES;
    currentBookingArray=[[NSMutableArray alloc]init];
    pastBookingArray=[[NSMutableArray alloc]init];
    cuurentBtn.layer.cornerRadius=5.0;
    pastBtn.layer.cornerRadius=5.0;
    [pastBtn setBackgroundColor:[UIColor clearColor]];
    [cuurentBtn setBackgroundColor:[UIColor whiteColor] ];
    [cuurentBtn setTitleColor:[UIColor colorWithRed:11/255.0f green:23/255.0f blue:76/256.f alpha:1.0] forState:UIControlStateNormal];
    [pastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [defaults setValue:[userInfo objectForKey:@"book_id"] forKey:@"book_id"];

    

    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookingDone)   name:@"bookingDone1" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookingDone1)   name:@"bookingDone2" object:nil];
    [self segmentButtonClikd:_segmentControl];
    _segmentControl.hidden = TRUE;
    self.switcher = [[DVSwitch alloc] initWithStringsArray:@[@"Upcoming", @"Past"]];
    self.switcher.frame = _segmentControl.frame;
    self.switcher.font = font;
    self.switcher.cornerRadius = self.switcher.frame.size.height/2.;
   
    self.switcher.backgroundColor = [UIColor colorWithRed:0.757 green:0.784 blue:0.859 alpha:0.3];
    self.switcher.sliderColor = [UIColor whiteColor];
    self.switcher.labelTextColorInsideSlider = kColorDarkBlueThemeColor;
    self.switcher.labelTextColorOutsideSlider = [UIColor colorWithRed:0.102 green:0.118 blue:0.4 alpha:0.5];

    
    [_segmentControl.superview addSubview:self.switcher];
    __weak BookingsViewController *weakSelf = self;
    [self.switcher setPressedHandler:^(NSUInteger index) {
       
        NSLog(@"Did press position on first switch at index: %lu", (unsigned long)index);
        weakSelf.segmentControl.selectedSegmentIndex = index;
        [weakSelf segmentButtonClikd:weakSelf.segmentControl];

        
    }];
    
    
}
- (void)viewDidLayoutSubviews
{
    self.switcher.frame = _segmentControl.frame;

}
-(void)bookingDone1
{
    
    
    if(self.navigationController.viewControllers.count>1)
    {
        self.navigationController.viewControllers = [[NSMutableArray alloc] initWithObjects: self.navigationController.viewControllers.firstObject,nil];
    }
    
}
-(void)bookingDone
{
  
    
    if(self.navigationController.viewControllers.count>1)
    {
    self.navigationController.viewControllers = [[NSMutableArray alloc] initWithObjects: self.navigationController.viewControllers.firstObject,nil];
    
    }
    NSString* tempString=@"Current";
    if( [[[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] uppercaseString] isEqualToString:@"REVIEW"])
    {
        tempString=@"Past";
    }
   
        
    
    
    BOOL bookStatusVal=YES;
    if(selectedIndex==nil)
    {
        bookStatusVal=NO;
    }else if([selectedIndex isEqualToString:tempString])
    {
        bookStatusVal=YES;

    }
    
   
    
    currentBookingArray=[[NSMutableArray alloc]init];
    pastBookingArray=[[NSMutableArray alloc]init];
    cuurentBtn.layer.cornerRadius=5.0;
    pastBtn.layer.cornerRadius=5.0;
    
    [pastBtn setBackgroundColor:[UIColor clearColor]];
    [cuurentBtn setBackgroundColor:[UIColor whiteColor] ];
    [cuurentBtn setTitleColor:[UIColor colorWithRed:11/255.0f green:23/255.0f blue:76/256.f alpha:1.0] forState:UIControlStateNormal];
    [pastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if( [[[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] uppercaseString] isEqualToString:@"REVIEW"])
    {
        selectedIndex=@"Past";
        
        
        [cuurentBtn setBackgroundColor:[UIColor clearColor]];
        [pastBtn setBackgroundColor:[UIColor whiteColor]];
        [cuurentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pastBtn setTitleColor:[UIColor colorWithRed:11/255.0f green:23/255.0f blue:76/256.f alpha:1.0] forState:UIControlStateNormal];
    }
    else
    {
        selectedIndex=@"Current";

    }
    
    if(bookStatusVal&&alredyLoaded)
        [self loadApi];

    
}
-(void)viewDidAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        
        self.loginView.hidden = YES;
        self.switchHeader.hidden = NO;

        
//        [defaults setValue:@"Rebooking" forKey:@"pushClick"];
//
//        [defaults setValue:[notification objectForKey:@"book_id"] forKey:@"book_id"];
//
//        [defaults setValue:[notification objectForKey:@"type"] forKey:@"type"];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"pushClick"] isEqualToString:@"Rebooking"] )
        {
          //  UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
          //  ReebookingViewController *vc = [y   instantiateViewControllerWithIdentifier:@"ReebookingViewController"];
            
            //vc.fromString=@"presentViewTab";
         //   [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            if(alredyCALLED)
                [self loadApi];
            
            
        }
    }
    else
    {
        
        //CJC 8 c
        
        self.loginView.hidden = NO;
        [__btnLogin setTitle:@"Login/Sign up" forState:UIControlStateNormal];

        self.switchHeader.hidden = YES;

        
        if(!loginAlertShowed){
            //CJC 8 c
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
                LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                vc.fromString=@"presentViewTab";
                [self.navigationController pushViewController:vc animated:YES];
            });
            loginAlertShowed = YES;
        }
        
        
    
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry"
//                                                                                 message:@"Kindly login to get your bookings"
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        //We add buttons to the alert controller by creating UIAlertActions:
//        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Login"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction * _Nonnull action) {
//
//            [alertController dismissViewControllerAnimated:TRUE completion:^{
//
//                dispatch_async(dispatch_get_main_queue(), ^(void){
//                     //Run UI Updates
//
//                    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
//                    LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                    vc.fromString=@"presentViewTab";
//                    [self.navigationController pushViewController:vc animated:YES];
//                 });
//
//            }];
//
//
//        }]; //You can use a block here to handle a press on this button
//        UIAlertAction *actioncanel = [UIAlertAction actionWithTitle:@"Canel"
//                                                           style:UIAlertActionStyleDefault
//                                                         handler:nil]; //You can use a block here to handle a press on this button
//        [alertController addAction:actioncanel];
//        [alertController addAction:actionOk];
//
//
//        [self presentViewController:alertController animated:YES completion:nil];

        
        
//        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        InitialViewController *vc = [y   instantiateViewControllerWithIdentifier:@"InitialViewController"];
//    
//            vc.fromString=@"presentViewTab";
//        [self.navigationController pushViewController:vc animated:YES];

        
        
//            vc.providesPresentationContextTransitionStyle = YES;
//            vc.definesPresentationContext = YES;
//            [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
//            [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if([selectedIndex isEqualToString:@"Current"])
    {
        return currentBookingArray.count;
    }
    else
    {
       return pastBookingArray.count;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row%2==0)
//        cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
//    else
//        cell.transform = CGAffineTransformMakeTranslation(0, 100);
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListHostelsTableViewCell *cell_lst=(ListHostelsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ListHostelsTableViewCellNew"];
    if([selectedIndex isEqualToString:@"Current"])
    {
        [cell_lst configureActiveBookingCellWithObject:currentBookingArray[indexPath.row]];
      
    }
    else
    {
        [cell_lst configurePastBookingCellWithObject:pastBookingArray[indexPath.row]];
       
    }


    cell_lst.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell_lst;
    cell=(BookingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BookingTableViewCell"];
    
    
    cell.cancelLBL.text=@"";

    if([selectedIndex isEqualToString:@"Current"])
    {
        
        
        if([[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"cancel_approval"])
        {
            if([[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"cancel_approval"]intValue] == 1)
            {
                cell.cancelLBL.text=@"CANCELLED";
            }
            else
                cell.cancelLBL.text=@"";


        }
        if(![[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] isKindOfClass:[NSNull class]])
        {
        cell.propertyName.text=[[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] valueForKey:@"name"];
            
            NSLog(@"sac -- %@",[[[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] objectForKey:@"contactinfo"] valueForKey:@"location"]);
            
            if([[[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] objectForKey:@"contactinfo"] valueForKey:@"location"]){//CJC 21
                
                cell.propertyLocation.text=[[[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] objectForKey:@"contactinfo"] valueForKey:@"location"];
                
            }else{
                cell.propertyLocation.text= @"";
                
            }
        }
        
        if([[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"book_id"])
        cell.bookingIDLBL.text=[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"book_id"];
//        book_id
        
        NSInteger roomsCount=0;
        for(NSDictionary* dic in [[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"room"])
        {
            roomsCount=roomsCount+[[dic valueForKey:@"number"] integerValue];
        }
        
        NSString *roomsString=@"ROOM";
        NSString *adultsString=@"ADULT";
           NSString *childString=@"CHILD";
        
        if(roomsCount>1)
        {
            roomsString=@"ROOMS";
        }
        if([[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_adults"] integerValue]>1)
        {
            adultsString=@"ADULTS";
        }
            if([[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_children"] integerValue]>1)
            {
                childString=@"CHILDREN'S";
            }
        
        
        if([[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_children"] integerValue]>0)
        {
        
            cell.roomsLabel.text=[NSString stringWithFormat:@"%ld %@, %@ %@, %@ %@",(long)roomsCount,roomsString,[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_adults"],adultsString,[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_children"],childString];
        }
        else
        {
            cell.roomsLabel.text=[NSString stringWithFormat:@"%ld %@, %@ %@",(long)roomsCount,roomsString,[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_adults"],adultsString];
        }
        
        
        
        NSDate *selectedDate=[dateFormatter dateFromString:[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"checkin_date"] ];
       
        [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
        NSString* nextDayString=[dateFormatter2 stringFromDate:selectedDate];
        
        cell.dateLBL.text=[NSString stringWithFormat:@"%@-%@h-%@",nextDayString,[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"selected_hours"],[self setDate:[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"checkin_time"]]];
        
    if(![[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] isKindOfClass:[NSNull class]])
        if([[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] objectForKey:@"images"])
        {
            
            if([[[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] objectForKey:@"images"] count]>0)
            {
                NSString*imgName=[[[[currentBookingArray objectAtIndex:indexPath.row] objectForKey:@"property"] objectForKey:@"images"]objectAtIndex:0];
                NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
                [cell.propertyImageVieww sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
            }
        }
        
    }
    else
    {
        if([[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"cancel_approval"])
        {
            if([[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"cancel_approval"]intValue] == 1)
            {
                cell.cancelLBL.text=@"CANCELLED";
            }
            else
                cell.cancelLBL.text=@"";
            
            
        }
        
        cell.propertyName.text=[[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"propertyInfo"] valueForKey:@"name"];
        
        
        NSLog(@"ss 1-- %@",[[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"propertyInfo"]  valueForKey:@"location"]);
        
        //CJC 21
        if([[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"propertyInfo"]  valueForKey:@"location"]){
            cell.propertyLocation.text=[[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"propertyInfo"]  valueForKey:@"location"];
        }else{
            cell.propertyLocation.text= @"";
        }
        if([[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"book_id"])
         cell.bookingIDLBL.text=[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"book_id"];
        NSInteger roomsCount=0;
        
        for(NSDictionary* dic in [[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"roomsInfo"])
        {
            roomsCount=roomsCount+1;
        }
        
        NSString *roomsString=@"ROOM";
        NSString *adultsString=@"ADULT";
        NSString *childString=@"CHILD";
        
        if(roomsCount>1)
        {
            roomsString=@"ROOMS";
        }
        if([[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_adults"] integerValue]>1)
        {
            adultsString=@"ADULTS";
        }
        if([[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_children"] integerValue]>1)
        {
            childString=@"CHILDREN'S";
        }
        
         if([[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_children"] integerValue]>0)
         {
          cell.roomsLabel.text=[NSString stringWithFormat:@"%ld %@, %@ %@, %@ %@",roomsCount,roomsString,[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_adults"],adultsString,[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_children"],childString];
         }
        else
        {
              cell.roomsLabel.text=[NSString stringWithFormat:@"%ld %@, %@ %@",roomsCount,roomsString,[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_adults"],adultsString];
        }
        //"selected_hours":24,
        // "checkin_time":"10:30",
//        cell.roomsLabel.text=[NSString stringWithFormat:@"%ld ROOM,%@ ADULTS ,%@ CHILD",roomsCount,[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_adults"],[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"no_of_children"]];
        
        
        
        NSDate *selectedDate=[dateFormatter dateFromString:[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"checkin_date"] ];
        
        [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
        NSString* nextDayString=[dateFormatter2 stringFromDate:selectedDate];
        
        cell.dateLBL.text=[NSString stringWithFormat:@"%@ - AED %@",nextDayString,[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"total_amt"]];
        
        
        if([[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"propertyInfo"] objectForKey:@"images"])
        {
            
            if([[[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"propertyInfo"] objectForKey:@"images"] count]>0)
            {
                NSString*imgName=[[[[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"propertyInfo"] objectForKey:@"images"]objectAtIndex:0];
                NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
                [cell.propertyImageVieww sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
            }
        }
        
    }
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    BookingDetailsNewViewController *vcDet = [y   instantiateViewControllerWithIdentifier:@"BookingDetailsNewViewController"];
    NSString*imgName = @"";
    NSString*hotelName = @"";
    NSString*addrs = @"";
    NSString*lat = @"";
    NSString*longt = @"";
    NSString*datestr = @"";
    NSString*bookingId = @"";
    NSString*guestcount = @"";
    NSString*property_id = @"";

    NSString*hoursString;

   

    
    if([selectedIndex isEqualToString:@"Current"])
    {
        NSDictionary *item =  currentBookingArray[indexPath.row];
        
      //  [cell.propertyImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];



     
        if([item[@"property"] objectForKey:@"images"])
        {
            
            if([[item[@"property"] objectForKey:@"images"] count]>0)
            {
        imgName=[[item[@"property"] objectForKey:@"images"]objectAtIndex:0];
            }
        }

  if([item objectForKey:@"property"])
        {
            hotelName = [NSString stringWithFormat:@"%@",[item objectForKey:@"property"][@"name"]];
            addrs=[NSString stringWithFormat:@"%@",[item objectForKey:@"property"][@"location"][@"address"]];
            NSArray *latlong = [item objectForKey:@"property"][@"location"][@"coordinates"];
            if ([latlong isKindOfClass:[NSArray class]]&&latlong.count>=2) {
                lat = latlong[1];
                longt = latlong[0];

            }
            //coordinates
            //[item objectForKey:@"property"][@"location"][@"coordinates"]
        }
        NSDate *chekindt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",item[@"checkin_date"],item[@"checkin_time"]] Format:@"yyyy-MM-dd HH:mm"];
        NSDate *chekoutdt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",item[@"checkout_date"],item[@"checkout_time"]] Format:@"yyyy-MM-dd HH:mm"];
        
//        datestr=[NSString stringWithFormat:@"%@",[Commons stringFromDate:chekindt Format:@"MMM dd, yyyy hh:mm a"]];

        //CJC 22
        datestr =[NSString stringWithFormat:@"%@ - %@",[Commons stringFromDate:chekindt Format:@"MMM dd hh:mm a"],[Commons stringFromDate:chekoutdt Format:@"MMM dd hh:mm a"]];
        
        
        
        NSNumber * sum = [[[item objectForKey:@"room"] valueForKeyPath:@"number"] valueForKeyPath:@"@sum.self"];

        bookingId = item[@"book_id"];
        
        guestcount = [NSString stringWithFormat:@"%@ Rooms %d Guests",sum,([item[@"no_of_adults"] intValue])];
        
        if ([[item objectForKey:@"stayDuration"] isKindOfClass:[NSDictionary class]])
                       {
                           hoursString = [NSString stringWithFormat:@" %@ ",[item objectForKey:@"stayDuration"][@"label"]];
                           
                       }
            else if ([[item objectForKey:@"stayDuration"] isKindOfClass:[NSString class]])
            {
                hoursString = [NSString stringWithFormat:@" %@ ",[item objectForKey:@"stayDuration"]];

 
            }
        /*
         */
        
        
    }
    else{
        NSDictionary *item =  pastBookingArray[indexPath.row];
        property_id = item[@"_id"];
        
        if([item[@"propertyInfo"] objectForKey:@"images"])
        {
            
            if([[item[@"propertyInfo"] objectForKey:@"images"] count]>0)
            {
        imgName=[[item[@"propertyInfo"] objectForKey:@"images"]objectAtIndex:0];
            }
        }
        // cell.userReviewLBL.text=@"No Review";

            
        if([item objectForKey:@"propertyInfo"])
        {
            hotelName = [NSString stringWithFormat:@"%@",[item objectForKey:@"propertyInfo"][@"name"]];
            addrs=[NSString stringWithFormat:@"%@",[item objectForKey:@"propertyInfo"][@"location"]];

        }
            bookingId = item[@"book_id"];

        NSDate *chekindt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",item[@"checkin_date"],item[@"checkin_time"]] Format:@"yyyy-MM-dd HH:mm"];
        NSDate *chekoutdt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",item[@"checkout_date"],item[@"checkout_time"]] Format:@"yyyy-MM-dd HH:mm"];
        

        NSNumber * sum = [[[item objectForKey:@"roomsInfo"] valueForKeyPath:@"number"] valueForKeyPath:@"@sum.self"];

         //   datestr=[NSString stringWithFormat:@"%@ -\n%@",[Commons stringFromDate:chekindt Format:@"MMM dd hh:mm"],[Commons stringFromDate:chekoutdt Format:@"MMM dd hh:mm"]];
//        datestr=[NSString stringWithFormat:@"%@",[Commons stringFromDate:chekindt Format:@"MMM dd, yyyy hh:mm a"]];

        //CJC 22
        datestr =[NSString stringWithFormat:@"%@ - %@",[Commons stringFromDate:chekindt Format:@"MMM dd hh:mm a"],[Commons stringFromDate:chekoutdt Format:@"MMM dd hh:mm a"]];

            bookingId = item[@"book_id"];
            
            guestcount = [NSString stringWithFormat:@"%@ Rooms %d Adults",sum,([item[@"no_of_adults"] intValue])];
      
        NSArray *latlong = [item objectForKey:@"latlng"];
        if ([latlong isKindOfClass:[NSArray class]]&&latlong.count>=2) {
            lat = latlong[0];
            longt = latlong[1];

        }
        if ([[item objectForKey:@"stayDuration"] isKindOfClass:[NSDictionary class]])
                       {
                           hoursString = [NSString stringWithFormat:@" %@ ",[item objectForKey:@"stayDuration"][@"label"]];
                           
                       }
            else if ([[item objectForKey:@"stayDuration"] isKindOfClass:[NSString class]])
            {
                hoursString = [NSString stringWithFormat:@" %@ ",[item objectForKey:@"stayDuration"]];

 
            }
            // pastBookingArray[indexPath.row]
        vcDet.isPastBookingOrCancelled  = TRUE;
        vcDet.ub_id = [item objectForKey:@"ub_id"];

    }
    vcDet.propertyId = property_id;
    vcDet.bookingID = bookingId;
    vcDet.hotelName = hotelName;
    vcDet.hotelAddress = addrs;
    vcDet.guestCount = guestcount;
    vcDet.timeString = datestr;
    vcDet.latitude = lat;
    vcDet.longitude = longt;
    vcDet.imageURL = imgName;
    vcDet.hoursString = hoursString;
    [self.navigationController pushViewController:vcDet animated:TRUE];
    
  
}


- (IBAction)currentBtnClick:(id)sender
{
    selectedIndex=@"Current";

   
    
    
    
    [pastBtn setBackgroundColor:[UIColor clearColor]];
    [cuurentBtn setBackgroundColor:[UIColor whiteColor] ];
    [cuurentBtn setTitleColor:[UIColor colorWithRed:11/255.0f green:23/255.0f blue:76/256.f alpha:1.0] forState:UIControlStateNormal];
    [pastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    [listingTableView reloadData];
    [self loadApi];

}

- (IBAction)pastBtnClick:(id)sender
{
    selectedIndex=@"Past";

    
    [cuurentBtn setBackgroundColor:[UIColor clearColor]];
    [pastBtn setBackgroundColor:[UIColor whiteColor]];
    [cuurentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pastBtn setTitleColor:[UIColor colorWithRed:11/255.0f green:23/255.0f blue:76/256.f alpha:1.0] forState:UIControlStateNormal];
    
    
    
//    [pastBtn setBackgroundColor:[UIColor clearColor]];
//    [cuurentBtn setBackgroundColor:[UIColor whiteColor] ];
//    [cuurentBtn setTitleColor:[UIColor colorWithRed:11/255.0f green:23/255.0f blue:76/256.f alpha:1.0] forState:UIControlStateNormal];
//    [pastBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [listingTableView reloadData];
    [self loadApi];

}


-(void)loadApi
{
    alredyCALLED=NO;
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
    
    [self.view endEditing:YES];
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    NSMutableDictionary *reqData1 = [NSMutableDictionary dictionary];
    NSString *url = @"";
    if([selectedIndex isEqualToString:@"Current"])
    {
        url = @"users/bookings?type=CURRENT";
    }
    else{
        url = @"users/bookings";

    }
    [util postRequest:reqData1 withToken:TRUE toUrl:url type:@"GET"];
}

- (IBAction)loginAction:(id)sender {
    
    //CJC
    if([__btnLogin.titleLabel.text isEqualToString:@"Login/Sign up"]){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
            LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            vc.fromString=@"presentViewTab";
            [self.navigationController pushViewController:vc animated:YES];
        });
    }else{
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
    
    
}


-(IBAction)backFunction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    alredyLoaded=YES;
    alredyCALLED=YES;

    if([rawData objectForKey:@"data"])
    {
        if([selectedIndex isEqualToString:@"Current"])
        {
            [currentBookingArray removeAllObjects];

       // if([rawData objectForKey:@"data"])
        {
            
            for(NSDictionary* dicValue in [rawData objectForKey:@"data"])
            {
                [currentBookingArray addObject:dicValue];
               // [pastBookingArray addObject:dicValue];

            }
           
        }
       
            if(currentBookingArray.count==0)
            {
                UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
                vc.imageName=@"Warning";
                vc.messageString=@"Nothing to display";
                vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
                [self.view addSubview:vc.view];
            }
            else
            {
                NSInteger selectedIndexVal=-1;
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"booking_ID"])
                    
                {
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"booking_ID"] length]!=0)
                        
                    {
                        
                        NSInteger i=0;
                 for(NSDictionary * dic in currentBookingArray)
                 {
                     
                     if([[dic valueForKey:@"_id"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"booking_ID"]])
                     {
                         selectedIndexVal=i;
                         break;
                         
                     }
                     i++;
                 }
                        
                    }
                }
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:@"" forKey:@"booking_ID"];
                [defaults setObject:@"NO" forKey:@"type"];
                [defaults synchronize];
                
               /* if(selectedIndexVal>=0)
                {
                UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                BookingDetailsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"BookingDetailsViewController"];
                {
                    vc.selectedProperty=[[currentBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"property"];
                    vc.loadedProperty=[currentBookingArray objectAtIndex:selectedIndexVal];
                    
                    if([[[currentBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"property"] objectForKey:@"contactinfo"])
                    {
                        if([[[[currentBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"property"] objectForKey:@"contactinfo"] objectForKey:@"latlng"])
                        {
                            if([[[[[currentBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"property"] objectForKey:@"contactinfo"] objectForKey:@"latlng"] count]>1)
                            {
                                
                                double latitude1 = [[[[[[currentBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"property"] objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:0] doubleValue];
                                double longitude1 = [[[[[[currentBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"property"] objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:1] doubleValue];
                                NSString *lat =[NSString stringWithFormat:@"%f",latitude1];
                                NSString *lon =[NSString stringWithFormat:@"%f",longitude1];
                                [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"mapLatitude"];
                                [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"mapLongitude"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                    vc.selectionString=selectedIndex;
                    [hud hideAnimated:YES afterDelay:0];

                    [self.navigationController pushViewController:vc animated:YES];
                }*/
            }
            
        }else if([selectedIndex isEqualToString:@"Past"])
        {
            [pastBookingArray removeAllObjects];

            if([rawData objectForKey:@"data"])
            {
                
                for(NSDictionary* dicValue in [rawData objectForKey:@"data"])
                {
                    [pastBookingArray addObject:dicValue];
                }
                
            }
            else
            {
                
            }
            if(pastBookingArray.count==0)
            {
                UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
                vc.imageName=@"Warning";
                vc.messageString=@"Nothing to display";
                vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
                [self.view addSubview:vc.view];
            }
            else
            {
               /* if( [[[[NSUserDefaults standardUserDefaults]objectForKey:@"type"] uppercaseString] isEqualToString:@"REVIEW"])
                {
                    NSInteger selectedIndexVal=-1;
                    ///
                    
                    NSInteger i=0;
                    for(NSDictionary * dic in pastBookingArray)
                    {
                        if([dic objectForKey:@"ub_id"])
                        if([[dic valueForKey:@"ub_id"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"book_id"]])
                        {
                            selectedIndexVal=i;
                            break;
                            
                        }
                        i++;
                    }
                    if(selectedIndexVal>=0)
                    {
                        
                        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        BookingDetailsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"BookingDetailsViewController"];
                        
                        
                        vc.selectedProperty=[[pastBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"propertyInfo"];
                        vc.loadedProperty=[pastBookingArray objectAtIndex:selectedIndexVal];
                        
                        
                        
                        if([[pastBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"latlng"])
                        {
                            if([[[pastBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"latlng"] count]>1)
                            {
                                
                                double latitude1 = [[[[pastBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"latlng"] objectAtIndex:0] doubleValue];
                                double longitude1 = [[[[pastBookingArray objectAtIndex:selectedIndexVal] objectForKey:@"latlng"] objectAtIndex:1] doubleValue];
                                NSString *lat =[NSString stringWithFormat:@"%f",latitude1];
                                NSString *lon =[NSString stringWithFormat:@"%f",longitude1];
                                [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"mapLatitude"];
                                [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"mapLongitude"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                                
                            }else
                            {
                                [[NSUserDefaults standardUserDefaults]setObject:@"0.0" forKey:@"mapLatitude"];
                                [[NSUserDefaults standardUserDefaults]setObject:@"0.0" forKey:@"mapLongitude"];
                                [[NSUserDefaults standardUserDefaults]synchronize];
                            }
                            
                        }
                        
                        vc.selectionString=selectedIndex;
                        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

                        [defaults setValue:@"" forKey:@"book_id"];
                        [defaults setObject:@"NO" forKey:@"type"];
                        [defaults synchronize];
                        [hud hideAnimated:YES afterDelay:0];

                        [self.navigationController pushViewController:vc animated:YES];
                    }
             
                    
                    ///
                    

                    
                }*/
            }
        }
    }
    else if([rawData objectForKey:@"message"])
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=[rawData objectForKey:@"message"];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
    else{
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"Nothing to display";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
    
    
    //CJC added
    if([selectedIndex isEqualToString:@"Current"])
    {
        if([currentBookingArray count] == 0){
            _heightValue.constant = 120;

            _loginView.hidden = NO;
            [__btnLogin setTitle:@"Find your short stay" forState:UIControlStateNormal];
        }else{
            _heightValue.constant = 70;

            _loginView.hidden = YES;
        }
    }
    else
    {
        if([pastBookingArray count] == 0){
            _heightValue.constant = 120;
            _loginView.hidden = NO;
            [__btnLogin setTitle:@"Find your short stay" forState:UIControlStateNormal];
        }else{
            _heightValue.constant = 70;

            _loginView.hidden = YES;
        }
    }
  
    
    
    
    [listingTableView reloadData];
    [hud hideAnimated:YES afterDelay:0];

    //[listingTBV reloadData];
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    alredyLoaded=YES;
    alredyCALLED=YES;

//   hud.margin = 10.f;
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
    alredyLoaded=YES;
    alredyCALLED=YES;

//    hud.margin = 10.f;
//
//    hud.label.text = errorMessage;
//    [hud hideAnimated:YES afterDelay:2];
    hud.margin = 10.f;
    //hud.label.text = response;
    [hud hideAnimated:YES afterDelay:0];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=errorMessage;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    if([selectedIndex isEqualToString:@"Current"])
    {
        [currentBookingArray removeAllObjects];
    }
    else{
        [pastBookingArray removeAllObjects];
    }
    
    //CJC added
    if([selectedIndex isEqualToString:@"Current"])
    {
        if([currentBookingArray count] == 0){
            _heightValue.constant = 120;

            _loginView.hidden = NO;
            [__btnLogin setTitle:@"Find your short stay" forState:UIControlStateNormal];
        }else{
            _heightValue.constant = 70;

            _loginView.hidden = YES;
        }
    }
    else
    {
        if([pastBookingArray count] == 0){
            _heightValue.constant = 120;

            _loginView.hidden = NO;
            [__btnLogin setTitle:@"Find your short stay" forState:UIControlStateNormal];
        }else{
            _heightValue.constant = 70;

            _loginView.hidden = YES;
        }
    }
    
    
    [listingTableView reloadData];
    
    

}



-(NSString*)setDate:(NSString*)time{
    
    [timePicker setTimeZone:[NSTimeZone localTimeZone]];
    [timePicker setDateFormat:@"HH:mm"];
    
    NSDate*datePassed=[timePicker dateFromString:time];
    [timePicker setDateFormat:@"hh:mm"];
    NSString*selectedTime=[timePicker stringFromDate:datePassed];
    
    [timePicker setDateFormat:@"hh:mm a"];
    NSString*amOrPm=[timePicker stringFromDate:datePassed];
  
    
    return amOrPm;
}
- (IBAction)segmentButtonClikd:(UISegmentedControl*)sender {
    
    if (sender.selectedSegmentIndex==0) {
        selectedIndex = @"Current";
    }
    else{
        selectedIndex = @"Past";

    }
    [self loadApi];

}

@end

