//
//  PopularPropertiesViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 14/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "PopularPropertiesViewController.h"

#import "PopularPropertiesViewController.h"
#import "ListHostelsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SinglePropertyDetailsViewController.h"
#import "MessageViewController.h"
#import "URLConstants.h"
#import "PropertyDetailsViewController.h"
#import "StayDateTimeViewController.h"

@interface PopularPropertiesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ListHostelsTableViewCell *cell;
    NSString *selectedFavId;
    IBOutlet NSLayoutConstraint *optionsViewWidth;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation PopularPropertiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
    _lblTitle.superview.layer.shadowOpacity = 0.3;
    _lblTitle.superview.layer.shadowRadius = 2.0;
    _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
    if(_isCheapest){
        _lblTitle.text = @"Cheapest hotels";
    }else{
        _lblTitle.text = @"Popular hotels";
    }
    

    self.view.backgroundColor = kColorCommonBG;

    
    self.timeBgImageview.clipsToBounds=YES;
    
    self.timeBgImageview.layer.cornerRadius=2;
    self.reviewBgImageview.clipsToBounds=YES;
    
    self.reviewBgImageview.layer.cornerRadius=2;
    
    optionsViewWidth.constant=[UIScreen mainScreen].bounds.size.width/2.5;
    self.mapView.showsUserLocation=YES;
    currentIndexValue=0;
    listingTBV.hidden=NO;
    mapLoadedStayus=NO;
    listingType=NO;
    propertyArray=[[NSMutableArray alloc]init];
    //june 24 -6h-11:30
    loadingLBL.text=@"";
    self.whiteImageView.layer.cornerRadius=4;
    [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteNormal"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteActive"] forState:UIControlStateSelected];
    self.BGView.alpha=0;
 utilObj = [[RequestUtil alloc]init];
    // Do any additional setup after loading the view. //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self loadApi];
    loadingLBL.hidden=NO;
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)loadApi
{
   /* [self webRawDataReceived:@{@"data":@{@"list":_popularPropertiesArray}}];
    return;*/
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"";
    
    hud.mode=MBProgressHUDModeText;
    hud.margin = 0.f;
    hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
    // hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-[UIScreen mainScreen].bounds.size.height/2);
    hud.removeFromSuperViewOnHide = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        hud.progress=hud.progress+0.05;
        if(hud.progress>1)
        {
            [timer invalidate];
        }
    }];
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
//
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"] forKey:@"number_adults"];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"] forKey:@"number_rooms"];
//
//    [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
//    NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];
    
    
  //  locationString=@"9.9312,76.2673";
//locationString=@"25.2048,55.2708";
    
    //[reqData setObject:locationString forKey:@"location"];
    
    //        "location:10.5276416, 76.21443490000001
    //    selected_hours:24
    //    checkin_time:10:30
    //    checkin_date:2018-08-11
    //    number_rooms:1
    //    number_adults:3
    //    number_childs:1
    
    
    [self.view endEditing:YES];
 
    
/*
 #ifndef DEBUG
                    NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLat"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLongt"]];
           [reqData setObject:locationString forKey:@"location"];

#endif
#ifdef DEBUG
           [reqData setObject:@"rahul.vagadiya@gmail.com" forKey:@"email"];

#endif*/
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    
    if(_isCheapest){
        [util postRequest:reqData toUrl:@"main/hotels-popular" type:@"GET"];

    }else{
        [util postRequest:reqData toUrl:@"main/hotels-cheapest" type:@"GET"];

    }


}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    loadingLBL.hidden=YES;
    
    [hud hideAnimated:YES afterDelay:0];
     [self.mapView removeAnnotations:self.mapView.annotations];
    if([rawData objectForKey:@"data"])
    {
        [propertyArray removeAllObjects];

        NSArray *listAr = [Commons dictionaryByReplacingNullsWithStrings:[rawData objectForKey:@"data"]][@"list"];
        if([listAr isKindOfClass:[NSArray class]]&&listAr.count>0)
        {
            /*if(firstTime)
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
                
              //  [[NSUserDefaults standardUserDefaults]objectForKey:@"priceSelected"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@,%@",minString,maxString] forKey:@"priceSelected"];
                
                [[NSUserDefaults standardUserDefaults] setObject:minString forKey:@"minSelected"];
                [[NSUserDefaults standardUserDefaults] setObject:maxString forKey:@"maxSelected"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                firstTime=NO;
        }*/
            [propertyArray addObjectsFromArray:listAr];

        }
/*
 //FIXME: DEBUG

#if DEBUG
        
        for(NSDictionary* dicValue in [rawData objectForKey:@"data"][@"list"])
        {
          
            [propertyArray addObject:dicValue];
        
        }
        
#else

        for(NSDictionary* dicValue in [rawData objectForKey:@"data"])
        {
            
            BOOL sts=NO;
            if([dicValue objectForKey:@"timeslots"])
            {
                for(NSString* stringVal in [dicValue objectForKey:@"timeslots"] )
                {
                    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] isEqualToString:[NSString stringWithFormat:@"%@",stringVal]])
                    {
                        sts=YES;
                        break;
                    }
                }
                
                if(sts)
            [propertyArray addObject:dicValue];
            }
        }
#endif

    */

        
       
        if([propertyArray count]==0)
        {
            loadingLBL.text=@"";
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
        if (selectedFavId&&[rawData objectForKey:@"message"] &&[[[rawData objectForKey:@"message"] lowercaseString] containsString:@"favourites"]) {
           // _favoriteButton.selected = !_favoriteButton.selected;
            
            [Commons addOrRomoveToFavselectedFavId:selectedFavId shouldAdd:[[[rawData objectForKey:@"message"] lowercaseString] containsString:@"added"]];

            selectedFavId = nil;
            
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Succses";
            vc.messageString=[rawData objectForKey:@"message"];
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            
             
        }
        
       else
       {
      //  loadingLBL.hidden=NO;
       // loadingLBL.text=@"There are no available rooms with your search criteria";
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=@"There are no availbale rooms";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
       }
        
    }
    [listingTBV reloadData];
}
-(IBAction)backFunction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
//    loadingLBL.text=response;
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
//    loadingLBL.text=errorMessage;
//   hud.margin = 10.f;
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
    
        ListHostelsTableViewCell *cell=(ListHostelsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ListHostelsTableViewCellNew"];
    [cell configureProprtiesCellWithObject:propertyArray[indexPath.row]];
    if([Commons checkFavorites:[propertyArray[indexPath.row] objectForKey:@"_id"] ])
    {
        cell.favoriteButton.selected=YES;
    }
    else
    {
        cell.favoriteButton.selected=NO;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.favoriteButton.restorationIdentifier = [propertyArray[indexPath.row] objectForKey:@"_id"];
    [cell.favoriteButton addTarget:self action:@selector(addOrRemoveFavorites:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
   // tableLoaded=YES;

    NSString* price=@"0";
    NSString* discountPrice=@"0";
    cell.propertyLocationLBL.text=@"";
    cell.userRatingValueLBL.text=@"0";
    cell.userReviewLBLValue.text=@"0";
    cell.userReviewLBL.text=@"0";

    cell.distanceLBL.hidden=YES;
    cell.distanceIMG.hidden=YES;
  if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"distance"])
    {
        
        
        float distance=[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"distance"] floatValue];
//        cell.distanceLBL.hidden=NO;
//        cell.distanceIMG.hidden=TRUE;
        cell.distanceLBL.text=[NSString stringWithFormat:@"%.02f KM from %@",distance,_lblTitle.text];
       
        
        
    }
   
    cell.propertyImageView.image = [UIImage imageNamed:@"QOMPlaceholder1"];
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
//    if([[self.selectedProperty objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
//    {
//        ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[[self.selectedProperty objectForKey:@"rating"] objectForKey:@"value"] ]];
//    }
//    else
//        ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[self.selectedProperty objectForKey:@"rating"] ]];
    //    else
    //        cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] ]];
     //   cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] ]];
    //    if([utilObj checkRating:[[popularByArray objectAtIndex:indexPath.row] objectForKey:@"rating"] ])
    //    {
    //        popularCell.favButtonSlotLbl.selected=YES;
    //    }
    //    else
    //    {
    //        popularCell.favButtonSlotLbl.selected=NO;
    //
      //  }
    
    if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
    {
        cell.userRatingValueLBL.text=[NSString stringWithFormat:@"%@",[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] objectForKey:@"value"] ];

//        cell.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rating"] objectForKey:@"value"] ]];
    }

    
    if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"userRating"])
    {
        cell.userReviewLBLValue.text=[NSString stringWithFormat:@"%0.2f",[[[propertyArray objectAtIndex:indexPath.row]  valueForKey:@"userRating"] floatValue] ];

//        cell.userRatingValueLBL.text=[NSString stringWithFormat:@"%@",[[propertyArray objectAtIndex:indexPath.row]  valueForKey:@"userRating"] ];
    }
    
    if([cell.userReviewLBLValue.text floatValue]<=0)
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
        
    if([cell.userReviewLBLValue.text floatValue]<=2.0)
    {
        cell.userReviewLBL.text=@"Poor";
    }
    else if([cell.userReviewLBLValue.text floatValue]<=4.0)
    {
        cell.userReviewLBL.text=@"Average";
    }
    else if([cell.userReviewLBLValue.text floatValue]<=6.0)
    {
        cell.userReviewLBL.text=@"Good";
    }else if([cell.userReviewLBLValue.text floatValue]<8.0)
    {
        cell.userReviewLBL.text=@"Very Good";
    }
    else
        cell.userReviewLBL.text=@"Excellent";

    cell.userRatingValueLBL.superview.layer.cornerRadius= 2.5;
    cell.userReviewLBLValue.layer.cornerRadius= cell.userRatingValueLBL.superview.layer.cornerRadius;
    if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"location"]&&[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"location"][@"address"])
    {
        cell.propertyLocationLBL.text = [[propertyArray objectAtIndex:indexPath.row] objectForKey:@"location"][@"address"];

    }
    else if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"])
    {

        if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] objectForKey:@"city"])
        {
            if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] objectForKey:@"city"][@"name"])

                cell.propertyLocationLBL.text=[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] valueForKey:@"city"][@"name"];
        }
        else if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] objectForKey:@"country"])
        {
            if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] objectForKey:@"country"][@"name"])

                cell.propertyLocationLBL.text=[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] valueForKey:@"country"][@"name"];
        }
        
    }
    else
        cell.propertyLocationLBL.text=@"";
    if([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"name"])
    cell.propertyNameLBL.text=[[propertyArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    else
        cell.propertyNameLBL.text=@"";

    price=@"0";

 //_hourLBL.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"];
    cell.hourLBL.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"];
    cell.hourLBL.text=@"";
               if ([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"stayDuration"])
               {
                   cell.hourLBL.text = [NSString stringWithFormat:@" %@ ",[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"stayDuration"][@"label"]];
                   
               }
    
//    if([self.selectionString isEqualToString:@"Near"])
//    {
//        //distanceLBL
//       cell.hourLBL.text= [NSString stringWithFormat:@"%@h",@"3" ];
//    }
    BOOL statusValue=NO;
// if ([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"minprice"])
// {
//     price=[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"minprice"];
// }
    
    price = [NSString stringWithFormat:@"%@",[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"priceSummary"][@"base"][@"amount"]];
    cell.priceLBL.text = price;
    NSString *savings = [NSString stringWithFormat:@"%@",[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"priceSummary"][@"base"][@"savings"]];
    int tot = [savings intValue]+[price intValue];
    NSString *total = [NSString stringWithFormat:@"%d",tot];
    cell.lblSavings.superview.hidden = FALSE;
    cell.lblSavings.text = [NSString stringWithFormat:@"Saving AED %@",savings];
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED %@ ",total]];
    
                                    //  [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:NSMakeRange(0, 3)];
    

    [str1 addAttribute:NSFontAttributeName value:cell.lblAED.font range:NSMakeRange(0, str1.length)];
        [str1 addAttribute:NSForegroundColorAttributeName value:cell.userReviewLBL.textColor range:NSMakeRange(0, str1.length)];
        
    [str1 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:2] range:NSMakeRange(str1.length-total.length, total.length)];

    cell.lblAED.hidden = FALSE;
    cell.lblAED.attributedText = str1;
  
    cell.featuredImageView.hidden=YES;
//    cell.hourLBL.hidden = TRUE;
//     cell.hourLBL.text=[NSString stringWithFormat:@"%@ H",[[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]] componentsSeparatedByString:@"h"] firstObject]] ;

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        
        
        //        NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
        //        [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
        //
        //        [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"] forKey:@"number_adults"];
        //        [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"] forKey:@"number_rooms"];
        //
        //        [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
        //        [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
        //        [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
    
    
     NSString *small=[NSString stringWithFormat:@"%@",[[propertyArray objectAtIndex:indexPath.row]valueForKey:@"smallest_timeslot"] ];
    
        NSString* loadingString;
        loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",small,[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[[propertyArray objectAtIndex:indexPath.row]valueForKey:@"_id"]];
        
        
        
        
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
  //  [self.navigationController popViewControllerAnimated:YES];
    
};
-(IBAction)sortFunction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];

};
-(IBAction)filterFunction:(id)sender{
    
};

-(void)addPins:(NSInteger)tag
{
    propertyTag=0;
    
    if([propertyArray count]>0)
    {
        [self clickFromMap:0];
        [UIView animateWithDuration:0.4 animations:^{
            self.BGView.alpha=1;
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
                    propertyTag++;
                    
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
        containerView.tag=[annotation.title integerValue];
        // mapButton.enabled=YES;
        // mapButton.userInteractionEnabled=YES;
      //  propertyTag++;
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

-(IBAction)loadFromMap:(id)sender
{
    
    
     NSString *small=[NSString stringWithFormat:@"%@",[[propertyArray objectAtIndex:currentIndexValue]valueForKey:@"smallest_timeslot"] ];
    
    NSString* loadingString;
    loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",small,[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[[propertyArray objectAtIndex:currentIndexValue]valueForKey:@"_id"]];
    
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
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
        PropertyDetailsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
        vc.selectedProperty=[propertyArray objectAtIndex:currentIndexValue];
        vc.selectionString=loadingString;
    vc.property_id =[propertyArray objectAtIndex:currentIndexValue][@"_id"];

        [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(void)clickFromMap:(NSInteger)selectedIndex
{
    currentIndexValue=selectedIndex;
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
        if([[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
        {
            self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] objectForKey:@"value"] ]];
        }
        else
            self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] ]];
//     self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] ]];
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
                        self.hourLBL.text=[NSString stringWithFormat:@"%@h",[[propertyArray objectAtIndex:selectedIndex]valueForKey:@"smallest_timeslot"] ];
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
        
        
        //
        
        
        
//    if ([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rooms"]) {
//        for(NSDictionary* dic in [[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rooms"])
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
//                        _hourLBL.text=@"3H";
//
//                    }
//                    else if([[dic objectForKey:@"price"] objectForKey:@"h6"])
//                    {
//                        price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
//                        _hourLBL.text=@"6H";
//
//
//                    }
//                    else if([[dic objectForKey:@"price"] objectForKey:@"h12"])
//                    {
//                        price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
//                        _hourLBL.text=@"12H";
//
//                    }
//                    else if([[dic objectForKey:@"price"] objectForKey:@"h24"])
//                    {
//                        price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
//                        _hourLBL.text=@"24H";
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
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED %@",price]];
//
//    NSInteger leng=str.length;
//    // ProximaNovaA-Regular 12.0Helvetica Neue Medium
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 3)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:22.0] range:NSMakeRange(4, leng-4)];
//    self.priceLBL.attributedText = str;
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED 1200"]];
//
//    [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:9.0] range:NSMakeRange(0, 3)];
//    self.discountPriceLBL.attributedText = str1;
//    self.featuredImageView.hidden=YES;
   // self.discountPriceLBL.hidden=YES;
    self.hourLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]];
}
}

-(IBAction)listTypeFunction:(id)sender{
    
    if(listingType)
    {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.BGView.alpha=0;
        }];
        listingTBV.hidden=NO;
        listingType=NO;
        
        
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
-(void)addOrRemoveFavorites:(UIButton*)button
{
    selectedFavId = button.restorationIdentifier;
     {
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
        }

        
        [self.view endEditing:YES];
        
        RequestUtil *util = [[RequestUtil alloc]init];
        util.webDataDelegate=(id)self;
        [util postRequest:@{@"propertyId":selectedFavId} withToken:TRUE toUrl:[NSString stringWithFormat: @"users/favorites"] type:@"POST"];
    }
}
@end

