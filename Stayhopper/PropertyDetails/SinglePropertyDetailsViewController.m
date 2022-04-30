//
//  SinglePropertyDetailsViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 12/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "SinglePropertyDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "ReviewListViewController.h"
#import "NearByLocationsViewController.h"
#import "AvailabilityViewController.h"
#import "MessageViewController.h"
#import "AboutTabedViewController.h"
#import "URLConstants.h"
@interface SinglePropertyDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *lblTitle;

@end

@implementation SinglePropertyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
       _lblTitle.superview.layer.shadowOpacity = 0.3;
       _lblTitle.superview.layer.shadowRadius = 2.0;
       _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
    self.view.backgroundColor = kColorCommonBG;
    
    clickedIndex=0;
    menuCollectionView.hidden = TRUE;

    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"selectedRooms"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"selectedChild"];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"selectedAdults"];
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    [favoriteButton setImage:[UIImage imageNamed:@"FavoriteNormal"] forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:@"FavoriteActive"] forState:UIControlStateSelected];
    imageArray=[[NSMutableArray alloc]init];
    menueArray=[[NSMutableArray alloc]initWithObjects:@"Overview",@"Reviews",@"Nearby", nil];
    self.slideImgWidth.constant=0;
    UISwipeGestureRecognizer *upRecognizer= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [upRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [downRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [bgScrollView addGestureRecognizer:upRecognizer];
    [bgScrollView addGestureRecognizer:downRecognizer];
    utilObj=[[RequestUtil alloc]init];

    
    
//    if([UIScreen mainScreen].bounds.size.height>=812)
//    {
//        self.scrollTop.constant=-40;
//
//        self.navigationTop.constant=-40;
//        self.bottomConst.constant=-20;
//    }
//    else
//    {
//        self.navigationTop.constant=-20;
//        self.bottomConst.constant=0;
//        self.scrollTop.constant=-20;
//    }
    
    [self loadBasicInfo];

    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movetoTop)   name:@"movetotop" object:nil];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movetobottom)   name:@"movetobottom" object:nil];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoDescription)   name:@"descriptionEnlarge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoPolicies)   name:@"policiesEnlarge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushFacilities)   name:@"facilitiesEnlarge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportAction)   name:@"reportAction" object:nil];
}
-(void)reportAction
{
    
    NSString *call, *message,*report,*block,*copy,*cancel,*options;
    
    
    call=@"Violation of Terms and conditions";
    message=@"Offensive word usage";
    
    cancel=@"Cancel";
    options=@"Options";
    
    UIAlertController *actnSheet=[UIAlertController alertControllerWithTitle:options message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actnSheet addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){
        
    }]];
    [actnSheet addAction:[UIAlertAction actionWithTitle:call style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [self reportAbuse];
        
    }]];
    
    [actnSheet addAction:[UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
        [self reportAbuse];
        
    }]];
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:actnSheet animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:actnSheet];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}


-(void)reportAbuse
{
    
}
-(void)pushtoDescription
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutTabedViewController  *aboutTabedViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AboutTabedViewController"];
    aboutTabedViewController.commonDIC=self.selectedProperty;
    aboutTabedViewController.loadedDIC=self.loadedProperty;
    aboutTabedViewController.selectedPropName=[self.selectedProperty valueForKey:@"name"];

    aboutTabedViewController.indexString=@"0";

    [self.navigationController pushViewController:aboutTabedViewController animated:YES ];
}
-(void)pushtoPolicies
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutTabedViewController  *aboutTabedViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AboutTabedViewController"];
    aboutTabedViewController.commonDIC=self.selectedProperty;
    aboutTabedViewController.loadedDIC=self.loadedProperty;
    aboutTabedViewController.selectedPropName=[self.selectedProperty valueForKey:@"name"];

    aboutTabedViewController.indexString=@"2";

    [self.navigationController pushViewController:aboutTabedViewController animated:YES ];
}
-(void)pushFacilities
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutTabedViewController  *aboutTabedViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AboutTabedViewController"];
    aboutTabedViewController.commonDIC=self.selectedProperty;
    aboutTabedViewController.loadedDIC=self.loadedProperty;
    aboutTabedViewController.selectedPropName=[self.selectedProperty valueForKey:@"name"];

    aboutTabedViewController.indexString=@"1";

    [self.navigationController pushViewController:aboutTabedViewController animated:YES ];
}
-(void)movetoTop
{
    float height=bgScrollView.frame.size.height;
    [UIView animateWithDuration:1.0f animations:^{
         navigationView.backgroundColor=   [UIColor colorWithRed: 0.043 green: 0.090 blue: 0.298 alpha:1];
        if([UIScreen mainScreen].bounds.size.height>=812)
            self.topScrollViewTop.constant=-1*(height-115);
        else
            self.topScrollViewTop.constant=-1*(height-138);
        
        [self.view layoutIfNeeded];
    }];
    
}
-(void)movetobottom
{
    // float height=bgScrollView.frame.size.height;
    
    [UIView animateWithDuration:1.0f animations:^{
         navigationView.backgroundColor=   [UIColor clearColor];
        if([UIScreen mainScreen].bounds.size.height>=812)
            self.topScrollViewTop.constant=-40;
        else
            self.topScrollViewTop.constant=-20;
        
        [self.view layoutIfNeeded];
    }];
}

-(void)loadBasicInfo
{
    /////
    _slideImgWidth.constant = 0;

    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    for(NSString* key in keys){
        
        if([key containsString:@"count-"] || [key containsString:@"selectedRoom-"] )
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
    }
    ///////
    
 //   ditanceLBL.text=[NSString stringWithFormat:@"- from %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLocationName"] ];
    
    [imageArray removeAllObjects];
    if([self.selectedProperty objectForKey:@"images"])
        for(NSString* imageString in [self.selectedProperty objectForKey:@"images"])
        {
            [imageArray addObject:imageString];
          //  [imageArray addObject:imageString];
            
        }
    [imageCollectionView reloadData];
    
//    imageCollectionView.layer.borderWidth = 2.0;
//    imageCollectionView.layer.borderColor = [UIColor greenColor].CGColor;
    
//    if(imageArray.count==0)
//    {
//        countLBL.text=@"0/0";
//    }
//    else
//    {
//        countLBL.text=[NSString stringWithFormat:@"1/%lu",(unsigned long)imageArray.count ];
//
//    }
    
    NSString* price=@"0";
    //  NSString* discountPrice=@"0";
    // cell.propertyLocationLBL.text=@"";
    userReviewValueLBL.text=@"0";
    if([[self.selectedProperty objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
    {
        countLBL.text = [NSString stringWithFormat:@"%@",[[self.selectedProperty  objectForKey:@"rating"] valueForKey:@"value"] ];
     }
    else
    {
        countLBL.text = @"0";
    }
    
    if([self.selectedProperty objectForKey:@"user_rating"])
    {
        
        
        userReviewValueLBL.text=[NSString stringWithFormat:@"%@",[self.selectedProperty  valueForKey:@"user_rating"] ];
    }
    userReviewValueLBL.layer.cornerRadius = 2.5;
    countLBL.superview.layer.cornerRadius = 2.5;
    
    
    if([userReviewValueLBL.text floatValue]<=0)
    {
        userReviewLBL.text=@"No Review";
        //CJC 12
        userReviewValueLBL.hidden = YES;
        userReviewLBL.hidden = YES;
        /**/
        
    }else{
        userReviewValueLBL.hidden = NO;
        userReviewLBL.hidden = NO;
    }
        
    if([userReviewValueLBL.text floatValue]<=2)
    {
        userReviewLBL.text=@"Poor";
    }
    else if([userReviewValueLBL.text floatValue]<=4.0)
    {
        userReviewLBL.text=@"Average";
    }
    else if([userReviewValueLBL.text floatValue]<=6.0)
    {
        userReviewLBL.text=@"Good";
    }else if([userReviewValueLBL.text floatValue]<8.0)
    {
        userReviewLBL.text=@"Very Good";
    }
    else
        userReviewLBL.text=@"Excellent";
    
    NSString *nameLbl =  @"";
    NSString *addrsLbl =  @"";

    if([self.selectedProperty objectForKey:@"name"])
    {
        nameLbl =[NSString stringWithFormat:@"%@\n",[self.selectedProperty valueForKey:@"name"]];
    }
    
        propertyNameLBL.text=@"";

    
        if([self.selectedProperty objectForKey:@"contactinfo"])
        {
            if([[self.selectedProperty objectForKey:@"contactinfo"] objectForKey:@"location"])
                addrsLbl = [[self.selectedProperty objectForKey:@"contactinfo"] valueForKey:@"location"];
            

        }
    NSString *completeStrign = [NSString stringWithFormat:@"%@%@",nameLbl,addrsLbl];
    NSMutableAttributedString *completeAttr = [[NSMutableAttributedString alloc] initWithString:completeStrign];
    [completeAttr addAttributes:@{NSForegroundColorAttributeName:kColorDarkBlueThemeColor,NSFontAttributeName:[UIFont fontWithName:FontSemiBold size:propertyNameLBL.font.pointSize]} range:NSMakeRange(0, completeStrign.length)];
    if (addrsLbl.length>0)
    {
        [completeAttr addAttributes:@{NSForegroundColorAttributeName:userReviewLBL.textColor,NSFontAttributeName:[UIFont fontWithName:FontRegular size:propertyNameLBL.font.pointSize-3]} range:NSMakeRange(completeStrign.length-addrsLbl.length, addrsLbl.length)];

    }

    
    propertyNameLBL.attributedText = completeAttr;
    
    //    else
    //        cell.propertyLocationLBL.text=@"";
    price=@"0.0";
    
//    if ([self.selectedProperty objectForKey:@"rooms"]) {
//        for(NSDictionary* dic in [self.selectedProperty objectForKey:@"rooms"])
//        {   if([dic isKindOfClass:[NSDictionary class]])
//        {
//            if([dic objectForKey:@"price"])
//            {
//                price=[dic valueForKey:@"price"];
//                break;
//            }
//        }
//        else
//            price=@"0.0";
//     }
//    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        favoriteButton.hidden=NO;
        
    }else
    {
        favoriteButton.hidden=YES;
        
    }
    if([utilObj checkFavorites:[self.selectedProperty objectForKey:@"_id"] ])
    {
        favoriteButton.selected=YES;
    }
    else
    {
        favoriteButton.selected=NO;
    }
    
    
  
    
    
//    if([[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
//    {
//        self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] objectForKey:@"value"] ]];
//    }
//    else
//        self.propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rating"] ]];
    
//     ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[self.selectedProperty objectForKey:@"rating"] ]];
    
    //    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED %@",price]];
    //
    //    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:NSMakeRange(0, 3)];
    //    .attributedText = str;
    //    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED 1200"]];
    //
    //    [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:9.0] range:NSMakeRange(0, 3)];
    //    cell.discountPriceLBL.attributedText = str1;
    //    cell.featuredImageView.hidden=YES;
    //    cell.discountPriceLBL.hidden=YES;
    //    cell.hourLBL.text=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]] uppercaseString];
    
    
    NSString *roomsString=@"ROOM";
    NSString *adultsString=@"ADULT";
    NSString *childString=@"CHILD";
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"] integerValue]>1)
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
    
//    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"] integerValue]>0)
//    {
//        adultsAndRoomsLBL.text= [NSString stringWithFormat:@"%@ %@, %@ %@, %@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"],roomsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"],adultsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"],childString];
//    }else
//    {
//        adultsAndRoomsLBL.text= [NSString stringWithFormat:@"%@ %@, %@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"],roomsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"],adultsString];
//    }
    
    
//    adultsAndRoomsLBL.text= [NSString stringWithFormat:@"%@ %@ , %@ %@ , %@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"],roomsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"],adultsString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"],childString];
    
//    adultsAndRoomsLBL.text= [NSString stringWithFormat:@"%@ ROOM , %@ ADULT , %@ CHILD",[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"],[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"],[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedChild"]];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *selectedDate=[dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedDate"] ];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MMM dd"];
    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
    NSString* nextDayString=[dateFormatter2 stringFromDate:selectedDate];
    if([self.selectedProperty objectForKey:@"name"])
    {
        _lblTitle.text =[self.selectedProperty valueForKey:@"name"];
    }
    else
    {
        _lblTitle.text = addrsLbl;
    }

    //    self.menuDetailsScrollViewHeight.constant= [UIScreen mainScreen].bounds.size.height-(topView.frame.origin.y+topView.frame.size.height)-165;
    
    
    
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
    
    [self.view endEditing:YES];
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    
    if([self.selectionString isEqualToString:@"Near"])
    {
        NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];

        [self.view endEditing:YES];
        
        RequestUtil *util = [[RequestUtil alloc]init];
        util.webDataDelegate=(id)self;
        NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
        
        [util postRequest:reqData toUrl:[NSString stringWithFormat: @"properties/search/near?location=%@",locationString] type:@"GET"];

    }
    else
    {
  
        NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];

       NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
           [util postRequest:reqData toUrl:[NSString stringWithFormat: @"%@&location=%@&number_adults=%@",self.selectionString,locationString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"]] type:@"GET"];
        
    }
}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    // loadingLBL.hidden=YES;
    
    [hud hideAnimated:YES afterDelay:0];
    //  [propertyArray removeAllObjects];
    self.loadedProperty=nil;
    _slideImgWidth.constant = [UIScreen mainScreen].bounds.size.width/menueArray.count;
    _slideImgLeading.constant = 0;

    if([rawData objectForKey:@"data"])
    {
        
        self.loadedProperty=[rawData objectForKey:@"data"];
        [self loadNeededViews];
        if([[rawData objectForKey:@"data"] objectForKey:@"rooms"])
        {
            for(NSDictionary* dic in [[rawData objectForKey:@"data"] objectForKey:@"rooms"])
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:[NSString stringWithFormat:@"count-%@",[dic valueForKey:@"_id"]]];
                [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:[NSString stringWithFormat:@"selectedRoom-%@",[dic valueForKey:@"_id"]]];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
        }
        
        
    }
    else
    {
        [self loadNeededViews];
        
    }
    
    
}
-(void)loadNeededViews
{
    [self.view layoutIfNeeded];
    
    if([self.loadedProperty objectForKey:@"distance"] && [self.loadedProperty objectForKey:@"distance_unit"] )
    {
        if(![[self.loadedProperty objectForKey:@"distance"] isKindOfClass:[NSNull class]])
        {
            ditanceLBL.text=[NSString stringWithFormat:@"%.2f %@ from %@",[[self.loadedProperty objectForKey:@"distance"] floatValue],[self.loadedProperty objectForKey:@"distance_unit"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocationName"] ];
        }
        else
            ditanceLBL.text=@"0.0Kms";
        
    }
    
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    RoomsListViewController  *roomsListViewController = [storyBoard instantiateViewControllerWithIdentifier:@"RoomsListViewController"];
//    if([self.loadedProperty  objectForKey:@"rooms"])
//
//        roomsListViewController.dataArray=[NSArray arrayWithArray:[self.loadedProperty objectForKey:@"rooms"]];
//
//    roomsListViewController.view.frame = CGRectMake(0,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
//    [self addChildViewController:roomsListViewController];
//    [menuDetailsScrolView addSubview:roomsListViewController.view];
    
    /////////
    
    AboutPropertyViewController  *aboutPropertyViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AboutPropertyViewController"];
    aboutPropertyViewController.selectedProperty=self.selectedProperty;
    aboutPropertyViewController.loadedsProperty=self.loadedProperty;
    aboutPropertyViewController.fromString=@"NO";

    NSMutableArray* srviceArray=[[NSMutableArray alloc]init];
    for(NSDictionary* dicVal in [self.loadedProperty  objectForKey:@"rooms"])
    {
        for(NSDictionary* dicValue in [dicVal objectForKey:@"services"])
            
            
        {
            BOOL isAvailbale=NO;
            
            for(NSDictionary* dicAdded in srviceArray)
            {
                if([[dicAdded valueForKey:@"_id"] isEqualToString:[dicValue valueForKey:@"_id"]])
                    isAvailbale=YES;
            }
            if(!isAvailbale)
                [srviceArray addObject:dicValue];
        }
    }
    
    aboutPropertyViewController.availableServices=srviceArray;
    
    
    if([self.selectedProperty objectForKey:@"contactinfo"])
    {
        if([[self.selectedProperty objectForKey:@"contactinfo"] objectForKey:@"latlng"])
            
        {
            
            if([[[self.selectedProperty objectForKey:@"contactinfo"] objectForKey:@"latlng"] count]>1)
            {
                
                double latitude1 = [[[[self.selectedProperty objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:0] doubleValue];
                double longitude1 = [[[[self.selectedProperty objectForKey:@"contactinfo"] objectForKey:@"latlng"] objectAtIndex:1] doubleValue];
                NSString *lat =[NSString stringWithFormat:@"%f",latitude1];
                NSString *lon =[NSString stringWithFormat:@"%f",longitude1];
                [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"mapLatitude"];
                [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"mapLongitude"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            }
            
        }
        
    }
    
    aboutPropertyViewController.view.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,menuDetailsScrolView.frame.size.height);
    [self addChildViewController:aboutPropertyViewController];
    [menuDetailsScrolView addSubview:aboutPropertyViewController.view];
    
    ///////
    int xoff = 1;
    ///////
    NSArray *reviews = [self.loadedProperty objectForKey:@"reviews"];
    if ([reviews isKindOfClass:[NSArray class]]&& reviews.count>0)
    {

    
    ReviewListViewController  *reviewListViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReviewListViewController"];
    reviewListViewController.view.frame = CGRectMake(menuDetailsScrolView.frame.size.width*xoff,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
    
    NSMutableArray* reviewsArray=[[NSMutableArray alloc]init];
    if([self.selectedProperty objectForKey:@"user_rating"])
    {
        
        
        reviewListViewController.ratingValue1=[NSString stringWithFormat:@"%@",[self.selectedProperty  valueForKey:@"user_rating"] ];
    }
    else
        reviewListViewController.ratingValue1=@"0.0";
    
    if([self.loadedProperty  objectForKey:@"reviews"])
    {
        //NSMutableArray* roomsArray=[[NSMutableArray alloc]init];
        
        for (NSDictionary* dic in [self.loadedProperty objectForKey:@"reviews"])
        {
            [reviewsArray addObject:dic];
        }
        
    }
    reviewListViewController.dataArray=reviewsArray;
    
    [self addChildViewController:reviewListViewController];
    [menuDetailsScrolView addSubview:reviewListViewController.view];
        xoff++;
    }
    else
    {
        [menueArray removeObjectAtIndex:xoff];

    }
    /////////
    NearByLocationsViewController  *nearByLocationsViewController = [storyBoard instantiateViewControllerWithIdentifier:@"NearByLocationsViewController"];
    nearByLocationsViewController.shouldHideTopView = TRUE;
    if([self.selectedProperty objectForKey:@"name"])
    {
        nearByLocationsViewController.titleString = [self.selectedProperty objectForKey:@"name"];
    }
    nearByLocationsViewController.dataArray = @[@{@"lat":@"25.1649",@"long":@"55.4084",@"title":@"Dubai",@"sub":@"Subtitle"}];

    if([self.selectedProperty  objectForKey:@"nearby"])
    {
        nearByLocationsViewController.dataArray=[NSArray arrayWithArray:[self.selectedProperty objectForKey:@"nearby"]];

    }
    nearByLocationsViewController.dataArray = @[@{@"lat":@"25.1649",@"long":@"55.4084",@"title":@"Dubai",@"sub":@"Subtitle"}];

    nearByLocationsViewController.view.frame = CGRectMake(menuDetailsScrolView.frame.size.width*xoff,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
//    nearByLocationsViewController.view.layer.borderWidth = 2.0;
//    nearByLocationsViewController.view.layer.borderColor = [UIColor redColor].CGColor;
    [self addChildViewController:nearByLocationsViewController];
    [menuDetailsScrolView addSubview:nearByLocationsViewController.view];
    
    ////
    menuDetailsScrolView.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width*(xoff+1), 0);
    menuDetailsScrolView.contentOffset=CGPointMake(0,0);
    
    [menuCollectionView reloadData];
    self.slideImgWidth.constant=[UIScreen mainScreen].bounds.size.width/menueArray.count;

    menuCollectionView.hidden = FALSE;


}

-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    //  loadingLBL.text=@"There are no available rooms with your search criteria";
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
    
//    hud.margin = 10.f;
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


- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        float height=bgScrollView.frame.size.height;
        
        [UIView animateWithDuration:1.0f animations:^{
             navigationView.backgroundColor=   [UIColor colorWithRed: 0.043 green: 0.090 blue: 0.298 alpha:1];
            if([UIScreen mainScreen].bounds.size.height>=812)
                self.topScrollViewTop.constant=-1*(height-115);
            else
                self.topScrollViewTop.constant=-1*(height-138);
            
            [self.view layoutIfNeeded];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:1.0f animations:^{
             navigationView.backgroundColor=   [UIColor clearColor];
            if([UIScreen mainScreen].bounds.size.height>=812)
                self.topScrollViewTop.constant=-40;
            else
                self.topScrollViewTop.constant=-20;
            
            [self.view layoutIfNeeded];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backFunction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
};
-(IBAction)shareFunction:(id)sender
{
    {
        UIImage *image = [UIImage imageNamed:@"Logo_Text"];
        NSArray *activityItems = @[image];
        UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityViewControntroller.excludedActivityTypes = @[];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            activityViewControntroller.popoverPresentationController.sourceView = self.view;
            activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
        }
        [self presentViewController:activityViewControntroller animated:true completion:nil];
    }
};
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView==imageCollectionView)
        // return imageArray.count;
        return imageArray.count;
    return menueArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView==imageCollectionView)
    {
        homeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
        
        NSString*imgName=[imageArray objectAtIndex:indexPath.item];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [homeCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
        
        
        
        
        return homeCell;
    }
    else{
        typeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TypeCollectionViewCell" forIndexPath:indexPath];
        
        typeCell.type.text=[menueArray objectAtIndex:indexPath.item];
     //   [typeCell.type setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        
        return typeCell;
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==imageCollectionView)
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    
    return CGSizeMake(collectionView.frame.size.width/menueArray.count, collectionView.frame.size.height);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==imageCollectionView)
    {
        
        //            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //            MallDetailsViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
        //            [self.navigationController pushViewController:menuView animated:YES];
        
        
    }
    else
        
    {
        [UIView animateWithDuration:0.5f animations:^{
            
            _slideImgLeading.constant=indexPath.item*menuCollectionView.frame.size.width/menueArray.count;
            [self.view layoutIfNeeded];
            
        }];
        clickedIndex=indexPath.item;
        [self loadViewSubViewsToScrollView:indexPath.item];
        //   [_mallOptionsCollectionView reloadData];
        
    }
}
-(void)loadViewSubViewsToScrollView:(NSInteger)index{
    
    if(clickedIndex==0){
        [UIView animateWithDuration:0.5f animations:^{
            menuDetailsScrolView.contentOffset=CGPointMake(0,0);
        }];
    }
    else if(clickedIndex==1){
        [UIView animateWithDuration:0.5f animations:^{
            menuDetailsScrolView.contentOffset=CGPointMake((menuDetailsScrolView.frame.size.width),0);
        }];
    }
    else if(clickedIndex==2){
        [UIView animateWithDuration:0.5f animations:^{
            menuDetailsScrolView.contentOffset=CGPointMake(2*(menuDetailsScrolView.frame.size.width),0);
        }];
    }
    else if(clickedIndex==3){
        [UIView animateWithDuration:0.5f animations:^{
            menuDetailsScrolView.contentOffset=CGPointMake(3*(menuDetailsScrolView.frame.size.width),0);
        }];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _slideImgLeading.constant=index*menuCollectionView.frame.size.width/menueArray.count;
        [self.view layoutIfNeeded];
    }];
    clickedIndex=index;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView==menuDetailsScrolView)
    {
        static NSInteger previousPage = 0;
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        // if (previousPage != page) {
        
        [UIView animateWithDuration:0.5f animations:^{
            _slideImgLeading.constant=page*_slideImgWidth.constant;
            [self.view layoutIfNeeded];
        }];
        //}
        
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [menuDetailsScrolView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self loadApi];
    // loadingLBL.hidden=NO;
    
    
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView==imageCollectionView)
    {
      /*  if(imageArray.count==0)
        {
            countLBL.text=@"0/0";
        }
        else
        {
            countLBL.text=[NSString stringWithFormat:@"%lu/%lu",(unsigned long)indexPath.item+1,(unsigned long)imageArray.count ];
            
        }*/
    }
}
-(IBAction)checkFunction:(id)sender
{
 //
    NSArray *latlongAr =  self.loadedProperty[@"contactinfo"][@"latlng"];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    
    DurationSelectionViewController *durn =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
    durn.latitude = @"";
    durn.longitude = @"";
    if ([latlongAr isKindOfClass:[NSArray class]]&&latlongAr.count>0) {

        if (latlongAr.count>0) {
            durn.latitude = [NSString stringWithFormat:@"%@",[latlongAr firstObject]];
            durn.longitude =[NSString stringWithFormat:@"%@",[latlongAr lastObject]];

        }
    }
    durn.cityIdString =self.loadedProperty[@"_id"];
    durn.isHotelSelected = TRUE;
    durn.selectedHotel  = self.loadedProperty;
    durn.formattedAddress = [self.loadedProperty[@"contactinfo"][@"location"] uppercaseString];
    durn.placeName = durn.formattedAddress;

[self.navigationController pushViewController:durn animated:TRUE];

    return;
    
    
    AvailabilityViewController *vc = [y   instantiateViewControllerWithIdentifier:@"AvailabilityViewController"];
    vc.locationDic=self.selectedProperty;
    [self.navigationController pushViewController:vc animated:YES];

    
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

@end

