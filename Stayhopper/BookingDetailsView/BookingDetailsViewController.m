//
//  BookingDetailsViewController.m
//  Stayhopper
//
//  Created by iROID Technologies on 11/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "BookingDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "AvailabilityViewController.h"
#import "MessageViewController.h"
#import "WriteReviewViewController.h"
@interface BookingDetailsViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet NSLayoutConstraint *centerval;
    BOOL isForTitle;
}
@end

@implementation BookingDetailsViewController

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    timePicker= [[NSDateFormatter alloc]init];

    dirImageView.layer.cornerRadius=4;
    clickedIndex=0;
    [favoriteButton setImage:[UIImage imageNamed:@"FavoriteNormal"] forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:@"FavoriteActive"] forState:UIControlStateSelected];
    imageArray=[[NSMutableArray alloc]init];
    menueArray=[[NSArray alloc]initWithObjects:@"ABOUT",@"REVIEWS",@"NEARBY", nil];
    self.slideImgWidth.constant=[UIScreen mainScreen].bounds.size.width/3;
    
    utilObj=[[RequestUtil alloc]init];
    self.availabilityButtonWidth.constant=[UIScreen mainScreen].bounds.size.width/2;

    [self loadBasicInfo];
    if([UIScreen mainScreen].bounds.size.height>=812)
    {
        self.scrollTop.constant=-40;
        
        self.navigationTop.constant=-40;
        self.bottomConst.constant=0;
    }
    else
    {
        self.navigationTop.constant=-20;
        self.bottomConst.constant=20;
        self.scrollTop.constant=-20;
    }
}
-(void)loadBasicInfo
{
    rulesBtn.alpha=1;
    self.cancelLBL.text=self.cancelVAL;
    if([self.loadedProperty objectForKey:@"book_id"])
        bookingIDLBL.text=[self.loadedProperty objectForKey:@"book_id"];
    
    
    if([self.selectionString isEqualToString:@"Current"])
    {
        rulesBtn.alpha=0;
        self.availabilityButtonWidth.constant=0;
    if([self.selectedProperty objectForKey:@"name"])
        propertyNameLBL.text=[self.selectedProperty valueForKey:@"name"];
    else
        propertyNameLBL.text=@"";
    ditanceLBL.text=self.distanceString;
    if([[self.selectedProperty objectForKey:@"contactinfo"] objectForKey:@"location"])
        ditanceLBL.text=[[self.selectedProperty objectForKey:@"contactinfo"] objectForKey:@"location"];
    else
        ditanceLBL.text=@"";
    [imageArray removeAllObjects];
    if([self.selectedProperty objectForKey:@"images"])
        for(NSString* imageString in [self.selectedProperty objectForKey:@"images"])
        {
            [imageArray addObject:imageString];
            
        }
        
        
    [imageCollectionView reloadData];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MMM dd"];
    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
    
    NSInteger roomsCount=0;
    for(NSDictionary* dic in [self.loadedProperty objectForKey:@"room"])
    {
        roomsCount=roomsCount+[[dic valueForKey:@"number"] integerValue];
    }
    
    //"selected_hours":24,
    // "checkin_time":"10:30",
        
        
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
        
        NSString *roomsString=@"ROOM";
        NSString *adultsString=@"ADULT";
        NSString *childString=@"CHILD";
        
        if(roomsCount>1)
        {
            roomsString=@"ROOMS";
        }
        if([[self.loadedProperty objectForKey:@"no_of_adults"] integerValue]>1)
        {
            adultsString=@"ADULTS";
        }
        if([[self.loadedProperty objectForKey:@"no_of_children"] integerValue]>1)
        {
            childString=@"CHILDREN'S";
        }
        if([[self.loadedProperty objectForKey:@"no_of_children"] integerValue]!=0)
        {
            adultsAndRoomsLBL.text=[NSString stringWithFormat:@"%ld %@, %@ %@, %@ %@",(long)roomsCount,roomsString,[self.loadedProperty objectForKey:@"no_of_adults"],adultsString,[self.loadedProperty objectForKey:@"no_of_children"],childString];
            
        }
        
        else
        {
            adultsAndRoomsLBL.text=[NSString stringWithFormat:@"%ld %@, %@ %@",(long)roomsCount,roomsString,[self.loadedProperty objectForKey:@"no_of_adults"],adultsString];
        }
//    adultsAndRoomsLBL.text=[NSString stringWithFormat:@"%ld %@,%@ %@,%@ %@",roomsCount,roomsString,[self.loadedProperty objectForKey:@"no_of_adults"],adultsString,[self.loadedProperty objectForKey:@"no_of_children"],childString];
    
    
    
    NSDate *selectedDate=[dateFormatter dateFromString:[self.loadedProperty objectForKey:@"checkin_date"] ];
    
    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
    NSString* nextDayString=[dateFormatter2 stringFromDate:selectedDate];
    
    sloatDateLBL.text=[NSString stringWithFormat:@"%@-%@h-%@",nextDayString,[self.loadedProperty objectForKey:@"selected_hours"],[self setDate:[self.loadedProperty objectForKey:@"checkin_time"]]];
    
    
    }else
    {
        
       // rulesBtn.alpha=0;
        
         if([[self.loadedProperty objectForKey:@"cancel_approval"]intValue] == 1)
         {
             rulesBtn.alpha=0;
             
             self.availabilityButtonWidth.constant=[UIScreen mainScreen].bounds.size.width-20;
             centerval.constant=[UIScreen mainScreen].bounds.size.width;

         }
        if([[self.loadedProperty objectForKey:@"propertyInfo"] objectForKey:@"name"])
            propertyNameLBL.text=[[self.loadedProperty objectForKey:@"propertyInfo"] valueForKey:@"name"];
        else
            propertyNameLBL.text=@"";
        
        ditanceLBL.text=self.distanceString;
        if([[self.loadedProperty objectForKey:@"propertyInfo"] objectForKey:@"location"])
            ditanceLBL.text=[[self.loadedProperty objectForKey:@"propertyInfo"] objectForKey:@"location"];
        else
            ditanceLBL.text=@"";
        
        [imageArray removeAllObjects];
        if([[self.loadedProperty objectForKey:@"propertyInfo"] objectForKey:@"images"])
            for(NSString* imageString in [[self.loadedProperty objectForKey:@"propertyInfo"] objectForKey:@"images"])
            {
                [imageArray addObject:imageString];
                //  [imageArray addObject:imageString];
                
            }
        [imageCollectionView reloadData];
        
        
        
        
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        
        NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc]init];
        [dateFormatter2 setDateFormat:@"MMM dd"];
        [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
        
        NSInteger roomsCount=0;
        for(NSDictionary* dic in [self.loadedProperty objectForKey:@"roomsInfo"])
        {
            roomsCount=roomsCount+1;
        }
        
        //"selected_hours":24,
        // "checkin_time":"10:30",
        
        
        
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
       
         NSString *roomsString=@"ROOM";
         NSString *adultsString=@"ADULT";
         NSString *childString=@"CHILD";
         
         if(roomsCount>1)
         {
         roomsString=@"ROOMS";
         }
         if([[self.loadedProperty objectForKey:@"no_of_adults"] integerValue]>1)
         {
         adultsString=@"ADULTS";
         }
         if([[self.loadedProperty objectForKey:@"no_of_children"] integerValue]>1)
         {
         childString=@"CHILDREN'S";
         }
        if([[self.loadedProperty objectForKey:@"no_of_children"] integerValue]!=0)
        {
           adultsAndRoomsLBL.text=[NSString stringWithFormat:@"%ld %@, %@ %@,%@ %@",roomsCount,roomsString,[self.loadedProperty objectForKey:@"no_of_adults"],adultsString,[self.loadedProperty objectForKey:@"no_of_children"],childString];
        }
        
        else
        {
             adultsAndRoomsLBL.text=[NSString stringWithFormat:@"%ld %@, %@ %@",roomsCount,roomsString,[self.loadedProperty objectForKey:@"no_of_adults"],adultsString];
        }
        
        
       
        
        
        
        NSDate *selectedDate=[dateFormatter dateFromString:[self.loadedProperty objectForKey:@"checkin_date"] ];
        
        [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
        NSString* nextDayString=[dateFormatter2 stringFromDate:selectedDate];
        
        sloatDateLBL.text=[NSString stringWithFormat:@"%@ - AED %@",nextDayString,[self.loadedProperty objectForKey:@"total_amt"]];
      //  [[pastBookingArray objectAtIndex:indexPath.row] objectForKey:@"total_amt"]
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
    scrollView.contentSize=CGSizeMake(0,0);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return imageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    homeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    
    NSString*imgName=[imageArray objectAtIndex:indexPath.item];
    NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    [homeCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
    
    
    
    
    return homeCell;
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==imageCollectionView)
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.height);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //            MallDetailsViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
    //            [self.navigationController pushViewController:menuView animated:YES];
    
    
    
    
}
-(IBAction)favoriteFunction:(UIButton*)sender
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"loadStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    [utilObj addOrRemoveFavorites:[self.selectedProperty objectForKey:@"_id"] userID:@""];
    
    if(sender.isSelected)
    {
        sender.selected=NO;
    }
    else
    {
        sender.selected=YES;
        
    }
    }
    
}
-(IBAction)backFunction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
};
-(IBAction)shareFunction:(id)sender
{
    
};
-(IBAction)checkFunction:(UIButton*)sender
{
    
}


- (void)Uploadprogress
{
    //  hud.progress = progress=hud.progress+0.05;
    hud.progress=hud.progress+0.05;
    //    if(hud.progress>1)
    //        hud.progress=0;
}
-(IBAction)payNowFunction:(UIButton*)sender;
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AvailabilityViewController *vc = [y   instantiateViewControllerWithIdentifier:@"AvailabilityViewController"];
    
    //vc.locationDic=self.selectedProperty;

    if([self.selectionString isEqualToString:@"Current"])
    {
        vc.pastVal=@"NO";

    vc.locationDic=self.selectedProperty;
    }
    else
    {
        vc.pastVal=@"YES";
        vc.locationDic= [self.loadedProperty objectForKey:@"propertyInfo"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)reviewButton:(UIButton*)sender
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WriteReviewViewController *vc = [y   instantiateViewControllerWithIdentifier:@"WriteReviewViewController"];
    if([self.selectionString isEqualToString:@"Current"])
    {
        if([self.selectedProperty objectForKey:@"name"])
            vc.propertyName=[self.selectedProperty valueForKey:@"name"];
        else
            vc.propertyName=@"";
    //vc.propertyName=@"";
    vc.propertyID=[self.selectedProperty valueForKey:@"_id"];
    }
    else
    {
        
        if([[self.loadedProperty objectForKey:@"propertyInfo"] objectForKey:@"name"])
             vc.propertyName=[[self.loadedProperty objectForKey:@"propertyInfo"] valueForKey:@"name"];
        else
             vc.propertyName=@"";
        
        vc.propertyID=[[self.loadedProperty objectForKey:@"propertyInfo"] valueForKey:@"id"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    
    
    if([rawData objectForKey:@"data"])
    {
        [hud hideAnimated:YES afterDelay:0];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }
    else
    {
      //  hud.margin = 10.f;
     //   hud.label.text = [rawData objectForKey:@"message"];
        
        [hud hideAnimated:YES afterDelay:0];
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=[rawData objectForKey:@"message"];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    
    
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    //  loadingLBL.text=@"There are no available rooms with your search criteria";
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
- (IBAction)directionClick:(id)sender
{
    
    //self.latitudeValue=;
  //  self.longitudeValue=[[[NSUserDefaults standardUserDefaults] valueForKey:@"mapLongitude"] floatValue];
    NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                                     [[[NSUserDefaults standardUserDefaults] valueForKey:@"currentLatitude"] floatValue], [[[NSUserDefaults standardUserDefaults] valueForKey:@"currentLongitude"] floatValue], [[[NSUserDefaults standardUserDefaults] valueForKey:@"mapLatitude"] floatValue], [[[NSUserDefaults standardUserDefaults] valueForKey:@"mapLongitude"] floatValue]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
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
@end

