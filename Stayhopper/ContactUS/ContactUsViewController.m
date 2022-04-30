//
//  ContactUsViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ContactUsViewController.h"
#import "MBProgressHUD.h"
#import "MessageViewController.h"
#import "URLConstants.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <UITextView+Placeholder.h>

@interface ContactUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
    if (_cancellationBookingID) {
        _lblTitle.text = [NSString stringWithFormat:@"Cancel your booking - %@",_cancellationBookingID];
    }
    self.view.backgroundColor = kColorProfilePages;
    bgScrollView.backgroundColor = [UIColor clearColor];
    
    nameTF.superview.layer.cornerRadius=6;
    emailTF.superview.layer.cornerRadius=nameTF.superview.layer.cornerRadius;
    messageTV.superview.layer.cornerRadius=nameTF.superview.layer.cornerRadius;
    
//    emailBgImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    emailBgImageView.layer.borderWidth=1;
//    namgeBgImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    namgeBgImageView.layer.borderWidth=1;
//    messageBgImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    messageBgImageView.layer.borderWidth=1;
    // 27 32 102
//    nameTF.superview.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:32.0/255.0 blue:102.0/255.0 alpha:0.1];
//
//    emailTF.superview.backgroundColor = nameTF.superview.backgroundColor;
//    messageTV.superview.backgroundColor = nameTF.superview.backgroundColor;
//    nameTF.backgroundColor = [UIColor clearColor];
//    messageTV.backgroundColor = [UIColor clearColor];
//    emailTF.backgroundColor = [UIColor clearColor];
    emailTF.superview.clipsToBounds = TRUE;
    nameTF.superview.clipsToBounds = TRUE;
    emailTF.superview.clipsToBounds = TRUE;

    nameTF.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    emailTF.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"userEmail"];
    //sendButton.layer.cornerRadius = 5.;
 
    messageTV.placeholder = @"Message*";
    messageTV.placeholderColor = [UIColor lightGrayColor]; // optional

    [self paddingtoTextField:nameTF];
    [self paddingtoTextField:emailTF];
   // [self paddingtoTextField:messageTV];

    
    // Do any additional setup after loading the view.
}
-(void)paddingtoTextField:(UITextField*)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
   
    {
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
//    else
//    {
//        textField.rightView = paddingView;
//        textField.rightViewMode = UITextFieldViewModeAlways;
//    }
//
}
-(void)viewDidAppear:(BOOL)animated
{

   // bgScrollView.contentSize=CGSizeMake(0,sendButton.frame.size.height+sendButton.frame.origin.y+50);

}
- (IBAction)closeBtnAction:(id)sender {
    if (_cancellationBookingID) {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else{
        [self dismissViewControllerAnimated:TRUE completion:^{
                
        }];
    }
}

-(IBAction)sendFunction:(id)sender
{
    if(nameTF.text.length!=0 && messageTV.text.length!=0 && emailTF.text!=0)
    {
        if([self validateEmailWithString:emailTF.text])
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
            NSString *urlString = @"";
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
            if (_cancellationBookingID)
                {
                    urlString = @"contactus";

                    [reqData setObject:[NSString stringWithFormat:@"Request to cancel %@",_cancellationBookingID] forKey:@"subject"];

                }
            else{
                urlString = @"contactus";
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

                [reqData setObject:[NSString stringWithFormat:@"Support for version [%@] iOS",version] forKey:@"subject"];

            }
    [reqData setObject:emailTF.text forKey:@"email"];
    [reqData setObject:nameTF.text forKey:@"name"];
    [reqData setObject:messageTV.text forKey:@"message"];

    
 //   NSString* locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    
 //   "email:saleeshprakash@gmail.com
//subject:test
//message:Hello this is test"
    
    
    [self.view endEditing:YES];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    [util postRequest:reqData withToken:TRUE toUrl:urlString type:@"POST"];
            
         }
        else
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Please provide valid email";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
    }
    else
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"Please fill mandatory fields";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
}
-(IBAction)backFunction:(id)sender
{
    
    [self closeBtnAction:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.//
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    [hud hideAnimated:YES afterDelay:0];

    if (rawData[@"status"] && [rawData[@"status"] isEqualToString:@"Success"])
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Succses";
        if (rawData[@"message"]) {
            vc.messageString=rawData[@"message"];

        }
        else
        {
            vc.messageString=@"Thank you for contacting us";

        }
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [[[UIApplication sharedApplication] keyWindow] addSubview:vc.view];
    }
   
    if (_cancellationBookingID) {
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
    else{
        [self dismissViewControllerAnimated:TRUE completion:^{
                
        }];
    }
//    [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];

}
-(void)moveBack
{
    [self closeBtnAction:nil];
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
    //
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
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    //handle any error
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)mailButtonAction:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
                   MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
                   mailCont.mailComposeDelegate = (id)self;
                    [mailCont setToRecipients:[NSArray arrayWithObject:@"support@stayhopper.com"]];
                   [mailCont setSubject:@""];
                   [mailCont setMessageBody:[@"" stringByAppendingString:@""] isHTML:NO];
                   [self presentViewController:mailCont animated:YES completion:nil];
               }
            else
            {
                
            }
}
- (IBAction)landlineAction:(UIButton*)sender {
    [self callActions:((UILabel*)[sender.superview viewWithTag:1]).text];
}
- (IBAction)normalPhoneAction:(UIButton*)sender {
    [self callActions:((UILabel*)[sender.superview viewWithTag:2]).text];

}
-(void)callActions:(NSString*)phoneNumber
{
     phoneNumber=[[phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    phoneNumber= [self removeAllCharactersOtherThanDigitFromString:phoneNumber];
    
    NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"EN"];
    [Formatter setLocale:locale];
    NSNumber *newNum = [Formatter numberFromString:phoneNumber];
    if (newNum) {
        NSLog(@"%@", newNum);
    }
    phoneNumber = [NSString stringWithFormat:@"%@",newNum];
    phoneNumber= [self removeAllCharactersOtherThanDigitFromString:phoneNumber];
    NSURL *phoneNumberUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [[UIApplication sharedApplication] openURL:phoneNumberUrl options:@{} completionHandler:nil];

}
-(NSString*)removeAllCharactersOtherThanDigitFromString:(NSString*)string
{
    NSString *newString = [[string componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    NSRange range = [newString rangeOfString:@"^0*" options:NSRegularExpressionSearch];
    newString= [newString stringByReplacingCharactersInRange:range withString:@""];
    
    return newString;
}

@end
