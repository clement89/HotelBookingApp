//
//  PropertyDetailsViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 12/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "PropertyDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "ReviewListViewController.h"
#import "NearByLocationsViewController.h"
#import "FinalBookingViewController.h"
#import "SingleRoomViewController.h"
#import "LoginViewController.h"
#import "InitialViewController.h"
#import "AboutTabedViewController.h"
#import "MessageViewController.h"
#import "URLConstants.h"
#import "BookingConfirmationNewViewController.h"
@interface PropertyDetailsViewController ()
{
    RoomsListViewController  *roomsListViewController;
}
@property (weak, nonatomic) IBOutlet UITextField *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnRightArrow;
@property (weak, nonatomic) IBOutlet UIButton *btnLeftArrow;

@end

@implementation PropertyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
_lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
_lblTitle.textColor = kColorDarkBlueThemeColor;
    _lblTitle.text = @"";
    _lblTitle.enabled = FALSE;
self.view.backgroundColor = kColorCommonBG;

    
    
    
    roomsArray=[[NSMutableArray alloc]init];
    roomsArrayTemp=[[NSMutableArray alloc]init];
    clickedIndex=0;
    menuCollectionView.hidden = TRUE;
    [favoriteButton setImage:[UIImage imageNamed:@"FavoriteNormal"] forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:@"FavoriteActive"] forState:UIControlStateSelected];
    imageArray=[[NSMutableArray alloc]init];
    menueArray=[[NSMutableArray alloc]initWithObjects:@"Rooms",@"Overview",@"Reviews",@"Nearby", nil];
    self.slideImgWidth.constant=0;
    UISwipeGestureRecognizer *upRecognizer= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [upRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [downRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [bgScrollView addGestureRecognizer:upRecognizer];
    [bgScrollView addGestureRecognizer:downRecognizer];
    bgScrollView.hidden = TRUE;
    utilObj=[[RequestUtil alloc]init];
   bookButton.enabled=NO;
    bookButton.alpha=1;
    bottomImageView.alpha=1;

   // [self loadBasicInfo];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomSelected)   name:@"roomSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCheckOutPag)   name:@"showCheckOutPag" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paynow)   name:@"paynow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roomDetails)   name:@"roomDetails" object:nil];
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"descriptionEnlarge" object:nil];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"policiesEnlarge" object:nil];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"facilitiesEnlarge" object:nil];
    
  /*  self.bottomHeight.constant=0;
    
    if([UIScreen mainScreen].bounds.size.height>=812)
    {
        self.scrollTop.constant=-40;

        self.navigationTop.constant=0;
        self.bottomConst.constant=-20;
    }
    else
    {
        self.navigationTop.constant=0;
        self.bottomConst.constant=0;
        self.scrollTop.constant=-20;
    }
    */
    
    bookButton.hidden = TRUE;
 
    [self loadApi];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movetoTop)   name:@"movetotop" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movetobottom)   name:@"movetobottom" object:nil];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoDescription)   name:@"descriptionEnlargePD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoPolicies)   name:@"policiesEnlargePD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushFacilities)   name:@"facilitiesEnlargePD" object:nil];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportAction)   name:@"reportAction" object:nil];
    if(_attributedTitle)
    {
        _lblTitle.attributedText = _attributedTitle;
    }
    else if (_checkinDateSelected&&_cityname) {
        NSString *citynameloc = _cityname;
        if (citynameloc.length==0) {
            if(self.selectedProperty&&[self.selectedProperty objectForKey:@"location"])
            {
                if([[self.selectedProperty objectForKey:@"location"] objectForKey:@"address"])
                    citynameloc = [[self.selectedProperty objectForKey:@"location"] valueForKey:@"address"];
                

            }
        }
        NSString *timeStr =@"";
        if ([_selectedDetails[@"bookingType"] isEqualToString:@"hourly"]) {
            timeStr =[NSString stringWithFormat:@"%@-%@",[Commons stringFromDate:_checkinDateSelected Format:@"MMM-dd HH:mm"],[Commons stringFromDate:_checkoutDateSelected Format:@"HH:mm"]];
        }
        else{
            timeStr =[NSString stringWithFormat:@"%@-%@",[Commons stringFromDate:_checkinDateSelected Format:@"MMM-dd"],[Commons stringFromDate:_checkoutDateSelected Format:@"MMM-dd-yy"]];

        }
        NSString *complStr =[NSString stringWithFormat:@"%@ %@",citynameloc,timeStr];
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
     self.view.backgroundColor = kColorHotelDetailsBG;
    menuDetailsScrolView.backgroundColor = kColorHotelDetailsBG;
    bgScrollView.backgroundColor = kColorHotelDetailsBG;
    menuListingScrollview.backgroundColor = kColorHotelDetailsBG;

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
    
    [self.view endEditing:YES];
    {
        NSString* locationString=@" ";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
        {
            
            locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        }
        
        NSString* postString=[NSString stringWithFormat:@"user=%@&commentID=%@&string=%@",locationString,[[NSUserDefaults standardUserDefaults]valueForKey:@"commentID"],@"BlockThisComment"];
        
        NSString *requstUrl=[NSString stringWithFormat:@"https://extranet.stayhopper.com/api/userratings/report"];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requstUrl]];
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        [request setURL:[NSURL URLWithString:requstUrl]];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSError *localError = nil;
            NSDictionary *parsedObject;
            if (!parsedObject) {
                parsedObject =[[NSDictionary alloc]init];
            }
            
            
            //[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            if(data!=nil)
            {
                // dic =[[NSMutableDictionary alloc]init];
                
                parsedObject = [NSJSONSerialization JSONObjectWithData:data  options:0 error:&localError];
                
                if ([parsedObject isKindOfClass:[NSDictionary class]] && parsedObject !=nil  )
                {
                    if ([parsedObject objectForKey:@"status"])
                    {
                        if ([[[parsedObject valueForKey:@"status"] lowercaseString] isEqualToString:@"success"])
                        {
                            if([parsedObject objectForKey:@"data"])
                            {
                               
                                
                                
                                
                                
                                
                            }
                            else
                            {
                                
                            }
                        }
                        else
                        {
                            
                            
                        }
                        
                    }
                    
                }
                else
                {
                    
                    
                }
            }
            else{
                
            }
            
            
        }];
        
        [postDataTask resume];
        
        
        
    }
}
-(void)pushtoDescription
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutTabedViewController  *aboutTabedViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AboutTabedViewController"];
    aboutTabedViewController.commonDIC=self.selectedProperty;
    aboutTabedViewController.loadedDIC=self.selectedProperty;
    aboutTabedViewController.selectedPropName=[self.selectedProperty valueForKey:@"name"];
    aboutTabedViewController.indexString=@"0";
    [self.navigationController pushViewController:aboutTabedViewController animated:YES ];
}
-(void)pushtoPolicies
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutTabedViewController  *aboutTabedViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AboutTabedViewController"];
    aboutTabedViewController.commonDIC=self.selectedProperty;
    aboutTabedViewController.loadedDIC=self.selectedProperty;
    aboutTabedViewController.selectedPropName=[self.selectedProperty valueForKey:@"name"];

    aboutTabedViewController.indexString=@"2";

    [self.navigationController pushViewController:aboutTabedViewController animated:YES ];
}
-(void)pushFacilities
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutTabedViewController  *aboutTabedViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AboutTabedViewController"];
    aboutTabedViewController.commonDIC=self.selectedProperty;
    aboutTabedViewController.loadedDIC=self.selectedProperty;
    aboutTabedViewController.selectedPropName=[self.selectedProperty valueForKey:@"name"];

    aboutTabedViewController.indexString=@"1";

    [self.navigationController pushViewController:aboutTabedViewController animated:YES ];
}
-(void)movetoTop
{
    float height=bgScrollView.frame.size.height;

    [UIView animateWithDuration:0.3f animations:^{
        //navigationView.backgroundColor=   [UIColor colorWithRed: 0.043 green: 0.090 blue: 0.298 alpha:1];
        
             self.topScrollViewTop.constant=-1*(height-menuCollectionView.superview.frame.size.height);

        
        [self.view layoutIfNeeded];
    }];
    
}
-(void)movetobottom
{
   // float height=bgScrollView.frame.size.height;
    
    [UIView animateWithDuration:0.3f animations:^{
         navigationView.backgroundColor=   [UIColor clearColor];
      
        
            self.topScrollViewTop.constant=0;
        
        [self.view layoutIfNeeded];
    }];
    
}
-(void)roomDetails
{
    return;
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SingleRoomViewController  *singleRoomViewController = [storyBoard instantiateViewControllerWithIdentifier:@"SingleRoomViewController"];
    
    NSString* selectedString=[[NSUserDefaults standardUserDefaults] objectForKey:@"roomIndex"];
    
    singleRoomViewController.selectedRoomDic=[[self.selectedProperty  objectForKey:@"rooms"] objectAtIndex:[selectedString integerValue]];
    singleRoomViewController.selectedProperty = self.selectedProperty;
    singleRoomViewController.selectedProperty = self.selectedProperty;
    singleRoomViewController.roomsArrayTemp = roomsArrayTemp;
   // finalBookingViewController.selectedProperty=self.selectedProperty;
  //  finalBookingViewController.selectedIDS=roomsArray;
    [self.navigationController pushViewController:singleRoomViewController animated:YES];
    
    
}
-(void)roomSelected
{//bookButton.alpha = 1;
    float totalPrice = 0.0;
    if (roomsListViewController.selectedRooms.count>0) {
        for (NSString *roomId in [roomsListViewController.selectedRooms allKeys])
        {
          NSArray *room =   [roomsListViewController.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"_id ==%@",roomId]];
            if ([room isKindOfClass:[NSArray class]]&&room.count >0) {
                totalPrice   =  totalPrice +[roomsListViewController.selectedRooms[roomId] floatValue]*[[room firstObject][@"priceSummary"][@"base"][@"amount"] floatValue];

            }
        }
      //  bookButton.enabled=YES;

    }
    else{
      //  bookButton.enabled=NO;
 
    }
    bookButton.enabled=YES;
    if (totalPrice>0) {
        bookButton.hidden = FALSE;

        NSString *totalString=[NSString stringWithFormat:@"AED %.2f",totalPrice];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"BOOK THIS FOR\n%@",totalString]];

        
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontRegular size:10.0] range:NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:20.0] range:NSMakeRange(str.length-totalString.length, totalString.length)];
        bookButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        bookButton.titleLabel.attributedText = str;
        [[bookButton titleLabel] setNumberOfLines:2];
        [[bookButton titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        
        [bookButton setAttributedTitle:str forState:UIControlStateNormal];
       

    }
    else
    {
        bookButton.hidden = TRUE;

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"BOOK"]];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontSemiBold size:16.0] range:NSMakeRange(0, str.length)];
        [bookButton setAttributedTitle:str forState:UIControlStateNormal];

     }
/*    BOOL status=NO;
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    for(NSString* key in keys){
        if([key containsString:@"selectedRoom-"] )
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:key] isEqualToString:@"YES"])
            {
                status=YES;
    bookButton.enabled=YES;
                self.bottomHeight.constant=50;

                ////
                
                [roomsArray removeAllObjects];
                
                
                NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
                for(NSString* key in keys){
                    BOOL status;
                    if([key containsString:@"selectedRoom-"] )
                    {
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:key] isEqualToString:@"YES"])
                        {
                            NSString* idString=[key stringByReplacingOccurrencesOfString:@"selectedRoom-" withString:@""];
                            
                            status=NO;
                            
                            for(NSString* string in roomsArray)
                            {
                                if([string isEqualToString:idString])
                                    status=YES;
                                
                            }
                            if(!status)
                                [roomsArray addObject:idString];
                            
                        }
                        //
                        // [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                        //[[NSUserDefaults standardUserDefaults]synchronize];
                        
                    }
                    
                }
               float totalPrice=0;
                for(NSString* string in roomsArray)
                {
                    //roomCount=roomCount+[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",string]] integerValue];
                    
                    totalPrice=totalPrice+([[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",string]] integerValue]*[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"pricePerRoom-%@",string]] floatValue]);
                    
                }
                NSString *totalString=[NSString stringWithFormat:@"%.2f",totalPrice];
                
                [roomsArray removeAllObjects];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"BOOK THIS FOR\nAED %@",totalString]];
                NSInteger leng=str.length;

                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:11.0] range:NSMakeRange(0, 13)];
                [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:21.0] range:NSMakeRange(14, leng-14)];
                bookButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                [[bookButton titleLabel] setNumberOfLines:2];
                [[bookButton titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
                
                [bookButton setAttributedTitle:str forState:UIControlStateNormal];
               
                
                ///
                
                
                
                
                break;
            }
        }
    }
    if(status)
    {
        bookButton.alpha=1;
        bottomImageView.alpha=1;
        self.bottomHeight.constant=50;

        bookButton.enabled=YES;
    }
else
{
    bookButton.alpha=0;
    bottomImageView.alpha=0;
    self.bottomHeight.constant=0;

    bookButton.enabled=NO;
}
*/
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
    
    if([self.selectedProperty objectForKey:@"userRating"])
    {
        
        
        userReviewValueLBL.text=[NSString stringWithFormat:@" %.01f ",[[self.selectedProperty  valueForKey:@"userRating"] floatValue] ];
    }
    userReviewValueLBL.clipsToBounds = TRUE;
    userReviewValueLBL.layer.cornerRadius = 2.5;
    countLBL.superview.layer.cornerRadius = 2.5;
    
    
    //CJC 12
    if([userReviewValueLBL.text floatValue]<=0)
    {
        userReviewLBL.text=@"No Review";
        userReviewLBL.hidden = YES;
        userReviewValueLBL.hidden = YES;
        
    }else{
        userReviewLBL.hidden = NO;
        userReviewValueLBL.hidden = NO;
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
    
    if (userReviewValueLBL.text.length>0) {
        NSString *hrlbl = userReviewValueLBL.text;
        
        hrlbl = [NSString stringWithFormat:@" %@.",hrlbl];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:userReviewValueLBL.textColor,NSFontAttributeName:userReviewValueLBL.font}];

        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
        userReviewValueLBL.attributedText = attr;
        userReviewValueLBL.backgroundColor = [UIColor colorWithRed:0.757 green:0.784 blue:0.859 alpha:0.3];
        userReviewValueLBL.clipsToBounds = TRUE;
        userReviewValueLBL.layer.cornerRadius = 2.;
        
    }
    
    
    
    NSString *nameLbl =  @"";
    NSString *addrsLbl =  @"";

    if([self.selectedProperty objectForKey:@"name"])
    {
        nameLbl =[NSString stringWithFormat:@"%@\n",[self.selectedProperty valueForKey:@"name"]];
    }
    
        propertyNameLBL.text=@"";

    
        if([self.selectedProperty objectForKey:@"location"])
        {
            if([[self.selectedProperty objectForKey:@"location"] objectForKey:@"address"])
                addrsLbl = [[self.selectedProperty objectForKey:@"location"] valueForKey:@"address"];
            

        }
    NSString *completeStrign = [NSString stringWithFormat:@"%@%@",nameLbl,addrsLbl];
    NSMutableAttributedString *completeAttr = [[NSMutableAttributedString alloc] initWithString:completeStrign];
    [completeAttr addAttributes:@{NSForegroundColorAttributeName:kColorDarkBlueThemeColor,NSFontAttributeName:[UIFont fontWithName:FontMedium size:18]} range:NSMakeRange(0, completeStrign.length)];
    if (addrsLbl.length>0)
    {
        [completeAttr addAttributes:@{NSForegroundColorAttributeName:userReviewLBL.textColor,NSFontAttributeName:[UIFont fontWithName:FontMedium size:14]} range:NSMakeRange(completeStrign.length-addrsLbl.length, addrsLbl.length)];

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
    if([Commons checkFavorites:[self.selectedProperty objectForKey:@"_id"] ])
    {
        favoriteButton.selected=YES;
    }
    else
    {
        favoriteButton.selected=NO;
    }
    
    
  
    
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
    if (_lblTitle.attributedText) {
         
    }
    else{
    if([self.selectedProperty objectForKey:@"name"])
    {
        _lblTitle.text =[self.selectedProperty valueForKey:@"name"];
    }
    else
    {
        _lblTitle.text = addrsLbl;
    }
    }
    //    self.menuDetailsScrollViewHeight.constant= [UIScreen mainScreen].bounds.size.height-(topView.frame.origin.y+topView.frame.size.height)-165;
//    bgScrollView.layer.borderWidth = 2.0;
//    bgScrollView.layer.borderColor = [UIColor greenColor].CGColor;
    
//    navigationView.layer.borderWidth = 2.0;
//    navigationView.layer.borderColor = [UIColor orangeColor].CGColor;
//    _lblTitle.text=[NSString stringWithFormat:@"%@-%@-%@",nextDayString,[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"],[utilObj convertTime]] ;
    self.slideImgWidth.constant=[UIScreen mainScreen].bounds.size.width/menueArray.count;
    _slideImgLeading.constant=0;
    clickedIndex = 0;
    [self roomSelected];
    
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
  //  NSString *properties = @"";
   // NSDictionary *reqData = @{@"checkinDate":checkinDate,@"checkinTime":checkinTime,
                        //      @"checkoutDate":checkoutDate,@"checkoutTime":checkoutTime,@"properties":properties};
    
//https://api.admin.sh.rahulv.com/api/properties/5c3edabdcfdc5b72e21f5435?checkinDate=17/11/2020&checkinTime=00:00&checkoutDate=17/12/2020&checkoutTime=23:59&location=25.2048493,%2055.2707828&numberRooms=1&numberAdults=2
    NSString *url;
    NSMutableDictionary *paramsSending = [[NSMutableDictionary alloc] init];
    if(_selectedDetails)
    {
            
//        url=[NSString stringWithFormat: @"properties/%@?checkinDate=%@&checkinTime=%@&checkoutDate=%@&checkoutTime=%@&numberRooms=%@&numberAdults=%@",_selectedDetails[@"property_id"],_selectedDetails[@"checkinDate"],_selectedDetails[@"checkinTime"],_selectedDetails[@"checkoutDate"],_selectedDetails[@"checkoutTime"],_selectedDetails[@"numberRooms"],_selectedDetails[@"numberAdults"]];
//
        url=[NSString stringWithFormat: @"properties/%@?checkinDate=%@&checkinTime=%@&checkoutDate=%@&checkoutTime=%@&numberRooms=%@&numberAdults=%@",_selectedDetails[@"property_id"],_selectedDetails[@"checkinDate"],_selectedDetails[@"checkinTime"],_selectedDetails[@"checkoutDate"],_selectedDetails[@"checkoutTime"],_selectedDetails[@"numberRooms"],_selectedDetails[@"numberAdults"]];
      
        paramsSending[@"properties"]=_selectedDetails[@"property_id"];
        paramsSending[@"checkinDate"]=_selectedDetails[@"checkinDate"];
        paramsSending[@"checkoutDate"]=_selectedDetails[@"checkoutDate"];
        paramsSending[@"numberRooms"]=_selectedDetails[@"numberRooms"];
        paramsSending[@"numberAdults"]=_selectedDetails[@"numberAdults"];
        paramsSending[@"checkinTime"]=_selectedDetails[@"checkinTime"];
        paramsSending[@"checkoutTime"]=_selectedDetails[@"checkoutTime"];
        if (_selectedDetails[@"bookingType"]) {
            paramsSending[@"bookingType"]=_selectedDetails[@"bookingType"];

        }
        else
        {
            if ([paramsSending[@"checkinDate"] isEqualToString:paramsSending[@"checkoutDate"]]) {
                paramsSending[@"bookingType"]=_selectedDetails[@"hourly"];

            }
            else{
                paramsSending[@"bookingType"]=_selectedDetails[@"monthly"];

            }
        }
        url = [NSString stringWithFormat: @"properties/%@",_selectedDetails[@"property_id"]];


    }
    else
    {
        NSString *checkinDate = [Commons stringFromDate:[NSDate date] Format:@"dd/MM/yyyy"];
        NSString *checkinTime = [Commons stringFromDate:[NSDate date] Format:@"hh:mm"];
        NSString *checkoutDate = checkinDate;
        NSString *checkoutTime = [Commons stringFromDate:[[NSDate date] dateByAddingTimeInterval:3*60*60] Format:@"hh:mm"];
        paramsSending[@"properties"]=_property_id;
        paramsSending[@"checkinDate"]=checkinDate;
        paramsSending[@"checkoutDate"]=checkoutDate;
        paramsSending[@"numberRooms"]=@"1";
        paramsSending[@"numberAdults"]=@"2";
        paramsSending[@"checkinTime"]=checkinTime;
        paramsSending[@"checkoutTime"]=checkoutTime;
        paramsSending[@"bookingType"]=_selectedDetails[@"hourly"];

        url=[NSString stringWithFormat: @"properties/%@?checkinDate=%@&checkinTime=%@&checkoutDate=%@&checkoutTime=%@&numberRooms=1&numberAdults=2",_property_id,checkinDate,checkinTime,checkoutDate,checkoutTime];
//        url=[NSString stringWithFormat: @"properties/%@?checkinDate=%@&checkinTime=%@&checkoutDate=%@&checkoutTime=%@&numberRooms=1&numberAdults=2",_property_id,checkinDate,checkinTime,checkoutDate,checkoutTime];
        url = [NSString stringWithFormat: @"properties/%@",_property_id];

        
    }
    [util postRequest:paramsSending withToken:FALSE toUrl:url type:@"POST"];

    
   
    
   /* if([self.selectionString isEqualToString:@"Near"])
    {
        NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLatitude"],[[NSUserDefaults standardUserDefaults] objectForKey:@"currentLongitude"]];
//        locationString=@"9.9312,76.2673";
     //  locationString=@"25.2048,55.2708";
        
        
        
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
        NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
        
        [util postRequest:reqData toUrl:[NSString stringWithFormat: @"properties/search/near?location=%@",locationString] type:@"GET"];
        //  [util postRequest:self.searchDic toUrl:[NSString stringWithFormat:@"properties/search/near?="] type:@"GET"];
        
    }
    else
    {
        
        NSString* locationString=[NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLat"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLongt"]];
        //        locationString=@"9.9312,76.2673";
       // locationString=@"25.2048,55.2708";
        NSMutableDictionary *reqData = [NSMutableDictionary dictionary];

       [util postRequest:reqData toUrl:[NSString stringWithFormat: @"%@&location=%@&number_adults=%@",self.selectionString,locationString,[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"]] type:@"GET"];
    }*/
}



-(void)loadNeededViews
{
   [self.view layoutIfNeeded];

    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    roomsListViewController = [storyBoard instantiateViewControllerWithIdentifier:@"RoomsListViewController"];
    roomsListViewController.selectedProperty =_selectedProperty;

    [roomsArrayTemp removeAllObjects];
    if([self.selectedProperty  objectForKey:@"rooms"])
    {
        
            for (NSDictionary* dic in [self.selectedProperty objectForKey:@"rooms"])
            {
                if([dic[@"priceSummary"] isKindOfClass:[NSDictionary class]] && [[dic valueForKey:@"numberOfRoomsAvailable"] intValue]!=0)
                    [roomsArrayTemp addObject:dic];
            }
        
    roomsListViewController.dataArray=roomsArrayTemp;
        
    }
    
    roomsListViewController.view.frame = CGRectMake(0,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
    [self addChildViewController:roomsListViewController];
    [menuDetailsScrolView addSubview:roomsListViewController.view];
        
    /////////
    
    AboutPropertyViewController  *aboutPropertyViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AboutPropertyViewController"];
    aboutPropertyViewController.selectedProperty=self.selectedProperty;
    aboutPropertyViewController.loadedsProperty=self.selectedProperty;
    aboutPropertyViewController.fromString=@"YES";
    NSMutableArray* srviceArray=[[NSMutableArray alloc]init];
    for(NSDictionary* dicVal in [self.selectedProperty  objectForKey:@"rooms"])
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
            if([[self.selectedProperty objectForKey:@"contactinfo"] objectForKey:@"location"])
                
            {
                
                if([[[self.selectedProperty objectForKey:@"contactinfo"][@"location"] objectForKey:@"coordinates"] count]>1)
                {
                   
                    double latitude1 = [[[[self.selectedProperty objectForKey:@"contactinfo"][@"location"] objectForKey:@"coordinates"] objectAtIndex:0] doubleValue];
                    double longitude1 = [[[[self.selectedProperty objectForKey:@"contactinfo"][@"location"] objectForKey:@"coordinates"] objectAtIndex:1] doubleValue];
                        NSString *lat =[NSString stringWithFormat:@"%f",latitude1];
                        NSString *lon =[NSString stringWithFormat:@"%f",longitude1];
                        [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"mapLatitude"];
                        [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"mapLongitude"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    
                }
                
            }
            
        }
       
    aboutPropertyViewController.view.frame = CGRectMake(menuDetailsScrolView.frame.size.width*1,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
    [self addChildViewController:aboutPropertyViewController];
    [menuDetailsScrolView addSubview:aboutPropertyViewController.view];
    int xoff = 2;
    ///////
    NSArray *reviews = [self.selectedProperty objectForKey:@"userRatings"];
    if ([reviews isKindOfClass:[NSArray class]])//CJC 3 removed && reviews.count>0
    {
         ReviewListViewController  *reviewListViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ReviewListViewController"];
             reviewListViewController.view.frame = CGRectMake(menuDetailsScrolView.frame.size.width*xoff,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
           NSMutableArray* reviewsArray=[[NSMutableArray alloc]init];
           if([self.selectedProperty objectForKey:@"userRating"])
           {
               
               
              reviewListViewController.ratingValue1=[NSString stringWithFormat:@"%@",[self.selectedProperty  valueForKey:@"userRating"] ];
           }
           else
               reviewListViewController.ratingValue1=@"0.0";
           
           if([self.selectedProperty  objectForKey:@"userRatings"])
           {
               //NSMutableArray* roomsArray=[[NSMutableArray alloc]init];
               
               for (NSDictionary* dic in [self.selectedProperty objectForKey:@"userRatings"])
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
        xoff++;

      //  [menueArray removeObjectAtIndex:xoff];
      //  menueArray
    }
    
    xoff = 3;

    /////////
    NearByLocationsViewController  *nearByLocationsViewController = [storyBoard instantiateViewControllerWithIdentifier:@"NearByLocationsViewController"];
    nearByLocationsViewController.shouldHideTopView = TRUE;
    if ([self.selectedProperty  objectForKey:@"name"]) {
        nearByLocationsViewController.title = [self.selectedProperty  objectForKey:@"name"];

    }
  //  nearByLocationsViewController.dataArray=
    
//    if([self.selectedProperty  objectForKey:@"nearby"])
//    {
//        nearByLocationsViewController.dataArray=[NSArray arrayWithArray:[self.selectedProperty objectForKey:@"nearby"]];
//
//    }
//    nearByLocationsViewController.dataArray = @[@{@"lat":@"25.1649",@"long":@"55.4084",@"title":@"Dubai",@"sub":@"Subtitle"}];


    
    if([self.selectedProperty  objectForKey:@"nearby"])
    {
        nearByLocationsViewController.dataArray=[NSArray arrayWithArray:[self.selectedProperty objectForKey:@"nearby"]];
    }
   
    nearByLocationsViewController.view.frame = CGRectMake(menuDetailsScrolView.frame.size.width*xoff,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
    [self addChildViewController:nearByLocationsViewController];
    [menuDetailsScrolView addSubview:nearByLocationsViewController.view];
    
    ////
    menuDetailsScrolView.contentSize=CGSizeMake(menuDetailsScrolView.frame.size.width*(xoff+1), 0);
    menuDetailsScrolView.contentOffset=CGPointMake(0,0);
    
    [menuCollectionView reloadData];
    self.slideImgWidth.constant=[UIScreen mainScreen].bounds.size.width/menueArray.count;
    menuCollectionView.hidden = FALSE;
    [self loadBasicInfo];
    bgScrollView.hidden = FALSE;

}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    // loadingLBL.hidden=YES;
    
    [hud hideAnimated:YES afterDelay:0];
    //  [propertyArray removeAllObjects];
    if([rawData objectForKey:@"data"])
    {
        self.selectedProperty=nil;

        self.selectedProperty=[rawData objectForKey:@"data"];
        if([[rawData objectForKey:@"data"] objectForKey:@"rooms"])
        {
            for(NSDictionary* dic in [[rawData objectForKey:@"data"] objectForKey:@"rooms"])
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:[NSString stringWithFormat:@"count-%@",[dic valueForKey:@"_id"]]];
                [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:[NSString stringWithFormat:@"selectedRoom-%@",[dic valueForKey:@"_id"]]];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
        }
        [self loadNeededViews];

        
    }
    else if([rawData objectForKey:@"message"])
    {
        //CJC 16
        

        if ([[[rawData objectForKey:@"message"] lowercaseString] containsString:@"added to favourites"]) {
            
            favoriteButton.selected = YES;
            [Commons addOrRomoveToFavselectedFavId:_selectedProperty[@"_id"] shouldAdd:favoriteButton.selected];
            
            
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Succses";
            vc.messageString=[rawData objectForKey:@"message"];
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
 
        }
        else{
            
            favoriteButton.selected = NO;
            [Commons addOrRomoveToFavselectedFavId:_selectedProperty[@"_id"] shouldAdd:favoriteButton.selected];
            
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Failed";
            vc.messageString=[rawData objectForKey:@"message"];
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
    
       // self.selectedProperty = self.selectedProperty;
        [self loadNeededViews];
        
    }
    else{
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=@"No data found, Please try again";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
       // self.selectedProperty = self.selectedProperty;

    }
 
    //hud.label.text = response;
    [hud hideAnimated:YES afterDelay:0];

    
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

        [UIView animateWithDuration:0.3f animations:^{
            //  navigationView.backgroundColor=   [UIColor colorWithRed: 0.043 green: 0.090 blue: 0.298 alpha:1];
            
                self.topScrollViewTop.constant=-1*(height-menuCollectionView.superview.frame.size.height);

            [self.view layoutIfNeeded];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
              navigationView.backgroundColor=   [UIColor clearColor];
           
            
                self.topScrollViewTop.constant=0;

            [self.view layoutIfNeeded];
}];
    }
}
- (IBAction)swipeButtonsPressed:(UIButton*)sender
{
    CGFloat width = imageCollectionView.frame.size.width;
    NSInteger page = (imageCollectionView.contentOffset.x + (0.5f * width)) / width;
    
    page=page+sender.tag;
    if (page>=0&&page<imageArray.count) {
        [imageCollectionView setContentOffset:CGPointMake(page*imageCollectionView.frame.size.width, imageCollectionView.contentOffset.y) animated:TRUE];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchButtonClikd:(id)sender {
  UIViewController *vc =   [[self.navigationController viewControllers] firstObject];
    UINavigationController *nv = self.navigationController;
    UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"PlaceSearchViewController"];
    
    [nv pushViewController:vc1 animated:TRUE];
    NSMutableArray *vcss =[[NSMutableArray alloc] initWithObjects:vc,vc1, nil];
    self.navigationController.viewControllers = vcss;
    
//    [self.navigationController popToViewController:vc animated:NO];

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
            activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/menueArray.count, 0, 0);
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
        
    {
        if (imageArray.count<=1) {
            _btnLeftArrow.hidden = TRUE;
        }
        else{
            _btnLeftArrow.hidden = FALSE;

        }
        _btnRightArrow.hidden = _btnLeftArrow.hidden;

        return imageArray.count;

    }
       // return imageArray.count;
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
       // [typeCell.type setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
     
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
            self.slideImgWidth.constant=[UIScreen mainScreen].bounds.size.width/menueArray.count;

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
    
    
    
  //  [menuDetailsScrolView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

}

-(void)viewDidAppear:(BOOL)animated{
    
   // loadingLBL.hidden=NO;
    
  
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"login_status"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey :@"login_status"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]){
            [self showCheckOutPag];
        }
    }
    
    
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
    
//    if(collectionView==imageCollectionView)
//    {
//    if(imageArray.count==0)
//    {
//        countLBL.text=@"0/0";
//    }
//    else
//    {
//        countLBL.text=[NSString stringWithFormat:@"%lu/%lu",(unsigned long)indexPath.item+1,(unsigned long)imageArray.count ];
//        
//    }
//    }
}
-(IBAction)favoriteFunction:(UIButton*)sender
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
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
         [util postRequest:@{@"propertyId":_selectedProperty[@"_id"]} withToken:TRUE toUrl:[NSString stringWithFormat: @"users/favorites"] type:@"POST"];
    
    }

-(void)paynow
{
    [self bookNowFunction:nil];
}

-(void) showCheckOutPag{
    
    
    
    int numberOfRoomsSelected = 0;
    if (roomsListViewController.selectedRooms.count>0)
    {
        numberOfRoomsSelected = [[[roomsListViewController.selectedRooms allValues] valueForKeyPath:@"@sum.self"] intValue];

        
    }
    
    if (numberOfRoomsSelected >= [_selectedDetails[@"numberRooms"] intValue]) {
        BookingConfirmationNewViewController *bcv =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"BookingConfirmationNewViewController"];
               bcv.selectedHotel = self.selectedProperty;
               bcv.selectedDetails = _selectedDetails;
                bcv.selectedRooms = roomsListViewController.selectedRooms;

               [self.navigationController pushViewController:bcv animated:TRUE];
               return;
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FinalBookingViewController  *finalBookingViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FinalBookingViewController"];
        finalBookingViewController.selectedProperty=self.selectedProperty;
        finalBookingViewController.selectedProperty=self.selectedProperty;
        finalBookingViewController.selectedIDS=roomsArray;
        [self.navigationController pushViewController:finalBookingViewController animated:YES];

        
    }
    else
    {
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=[NSString stringWithFormat:@"Select %@ rooms",_selectedDetails[@"numberRooms"]];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
}

-(IBAction)bookNowFunction:(UIButton*)sender
{
    //CJC 8 a
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"loginOk"  forKey:@"checking"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
            LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            vc.fromString=@"presentViewTab";
            [self.navigationController pushViewController:vc animated:YES];
        });

        return;
    }
    

    
    [self showCheckOutPag];
    
    
    return;
    
    
    
    
    
    
    [roomsArray removeAllObjects];
    
    
    NSArray *keys = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys];
    for(NSString* key in keys){
        BOOL status;
        if([key containsString:@"selectedRoom-"] )
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:key] isEqualToString:@"YES"])
            {
            NSString* idString=[key stringByReplacingOccurrencesOfString:@"selectedRoom-" withString:@""];
            
            status=NO;

            for(NSString* string in roomsArray)
            {
                if([string isEqualToString:idString])
                    status=YES;
                
            }
            if(!status)
                [roomsArray addObject:idString];
                
            }
              //
             // [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            //[[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
    }
    
    
    NSUInteger countValue=0;
    NSInteger roomCount=0;

    for(NSString* str in roomsArray)
    {
        for(NSDictionary* dicV in roomsArrayTemp)
        {
            if([[dicV valueForKey:@"_id"] isEqualToString:str])
            {
                countValue=countValue+  ([[dicV valueForKey:@"number_guests"] integerValue] *[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",str]] integerValue]);
                
                
                roomCount=roomCount+[[[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"count-%@",str]] integerValue];
                break;
            }
        }
        
        
    }
  if(roomCount<=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue])  {
   if(roomCount>=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"] integerValue] || countValue>=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue]) {
     if(roomCount>=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedRooms"] integerValue])
    {
    if(countValue>=[[[NSUserDefaults standardUserDefaults]valueForKey:@"selectedAdults"] integerValue])
    {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        if(roomsArray.count!=0)
        {
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FinalBookingViewController  *finalBookingViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FinalBookingViewController"];
            finalBookingViewController.selectedProperty=self.selectedProperty;
            finalBookingViewController.selectedProperty=self.selectedProperty;
            finalBookingViewController.selectedIDS=roomsArray;
            [self.navigationController pushViewController:finalBookingViewController animated:YES];
        }
        
    }
    else
    {
//        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//        InitialViewController *vc = [y   instantiateViewControllerWithIdentifier:@"InitialViewController"];
//
//        vc.fromString=@"presentView";
//        [self.navigationController pushViewController:vc animated:YES];
        
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.fromString=@"presentView";
        [self.navigationController pushViewController:vc animated:YES];
        
        //        vc.providesPresentationContextTransitionStyle = YES;
        //        vc.definesPresentationContext = YES;
        //        [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
        //        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    }else
    {
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"Adult count mismatch";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
}else
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Warning";
    vc.messageString=@"Room count mismatch";
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
}
   }else
   {
       UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
       MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
       vc.imageName=@"Warning";
       vc.messageString=@"Room / Adult count mismatch";
       vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
       [self.view addSubview:vc.view];
   }
    }else
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"Room / Adult count mismatch";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
    
    
    
}






@end
