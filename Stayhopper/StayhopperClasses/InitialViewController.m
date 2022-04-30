//
//  InitialViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 23/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "InitialViewController.h"
#import "SignUpViewController.h"
#import "ImgCollectionViewCell.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "MessageViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
@interface InitialViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    ImgCollectionViewCell *cell;
}
@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray=[[NSArray alloc] initWithObjects:@"slide0.png",@"slide1.png",@"slide2.png",@"slide3.png", nil];
    titleArray=[[NSArray alloc] initWithObjects:@"UAE's first Microstay",@"Spend your day at the hotel",@"We covered all the hotels",@"Great customer service", nil];
   descriptionArray=[[NSArray alloc] initWithObjects:@"Deside the time of your check-in and length of your stay. Reserve 3,6,12 or 24 hours during the day or night.",@"Access to all services like meeting room,health club ,etc included",@"Extensive range of Hotels across UAE. 3,4 or 5 star hotels for the business people, travellers and leisure seekers.",@"24/7 customer support.Connect us through a live chat or call.", nil];
    lower_view.layer.cornerRadius=15.0;
    sign_up_View.layer.cornerRadius=8.0;
    fb_View.layer.cornerRadius=8.0;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"])
    {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        [self.navigationController setViewControllers:@[menuView]];
    }
    [self.pageControl setNumberOfPages:imageArray.count];
    
    connectButtopn = [[FBSDKLoginButton alloc] init];
    connectButtopn.permissions = @[@"public_profile", @"email"];    connectButtopn.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoSIGNUP)   name:@"pushToSignUp" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushtoLogin)   name:@"pushToLogin" object:nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    
    
    guestLBL.alpha=1;
    skipButtopn.alpha=1;
    
    if([_fromString isEqualToString:@"presentViewTab"])
    {
        guestLBL.alpha=0;
        skipButtopn.alpha=0;
    }
}
-(void)pushtoSIGNUP
{
    [self signUpAction:nil];
}

-(void)pushtoLogin
{
    [self signInAction:nil];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(ImgCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCollectionViewCell" forIndexPath:indexPath];
    cell.lbl.text=[titleArray objectAtIndex:indexPath.row];
    cell.decriptionLBL.text=[descriptionArray objectAtIndex:indexPath.row];

    cell.img.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((_imgCollection.superview.frame.size.width),(_imgCollection.superview.frame.size.height));
    
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.pageControl setCurrentPage:indexPath.item];
    
}






- (IBAction)signUpAction:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    SignUpViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    vc.fromString=self.fromString;

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)connectAction:(id)sender {
  
       // isFBSigned=NO;
        FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
        [manager logOut];
        [connectButtopn sendActionsForControlEvents: UIControlEventTouchUpInside];
        if ([FBSDKAccessToken currentAccessToken])
        {
            
        }
        
    }
    
    
    - (void)loginButton:    (FBSDKLoginButton *)loginButton
didCompleteWithResult:    (FBSDKLoginManagerLoginResult *)result
error:    (NSError *)error
    {
        // result.token.tokenString
        if ([FBSDKAccessToken currentAccessToken])
        {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,email,picture.width(500).height(500)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                  NSString *nameOfLoginUser = [result valueForKey:@"name"];
                 
                   NSString*userEmail=[result valueForKey:@"email"];
                    NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                    NSURL *fbProfileImgUrl=[NSURL URLWithString:imageStringOfLoginUser];
                    NSString *picURL=[NSString stringWithFormat:@"%@",fbProfileImgUrl];
                    
                    NSMutableCharacterSet *const allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
                    // See https://en.wikipedia.org/wiki/Percent-encoding
                    [allowedCharacterSet removeCharactersInString:@"&"]; // RFC 3986 section 2.2 Reserved Characters (January 2005)
                   // NSString *const urlEncoded = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
                       NSString * encodedString = [picURL stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];

                    
                {
                        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.label.text = @"";
                        
                        hud.mode=MBProgressHUDModeText;
                        hud.margin = 0.f;
                        hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
                        hud.removeFromSuperViewOnHide = YES;
                       
                        
                        
                        
                        [self.view endEditing:YES];
                        
                        RequestUtil *util = [[RequestUtil alloc]init];
                        util.webDataDelegate=(id)self;
                        NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
                        [reqData setValue:userEmail forKey:@"email"];
                        [reqData setValue:nameOfLoginUser forKey:@"name"];
                        if(picURL!=nil)
                        {
                            if(picURL.length!=0)
                                [reqData setObject:encodedString forKey:@"image"];
                        }
                    
                    [reqData setValue:@"ios" forKey:@"device_type"];

                        [util postRequest:reqData toUrl:@"users/fblogin" type:@"POST"];
                        
                        
                        
                    }
                    
                    
                }
            }];
        }
        
        else  if(result.token.tokenString!=nil || ![result.token.tokenString isKindOfClass:[NSNull class]])
        {
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,email,picture.width(500).height(500)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    
                  NSString *nameOfLoginUser = [result valueForKey:@"name"];
                   NSString*userEmail=[result valueForKey:@"email"];
                    NSString*fbID=[result valueForKey:@"id"];
                    
                   // image
                    NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                    NSURL *fbProfileImgUrl=[NSURL URLWithString:imageStringOfLoginUser];
                    NSString *picURL=[NSString stringWithFormat:@"%@",fbProfileImgUrl];
                    NSMutableCharacterSet *const allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
                    [allowedCharacterSet removeCharactersInString:@"&"]; // RFC 3986
                    NSString * encodedString = [picURL stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
                   
                    {
                        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
                        NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
                        [reqData setValue:userEmail forKey:@"email"];
                        if(picURL!=nil)
                        {
                            if(picURL.length!=0)
                        [reqData setObject:encodedString forKey:@"image"];
                        }
                        [reqData setValue:nameOfLoginUser forKey:@"name"];
                        [reqData setValue:@"ios" forKey:@"device_type"];

                        [util postRequest:reqData toUrl:@"users/fblogin" type:@"POST"];
                        
                        
                        
                    }
                    
                }
            }];
            
        }
        
    }

- (IBAction)skipAction:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabBarViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    [self.navigationController setViewControllers:@[menuView]];
}



- (IBAction)signInAction:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.fromString=self.fromString;
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    
    if([rawData objectForKey:@"data"])
    {
        if([[rawData objectForKey:@"status"] isEqualToString:@"Success"])
        {
            [hud hideAnimated:YES afterDelay:0];

            [[NSUserDefaults standardUserDefaults]setObject:[[rawData objectForKey:@"data"] objectForKey:@"_id"] forKey:@"userID" ];
            if([[rawData objectForKey:@"data"] objectForKey:@"country"] && ![[[rawData objectForKey:@"data"] objectForKey:@"country"] isKindOfClass:[NSNull class]])            [[NSUserDefaults standardUserDefaults]setObject:[[rawData objectForKey:@"data"]valueForKey:@"country"] forKey:@"nationalityName"];
            
            if([[rawData objectForKey:@"data"] objectForKey:@"city"] && ![[[rawData objectForKey:@"data"] objectForKey:@"city"] isKindOfClass:[NSNull class]])
                [[NSUserDefaults standardUserDefaults]setObject:[[rawData objectForKey:@"data"]valueForKey:@"city"] forKey:@"cityName"];
            
            if([[rawData objectForKey:@"data"] objectForKey:@"email"] && ![[[rawData objectForKey:@"data"] objectForKey:@"email"] isKindOfClass:[NSNull class]])
                [[NSUserDefaults standardUserDefaults]setObject:[[rawData objectForKey:@"data"]valueForKey:@"email"] forKey:@"userEmail"];
            
            if([[rawData objectForKey:@"data"] objectForKey:@"last_name"] && ![[[rawData objectForKey:@"data"] objectForKey:@"last_name"] isKindOfClass:[NSNull class]])
                [[NSUserDefaults standardUserDefaults]setObject:[[rawData objectForKey:@"data"]valueForKey:@"last_name"] forKey:@"lastName"];
            
            
            
            if([[rawData objectForKey:@"data"] objectForKey:@"image"] && ![[[rawData objectForKey:@"data"] objectForKey:@"image"] isKindOfClass:[NSNull class]])
                [[NSUserDefaults standardUserDefaults]setObject:[[rawData objectForKey:@"data"]valueForKey:@"image"] forKey:@"userImage"];
            
            if([[rawData objectForKey:@"data"] objectForKey:@"name"] && ![[[rawData objectForKey:@"data"] objectForKey:@"name"] isKindOfClass:[NSNull class]])
                [[NSUserDefaults standardUserDefaults]setObject:[[rawData objectForKey:@"data"]valueForKey:@"name"] forKey:@"userName"];
            
            if([[rawData objectForKey:@"data"] objectForKey:@"mobile"] && ![[[rawData objectForKey:@"data"] objectForKey:@"mobile"] isKindOfClass:[NSNull class]])
            {
                NSString *mobileNumber=[NSString stringWithFormat:@"%@",[[rawData objectForKey:@"data"] objectForKey:@"mobile"] ];
                if(mobileNumber.length!=0)
                    [[NSUserDefaults standardUserDefaults]setObject:[[rawData objectForKey:@"data"] objectForKey:@"mobile"] forKey:@"mobileNumber" ];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
           
                UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TabBarViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                [self.navigationController setViewControllers:@[menuView]];
          
        }
        else
        {
            hud.margin = 10.f;
            // hud.label.text = [[rawData objectForKey:@"data"] objectForKey:@"message"];
            [hud hideAnimated:YES afterDelay:0];
            //hud.margin = 10.f;
            //hud.label.text = response;
            // [hud hideAnimated:YES afterDelay:0];
            
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Failed";
            vc.messageString=[[rawData objectForKey:@"data"] objectForKey:@"message"];
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            
        }
    }
    else
    {
        //        hud.margin = 10.f;
        //        hud.label.text = [rawData objectForKey:@"message"];
        //        [hud hideAnimated:YES afterDelay:3];
        hud.margin = 10.f;
        // hud.label.text = [[rawData objectForKey:@"data"] objectForKey:@"message"];
        [hud hideAnimated:YES afterDelay:0];
        //hud.margin = 10.f;
        //hud.label.text = response;
        // [hud hideAnimated:YES afterDelay:0];
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=[rawData objectForKey:@"message"];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
    
    //[listingTBV reloadData];
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    //    hud.margin = 10.f;
    //    hud.label.text = response;
    //    [hud hideAnimated:YES afterDelay:3];
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
    
    //    hud.margin = 10.f;
    //    hud.label.text = errorMessage;
    //    [hud hideAnimated:YES afterDelay:3];
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



@end

