//
//  ProfileViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 24/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ProfileViewController.h"
#import "ListHostelsTableViewCell.h"
#import "InitialViewController.h"
#import "ProfileListTableViewCell.h"
#import "LoginViewController.h"
#import "FAQViewController.h"
#import "NotificationsViewController.h"
#import "TermsAndConditionsViewController.h"
#import "ContactUsViewController.h"
#import "EditProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "TERMSWEBViewController.h"
#import "URLConstants.h"
#import "GetHelpViewController.h"
#import "SettingsViewController.h"
#import "WalkThroughViewController.h"
#import "AppDelegate.h"
@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgDummyEdit;

@property (weak, nonatomic) IBOutlet UILabel *lblLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    profileName.superview.layer.shadowOffset = CGSizeMake(0, 2);
    profileName.superview.layer.shadowOpacity = 0.3;
    profileName.superview.layer.shadowRadius = 2.0;
    profileName.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    self.view.backgroundColor = kColorProfilePages;
    editPic.contentMode = UIViewContentModeScaleAspectFill;

//    editPic.layer.cornerRadius = editPic.frame.size.height/2.;
//    editPic.layer.masksToBounds = FALSE;
// //  editPic.clipsToBounds = TRUE;
//    editPic.layer.shadowOffset = CGSizeMake(0, 2);
//    editPic.layer.shadowOpacity = 0.3;
//  //  editPic.layer.shadowRadius = 5.0;
//    editPic.layer.shadowColor = [UIColor grayColor].CGColor;
  //  [editPic.layer setBorderWidth:1.5f];
    
    
//    [editPic.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [editPic.layer setBorderWidth:1.5f];
//    [editPic.layer setShadowColor:[UIColor lightGrayColor].CGColor];
//    [editPic.layer setShadowOpacity:0.3];
//    [editPic.layer setShadowRadius:2.0];
//    [editPic.layer setShadowOffset:CGSizeMake(0, 2.0)];

    
  //  listArray=[[NSArray alloc]initWithObjects:@"Frequently Asked Questions",@"Contact US",@"Terms & Conditions",@"Notifications",@"Log In", nil];;
    listArray=[[NSArray alloc]initWithObjects:@"How Stayhopper works",@"Get help",@"Settings",@"List your property", nil];;

    imageArray=[[NSArray alloc]initWithObjects:@"How stayhopper works",@"Get help",@"Settingsp",@"Listproprty",@"logout", nil];;
    porfilePic.clipsToBounds=YES;
    porfilePic.layer.cornerRadius=porfilePic.frame.size.width/2;
    porfilePic.layer.borderColor = [UIColor colorWithRed:16./255. green:11./255. blue:40./255. alpha:0.2].CGColor;
    porfilePic.layer.borderWidth = 0.2;
    profileName.text=@"";
    profileEmail.text=@"";
   
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
//    {
//    listArray=[[NSArray alloc]initWithObjects:@"Frequently Asked Questions",@"Contacts",@"Terms & Conditions",@"Notifications",@"Log Out", nil];;
//    profileName.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
//
//    profileEmail.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"userEmail"];
//    }
//
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
   
    editButton.alpha=0;
    editPic.alpha=0;
    profileName.text=@"";
    profileEmail.text=@"";
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        _lblLogin.hidden = TRUE;

        _btnLogin.enabled = FALSE;
        editPic.hidden = FALSE;
        editButton.hidden = FALSE;
        _imgDummyEdit.hidden = FALSE;
        editButton.alpha=1;
        editPic.alpha=1;
        _lblLogin.hidden = TRUE;
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userImage" ])
        {
            porfilePic.contentMode = UIViewContentModeScaleAspectFill;

            NSString*imgName=[[NSUserDefaults standardUserDefaults]objectForKey:@"userImage" ];
            NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
            [porfilePic sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"avatarimage"]];

        }
        else
        {
            porfilePic.contentMode = UIViewContentModeCenter;

            porfilePic.image = [UIImage imageNamed:@"avatarimage"];
        }
//        listArray=[[NSArray alloc]initWithObjects:@"How Stayhopper works",@"Get help",@"Settings",@"List your property", nil];;

      // listArray=[[NSArray alloc]initWithObjects:@"FAQ",@"Contact",@"Terms and conditions",@"Notifications", nil];;
        profileName.text=[[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"] capitalizedString];
        
        profileEmail.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"userEmail"];
        _lblLogout.hidden = FALSE;

    }
    else
    {
        _lblLogin.hidden = FALSE;
 
        porfilePic.contentMode = UIViewContentModeCenter;

        porfilePic.image = [UIImage imageNamed:@"avatarimage"];
        _btnLogin.enabled = TRUE;
        profileName.text = @"";
        profileEmail.text=@"";
        editPic.hidden = TRUE;
        editButton.hidden = TRUE;
        _imgDummyEdit.hidden = TRUE;
        _lblLogout.hidden = TRUE;

        
    }
    [profileTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ProfileListTableViewCell* cell=(ProfileListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ProfileListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImage.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.listTitle.text=[listArray objectAtIndex:indexPath.row];

    return cell;
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
-(IBAction)EDITPROFILE:(id)sender
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfileViewController *vc = [y   instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    
    // vc.fromString=@"presentViewTab";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if(indexPath.row==0)
    {
        //UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        

        WalkThroughViewController *vc = [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"WalkThroughViewController"];
        vc.isFromSettings = TRUE;
        if (@available(iOS 13.0, *)) {
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
        } else {
            // Fallback on earlier versions
        }
        // vc.fromString=@"presentViewTab";
        [self.navigationController presentViewController:vc animated:TRUE completion:^{
             
        }];

    }
    else if(indexPath.row==1)
    {
        //UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ContactUsViewController *vc = [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil]   instantiateViewControllerWithIdentifier:@"GetHelpViewController"];
        
        // vc.fromString=@"presentViewTab";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row==2)
    {
       
        
       // TermsAndConditionsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"TermsAndConditionsViewController"];
        
       // [self.navigationController pushViewController:vc animated:YES];
        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://stayhopper.com/privacy.html"]];
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        UIViewController *vc = [y   instantiateViewControllerWithIdentifier:@"SettingsViewController"];
//        vc.WEBSTRING=@"https://stayhopper.com/terms.html#noheader";
        [self.navigationController pushViewController:vc animated:YES];
        

       // [[UIApplication sharedApplication] openURL:request.URL];

       // https://stayhopper.com/privacy.html
    }
    else if(indexPath.row==3)
    {
        
        //CJC
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        
        TERMSWEBViewController *vc = [y   instantiateViewControllerWithIdentifier:@"TERMSWEBViewController"];
//        vc.WEBSTRING=@"https://stayhopper.com/terms.html#noheader";
        vc.titleString = @"List your property";
        vc.WEBSTRING=@"https://stayhopper.com/register-property?noheader";//CJC 20

        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:TRUE completion:^{
             
        }];
        
        
        
//        NSURL* directionsURL = [NSURL URLWithString:@"https://www.staging.stayhopper.com/register-property"];
//           if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
//               [[UIApplication sharedApplication] openURL:directionsURL options:@{} completionHandler:^(BOOL success) {}];
//           } else {
//               [[UIApplication sharedApplication] openURL:directionsURL];
//           }
//
        
      /*  ContactUsViewController *vc = [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil]   instantiateViewControllerWithIdentifier:@"GetHelpViewController"];
        
        // vc.fromString=@"presentViewTab";
        [self.navigationController pushViewController:vc animated:YES];*/

    }
 
    
  
    
    
}
- (IBAction)loginButtonActionss:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    vc.fromString=@"presentViewTab";
    [self.navigationController pushViewController:vc animated:YES];
    
   

}
- (IBAction)logoutActionn:(id)sender {
    
    //CJC logout
    
    
//    NSString* postString=[NSString stringWithFormat:@"user_id=%@&device_type=ios&device_token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"],[[NSUserDefaults standardUserDefaults]objectForKey:@"DEVICE_TOKENFCM"]];
//
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    
    
    [util postRequest:reqData withToken:TRUE toUrl:@"users/logout" type:@"GET"];

   
    
//    NSString *requstUrl=[NSString stringWithFormat:@"https://extranet.stayhopper.com/api/users/logout"];
//
//
//    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requstUrl]];
//    [request setHTTPMethod:@"GET"];
//    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postString length]] forHTTPHeaderField:@"Content-length"];
//    [request setURL:[NSURL URLWithString:requstUrl]];
//
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//        NSError *localError = nil;
//        NSDictionary *parsedObject;
//        if (!parsedObject) {
//            parsedObject =[[NSDictionary alloc]init];
//        }
//
//
//        //[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//        if(data!=nil)
//        {
//
//        }
//        else{
//
//        }
//
//
//    }];
//
//    [postDataTask resume];
    


    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"WalkThroughViewController"];
        
//    InitialViewController *vc = [self.storyboard   instantiateViewControllerWithIdentifier:@"InitialViewController"];
//    [self.navigationController setViewControllers:@[vc]];
    }
    else
    {
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        vc.fromString=@"presentViewTab";
        [self.navigationController pushViewController:vc animated:YES];
//            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//            InitialViewController *vc = [y   instantiateViewControllerWithIdentifier:@"InitialViewController"];
//
//            vc.fromString=@"presentViewTab";
//            [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    NSLog(@"fkdjfk 1- %@",rawData);

}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    
    //    loadingLBL.text=response;
    //    hud.margin = 10.f;
    //    hud.label.text = response;
    //    [hud hideAnimated:YES afterDelay:2];
   
    NSLog(@"fkdjfk 2- %@",response);

    
}
-(void)webRawDataReceivedWithError:(NSString *)errorMessage
{
    //    loadingLBL.text=errorMessage;
    //
    //    hud.margin = 10.f;
    //    hud.label.text = errorMessage;
    //    [hud hideAnimated:YES afterDelay:2];
  
    
    NSLog(@"fkdjfk 3- %@",errorMessage);

    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
