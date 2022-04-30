//
//  SavedViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "SavedViewController.h"
#import "PopularPropertiesViewController.h"
#import "ListHostelsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SinglePropertyDetailsViewController.h"
#import "LoginViewController.h"
#import "InitialViewController.h"
#import "MessageViewController.h"
#import "URLConstants.h"
#import "PropertyDetailsViewController.h"
#import "StayDateTimeViewController.h"
#import "DurationSelectionViewController.h"
@interface SavedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ListHostelsTableViewCell *cell;
    
    IBOutlet NSLayoutConstraint *optionsViewWidth;
    NSString *selectedFavId;
    BOOL loginAlertShowed;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SavedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
    _lblTitle.superview.layer.shadowOpacity = 0.3;
    _lblTitle.superview.layer.shadowRadius = 2.0;
    _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
   // _lblTitle.superview.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;

    self.view.backgroundColor = kColorProfilePages;//CJC changed kColorCommonBG
    
    optionsViewWidth.constant=[UIScreen mainScreen].bounds.size.width/2.5;
    self.mapView.showsUserLocation=YES;
    self.mapView.hidden = TRUE;
    listingTBV.hidden=NO;
    mapLoadedStayus=NO;
    listingType=NO;
    propertyArray=[[NSMutableArray alloc]init];
    //june 24 -6h-11:30
    loadingLBL.text=@"";
    self.whiteImageView.layer.cornerRadius=4;
    utilObj = [[RequestUtil alloc]init];
    loginAlertShowed = NO;

    self.BGView.alpha=0;
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"loadStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSaved)   name:@"reloadSaved" object:nil];
   
//    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loadStatus"] isEqualToString:@"YES"])
//    {
    // Do any additional setup after loading the view. //
}
-(void)reloadSaved
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]&&[[[NSUserDefaults standardUserDefaults] valueForKey:@"loadStatus"] isEqualToString:@"YES"])
    {
        [self loadApi];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"loadStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadApi];
        loadingLBL.hidden=NO;
        
        _loginView.hidden = YES;

    }
    else
    {
        _loginView.hidden = NO;

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
       
        
            
        
//        [self addChildViewController:vc];
//        [self.view addSubview:vc.view];
//        [vc.navigationController didMoveToParentViewController:self];




        
        
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry"
//                                                                                 message:@"Kindly login to get your saved items"
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        //We add buttons to the alert controller by creating UIAlertActions:
//        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Login"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction * _Nonnull action) {
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
//        vc.fromString=@"presentViewTab";
////        vc.providesPresentationContextTransitionStyle = YES;
////        vc.definesPresentationContext = YES;
////        [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)loadApi
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loadStatus"] isEqualToString:@"YES"])
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
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    
    NSString* locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    
    
  
    
    [self.view endEditing:YES];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    [util postRequest:reqData withToken:TRUE toUrl:[NSString stringWithFormat: @"users/me"] type:@"GET"];
//    [util postRequest:reqData toUrl:[NSString stringWithFormat: @"users/me"] type:@"POST"];
}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    loadingLBL.hidden=YES;
//    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loadStatus"] isEqualToString:@"YES"])
//    {
//    [hud hideAnimated:YES afterDelay:0];
//    }
    
    if([rawData objectForKey:@"user"])
    {
        NSArray *favouriteskey =[rawData[@"user"] objectForKey:@"favourites"];
//        for(NSDictionary* dicValue in [rawData objectForKey:@"data"])
//        {
//            [propertyArray addObject:dicValue];
//        }
        if(!favouriteskey || [favouriteskey count]==0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[@[] mutableCopy] forKey:favoriteListKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

          //  if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loadStatus"] isEqualToString:@"YES"])
            {
            //loadingLBL.text=@"Your list is empty";
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Nothing to display";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
                

            }
            [hud hideAnimated:YES afterDelay:0];

        }
        else
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:[favouriteskey mutableCopy] forKey:favoriteListKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            RequestUtil *util = [[RequestUtil alloc]init];
            util.webDataDelegate=(id)self;
            
            NSString *checkinDate = [Commons stringFromDate:[NSDate date] Format:@"dd/MM/yyyy"];
            NSString *checkinTime = [Commons stringFromDate:[NSDate date] Format:@"hh:mm"];
            NSString *checkoutDate = checkinDate;
            NSString *checkoutTime = [Commons stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60] Format:@"hh:mm"];
            NSString *properties = [favouriteskey componentsJoinedByString:@","];
            NSDictionary *reqData = @{@"checkinDate":checkinDate,@"checkinTime":checkinTime,
                                      @"checkoutDate":checkoutDate,@"checkoutTime":checkoutTime,@"properties":properties};
            
            [util postRequest:reqData withToken:FALSE toUrl:[NSString stringWithFormat: @"properties/search"] type:@"POST"];
        }
    }
    else if([rawData objectForKey:@"data"])

    {
        [propertyArray removeAllObjects];

        NSArray *list =rawData[@"data"][@"list"];
        if ([list isKindOfClass:[NSArray class]]) {
            [propertyArray addObjectsFromArray:list];

        }
        if (propertyArray.count==0) {
            {

                //loadingLBL.text=@"Your list is empty";
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Nothing to display";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
                
                
              
            }
        }
        else{
 
        }
        [[NSUserDefaults standardUserDefaults] synchronize];

        [hud hideAnimated:YES afterDelay:0];

    }
    else if([rawData objectForKey:@"message"])

    {
        if (selectedFavId&&[[[rawData objectForKey:@"message"] lowercaseString] containsString:@"favourites"]) {
            
            [Commons addOrRomoveToFavselectedFavId:selectedFavId shouldAdd:FALSE];
           NSArray *fv = [propertyArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"_id == %@",selectedFavId]];
            if (fv) {
                [propertyArray removeObject:[fv firstObject]];
             }
            selectedFavId = nil;
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Succses";
            vc.messageString=[rawData objectForKey:@"message"];
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
             
        }
       
        
        else {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=[rawData objectForKey:@"message"];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
        }
        [hud hideAnimated:YES afterDelay:0];

    }
    else {
        {
           // loadingLBL.hidden=NO;
           // loadingLBL.text=@"Your list is empty";
            //loadingLBL.text=@"Your list is empty";
           // if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loadStatus"] isEqualToString:@"YES"])
            {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Failed";
            vc.messageString=@"Unable to load saved items";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            }
            [hud hideAnimated:YES afterDelay:0];

        }
    }
    
    //CJC added
    if([propertyArray count] == 0){
        _loginView.hidden = NO;
        _loginButton.hidden = YES;
    }else{
        _loginView.hidden = YES;
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
   // if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loadStatus"] isEqualToString:@"YES"])
    {
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
    
}
-(void)webRawDataReceivedWithError:(NSString *)errorMessage
{
//    loadingLBL.text=errorMessage;
//
//    hud.margin = 10.f;
//    hud.label.text = errorMessage;
//    [hud hideAnimated:YES afterDelay:2];
   // if([[[NSUserDefaults standardUserDefaults] valueForKey:@"loadStatus"] isEqualToString:@"YES"])
    {
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
    cell.favoriteButton.selected=YES;

    cell.favoriteButton.restorationIdentifier = [propertyArray[indexPath.row] objectForKey:@"_id"];
    [cell.favoriteButton addTarget:self action:@selector(addOrRemoveFavorites:) forControlEvents:UIControlEventTouchUpInside];
    
cell.selectionStyle = UITableViewCellSelectionStyleNone;
return cell;
    
    cell=(ListHostelsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ListHostelsTableViewCellNew"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fromValue=@"YES";
    NSString* price=@"0";
    NSString* discountPrice=@"0";
    cell.propertyLocationLBL.text=@"";
    cell.userRatingValueLBL.text=@"0";
    cell.propertyID=[[propertyArray objectAtIndex:indexPath.row] objectForKey:@"_id"];
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
    
    cell.favoriteButton.selected=YES;
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
    
    BOOL statusValue=NO;
    
    if ([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"]) {
        for(NSDictionary* dic in [[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"])
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
                     cell.hourLBL.text=[NSString stringWithFormat:@"%@h",[[propertyArray objectAtIndex:indexPath.row]valueForKey:@"smallest_timeslot"] ];
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
//    if ([[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"]) {
//        for(NSDictionary* dic in [[propertyArray objectAtIndex:indexPath.row] objectForKey:@"rooms"])
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
//    // ProximaNovaA-Regular 12.0Helvetica Neue Medium
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 4)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:22.0] range:NSMakeRange(5, leng-5)];
//     self.priceLBL.attributedText = str;
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED 1200"]];
//
//    [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:9.0] range:NSMakeRange(0, 3)];
//    cell.discountPriceLBL.attributedText = str1;
//    cell.featuredImageView.hidden=YES;
//    cell.discountPriceLBL.hidden=YES;
    cell.hourLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
   // sd.isMonthlySelected = false;
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
        [UIView animateWithDuration:0.5 animations:^{
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

- (IBAction)loginAction:(id)sender {
    
    //CJC 8 d
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.fromString=@"presentViewTab";
        [self.navigationController pushViewController:vc animated:YES];
    });
}



-(void)clickFromMap:(NSInteger)selectedIndex
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
    if ([[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rooms"]) {
        for(NSDictionary* dic in [[propertyArray objectAtIndex:selectedIndex] objectForKey:@"rooms"])
        {
            if([dic isKindOfClass:[NSDictionary class]])
            {
                if([dic objectForKey:@"price"])
                {
                    price=[dic valueForKey:@"price"];
                    break;
                }
            }
            else
                price=@"0.0";
            
        }
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED %@",price]];
    
    NSInteger leng=str.length;
    // ProximaNovaA-Regular 12.0Helvetica Neue Medium
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:14.0] range:NSMakeRange(0, 3)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FontBold size:22.0] range:NSMakeRange(4, leng-4)];
    self.priceLBL.attributedText = str;
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED 1200"]];
    
    [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:9.0] range:NSMakeRange(0, 3)];
    self.discountPriceLBL.attributedText = str1;
    self.featuredImageView.hidden=YES;
    self.discountPriceLBL.hidden=YES;
    self.hourLBL.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"]] ;
}

-(IBAction)listTypeFunction:(id)sender{
    
    if(listingType)
    {
        
        [UIView animateWithDuration:1 animations:^{
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
    selectedFavId =button.restorationIdentifier;
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
@end


