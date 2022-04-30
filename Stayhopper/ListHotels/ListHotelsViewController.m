//
//  ListHotelsViewController.m
//  Stayhopper
//
//  Created by iROID Technologies on 08/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ListHotelsViewController.h"
#import "ListHostelsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "PropertyDetailsViewController.h"
#import "SinglePropertyDetailsViewController.h"
#import "FiltersViewController.h"
#import "SortViewController.h"
#import "MessageViewController.h"
#import "Commons.h"
#import "URLConstants.h"
#import "MKMapDimOverlay.h"
#import "MKMapDimOverlayView.h"
#import "StayDateTimeViewController.h"
#import "SingletonClass.h"
#import "FiltersNewViewController.h"


@interface ListHotelsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *viewMapOverlay;
    IBOutlet NSLayoutConstraint *optionsViewWidth;
    NSString *selectedFavId;
    int selectedHotelIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIView *viewSingleDetails;

@end

@implementation ListHotelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedHotelIndex = -1;
    NSString *pickupLocationName =[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLocationName"];
    if ([pickupLocationName isKindOfClass:[NSString class]]) {
        _lblTitle.text = pickupLocationName;
    }
//    if (_btnFilter.imageView.image) {
//        [_btnFilter setImage:[Commons image:_btnFilter.imageView.image fromColor:_lblTitle.textColor] forState:UIControlStateNormal];
//    }
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
    _lblTitle.superview.layer.shadowOpacity = 0.3;
    _lblTitle.superview.layer.shadowRadius = 2.0;
    _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    _lblTitle.numberOfLines = 1;
    self.view.backgroundColor = kColorCommonBG;
    listingTBV.backgroundColor = kColorCommonBG;
    _btnMap.hidden = TRUE;
    firstTime=YES;
    minString=@"0";
    maxString=@"0";
    sortString=@"sort_rating=0";
    tableLoaded=NO;
    [[NSUserDefaults standardUserDefaults] setObject:sortString forKey:@"sortValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if([self.selectionString isEqualToString:@"popular"])
    {
        sortLBL.text=@"Popularity";
        sortString=@"sort_rating=1";
        tableLoaded=NO;
        [[NSUserDefaults standardUserDefaults] setObject:sortString forKey:@"sortValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.timeBgImageview.clipsToBounds=YES;
    
    self.timeBgImageview.layer.cornerRadius=2;
    self.reviewBgImageview.clipsToBounds=YES;
    
    self.reviewBgImageview.layer.cornerRadius=2;
    
    optionsViewWidth.constant=[UIScreen mainScreen].bounds.size.width/2.5;
    viewMapOverlay = [[UIView alloc] init];
    viewMapOverlay.backgroundColor = kColorDarkBlueThemeColor;
    viewMapOverlay.alpha = 0.5;
    viewMapOverlay.clipsToBounds = TRUE;

   // [self.mapView addOverlay:viewMapOverlay];
    
    MKMapDimOverlay *dimOverlay = [[MKMapDimOverlay alloc] initWithMapView:self.mapView];
    
    [self.mapView addOverlay: dimOverlay];

    
    self.mapView.showsUserLocation=YES;
    currentIndexValue=0;
    listingTBV.hidden=NO;
    mapLoadedStayus=NO;
    listingType=NO;
    if([self.selectionString isEqualToString:@"Near"])
    {
        listingType=YES;
        listTypeImageView.image=[UIImage imageNamed:@"list"];

    }
    propertyArray=[[NSMutableArray alloc]init];
    _ratingArray=[[NSMutableArray alloc]init];

    _serviceArray=[[NSMutableArray alloc]init];

    //june 24 -6h-11:30
    loadingLBL.text=@"";
    utilObj = [[RequestUtil alloc]init];
    [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteNormal"] forState:UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"FavoriteActive"] forState:UIControlStateSelected];
    _lblTitle.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLocationName"];
     if([self.selectionString isEqualToString:@"Near"])
         _lblTitle.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocationName"];

    
//    [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
//    [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *selectedDate=[dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedDate"] ];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MMM dd"];
    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
    NSString* nextDayString=[dateFormatter2 stringFromDate:selectedDate];
    scheduleLBL.text=[NSString stringWithFormat:@"%@-%@-%@",nextDayString,[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"],[utilObj convertTime]] ;
    self.BGView.alpha=0;
    
    self.whiteImageView.layer.cornerRadius=4;
    _mapView.hidden = TRUE;
    _viewSingleDetails.hidden = _mapView.hidden;

    [self loadApi];
    loadingLBL.hidden=NO;
    // Do any additional setup after loading the view. //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadApi) name:kNotificationFilterItemsChanges object:nil];

    if (_checkinDateSelected) {
        NSString *cityname = _lblTitle.text;
        NSString *timeStr =@"";
        if (_isHourly) {
            timeStr =[NSString stringWithFormat:@"%@-%@",[Commons stringFromDate:_checkinDateSelected Format:@"MMM-dd HH:mm"],[Commons stringFromDate:_checkoutDateSelected Format:@"HH:mm"]];
        }
        else{
            timeStr =[NSString stringWithFormat:@"%@-%@",[Commons stringFromDate:_checkinDateSelected Format:@"MMM-dd"],[Commons stringFromDate:_checkoutDateSelected Format:@"MMM-dd-yy"]];

        }
        NSString *complStr =[NSString stringWithFormat:@"%@ %@",cityname,timeStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:complStr attributes:@{NSForegroundColorAttributeName:_lblTitle.textColor,NSFontAttributeName:_lblTitle.font}];

        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.102 green:0.118 blue:0.4 alpha:0.5]} range:NSMakeRange(complStr.length-timeStr.length, timeStr.length)];
        [attr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:FontMedium size:14]} range:NSMakeRange(complStr.length-timeStr.length, timeStr.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [attr addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0,[attr length])];
        
        _lblTitle.attributedText = attr;
        

//        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];


    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    if([overlay isMemberOfClass:[MKMapDimOverlay class]]) {
        MKMapDimOverlayView *dimOverlayView = [[MKMapDimOverlayView alloc] initWithOverlay:overlay];
        dimOverlayView.overlayColor = kColorDarkBlueThemeColor;
        return dimOverlayView;
    }
    return nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    viewMapOverlay.frame = self.mapView.bounds;
}
    -(void)loadApi
    {
//        #if DEBUG
//                self.searchDic[@"selected_hours"] = @"3";
//        #endif
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

        
//    "location:10.5276416, 76.21443490000001
//    selected_hours:24
//    checkin_time:10:30
//    checkin_date:2018-08-11
//    number_rooms:1
//    number_adults:3
//    number_childs:1
        
        
        for (NSDictionary *item in [SingletonClass getInstance].selectedFiltersArray) {
            NSArray *ids = [item[@"ids"] allObjects];
            self.searchDic[item[@"key"]]=[ids componentsJoinedByString:@","];
            
        }
        self.searchDic[@"sort"] = [SingletonClass getInstance].currentSortSelection;
        if ([SingletonClass getInstance].selectedMinimumPrice!=-1) {
            self.searchDic[@"priceMin"] = [NSString stringWithFormat:@"%d",[SingletonClass getInstance].selectedMinimumPrice];
            self.searchDic[@"priceMax"] = [NSString stringWithFormat:@"%d",[SingletonClass getInstance].selectedMaximumPrice];
            
        }
        
        [self.view endEditing:YES];
        NSLog(@"self.searchDic---->%@",self.searchDic);

        RequestUtil *util = [[RequestUtil alloc]init];
        util.webDataDelegate=(id)self;
        
      /*  if([self.selectionString isEqualToString:@"Near"])
        {
            NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];
            
            
//            NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
//            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedChild"] forKey:@"number_childs"];
//
//            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedAdults"] forKey:@"number_adults"];
//            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"] forKey:@"number_rooms"];
//
//            [reqData setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""] forKey:@"selected_hours"];
//            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"] forKey:@"checkin_time"];
//            [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"] forKey:@"checkin_date"];
//
//           //[reqData setObject:@"" forKey:@"sort_rating"];
//
//            [reqData setObject:locationString forKey:@"location"];
//
//
//
//           // locationString=@"9.9312,76.2673";
//           // locationString=@"25.2048,55.2708";
//
//            NSMutableString *strReqString = [[NSMutableString alloc] initWithString:@""];;
//            for (NSString *key in reqData) {
//
//                NSString *value = [reqData objectForKey:key];
//                [strReqString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
//            }
//            listingString=@"";
//            if(strReqString.length==0)
//            {
//
//            }
//            else
//            {
//                listingString = strReqString;
//            }
            
            //[reqData setObject:locationString forKey:@"location"];
            
            //        "location:10.5276416, 76.21443490000001
            //    selected_hours:24
            //    checkin_time:10:30
            //    checkin_date:2018-08-11
            //    number_rooms:1
            //    number_adults:3
            //    number_childs:1
            
            
            [self.view endEditing:YES];
            
            RequestUtil *util = [[RequestUtil alloc]init];
            util.webDataDelegate=(id)self;
            NSMutableDictionary *reqData1 = [NSMutableDictionary dictionary];
            
            listingString=[NSString stringWithFormat: @"properties/search/near?checkin_time=%@&location=%@&",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentSlotTime"],locationString];
            [util postRequest:reqData1 toUrl:[NSString stringWithFormat: @"properties/search/near?checkin_time=%@&location=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentSlotTime"],locationString] type:@"GET"];
            
            
//            listingString=[NSString stringWithFormat: @"properties/search/near?location=%@&",locationString];
//            [util postRequest:reqData1 toUrl:[NSString stringWithFormat: @"properties/search/near?location=%@",locationString] type:@"GET"];
          //  [util postRequest:self.searchDic toUrl:[NSString stringWithFormat:@"properties/search/near?="] type:@"GET"];

        }
 else*/
 {
    
     
     
         [util postRequest:self.searchDic toUrl:@"properties/search" type:@"POST"];

     
     
     
 }
}
-(void)addingAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];

    for (NSDictionary *item in propertyArray) {
        if([item objectForKey:@"location"])
        {
            NSArray *coordinates = [item objectForKey:@"location"][@"coordinates"];
            if ([coordinates isKindOfClass:[NSArray class]]&&coordinates.count>0) {
                {
                                    MKPointAnnotation *mapPin1 = [[MKPointAnnotation alloc] init];
                                    
                                    mapPin1.title=[NSString stringWithFormat:@"%lu",(unsigned long)[propertyArray indexOfObject:item]];
                                  //  propertyTag++;
                                    
                                    double latitude1 = [coordinates[1] doubleValue];
                                    double longitude1 = [coordinates[0] doubleValue];
                                    CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1);
                                    
                                    MKCoordinateSpan span;
                                    span.latitudeDelta = .5f;
                                    span.longitudeDelta = .5f;
                                    MKCoordinateRegion region;
                                    region.center = coordinate1;
                                    region.span = span;
                                    //[_mapView setRegion:region animated:TRUE];
                                 //   [_mapView setRegion:region];
                                    // setup the map pin with all data and add to map view
                                    
                                    mapPin1.coordinate = coordinate1;
                                    
                                    [self.mapView addAnnotation:mapPin1];
                                }
            }
            
        }
    }
}

-(void)webRawDataReceived:(NSDictionary *)rawData
{
    mapLoadedStayus=NO;
    loadingLBL.hidden=YES;
  

   // listingTBV.contentOffset=CGPointMake(0, 0);
    if(firstTime)
    {
    minString=@"0";
    maxString=@"0";
        [[NSUserDefaults standardUserDefaults] setObject:minString forKey:@"minSelected"];
        [[NSUserDefaults standardUserDefaults] setObject:maxString forKey:@"maxSelected"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [hud hideAnimated:YES afterDelay:0];
    
   // [listingTBV reloadData];

   // self.BGView.alpha=0;
    if([rawData objectForKey:@"data"])
    {
         if(propertyArray.count!=0 && tableLoaded)
        [listingTBV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
        

        [propertyArray removeAllObjects];

        NSArray *listAr = [rawData objectForKey:@"data"][@"list"];
        if([listAr isKindOfClass:[NSArray class]]&&listAr.count>0)
        {
        
            [propertyArray addObjectsFromArray:listAr];
            if (selectedHotelIndex ==-1 || selectedHotelIndex>=propertyArray.count) {
                selectedHotelIndex = 0;
            }
        }
        if (propertyArray.count==0) {
            selectedHotelIndex = -1;

        }
        [self addingAnnotations];
        [self.mapView showAnnotations:self.mapView.annotations animated:FALSE];

        [self loadSelecteViewsAtTheBottom];
  
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
            [self loadSelecteViewsAtTheBottom];

             
        }
        else
        {
        //loadingLBL.hidden=NO;
       // loadingLBL.text=@"";
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
       vc.messageString=@"There are no availbale rooms";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
        }
    }
    if([self.selectionString isEqualToString:@"Near"])
    {
        if(!listingType)
        {
            [listingTBV reloadData];
        }
        else
        {
            [self listTypeFunctionNEW:nil];
            
        }
    }
    else
    {
        if(!listingType)
        {
        [listingTBV reloadData];
        }
        else
        {
            [self listTypeFunctionNEW:nil];

       }
    }
}
-(IBAction)backFunction:(id)sender
{
    if (_mapView.hidden) {
        [self.navigationController popViewControllerAnimated:YES];

    }
    else{
        [self listTypeFunction:nil];
    }
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
 //   loadingLBL.text=@"There are no available rooms with your search criteria";
    hud.margin = 10.f;
    hud.label.text = response;
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

   // hud.margin = 10.f;
   // hud.label.text = errorMessage;
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=errorMessage;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    [hud hideAnimated:YES afterDelay:0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableLoaded=NO;
    if([propertyArray count]==0)
         {
             _btnMap.hidden = TRUE;

         }
    else
    {
      _btnMap.hidden = !_mapView.hidden;

    }
    return [propertyArray count];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    if(indexPath.row%2==0)
//    cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
//    else
//        cell.transform = CGAffineTransformMakeTranslation(0, 100);
//
//   // cell.transform = CGAffineTransformMakeTranslation(50.f, 100);
//
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
    
        ListHostelsTableViewCell *cell=(ListHostelsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ListHostelsTableViewCellNew"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureProprtiesCellWithObject:[propertyArray objectAtIndex:indexPath.row]];
    
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
    tableLoaded=YES;

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
          cell.distanceLBL.hidden=NO;
          cell.distanceIMG.hidden=NO;
          cell.distanceLBL.text=[NSString stringWithFormat:@"%.02f KM from %@",distance,_lblTitle.text];
         
          
          
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
//        if([[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] objectForKey:@"location"])
//
//        cell.propertyLocationLBL.text=[[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"contactinfo"] valueForKey:@"location"];
        
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
    
     
     if ([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"]) {
         
         NSArray* sortedArray=[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"];
         
//         NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"current_price"
//                                                                      ascending:YES];
//         NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
//         NSArray *sortedArray = [arrin sortedArrayUsingDescriptors:sortDescriptors];
         
         
//         for(NSDictionary* dic in [[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"])
        for(NSDictionary* dic in sortedArray)
        {
            if([dic isKindOfClass:[NSDictionary class]])
            {
                if([[dic objectForKey:@"priceSummary"] isKindOfClass:[NSDictionary class]])
                {
                if (dic[@"priceSummary"][@"total"]) {
                    if (dic[@"priceSummary"][@"total"][@"amount"]) {
                        price = dic[@"priceSummary"][@"total"][@"amount"];

                    }
                }
                
               /* if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
                {
                    if([[dic objectForKey:@"price"] objectForKey:@"h3"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
                        
                        
                    }
                }
                else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
                {
                    if([[dic objectForKey:@"price"] objectForKey:@"h6"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
                        
                        
                    }
                }
                else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
                {
                    if([[dic objectForKey:@"price"] objectForKey:@"h12"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
                        
                    }
                }
                else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
                {
                    if([[dic objectForKey:@"price"] objectForKey:@"h24"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
                        
                        
                    }
                }
                */
                // break;
            }
                
               /* if([[dic objectForKey:@"price"] isKindOfClass:[NSDictionary class]])
                {
                    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
                    {
                    if([[dic objectForKey:@"price"] objectForKey:@"h3"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
                        
                        
                    }
                    }
                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
                    {
                        if([[dic objectForKey:@"price"] objectForKey:@"h6"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
                        
                        
                    }
                    }
                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
                    {
                        if([[dic objectForKey:@"price"] objectForKey:@"h12"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
                        
                    }
                    }
                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
                    {
                        if([[dic objectForKey:@"price"] objectForKey:@"h24"])
                    {
                        price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
                        
                        
                    }
                    }
                    
                   // break;
                }
                else
                {
                    price=[dic valueForKey:@"price"];
                    //break;
                }
                */
                ////
               /* if([dic objectForKey:@"custom_price"])
                {
                    statusValue=YES;
                if([[dic objectForKey:@"custom_price"] isKindOfClass:[NSDictionary class]])
                {
                
                    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
                    {
                        if([[dic objectForKey:@"custom_price"] objectForKey:@"h3"])
                        {
                            discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h3"];
                            
                            
                        }
                    }
                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
                    {
                        if([[dic objectForKey:@"custom_price"] objectForKey:@"h6"])
                        {
                            discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h6"];
                            
                            
                        }
                    }
                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
                    {
                        if([[dic objectForKey:@"custom_price"] objectForKey:@"h12"])
                        {
                            discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h12"];
                            
                        }
                    }
                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
                    {
                        if([[dic objectForKey:@"custom_price"] objectForKey:@"h24"])
                        {
                            discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h24"];
                            
                            
                        }
                    }
                    
                    break;
                }else
                {
                    discountPrice=[dic valueForKey:@"custom_price"];
                    break;
                }
                }*/
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
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, 4)];

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
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, 4)];

          [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(5, leng-5)];
        cell.priceLBL.attributedText = str;

    }
    cell.featuredImageView.hidden=YES;
     cell.hourLBL.text=[NSString stringWithFormat:@"%@ H",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]] ;
//    cell.userRatingValueLBL.backgroundColor = [UIColor redColor];
//    cell.userRatingValueLBL.hidden = FALSE;
    return cell;
}
-(void)gotoDetailsPage:(NSDictionary*)item
{
    
    PropertyDetailsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
        vc.selectedProperty=item;
        vc.selectionString=@"";
    vc.property_id =item[@"_id"];
    vc.attributedTitle = _lblTitle.attributedText;
    _searchDic[@"property_id"] = vc.property_id;
    vc.selectedDetails = _searchDic;
    
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)singleItemSelected:(id)sender {
    [self gotoDetailsPage:propertyArray[selectedHotelIndex]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self gotoDetailsPage:propertyArray[indexPath.row]];

    return;
    
    
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
    
//     vc.selectedProperty=[propertyArray objectAtIndex:indexPath.row];
//    vc.property_id =[propertyArray objectAtIndex:indexPath.row][@"_id"];
//    if (_searchDic) {
//        _searchDic[@"property_id"] = vc.property_id;
//        vc.selectedDetails = _searchDic;
//    }
//     [self.navigationController pushViewController:vc animated:YES];
    
}


-(IBAction)loadFromMap:(id)sender
{
    NSString* loadingString;
    loadingString=[NSString stringWithFormat:@"properties/single?selected_hours=%@&checkin_time=%@&checkin_date=%@&number_rooms=%@&property=%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]  stringByReplacingOccurrencesOfString:@"h" withString:@""],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedDate"],[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedRooms"],[[propertyArray objectAtIndex:currentIndexValue]valueForKey:@"_id"]];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    if(![self.selectionString isEqualToString:@"Near"])
    {

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
        sd.selectedHotel = [propertyArray objectAtIndex:currentIndexValue];
        [self.navigationController pushViewController:sd animated:TRUE];
        //TODO: OLD FLOW
        return;
    PropertyDetailsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
    vc.selectedProperty=[propertyArray objectAtIndex:currentIndexValue];
    vc.selectionString=loadingString;
    [self.navigationController pushViewController:vc animated:YES];
}else
{
    DurationSelectionViewController *sd =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
    sd.placeName = @"";
    sd.latitude = @"";
    sd.longitude = @"";
    sd.formattedAddress = @"";
   // sd.isMonthlySelected = false;
    sd.cityIdString =@"";
    sd.selectionString = @"";
    sd.isHotelSelected = TRUE;
    sd.selectedHotel = [propertyArray objectAtIndex:currentIndexValue];
    [self.navigationController pushViewController:sd animated:TRUE];
    //TODO: OLD FLOW
    return;
    
    PropertyDetailsViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]   instantiateViewControllerWithIdentifier:@"PropertyDetailsViewController"];
    vc.property_id =[propertyArray objectAtIndex:currentIndexValue][@"_id"];

    vc.selectedProperty=[propertyArray objectAtIndex:currentIndexValue];
    vc.selectionString=loadingString;
    [self.navigationController pushViewController:vc animated:YES];
}

}
-(IBAction)whenFunction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
};
-(IBAction)whereFunction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];

};
-(IBAction)sortFunction:(id)sender{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
    SortViewController *vc = [y   instantiateViewControllerWithIdentifier:@"SortViewController"];
    vc.valueString=listingString;
    vc.fromString=self.selectionString;
    vc.delegate=self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
};
-(IBAction)filterFunction:(id)sender{
    
    
    FiltersNewViewController *fv = [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"FiltersNewViewController"];
     fv.modalPresentationStyle = UIModalPresentationFullScreen;
    fv.isFromMapView = listingTBV.hidden;
     [self.navigationController presentViewController:fv animated:TRUE completion:^{
             
     }];
     return;
    
    
    
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
  
        
        FiltersViewController *vc = [y   instantiateViewControllerWithIdentifier:@"FiltersViewController"];
    vc.valueString=listingString;
    vc.delegate=self;
    vc.serviceArrayPassed=self.serviceArray;
    vc.ratingArrayPassed=self.ratingArray;
    vc.minString=minString;
    vc.maxString=maxString;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    
    
};

-(void)addPins:(NSInteger)tag
{
    propertyTag=0;
    
    if([propertyArray count]>0)
    {
    [self clickFromMap:0];
    [UIView animateWithDuration:0.5 animations:^{    self.BGView.alpha=1;
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

-(IBAction)clickFunction:(UIButton*)sender
{
    
}
-(void)loadSelecteViewsAtTheBottom
{
    
//    [_viewSingleDetails setBackgroundColor:[UIColor whiteColor]];//CJC remove
    ListHostelsTableViewCell *cell;
    _viewSingleDetails.hidden = _mapView.hidden;
    cell =  [_viewSingleDetails viewWithTag:111];
    if (!cell) {
        _viewSingleDetails.hidden = TRUE;
        return;
    }
    int indx =selectedHotelIndex;
    if (indx==-1 || indx>=propertyArray.count) {
        _viewSingleDetails.hidden = TRUE;
        return;
    }
    
    
    
     [cell configureProprtiesCellWithObject:[propertyArray objectAtIndex:indx]];
    cell.propertyLocationLBL.numberOfLines = 1;
    if([Commons checkFavorites:[propertyArray[indx] objectForKey:@"_id"] ])
    {
        cell.favoriteButton.selected=YES;
    }
    else
    {
        cell.favoriteButton.selected=NO;
        
    }
    
    cell.favoriteButton.restorationIdentifier = [propertyArray[indx] objectForKey:@"_id"];

    [_viewSingleDetails bringSubviewToFront:cell];//CJC added
}
-(IBAction)listTypeFunction:(id)sender{
    
    _mapView.hidden = !_mapView.hidden;
    listingTBV.hidden = !_mapView.hidden;
    _btnMap.hidden = listingTBV.hidden;
    _imgBack.highlighted =!_mapView.hidden;
    _viewSingleDetails.hidden = _mapView.hidden;
    if (_viewSingleDetails.hidden == FALSE) {
        ListHostelsTableViewCell *cell;
        if (![_viewSingleDetails viewWithTag:111]) {
          //  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListHostelsTableViewCellNew"]
//            ListHostelsTableViewCell *cell=(ListHostelsTableViewCell*)[listingTBV dequeueReusableCellWithIdentifier:@"ListHostelsTableViewCellNew"];
//            [cell configureProprtiesCellWithObject:[propertyArray objectAtIndex:0]];

//            ListHostelsTableViewCell *cell= [[ListHostelsTableViewCell alloc]init];
            
            cell = [listingTBV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedHotelIndex inSection:0]];

            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            [cell.favoriteButton addTarget:self action:@selector(addOrRemoveFavorites:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnDetails.hidden = FALSE;
            [cell.btnDetails addTarget:self action:@selector(singleItemSelected:) forControlEvents:UIControlEventTouchUpInside];

            
            cell.frame = _viewSingleDetails.bounds;
            [_viewSingleDetails addSubview:cell];
//            [_viewSingleDetails bringSubviewToFront:cell];

            cell.tag = 111;
        }
        else{
            cell =  [_viewSingleDetails viewWithTag:111];
        }
        [self loadSelecteViewsAtTheBottom];
        
    }
    return;
   
    
    
};
-(IBAction)listTypeFunctionNEW:(id)sender{
    
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
    if([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"userRating"])
    {
        
        
        self.userRatingValueLBL.text=[NSString stringWithFormat:@"%0.2f",[[[propertyArray objectAtIndex:selectedIndex]  valueForKey:@"userRating"] floatValue] ];
    }
    
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
   //  self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] ]];
    
        
        
//        if([[self.selectedProperty objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
//        {
//            ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[[self.selectedProperty objectForKey:@"rating"] objectForKey:@"value"] ]];
//        }
//        else
//            ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[self.selectedProperty objectForKey:@"rating"] ]];
        if([[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
        {
            self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] objectForKey:@"value"] ]];
        }
        else
            self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] ]];
    if([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"contactinfo"])
    {
        if([[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"contactinfo"] objectForKey:@"city"])
            if([[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"contactinfo"] objectForKey:@"city"][@"name"])

            self.propertyLocationLBL.text=[[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"contactinfo"] valueForKey:@"city"][@"name"];
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
                    
                    if([[dic objectForKey:@"priceSummary"] isKindOfClass:[NSDictionary class]])
                    {
                        if (dic[@"priceSummary"][@"total"]) {
                            if (dic[@"priceSummary"][@"total"][@"amount"]) {
                                price = dic[@"priceSummary"][@"total"][@"amount"];

                            }
                        }
                        
                       /* if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
                        {
                            if([[dic objectForKey:@"price"] objectForKey:@"h3"])
                            {
                                price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
                                
                                
                            }
                        }
                        else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
                        {
                            if([[dic objectForKey:@"price"] objectForKey:@"h6"])
                            {
                                price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
                                
                                
                            }
                        }
                        else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
                        {
                            if([[dic objectForKey:@"price"] objectForKey:@"h12"])
                            {
                                price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
                                
                            }
                        }
                        else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
                        {
                            if([[dic objectForKey:@"price"] objectForKey:@"h24"])
                            {
                                price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
                                
                                
                            }
                        }
                        */
                        // break;
                    }
                  /*  else
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
                            
                            if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
                            {
                                if([[dic objectForKey:@"custom_price"] objectForKey:@"h3"])
                                {
                                    discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h3"];
                                    
                                    
                                }
                            }
                            else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
                            {
                                if([[dic objectForKey:@"custom_price"] objectForKey:@"h6"])
                                {
                                    discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h6"];
                                    
                                    
                                }
                            }
                            else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
                            {
                                if([[dic objectForKey:@"custom_price"] objectForKey:@"h12"])
                                {
                                    discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h12"];
                                    
                                }
                            }
                            else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
                            {
                                if([[dic objectForKey:@"custom_price"] objectForKey:@"h24"])
                                {
                                    discountPrice=[[dic objectForKey:@"custom_price"] valueForKey:@"h24"];
                                    
                                    
                                }
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
                    */
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
//                    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"3H"])
//                    {
//                        if([[dic objectForKey:@"price"] objectForKey:@"h3"])
//                        {
//                            price=[[dic objectForKey:@"price"] valueForKey:@"h3"];
//
//
//                        }
//                    }
//                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"6H"])
//                    {
//                        if([[dic objectForKey:@"price"] objectForKey:@"h6"])
//                        {
//                            price=[[dic objectForKey:@"price"] valueForKey:@"h6"];
//
//
//                        }
//                    }
//                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"12H"])
//                    {
//                        if([[dic objectForKey:@"price"] objectForKey:@"h12"])
//                        {
//                            price=[[dic objectForKey:@"price"] valueForKey:@"h12"];
//
//                        }
//                    }
//                    else  if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]uppercaseString] isEqualToString:@"24H"])
//                    {
//                        if([[dic objectForKey:@"price"] objectForKey:@"h24"])
//                        {
//                            price=[[dic objectForKey:@"price"] valueForKey:@"h24"];
//
//
//                        }
//                    }
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
//    NSInteger leng=str.length;
//   // ProximaNovaA-Regular 12.0Helvetica Neue Medium
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
//     [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:22.0] range:NSMakeRange(5, leng-5)];
//    self.priceLBL.attributedText = str;
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED 1200"]];
//
//    [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 3)];
//    self.discountPriceLBL.attributedText = str1;
//    self.featuredImageView.hidden=YES;
//    self.discountPriceLBL.hidden=NO;
    self.hourLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]];
        if([self.selectionString isEqualToString:@"Near"])
        {
            //FIXME:hourLBL
            self.hourLBL.text= [NSString stringWithFormat:@"%@h",@"3" ];
        }
}
}
-(void)filterFunctionByString:(NSString*)filterOption value:(NSString*)selectedString
{
    
   // priceSelected   sortValue
    
   // filterLBL.text=selectedString;
  //  sortLBL.text=@"Default";
    filterLBL.text=selectedString;
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
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    if([self.selectionString isEqualToString:@"Near"])
    {
        
        NSMutableDictionary *reqData1 = [NSMutableDictionary dictionary];

        
         [util postRequest:reqData1 toUrl:filterOption type:@"GET"];
    }
    else
  [util postString:filterOption toUrl:@"properties/search" type:@"POST"];
    
        
   // [util postString:filterOption toUrl:@"test/testsearch" type:@"POST"];

        
       
        
    
}
-(void)sortFunctionByString:(NSString*)filterOption value:(NSString*)selectedString
{
    {
        
        // priceSelected   sortValue
        
        // filterLBL.text=selectedString;
        //  sortLBL.text=@"Default";
        sortLBL.text=selectedString;
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
        
        RequestUtil *util = [[RequestUtil alloc]init];
        util.webDataDelegate=(id)self;
        if([self.selectionString isEqualToString:@"Near"])
        {
            
            NSMutableDictionary *reqData1 = [NSMutableDictionary dictionary];
            
            
            [util postRequest:reqData1 toUrl:filterOption type:@"GET"];
        }
        else
            [util postString:filterOption toUrl:@"properties/search" type:@"POST"];
        
        
        // [util postString:filterOption toUrl:@"test/testsearch" type:@"POST"];
        
        
        
        
        
    }
    

    
    
    
    
}
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
      //  pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
     //   if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.userInteractionEnabled=YES;
        pinView.enabled=YES;
        UIImage *annotationImage;
        UIColor *tetxtColor;
        if (selectedHotelIndex==[annotation.title integerValue]) {
            annotationImage= [UIImage imageNamed:@"map_annot_1"];
            tetxtColor = [UIColor whiteColor];
        }
        else{
            annotationImage= [UIImage imageNamed:@"map_annot_0"];
            tetxtColor = kColorDarkBlueThemeColor;
        }
        
        
      //  map_annot_0@2x
        pinView.frame = CGRectMake(0, 0, annotationImage.size.width,annotationImage.size.height);
        float height = pinView.frame.size.height - pinView.frame.size.height*10./42.0;
        
        UIView *itemContainers;
        UIView*containerView;
        containerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, annotationImage.size.width,annotationImage.size.height)];
        containerView.tag=[annotation.title integerValue];
        containerView.backgroundColor = [UIColor clearColor];

        
        itemContainers = [[UIView alloc]initWithFrame:CGRectMake(0, 0, containerView.frame.size.width,height)];
        itemContainers.backgroundColor = [UIColor clearColor];
        [containerView addSubview:itemContainers];
        itemContainers.layer.cornerRadius = containerView.layer.cornerRadius;
       // itemContainers.layer.borderColor = kColorThemeBlue.CGColor;
        //itemContainers.layer.borderWidth = 1.0;
        itemContainers.clipsToBounds = TRUE;


        

        UILabel *lbltitle =[[UILabel alloc] initWithFrame:CGRectMake(2.5, 2.5, itemContainers.frame.size.width-5., itemContainers.frame.size.height)];
        lbltitle.font =[UIFont fontWithName:FontRegular size:14];
        NSDictionary *item =propertyArray[containerView.tag];
        

        lbltitle.textAlignment = NSTextAlignmentCenter;
        lbltitle.numberOfLines = 2;
        lbltitle.textColor = tetxtColor;
      //  lbltitle.text = annotation.title;
        lbltitle.text = [NSString stringWithFormat:@"AED %@",[item objectForKey:@"priceSummary"][@"base"][@"amount"]];
        [itemContainers addSubview:lbltitle];
        lbltitle.backgroundColor = [UIColor clearColor];
        containerView.userInteractionEnabled=YES;
        pinView.image=annotationImage;
        pinView.tag = [annotation.title integerValue];
       
        [pinView addSubview:containerView];
       
        
    }
    
    return pinView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   [mapView deselectAnnotation:view.annotation animated:FALSE];
    if (view.tag!=selectedHotelIndex) {
        selectedHotelIndex = view.tag;
        [self addingAnnotations];
        [self loadSelecteViewsAtTheBottom];
    }
 

    
}
@end
