//
//  LoginViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 23/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "LoginViewController.h"
#import "ApiCalling.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "TabBarViewController.h"
#import "MessageViewController.h"
#import "ForgotpasswordViewController.h"
#import "SignUpViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()<UITextFieldDelegate>{
    ApiCalling *ac;
}
@property (weak, nonatomic) IBOutlet UIImageView *orImage;
@property (weak, nonatomic) IBOutlet UIButton *fbLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  ac=[[ApiCalling alloc]init];
   // ac.delegate=self;
    [Commons paddingtoTextField:_txtEmail];
    [Commons paddingtoTextField:_txtPassword];

    _txtEmail.layer.cornerRadius = 6.0;
    _txtPassword.layer.cornerRadius= _txtEmail.layer.cornerRadius;
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
//_lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
_lblTitle.textColor = kColorDarkBlueThemeColor;
    

    
    _signUpView.layer.cornerRadius=18;
    _signUpView.clipsToBounds=YES;
    _signUp.layer.cornerRadius=8;
    _signUp.clipsToBounds=YES;
    connectButtonBTN.alpha=0;
 
    

    
    
    connectButtopn = [[FBSDKLoginButton alloc] init];
    connectButtopn.permissions = @[@"public_profile", @"email"];
    
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if([pref boolForKey:@"not_show_fb_login"]){
        [_fbLoginButton setHidden:YES];
        [_orImage setHidden:YES];
    }else{
        [_fbLoginButton setHidden:NO];
        [_orImage setHidden:NO];
    }
    
//    connectButtopn.delegate=self;
    
}

- (IBAction)doneWithNumberPad:(id)textField
{
    [self.view endEditing:YES];
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardFrame;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]getValue:&keyboardFrame];
    
    double animationDuration;
    UIViewAnimationCurve animationCurve;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]getValue:&animationDuration];
    
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]getValue:&animationCurve];
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:1.4 animations:^{
        int height = MIN(keyboardSize.height,keyboardSize.width);
        _scrollView.contentOffset=CGPointMake(0, keyboardSize.height-70);
    } completion:NULL];
    
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    CGRect keyboardFrame;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]getValue:&keyboardFrame];
    
    double animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey]getValue:&animationDuration];
    [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]getValue:&animationCurve];
    [UIView animateWithDuration:0.5 animations:^{
        [UIView animateWithDuration:1 animations:^{
            _scrollView.contentOffset=CGPointMake(0, 0);
        }];
    } completion:NULL];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_scrollView setScrollEnabled:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_scrollView setScrollEnabled:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtEmail)
    {
        //[textField resignFirstResponder];
        [self.txtPassword becomeFirstResponder];
    }
    
    else    {
        [textField resignFirstResponder];
     }
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    /*if(textField==self.confirmPassword)
     {
     NSString*str= [textField.text stringByReplacingCharactersInRange:range withString:string];
     BOOL showAlert=NO;
     NSString*msg;
     if(self.confirmPassword.text.length>=self.password.text.length)
     {
     if([self.password.text isEqualToString:str])
     {
     
     }
     else{
     showAlert=YES;
     msg=@"Passwords do not match";
     if(selectedLang)
     {
     msg=@"";
     }
     }
     
     if(showAlert){
     showAlert=NO;
     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.mode = MBProgressHUDModeText;
     hud.label.text = msg;
     hud.mode=MBProgressHUDModeText;
    hud.margin = 0.f;
     hud.yOffset = 200.f;
     hud.removeFromSuperViewOnHide = YES;
     hud.userInteractionEnabled=YES;
     [hud hideAnimated:YES afterDelay:2];
     }
     }
     }*/
    
    return YES;
}



- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


-(void)viewDidAppear:(BOOL)animated{
    //_scrollView.contentSize=CGSizeMake(0,_containerViewOfScrollView.frame.size.height);
    
}


-(void)viewDidLayoutSubviews{
//    _containerViewOfScrollViewHt.constant=_signUpViewHt.constant+40;
//    _scrollView.contentSize=CGSizeMake(0,_containerViewOfScrollViewHt.constant);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)backAction:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//    return;
    
    
    
   
    
    //CJC 8
    
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"checking"]){
        [[NSUserDefaults standardUserDefaults] setValue:@"loginOk"  forKey:@"login_status"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey :@"checking"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    /**/
    
if([self.fromString isEqualToString:@"presentViewTab"])    {
    
    
  [[NSNotificationCenter defaultCenter] postNotificationName:@"GUSTBACK" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
//
    }
    else
     [self.navigationController popViewControllerAnimated:YES];
//    if([self.fromString isEqualToString:@"presentView"])
//    {
//       // [self.parentViewController.tabBarController setSelectedIndex:0];
//
//
//
//
//
//      //  [self dismissViewControllerAnimated:YES completion:nil];
//
//    }
//    else if([self.fromString isEqualToString:@"presentViewTab"])
//    {
//
//
//
//
//
//
//        [self.navigationController popViewControllerAnimated:YES];
//
//        //  [self dismissViewControllerAnimated:YES completion:nil];
//
//    }
//    else
//        [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signUpAction:(id)sender {
    [self.view endEditing:YES];

    if(_txtEmail.text.length!=0 && _txtPassword.text.length!=0)
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
    [reqData setValue:_txtEmail.text forKey:@"email"];
    [reqData setValue:_txtPassword.text forKey:@"password"];
    [util postRequest:reqData toUrl:@"users/login" type:@"POST"];
    

    
    }
    else
    {
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.label.text = @"Invalid Username || Password";
//
//        hud.mode=MBProgressHUDModeText;
//hud.margin = 10.f;
//        hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
//        hud.removeFromSuperViewOnHide = YES;
//        [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            hud.progress=hud.progress+0.05;
//            if(hud.progress>1)
//            {
//                [timer invalidate];
//            }
//        }];
//        [hud hideAnimated:YES afterDelay:2];
//
//
//        hud.margin = 10.f;
//        //hud.label.text = response;
//        [hud hideAnimated:YES afterDelay:0];
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"Invalid Email || Password";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];

    }
}



-(IBAction)clickSignUp:(id)sender
{
    if(![self.fromString isEqualToString:@"presentView"] && ![self.fromString isEqualToString:@"presentViewTab"])
    {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToSignUp" object:nil];
}
    else
    {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        SignUpViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        vc.fromString=self.fromString;
        
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    
     {
    if([rawData objectForKey:@"user"] )
    {
        [hud hideAnimated:YES afterDelay:0];

//        {"status":"Success","data":{"_id":"5b8d331da8de7573b7fd43c1","name":"saleeshh","email":"saleeshprakash@gmail.com","__v":0}}
        
        NSDictionary *user = [Commons dictionaryByReplacingNullsWithStrings:[rawData objectForKey:@"user"]];
        [[NSUserDefaults standardUserDefaults]setObject:user forKey:@"userDetails"];
        [[NSUserDefaults standardUserDefaults]setObject:[rawData objectForKey:@"token"] forKey:@"token" ];
        NSString *fname =[user objectForKey:@"name"];
      NSArray *names =   [fname componentsSeparatedByString:@" "];
        NSString *lname =  @"";
        if (names.count>1) {
            NSString *nn =@"";
            for (int i=0;i<names.count-1;i++) {
            nn = [nn stringByAppendingString:names[i]];
            }
            fname = nn;
            lname = [names lastObject];
            
        }
        [[NSUserDefaults standardUserDefaults]setObject:lname forKey:@"lastName" ];
        [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"name"] forKey:@"userName" ];
        [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"email"] forKey:@"userEmail" ];
        [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"country"] forKey:@"countryName" ];
        [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"_id"] forKey:@"userID" ];
        [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"mobile"] forKey:@"mobileNumber"];
        [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"gender"] forKey:@"gender"];
        if ([user objectForKey:@"image"]) {
            [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"image"] forKey:@"userImage"];

        }
        if ([user objectForKey:@"city"]) {
            [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"city"] forKey:@"cityName"];

        }
//        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@-%@",_lblCountryCode.text,_txtPhoneNumer.text] forKey:@"mobileNumber" ];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        AppDelegate *appdel = [[UIApplication sharedApplication] delegate];
        [appdel callFavoritesAPI];
        
        
        //CJC last work
        RequestUtil *utilObj = [[RequestUtil alloc]init];
        [utilObj pushRegistration];
        
       // [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self backAction:nil];
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
            if (rawData) {
                vc.messageString=[[rawData objectForKey:@"data"] objectForKey:@"message"];

            }
            else
            {
                vc.messageString=@"Invalid Email || Password";

            }
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            
        }
    }
   
    
    //[listingTBV reloadData];
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
-(IBAction)forgotPasswordFunction:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    ForgotpasswordViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"ForgotpasswordViewController"];
    [self.navigationController pushViewController:menuView animated:YES];
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
                [allowedCharacterSet removeCharactersInString:@"&"]; // RFC 3986 section 2.2 Reserved
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
                    [reqData setValue:@"ios" forKey:@"device_type"];

                    if(picURL!=nil)
                    {
                        if(picURL.length!=0)
                            [reqData setObject:encodedString forKey:@"image"];
                    }
                    [reqData setValue:@"ios" forKey:@"device_type"];

                    [util postRequest:reqData toUrl:@"users/fb-login" type:@"POST"];
                    
                    
                    
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
                    [util postRequest:reqData toUrl:@"users/fb-login" type:@"POST"];
                    
                    
                    
                }
                
            }
        }];
        
    }
    
}

@end

