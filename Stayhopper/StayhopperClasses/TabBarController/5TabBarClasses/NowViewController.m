//
//  ListHotelsViewController.m
//  Stayhopper
//
//  Created by iROID Technologies on 08/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//
#import "NowViewController.h"
#import "ListHotelsViewController.h"
#import "ListHostelsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SinglePropertyDetailsViewController.h"
#import "MessageViewController.h"
#import "PropertyDetailsViewController.h"
#import "StayDateTimeViewController.h"
@interface NowViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ListHostelsTableViewCell *cell;
    
    IBOutlet NSLayoutConstraint *optionsViewWidth;
}
@end

@implementation NowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    firstTime=YES;
    tableLoaded=NO;
    minString=@"0";
    maxString=@"0";
    [[NSUserDefaults standardUserDefaults] setObject:@"sort_rating=0" forKey:@"sortValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    newStatus=YES;
    currentIndexValue=0;
    self.timeBgImageview.clipsToBounds=YES;
    
    self.timeBgImageview.layer.cornerRadius=2;
    self.reviewBgImageview.clipsToBounds=YES;
    
    self.reviewBgImageview.layer.cornerRadius=2;
    optionsViewWidth.constant=[UIScreen mainScreen].bounds.size.width/2.5;
    self.mapView.showsUserLocation=YES;
    
    listingTBV.hidden=NO;
    mapLoadedStayus=NO;
    listingType=YES;
    propertyArray=[[NSMutableArray alloc]init];
    _ratingArray=[[NSMutableArray alloc]init];
    
    _serviceArray=[[NSMutableArray alloc]init];
    //june 24 -6h-11:30
    loadingLBL.text=@"";
    
    utilObj = [[RequestUtil alloc]init];

    [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteNormal"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteActive"] forState:UIControlStateSelected];
    locationLBL.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocationName"];
    //    [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
    //    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
    //    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
    
    
    ////
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate*currentDate=[NSDate date];
    
    NSDateFormatter *dateFormatter22 = [[NSDateFormatter alloc]init];
    [dateFormatter22 setDateFormat:@"HH:mm"];
    NSString*nextDayStringtem;
    [dateFormatter22 setTimeZone:[NSTimeZone localTimeZone]];
    
    nextDayStringtem=[dateFormatter22 stringFromDate:currentDate];
    
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
    BOOL nextDateVal=NO;
    if(time>=12)
    {
        if([[timeArray objectAtIndex:0] isEqualToString:@"23"])
        {
            nextDateVal=YES;
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
    
    [[NSUserDefaults standardUserDefaults]setObject:nextDayStringtem forKey:@"selectedTime"];
    
    
    ////
    
    
  //  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    int timeToAdd=24*60*60;
    NSDate*nextDay;
    NSString*nextDayString;
    nextDay=[currentDate dateByAddingTimeInterval:timeToAdd];
    nextDayString=[dateFormatter stringFromDate:[NSDate date]];
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
    
    
 //  NSString* nextDayStringd=[dateFormatter stringFromDate:[NSDate date]];
 //   [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];

    [[NSUserDefaults standardUserDefaults]synchronize];

    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *selectedDate=[dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedDate"] ];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MMM dd"];
    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
    
    
    
    
    
    
    
    
    
    
    NSString* nextDayString1=[dateFormatter2 stringFromDate:selectedDate];
    scheduleLBL.text=[NSString stringWithFormat:@"%@-%@-%@",nextDayString1,[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"],[utilObj convertTime]];
    self.BGView.alpha=0;
    
    self.whiteImageView.layer.cornerRadius=4;
    loadingLBL.hidden=NO;
    
    
    filterLBL.text=@"No Filter";
    sortLBL.text=@"Distance";
    // Do any additional setup after loading the view. //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadApi) name:kNotificationFilterItemsChanges object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    if(newStatus)
    {
        
    [self loadApi];
        
    }
    newStatus=YES;

}
-(void)loadApi
{
    
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate*currentDate=[NSDate date];
    NSString*nextDayString;
    nextDayString=[dateFormatter stringFromDate:currentDate];
    // [datesArr addObject:nextDay];
    
   
    
  //  [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
  //  [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];
    
    
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
    
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"] forKey:@"number_adults"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"] forKey:@"number_rooms"];
    
    [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
    
   // [reqData setObject:@"1" forKey:@"sort_rating"];

    
    
    
    
   // locationString=@"9.9312,76.2673";
  // locationString=@"25.2048,55.2708";
    [reqData setObject:locationString forKey:@"location"];

    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    for (NSString *key in reqData) {
        
        NSString *value = [reqData objectForKey:key];
        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    listingString=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
        listingString = strReqString;
    }

    
    [self.view endEditing:YES];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    NSMutableDictionary *reqData1 = [NSMutableDictionary dictionary];
    listingString=[NSString stringWithFormat: @"properties/search/near?checkin_time=%@&location=%@&",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],locationString];
    [util postRequest:reqData1 toUrl:[NSString stringWithFormat: @"properties/search/near?checkin_time=%@&location=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],locationString] type:@"GET"];
}

-(void)loadApiWithoutNotification
{
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate*currentDate=[NSDate date];
    NSString*nextDayString;
    nextDayString=[dateFormatter stringFromDate:currentDate];
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:nextDayString forKey:@"selectedDate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];
    
    
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
    
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"] forKey:@"number_adults"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"] forKey:@"number_rooms"];
    
    [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
    
    // [reqData setObject:@"1" forKey:@"sort_rating"];
    
    
    
    
    
    // locationString=@"9.9312,76.2673";
    // locationString=@"25.2048,55.2708";
    [reqData setObject:locationString forKey:@"location"];
    
    
    NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
    for (NSString *key in reqData) {
        
        NSString *value = [reqData objectForKey:key];
        [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    listingString=@"";
    if(strReqString.length==0)
    {
        
    }
    else
    {
        listingString = strReqString;
    }
    
    
    [self.view endEditing:YES];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    NSMutableDictionary *reqData1 = [NSMutableDictionary dictionary];
    listingString=[NSString stringWithFormat: @"properties/search/near?checkin_time=%@&location=%@&",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],locationString];
    [util postRequest:reqData1 toUrl:[NSString stringWithFormat: @"properties/search/near?checkin_time=%@&location=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],locationString] type:@"GET"];
}
-(IBAction)backFunction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    
    if(propertyArray.count!=0 && tableLoaded)
        [listingTBV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
    if(firstTime)
    {
        minString=@"0";
        maxString=@"0";
    }
    loadingLBL.hidden=YES;
    [hud hideAnimated:YES afterDelay:0];
    [propertyArray removeAllObjects];
    self.BGView.alpha=0;
    [self.mapView removeAnnotations:self.mapView.annotations];
    if([rawData objectForKey:@"data"])
    {
        
        
        if([[rawData objectForKey:@"data"] count]!=0)
        {
            if(firstTime)
            {
                float minPriceTemp=100000.0f;
                float maxPriceTemp=0.0f;
                
                for(NSDictionary* dic in [rawData objectForKey:@"data"])
                {
                    if([[dic objectForKey:@"minprice"] floatValue])
                        if(minPriceTemp>[[dic objectForKey:@"minprice"] floatValue])
                        {
                            minPriceTemp=[[dic objectForKey:@"minprice"] floatValue];
                        }
                    if([[dic objectForKey:@"maxprice"] floatValue])
                        if(maxPriceTemp<[[dic objectForKey:@"maxprice"] floatValue])
                        {
                            maxPriceTemp=[[dic objectForKey:@"maxprice"] floatValue];
                        }
                    
                }
                
                
                if(minPriceTemp<100000.0f)
                    minString=[NSString stringWithFormat:@"%.0f",minPriceTemp ];
                else
                    minString=@"0";
                
                if(maxPriceTemp>0)
                    maxString=[NSString stringWithFormat:@"%.0f",maxPriceTemp ];
                else
                    maxString=minString;
                 [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@,%@",minString,maxString] forKey:@"priceSelected"];
                
                [[NSUserDefaults standardUserDefaults] setObject:minString forKey:@"minSelected"];
                [[NSUserDefaults standardUserDefaults] setObject:maxString forKey:@"maxSelected"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                firstTime=NO;
            }
        }
       
        
        for(NSDictionary* dicValue in [rawData objectForKey:@"data"])
        {
            [propertyArray addObject:dicValue];
        }
        if([propertyArray count]==0)
        {
            

            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Failed";
            vc.messageString=@"There are no availbale rooms";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            
        }
        else
        {
            mapLoadedStayus=NO;

        }
    }
    else
    {
       // loadingLBL.hidden=NO;
       // loadingLBL.text=@"There are no available rooms with your search criteria";
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=@"There are no availbale rooms";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
    [self listTypeFunctionNEW:nil];
    
    //[listingTBV reloadData];
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
//    loadingLBL.text=@"There are no available rooms with your search criteria";
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
//    loadingLBL.text=@"There are no available rooms with your search criteria";
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    tableLoaded=NO;
    return [propertyArray count];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row%2==0)
//        cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
//    else
//        cell.transform = CGAffineTransformMakeTranslation(0, 100);    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
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
    cell=(ListHostelsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ListHostelsTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableLoaded=YES;
    NSString* price=@"0";
    NSString* discountPrice=@"0";
    cell.propertyLocationLBL.text=@"";
    cell.userRatingValueLBL.text=@"0";
    
    cell.distanceLBL.hidden=YES;
    cell.distanceIMG.hidden=YES;
    if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"distance"])
    {
        
        
        float distance=[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"distance"] floatValue];
        cell.distanceLBL.hidden=NO;
        cell.distanceIMG.hidden=NO;
        cell.distanceLBL.text=[NSString stringWithFormat:@"%.2f km from %@",distance,locationLBL.text];
        
        
        
    }
    
    
    if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"user_rating"])
    {
        
        
        cell.userRatingValueLBL.text=[NSString stringWithFormat:@"%@",[[propertyArray objectAtIndex:indexPath.row]  valueForKey:@"user_rating"] ];
    }
    
    if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"images"])
    {
        
        if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"images"] count]>0)
        {
            NSString*imgName=[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"images"]objectAtIndex:0];
            NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
            [cell.propertyImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
        }
    }
    
    cell.propertyID=[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"_id"];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        cell.favoriteButton.hidden=NO;
        
    }else
    {
        cell.favoriteButton.hidden=YES;
        
    }
    if([utilObj checkFavorites:[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"_id"] ])
    {
        cell.favoriteButton.selected=YES;
    }
    else
    {
        cell.favoriteButton.selected=NO;
        
    }
  //  cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] ]];
    
    
//    if([[self.selectedProperty objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
//    {
//        ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[[self.selectedProperty objectForKey:@"rating"] objectForKey:@"value"] ]];
//    }
//    else
//        ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[self.selectedProperty objectForKey:@"rating"] ]];
    
    if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
    {
        cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] objectForKey:@"value"] ]];
    }
    else
        cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] ]];
    
    
    if([cell.userRatingValueLBL.text floatValue]<=0)
    {
        cell.userReviewLBL.text=@"No Review";
        //CJC 12
        cell.userReviewLBLValue.hidden = YES;
        cell.userReviewLBL.hidden = YES;
        /**/
        
    }else{
        cell.userReviewLBLValue.hidden = NO;
        cell.userReviewLBL.hidden = NO;
    }
        
    if([cell.userRatingValueLBL.text floatValue]<=2)
    {
        cell.userReviewLBL.text=@"Poor";
    }
    else if([cell.userRatingValueLBL.text floatValue]<=4.0)
    {
        cell.userReviewLBL.text=@"Average";
    }
    else if([cell.userRatingValueLBL.text floatValue]<=6.0)
    {
        cell.userReviewLBL.text=@"Good";
    }else if([cell.userRatingValueLBL.text floatValue]<8.0)
    {
        cell.userReviewLBL.text=@"Very Good";
    }
    else
        cell.userReviewLBL.text=@"Excellent";
    
    
    if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"])
    {
        if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] objectForKey:@"location"])
            
            cell.propertyLocationLBL.text=[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] valueForKey:@"location"];
    }
    else
        cell.propertyLocationLBL.text=@"";
    
    if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"name"])
        cell.propertyNameLBL.text=[[propertyArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    else
        cell.propertyNameLBL.text=@"";
    ////new
    BOOL statusValue=NO;
    
    if ([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"]) {
        
        
        
        
        
        NSArray* arrin=[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"];
        
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"current_price"
                                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        NSArray *sortedArray = [arrin sortedArrayUsingDescriptors:sortDescriptors];
        
        
        //         for(NSDictionary* dic in [[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"])
        for(NSDictionary* dic in sortedArray)
        {
            if([dic isKindOfClass:[NSDictionary class]])
            {
                
                if([[dic objectForKey:@"price"] isKindOfClass:[NSDictionary class]])
                {
                    
                    if([[dic objectForKey:@"price"] objectForKey:@"h3"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
                        cell.hourLBL.text=@"3h";
                        
                        
                    }
                    else   if([[dic objectForKey:@"price"] objectForKey:@"h6"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
                        
                        cell.hourLBL.text=@"6h";
                    }
                    
                    else   if([[dic objectForKey:@"price"] objectForKey:@"h12"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
                        cell.hourLBL.text=@"12h";
                        
                    }
                    else
                        if([[dic objectForKey:@"price"] objectForKey:@"h24"])
                        {
                            price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
                            
                            cell.hourLBL.text=@"24h";
                            
                        }
                    
                    // break;
                }
                else
                {
                    price=[dic valueForKey:@"price"];
                   
                    //break;
                }
//                cell.hourLBL.text = [NSString stringWithFormat:@"%@h",[[propertyArray objectAtIndex:indexPath.row]valueForKey:@"smallest_timeslot"] ];
                cell.hourLBL.text = [NSString stringWithFormat:@"%@h",@"3" ];
                ////
                if([dic objectForKey:@"custom_price"])
                {
                    statusValue=YES;
                    if([[dic objectForKey:@"custom_price"] isKindOfClass:[NSDictionary class]])
                    {
                        
                        if([[dic objectForKey:@"custom_price"] objectForKey:@"h3"])
                        {
                            discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h3"];
                            
                            
                            
                        }
                        else   if([[dic objectForKey:@"custom_price"] objectForKey:@"h6"])
                        {
                            discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h6"];
                            
                            
                            
                        }
                        else
                            if([[dic objectForKey:@"custom_price"] objectForKey:@"h12"])
                            {
                                discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h12"];
                                
                                
                            }
                            else  if([[dic objectForKey:@"custom_price"] objectForKey:@"h24"])
                            {
                                discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h24"];
                                
                                
                                
                            }
                        
                        break;
                    }else
                    {
                        discountPrice=[dic valueForKey:@"custom_price"];
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
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" AED %@ ",price]];
    
    //  [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:NSMakeRange(0, 3)];
    
    NSInteger leng=str.length;
    // ProximaNovaA-Regular 12.0Helvetica Neue Medium
    // [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
    //  [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng-5)];
    
    // cell.priceLBL.attributedText = str;
    if(statusValue)
    {
        
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" AED %@ ",discountPrice]];
        NSInteger leng1=str1.length;
        
        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng1-5)];
        
        
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:12.0] range:NSMakeRange(0, leng)];
        [str addAttribute:NSStrikethroughStyleAttributeName
                    value:@1
                    range:NSMakeRange(0, [str length])];
        
        cell.discountPriceLBL.attributedText = str;
        
        cell.priceLBL.attributedText = str1;
        
        cell.discountPriceLBL.hidden=NO;
        if([discountPrice floatValue]>=[price floatValue])
        {
            cell.discountPriceLBL.hidden=YES;
        }
        
    }
    else
    {
        cell.discountPriceLBL.hidden=YES;;
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng-5)];
        cell.priceLBL.attributedText = str;
        
    }
    
    cell.featuredImageView.hidden=YES;
    
    ////
//    if ([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"]) {
//        for(NSDictionary* dic in [[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"])
//        {
//            if([dic isKindOfClass:[NSDictionary class]])
//            {
//
//                if([[dic objectForKey:@"price"] isKindOfClass:[NSDictionary class]])
//                {
//
//                    if([[dic objectForKey:@"price"] objectForKey:@"h3"])
//                    {
//                        price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
//                        cell.hourLBL.text=@"3h";
//
//                    }
//                    else if([[dic objectForKey:@"price"] objectForKey:@"h6"])
//                    {
//                        price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
//                        cell.hourLBL.text=@"6h";
//
//
//                    }
//                    else if([[dic objectForKey:@"price"] objectForKey:@"h12"])
//                    {
//                        price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
//                        cell.hourLBL.text=@"12h";
//
//                    }
//                    else if([[dic objectForKey:@"price"] objectForKey:@"h24"])
//                    {
//                        price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
//                        cell.hourLBL.text=@"24h";
//
//
//                    }
//
//
//                    break;
//                }
//                else
//                {
//                    price=[dic valueForKey:@"price"];
//                    break;
//                }
//
//            }
//
//        }
//    }
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" AED %@ ",price]];
//
//
//  // //  [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:NSMakeRange(0, 3)];
// //
//
//    NSInteger leng=str.length;
//// ProximaNovaA-Regular 12.0Helvetica Neue Medium
//
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:22.0] range:NSMakeRange(5, leng-5)];
//    cell.priceLBL.attributedText = str;
//
//    //cell.priceLBL.attributedText = str;
//
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED 1200"]];
//
//    [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:9.0] range:NSMakeRange(0, 3)];
//    cell.discountPriceLBL.attributedText = str1;
    cell.featuredImageView.hidden=YES;
   // cell.discountPriceLBL.hidden=YES;
   // cell.hourLBL.text=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]] uppercaseString];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* loadingString;
    loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[[propertyArray objectAtIndex:indexPath.row]valueForKey:@"_id"]];
    
    
    
    
    //        "selected_hours:24
    //    checkin_time:10:30
    //    checkin_date:2018-08-11
    //    number_rooms:5
    //    property:5b696916c7c57a00146e0877"
    
    DurationSelectionViewController *sd =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
    sd.placeName = @"";
    sd.latitude = @"";
    sd.longitude = @"";
    sd.formattedAddress = @"";
    //sd.isMonthlySelected = false;
    sd.cityIdString =@"";
    sd.selectionString = @"";
    sd.isHotelSelected = TRUE;
    sd.selectedHotel = [propertyArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:sd animated:TRUE];
    //TODO: OLD FLOW
    return;
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
  
        PropertyDetailsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
        vc.selectedProperty=[propertyArray objectAtIndex:indexPath.row];
        vc.selectionString=loadingString;
        vc.property_id =[propertyArray objectAtIndex:indexPath.row][@"_id"];

        [self.navigationController pushViewController:vc animated:YES];
 
    
}


-(IBAction)whenFunction:(id)sender
{
   // [self.navigationController popViewControllerAnimated:YES];
};
-(IBAction)whereFunction:(id)sender{
    //[self.navigationController popViewControllerAnimated:YES];
    
};
-(IBAction)sortFunction:(id)sender{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    newStatus=NO;
    
    
    SortViewController *vc = [y   instantiateViewControllerWithIdentifier:@"SortViewController"];
    vc.valueString=listingString;
    vc.delegate=self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
};
-(IBAction)filterFunction:(id)sender{
    
    UIViewController *fv = [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"FiltersNewViewController"];
     fv.modalPresentationStyle = UIModalPresentationFullScreen;
     [self.navigationController presentViewController:fv animated:TRUE completion:^{
             
     }];
     return;
    
    newStatus=NO;

    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
    FiltersViewController *vc = [y   instantiateViewControllerWithIdentifier:@"FiltersViewController"];
    vc.valueString=listingString;
    vc.delegate=self;
    vc.minString=minString;
    vc.maxString=maxString;
    vc.serviceArrayPassed=self.serviceArray;
    vc.ratingArrayPassed=self.ratingArray;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    
    
};
-(void)filterFunctionByString:(NSString*)filterOption value:(NSString*)selectedString
{
    
    filterLBL.text=selectedString;
   // sortLBL.text=@"Default";
    filterLBL.text=selectedString;
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"";
    
    hud.mode=MBProgressHUDModeText;
    hud.margin = 0.f;
    hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
    hud.removeFromSuperViewOnHide = YES;
    
//    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        hud.progress=hud.progress+0.05;
//        if(hud.progress>1)
//        {
//            [timer invalidate];
//        }
//    }];
    //        "location:10.5276416, 76.21443490000001
    //    selected_hours:24
    //    checkin_time:10:30
    //    checkin_date:2018-08-11
    //    number_rooms:1
    //    number_adults:3
    //    number_childs:1
    
    filterOption=[NSString stringWithFormat:@"%@%@",listingString,[[NSUserDefaults standardUserDefaults]objectForKey:@"priceSelected"]];
    filterOption= [NSString stringWithFormat:@"%@&%@",filterOption,[[NSUserDefaults standardUserDefaults]objectForKey:@"sortValue"]];
    
    
    NSString*serviceString=@"";
    
    BOOL servicemultiple=NO;;
    BOOL ratingmultiple=NO;;
    
    
    for(NSString* str in self.serviceArray)
    {
        
        servicemultiple=YES;
        // kk=kk+1;
        if(serviceString.length==0)
        {
            serviceString=str;;
        }
        else
        {
            serviceString=   [serviceString stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
        }
        
        
    }
    
    
    if(serviceString.length!=0)
    {
        filterOption=[NSString stringWithFormat:@"%@&service=%@",filterOption,serviceString];
    }
    
    
    NSString*ratingString=@"";
    
    for(NSString* str in self.ratingArray)
    {
        ratingmultiple=YES;
        
        if(ratingString.length==0)
        {
            ratingString=str;;
        }
        else
        {
            ratingString=   [ratingString stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
        }
        
        
    }
    
    
    if(ratingString.length!=0)
    {
        filterOption=[NSString stringWithFormat:@"%@&rating=%@",filterOption,ratingString];
    }
    
    
    
    [self.view endEditing:YES];
    NSMutableDictionary *reqData1 = [NSMutableDictionary dictionary];

    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    //  NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    
    
   // [util postString:filterOption toUrl:@"properties/search" type:@"POST"];
    
        [util postRequest:reqData1 toUrl:filterOption type:@"GET"];
    
    
    
    
}
-(void)sortFunctionByString:(NSString*)filterOption value:(NSString*)selectedString
{
    //filterLBL.text=selectedString;
    sortLBL.text=selectedString;
    //filterLBL.text=@"No Filters";
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
    
    //        "location:10.5276416, 76.21443490000001
    //    selected_hours:24
    //    checkin_time:10:30
    //    checkin_date:2018-08-11
    //    number_rooms:1
    //    number_adults:3
    //    number_childs:1
    filterOption=[NSString stringWithFormat:@"%@%@",listingString,[[NSUserDefaults standardUserDefaults]objectForKey:@"priceSelected"]];
    filterOption= [NSString stringWithFormat:@"%@&%@",filterOption,[[NSUserDefaults standardUserDefaults]objectForKey:@"sortValue"]];
    
    
    NSString*serviceString=@"";
    
    BOOL servicemultiple=NO;;
    BOOL ratingmultiple=NO;;
    
    
    for(NSString* str in self.serviceArray)
    {
        
        servicemultiple=YES;
        // kk=kk+1;
        if(serviceString.length==0)
        {
            serviceString=str;;
        }
        else
        {
            serviceString=   [serviceString stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
        }
        
        
    }
    
    
    if(serviceString.length!=0)
    {
        filterOption=[NSString stringWithFormat:@"%@&service=%@",filterOption,serviceString];
    }
    
    
    NSString*ratingString=@"";
    
    for(NSString* str in self.ratingArray)
    {
        ratingmultiple=YES;
        
        if(ratingString.length==0)
        {
            ratingString=str;;
        }
        else
        {
            ratingString=   [ratingString stringByAppendingString:[NSString stringWithFormat:@",%@",str]];
        }
        
        
    }
    
    
    if(ratingString.length!=0)
    {
        filterOption=[NSString stringWithFormat:@"%@&rating=%@",filterOption,ratingString];
    }
    
    
    
    [self.view endEditing:YES];
    
//    RequestUtil *util = [[RequestUtil alloc]init];
//    util.webDataDelegate=(id)self;
//    //  NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
//    
//    
//    [util postString:filterOption toUrl:@"properties/search" type:@"POST"];
    
    NSMutableDictionary *reqData1 = [NSMutableDictionary dictionary];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    //  NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    
    
   // [util postString:filterOption toUrl:@"properties/search" type:@"POST"];
    
    [util postRequest:reqData1 toUrl:filterOption type:@"GET"];
    
    
    
    
}
-(void)addPins:(NSInteger)tag
{
    propertyTag=0;
    
    if([propertyArray count]>0)
    {
        [self clickFromMap:0];
        [UIView animateWithDuration:0.5 animations:^{
            self.BGView.alpha=1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.BGView.alpha=0;
        }];
    }
    for(NSDictionary* dicValue in propertyArray)
    {
        if([dicValue objectForKey:@"contactinfo"])
        {
            if([[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"])
                
            {
                
                if([[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] count]>1)
                {
                    MKPointAnnotation *mapPin1 = [[MKPointAnnotation alloc] init];
                    mapPin1.title=[NSString stringWithFormat:@"%ld",(long)propertyTag];
                    //  propertyTag++;
                    // clear out any white space
                    // convert string into actual latitude and longitude values
                    
                    double latitude1 = [[[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:0] doubleValue];
                    double longitude1 = [[[[dicValue objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:1] doubleValue];
                    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1);
                    
                    MKCoordinateSpan span;
                    span.latitudeDelta = .5f;
                    span.longitudeDelta = .5f;
                    MKCoordinateRegion region;
                    region.center = coordinate1;
                    region.span = span;
                    //[_mapView setRegion:region animated:TRUE];
                    [_mapView setRegion:region];
                    // setup the map pin with all data and add to map view
                    
                    mapPin1.coordinate = coordinate1;
                    
                    [self.mapView addAnnotation:mapPin1];
                    propertyTag++;

                }
                
            }
            
        }
        // propertyTag++;
    }
    
    
    
    
    
    
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    for(UIView *subview in view.subviews)
    {
        if([subview isKindOfClass:[UIView class]])
        {
            NSLog(@"%ld",(long)subview.tag);
            
            
            [self clickFromMap:subview.tag];
        }
        
    }
    
    //here you action
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
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
        containerView.tag=[annotation.title integerValue];;
        // mapButton.enabled=YES;
        // mapButton.userInteractionEnabled=YES;
       // propertyTag++;
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
-(IBAction)clickFunction:(UIButton*)sender
{
    
}
-(IBAction)listTypeFunction:(id)sender{
    
    if(listingType)
    {
        
        
        listingTBV.hidden=NO;
        listingType=NO;
        [UIView animateWithDuration:0.5 animations:^{    self.BGView.alpha=0;
        }];
        [listingTBV reloadData];
        listTypeImageView.image=[UIImage imageNamed:@"Map"];
    }
    else
    {
        
        listingType=YES;
        if(!mapLoadedStayus)
            [self addPins:0];
        else if([propertyArray count]>0)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.BGView.alpha=1;
            }];
        }
        mapLoadedStayus=YES;
        listingTBV.hidden=YES;
        listTypeImageView.image=[UIImage imageNamed:@"list"];
        
    }
    
};
-(IBAction)listTypeFunctionNEW:(id)sender{
    
    if(!listingType)
    {
        
        
        listingTBV.hidden=NO;
      //  listingType=NO;
        [UIView animateWithDuration:0.5 animations:^{    self.BGView.alpha=0;
        }];
        [listingTBV reloadData];
        //listTypeImageView.image=[UIImage imageNamed:@"Map"];
    }
    else
    {
        
       // listingType=YES;
        if(!mapLoadedStayus)
            [self addPins:0];
        else if([propertyArray count]>0)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.BGView.alpha=1;
            }];
        }
        mapLoadedStayus=YES;
        listingTBV.hidden=YES;
       // listTypeImageView.image=[UIImage imageNamed:@"list"];
        
    }
    
};

-(void)clickFromMap:(NSInteger)selectedIndex
{
    currentIndexValue=selectedIndex;
    if(currentIndexValue<[propertyArray count])

     if([propertyArray count]>0)
     {
        self.BGView.alpha=1;
        
        
        
   
    NSString* price=@"0";
    NSString* discountPrice=@"0";
    self.propertyLocationLBL.text=@"";
    self.userRatingValueLBL.text=@"0";
    if([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"user_rating"])
    {
        
        
        self.userRatingValueLBL.text=[NSString stringWithFormat:@"%@",[[propertyArray objectAtIndex:selectedIndex]  valueForKey:@"user_rating"] ];
    }
         if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
         {
             self.favoriteButton.hidden=NO;
             
         }else
         {
             self.favoriteButton.hidden=YES;
             
         }
    
    if([utilObj checkFavorites:[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"_id"] ])
    {
        self.favoriteButton.selected=YES;
    }
    else
    {
        self.favoriteButton.selected=NO;
        
    }
   // self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] ]];
//         if([[self.selectedProperty objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
//         {
//             ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[[self.selectedProperty objectForKey:@"rating"] objectForKey:@"value"] ]];
//         }
//         else
//             ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[self.selectedProperty objectForKey:@"rating"] ]];
         if([[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
         {
             self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] objectForKey:@"value"] ]];
         }
         else
             self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] ]];
         
    
    if([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"images"])
    {
        
        if([[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"images"] count]>0)
        {
            NSString*imgName=[[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"images"]objectAtIndex:0];
            NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
            [self.propertyImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
        }
    }
    
    if([self.userRatingValueLBL.text floatValue]<=0)
    {
        self.userReviewLBL.text=@"No Review";
        //CJC 12
        self.userRatingValueLBL.hidden = YES;
        self.userReviewLBL.hidden = YES;
        /**/
        
    }else{
        self.userRatingValueLBL.hidden = NO;
        self.userReviewLBL.hidden = NO;
    }
        
    if([self.userRatingValueLBL.text floatValue]<=2)
    {
        self.userReviewLBL.text=@"Poor";
    }
    else if([self.userRatingValueLBL.text floatValue]<=4.0)
    {
        self.userReviewLBL.text=@"Average";
    }
    else if([self.userRatingValueLBL.text floatValue]<=6.0)
    {
        self.userReviewLBL.text=@"Good";
    }else if([self.userRatingValueLBL.text floatValue]<8.0)
    {
        self.userReviewLBL.text=@"Very Good";
    }
    else
        self.userReviewLBL.text=@"Excellent";
    
    
    if([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"contactinfo"])
    {
        if([[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"contactinfo"] objectForKey:@"location"])
            
            self.propertyLocationLBL.text=[[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"contactinfo"] valueForKey:@"location"];
    }
    else
        self.propertyLocationLBL.text=@"";
    if([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"name"])
        self.propertyNameLBL.text=[[propertyArray objectAtIndex:selectedIndex] valueForKey:@"name"];
    else
        self.propertyNameLBL.text=@"";
         
         ///
         
         
         BOOL statusValue=NO;
         
         if ([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rooms"]) {
             for(NSDictionary* dic in [[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rooms"])
             {
                 if([dic isKindOfClass:[NSDictionary class]])
                 {
                     
                     if([[dic objectForKey:@"price"] isKindOfClass:[NSDictionary class]])
                     {
                         
                         if([[dic objectForKey:@"price"] objectForKey:@"h3"])
                         {
                             price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
                             self.hourLBL.text=@"3h";
                             
                             
                         }
                         else   if([[dic objectForKey:@"price"] objectForKey:@"h6"])
                         {
                             price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
                             
                             self.hourLBL.text=@"6h";
                         }
                         
                         else   if([[dic objectForKey:@"price"] objectForKey:@"h12"])
                         {
                             price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
                             self.hourLBL.text=@"12h";
                             
                         }
                         else
                             if([[dic objectForKey:@"price"] objectForKey:@"h24"])
                             {
                                 price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
                                 
                                 self.hourLBL.text=@"24h";
                                 
                             }
                         
                         // break;
                     }
                     else
                     {
                         price=[dic valueForKey:@"price"];
                         self.hourLBL.text=   [NSString stringWithFormat:@"%@h",[[propertyArray objectAtIndex:selectedIndex]valueForKey:@"smallest_timeslot"] ];
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
                                 discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h3"];
                                 
                                 
                                 
                             }
                             else   if([[dic objectForKey:@"custom_price"] objectForKey:@"h6"])
                             {
                                 discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h6"];
                                 
                                 
                                 
                             }
                             else
                                 if([[dic objectForKey:@"custom_price"] objectForKey:@"h12"])
                                 {
                                     discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h12"];
                                     
                                     
                                 }
                                 else  if([[dic objectForKey:@"custom_price"] objectForKey:@"h24"])
                                 {
                                     discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h24"];
                                     
                                     
                                     
                                 }
                             
                             break;
                         }else
                         {
                             discountPrice=[dic valueForKey:@"custom_price"];
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
         }
         NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" AED %@ ",price]];
         
         //  [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:NSMakeRange(0, 3)];
         
         NSInteger leng=str.length;
         // ProximaNovaA-Regular 12.0Helvetica Neue Medium
         // [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
         //  [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng-5)];
         
         // cell.priceLBL.attributedText = str;
         if(statusValue)
         {
             
             NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" AED %@ ",discountPrice]];
             NSInteger leng1=str1.length;
             
             [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
             [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng1-5)];
             
             
             // [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng-5)];
             [str addAttribute:NSStrikethroughStyleAttributeName
                         value:@1
                         range:NSMakeRange(0, [str length])];
             
             
             self.discountPriceLBL.attributedText = str;
             
             self.priceLBL.attributedText = str1;
             
             self.discountPriceLBL.hidden=NO;
             if([discountPrice floatValue]>=[price floatValue])
             {
                 self.discountPriceLBL.hidden=YES;
             }
             
         }
         else
         {
             self.discountPriceLBL.hidden=YES;;
             [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
             [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng-5)];
             self.priceLBL.attributedText = str;
             
         }
         
         self.featuredImageView.hidden=YES;
         

    self.hourLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]];
         cell.hourLBL.text = [NSString stringWithFormat:@"%@h",@"3" ];

     }
}

-(IBAction)loadFromMap:(id)sender
{
    DurationSelectionViewController *sd =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
    sd.placeName = @"";
    sd.latitude = @"";
    sd.longitude = @"";
    sd.formattedAddress = @"";
    //sd.isMonthlySelected = false;
    sd.cityIdString =@"";
    sd.selectionString = @"";
    sd.isHotelSelected = TRUE;
    sd.selectedHotel = [propertyArray objectAtIndex:currentIndexValue];
    [self.navigationController pushViewController:sd animated:TRUE];
    //TODO: OLD FLOW
    return;
    
    NSString* loadingString;
    loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[[propertyArray objectAtIndex:currentIndexValue]valueForKey:@"_id"]];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
   
        PropertyDetailsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
        vc.selectedProperty=[propertyArray objectAtIndex:currentIndexValue];
        vc.selectionString=loadingString;
        vc.property_id =[propertyArray objectAtIndex:currentIndexValue][@"_id"];

        [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end

