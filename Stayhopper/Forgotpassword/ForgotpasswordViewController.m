//
//  ForgotpasswordViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 19/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ForgotpasswordViewController.h"
#import "MessageViewController.h"
@interface ForgotpasswordViewController ()

@end

@implementation ForgotpasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _txtEmail.layer.cornerRadius = 6.0;
    [Commons paddingtoTextField:_txtEmail];
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
//_lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
_lblTitle.textColor = kColorDarkBlueThemeColor;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)sendFunction:(id)sender
{
    NSString *errorMessage = @"";
    if (![Commons validateEmail:_txtEmail.text]) {
        [_txtEmail becomeFirstResponder];
        errorMessage = [NSString stringWithFormat:@"Please enter a valid Email"];
        [_txtEmail becomeFirstResponder];
    }
    
  if(errorMessage!=0)
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
      
      NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
      [reqData setObject:_txtEmail.text forKey:@"email"];
 
      
      [self.view endEditing:YES];
      
      RequestUtil *util = [[RequestUtil alloc]init];
      util.webDataDelegate=(id)self;
      
      [util postRequest:reqData toUrl:[NSString stringWithFormat: @"users/reset-password"] type:@"POST"];
      }
      
  }
    else
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=errorMessage;
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
    
}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    
    [hud hideAnimated:YES afterDelay:0];
    if([[rawData objectForKey:@"status"] isEqualToString:@"Success"])
    
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Succses";
        vc.messageString=[rawData objectForKey:@"message"];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [[[UIApplication sharedApplication] keyWindow] addSubview:vc.view];
        [self moveBack];
}
    else
    {
      
        
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=[rawData objectForKey:@"message"];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
       // [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];
    }
    
    //   }
    // [listingTBV reloadData];
}
- (IBAction)backBtnClikd:(id)sender {
    [self moveBack];
}
-(void)moveBack
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
-(IBAction)backFunction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
};
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
