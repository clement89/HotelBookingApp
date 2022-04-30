//
//  SignUpViewController.m
//  Stayhopper
//
//  Created by Vh iROID Technologies on 23/07/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "SignUpViewController.h"
#import "ApiCalling.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "TabBarViewController.h"
#import "FinalBookingViewController.h"
#import "MessageViewController.h"
#import "ForgotpasswordViewController.h"
#import "CountryListViewController.h"
#import "CountrySelectionVC.h"
#import "CountryListDataSource.h"
#import <NBMetadataHelper.h>
#import <NBPhoneNumber.h>
#import <NBPhoneNumberUtil.h>
#import "ARDatePicker.h"

#define datepicker_date_format @"dd MMM yyyy"


@interface SignUpViewController ()<UITextFieldDelegate,countryDelegate>{
    int selectedNationality;
    BOOL isNationalitySelcted;
    ApiCalling *ac;
    int currentIndex;
    NSNumber *selectedCountryCode;
    NSString *selctedGender,*dobString;
    
}
@property (strong, nonatomic) NSArray *dataRows;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dobString = @"";
    selctedGender = @"";
    _txtBirthDate.text =@"";
    selectedNationality = -1;
    [self genderSelectionAction:_btnMale];
    [Commons paddingtoTextField:_txtEmail];
    [Commons paddingtoTextField:_txtNationality];
    [Commons paddingtoTextField:_txtFirstName];
    [Commons paddingtoTextField:_txtLastName];
    [Commons paddingtoTextField:_txtBirthDate];
    
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
    currentIndex = 0;
    
    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    for (NSDictionary *countries in _dataRows) {
        if ([[[countries valueForKey:kCountryCode] lowercaseString] isEqualToString:[countryCode lowercaseString]]) {
            NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
            NSError *anError;
            NBPhoneNumber *phNumber = (NBPhoneNumber *)[phoneUtil parse:@"1234"
                                                          defaultRegion:[countryCode lowercaseString] error:&anError];
            selectedCountryCode = phNumber.countryCode;

            currentIndex = (int)[_dataRows indexOfObject:countries];
            [self settingTheCodeAndCountry];
            selectedNationality = currentIndex;
            break;
        }
    }
    
    

    _txtEmail.layer.cornerRadius = 6.0;
    
    _txtEmail.layer.cornerRadius = _txtEmail.layer.cornerRadius;
    _txtNationality.layer.cornerRadius = _txtEmail.layer.cornerRadius;
    _txtFirstName.layer.cornerRadius = _txtEmail.layer.cornerRadius;
    _txtLastName.layer.cornerRadius = _txtEmail.layer.cornerRadius;
    _txtBirthDate.layer.cornerRadius = _txtEmail.layer.cornerRadius;
    _txtPhoneNumer.superview.layer.cornerRadius = _txtEmail.layer.cornerRadius;

 
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
//_lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
_lblTitle.textColor = kColorDarkBlueThemeColor;
    
    
    
    
    ac=[[ApiCalling alloc]init];
    ac.delegate=self;
    
    UIColor *color = [UIColor lightGrayColor];
    /*  _userName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
     _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
     
     */
    
    _signUpView.layer.cornerRadius=18;
    _signUpView.clipsToBounds=YES;
    _signUp.layer.cornerRadius=8;
    _signUp.clipsToBounds=YES;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    
//    UIToolbar  *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
//    numberToolbar.items = [NSArray arrayWithObjects:
//                           
//                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)],
//                           nil];
//    _phoneNumber.inputAccessoryView = numberToolbar;
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
    if([UIScreen mainScreen].bounds.size.width>320)
    {
        [UIView animateWithDuration:1 animations:^{
            int height = MIN(keyboardSize.height,keyboardSize.width);
            _scrollView.contentOffset=CGPointMake(0, keyboardSize.height-70);
        } completion:NULL];
    }
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
//    if([UIScreen mainScreen].bounds.size.width<=320)
//    {
//        [UIView animateWithDuration:1 animations:^{
//            // int height = MIN(textField.frame.origin.y,keyboardSize.width);
//            _scrollView.contentOffset=CGPointMake(0,textField.superview.frame.origin.y+ textField.frame.origin.y+50);
//        } completion:NULL];
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_scrollView setScrollEnabled:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.name)
    {
        //[textField resignFirstResponder];
        [self.email becomeFirstResponder];
    }
    if (textField == self.email)
    {
        //[textField resignFirstResponder];
        [self.phoneNumber becomeFirstResponder];
    }
    if (textField == self.phoneNumber)
    {
        //[textField resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    if (textField == self.password)
    {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
    }
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if((textField == _txtLastName || textField == _txtFirstName) ) {
        if (([string isEqualToString:@" "] || [string isEqualToString:@"."])) {
            return TRUE;
        }
        NSCharacterSet *allowedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        return ([string rangeOfCharacterFromSet:allowedCharacters].location == NSNotFound);
    }
    else if(textField==_name)
    {
        
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. "] invertedSet];
            NSString *filteredstring  = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            if(![string isEqualToString:filteredstring])
                
                return ([string isEqualToString:filteredstring]);
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            return (newString.length<=21);
        
}
        
        
        
        
    }
    
   
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
    _containerViewOfScrollViewHt.constant=_signUpViewHt.constant+40;
    _scrollView.contentSize=CGSizeMake(0,_containerViewOfScrollViewHt.constant);
    
    if([UIScreen mainScreen].bounds.size.width<=320)
        _scrollView.contentSize=CGSizeMake(0,_containerViewOfScrollViewHt.constant+80);
    
    
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signUpAction:(id)sender {
    [self.view endEditing:YES];
    NSString *errorMessage = @"";
    if ([Commons trimWhitespacesAndGivingCorrectString:_txtFirstName.text].length ==0) {
        [_txtFirstName becomeFirstResponder];
        errorMessage = [NSString stringWithFormat:@"%@ cannot be empty",_txtFirstName.placeholder];
    }
    else if (![Commons validateEmail:_txtEmail.text]) {
        [_txtEmail becomeFirstResponder];
        errorMessage = [NSString stringWithFormat:@"Please enter a valid %@",_txtEmail.placeholder];
    }
    else if ([Commons trimWhitespacesAndGivingCorrectString:_txtBirthDate.text].length ==0) {
         errorMessage = [NSString stringWithFormat:@"Please select %@",_txtBirthDate.placeholder];
        [self birthDateSelctionAction:nil];
    }
    else if ([Commons trimWhitespacesAndGivingCorrectString:_txtNationality.text].length ==0) {
         errorMessage = [NSString stringWithFormat:@"Please select %@",_txtNationality.placeholder];
    }
    else if ([Commons trimWhitespacesAndGivingCorrectString:_txtPhoneNumer.text].length <=6) {
        [_txtPhoneNumer becomeFirstResponder];
         errorMessage = [NSString stringWithFormat:@"Please enter a valid %@",_txtPhoneNumer.placeholder];
    }
    if(errorMessage.length==0)
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
            
            [self.view endEditing:YES];
            NSString* stringPhn=[NSString stringWithFormat:@"%@-%@",_lblCountryCode.text,_txtPhoneNumer.text];

            RequestUtil *util = [[RequestUtil alloc]init];
            util.webDataDelegate=(id)self;
            NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
            [reqData setValue:[NSString stringWithFormat:@"%@ %@",_txtFirstName.text,_txtLastName.text] forKey:@"name"];

            
            [reqData setValue:_txtEmail.text forKey:@"email"];
           
            [reqData setValue:_txtNationality.text forKey:@"country"];
            [reqData setValue:_txtNationality.text forKey:@"city"];

            [reqData setValue:stringPhn forKey:@"mobile"];
            [reqData setValue:selctedGender forKey:@"gender"];
            NSDate *bd =[Commons getDateFromString:_txtBirthDate.text Format:datepicker_date_format];
            
            [reqData setValue:[Commons stringFromDate:bd Format:@"MM/dd/yyyy"] forKey:@"dateOfBirth"];

            [reqData setValue:@"ios" forKey:@"device_type"];

            
            [util postRequest:reqData toUrl:@"users" type:@"POST"];
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
    
    
    if([rawData objectForKey:@"user"])
    {/*{
      "message": "Registration successful",
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJnZW5kZXIiOiJtYWxlIiwiZmF2b3VyaXRlcyI6W10sInN0YXR1cyI6MSwicHJvbW9jb2RlcyI6W10sIl9pZCI6IjVmYjM5NDIwMjAwZWU0MjQ4YTgzYjMyZSIsIm5hbWUiOiJBQkMgVXNlciIsImVtYWlsIjoiYWJjMUBnbWFpbC5jb20iLCJtb2JpbGUiOiI5NzE1NTY2MTgxNTYiLCJjb3VudHJ5IjoiVUFFIiwiZGF0ZU9mQmlydGgiOiIwMi8xNS8xOTkwIiwicGFzc3dvcmQiOiIkMmIkMTAkcmtHRkpDWE96TUVEclhmaWdIOGt1T2JOM0ZYQ1BKakpBWUFOaFdWdEo2NzA3enhyVndtZDIiLCJjcmVhdGVkQXQiOiIyMDIwLTExLTE3VDA5OjEzOjA0LjcwMloiLCJ1cGRhdGVkQXQiOiIyMDIwLTExLTE3VDA5OjEzOjA0LjcwMloiLCJfX3YiOjAsImlhdCI6MTYwNTYwNDM4NH0.eH02nrV8n-pixA4ifzIzerNi_vqRAaoI5MpwL6QF5uE",
      "user": {
          "gender": "male",
          "favourites": [],
          "status": 1,
          "promocodes": [],
          "_id": "5fb39420200ee4248a83b32e",
          "name": "ABC User",
          "email": "abc1@gmail.com",
          "mobile": "971556618156",
          "country": "UAE",
          "dateOfBirth": "02/15/1990",
          "password": "$2b$10$rkGFJCXOzMEDrXfigH8kuObN3FXCPJjJAYANhWVtJ6707zxrVwmd2",
          "createdAt": "2020-11-17T09:13:04.702Z",
          "updatedAt": "2020-11-17T09:13:04.702Z",
          "__v": 0
      }
  }
      */
     //   if([[rawData objectForKey:@"status"] isEqualToString:@"Success"])
        {
            [hud hideAnimated:YES afterDelay:0];
            
            //  {"status":"Success","data":{"_id":"5b8d331da8de7573b7fd43c1","name":"saleeshh","email":"saleeshprakash@gmail.com","__v":0}}
 
            
          /**/
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Succses";
            vc.messageString=@"Your password has been sent to your registered Email ";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [[[UIApplication sharedApplication] keyWindow] addSubview:vc.view];

 
            
            [self backAction:nil];

         //   [[NSNotificationCenter defaultCenter] postNotificationName:@"paynow" object:nil];

           
        }
         
    }
    else
    {
      hud.margin = 10.f;
         if([rawData objectForKey:@"message"])
         {
       // hud.label.text = [rawData objectForKey:@"message"];
             UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
             MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
             vc.imageName=@"Failed";
             vc.messageString=[rawData objectForKey:@"message"];
             vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
             [self.view addSubview:vc.view];
         }
        else
        {
          //  hud.label.text=@"Registration Failed";
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Failed";
            vc.messageString=@"Account exist with same email";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
        [hud hideAnimated:YES afterDelay:0];
    }
    
    //[listingTBV reloadData];
}

-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
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
-(void)webRawDataReceivedWithError:(NSString *)errorMessage
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
- (IBAction)loginAction:(id)sender {
    
    [self.view endEditing:YES];
    if(![self.fromString isEqualToString:@"presentView"] && ![self.fromString isEqualToString:@"presentViewTab"])
    {
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToLogin" object:nil];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];

}
-(IBAction)forgotPasswordFunction:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    ForgotpasswordViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"ForgotpasswordViewController"];
    [self.navigationController pushViewController:menuView animated:YES];
}
-(IBAction)countryCodeFunction:(id)sender
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    
    


    CountrySelectionVC *countr =[y instantiateViewControllerWithIdentifier:@"CountrySelectionVC"];
     countr.delegate =(id) self;
     countr.dataRows =_dataRows;
    if (isNationalitySelcted) {
        countr.currentIndex = selectedNationality;

    }
    else{
        countr.currentIndex = currentIndex;

    }
    [self.navigationController pushViewController:countr animated:TRUE];
}

-(void)countryFunctionByString:(NSString*)countryString value:(NSString*)countryCode
{
    [self.countryCode setTitle:countryCode forState:UIControlStateNormal];
}
- (IBAction)genderSelectionAction:(UIButton*)sender {
    sender.selected = TRUE;
    selctedGender = [sender restorationIdentifier];
    for (UIButton *btn in [sender.superview subviews]) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn!=sender) {
                btn.selected = FALSE;
            }
        }
    }
}
- (IBAction)birthDateSelctionAction:(id)sender {
    
    [self.view endEditing:true];
    NSDate *selDate=[NSDate date];
    
    if (_txtBirthDate.text.length>0) {
        selDate = [Commons getDateFromString:_txtBirthDate.text Format:datepicker_date_format];
    }
    [ARDatePicker showPickerViewInView:self.view withOptions:@{
                                                          ANbackgroundColor : [UIColor whiteColor],
                                                          ANtextColor : [UIColor whiteColor],
                                                          ANtoolbarColor : kColorDarkBlueThemeColor,
                                                          ANbuttonTextColor : [UIColor blackColor],
                                                          ANtoolbarTitle : _txtBirthDate.placeholder,
                                                          ANCurrentDate : selDate,
                                                          ANMaxtDate : [NSDate date],
                                                          ANfont : [UIFont fontWithName:FontRegular size:15.0],
                                                          ANReturnDateFormat : datepicker_date_format,
                                                          ANtextAlignment : @1
                                                          } completion:^(NSString *selectedString) {
                                                              if ([selectedString intValue]>=0)
                                                              {
                                                                  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                                  [formatter setDateFormat:datepicker_date_format];
                                                                  //[CommonFunction date]
                                                                  NSDate *selected_date_ = [formatter dateFromString:selectedString];
                                                                  if ([selected_date_ isKindOfClass:[NSDate class]]) {
                                                                      
                                                                      _txtBirthDate.text = [Commons stringFromDate:selected_date_ Format:datepicker_date_format];
                                                                    
                                                                      
                                                                  }
                                                              }
                                                              else
                                                              {
                                                                  //Revert back button Slection TODO
                                                                  NSLog(@"cancell pressed");
                                                              }
                                                          }];
    
}
- (IBAction)nationalitySelctionAction:(id)sender {
    [self.view endEditing:TRUE];

    isNationalitySelcted = TRUE;
    [self countryCodeFunction:nil];
}
- (IBAction)phoneCodeSelection:(id)sender
{
    [self.view endEditing:TRUE];
    isNationalitySelcted = FALSE;
    [self countryCodeFunction:nil];
}
-(void)settingTheCodeAndCountry{
    if (!isNationalitySelcted) {
        _imgFlag.image = [self getCountryImageForNumber:selectedCountryCode];
        _lblCountryCode.text = [NSString stringWithFormat:@"+%@",selectedCountryCode];

    }
    else
    {
        _txtNationality.text = [_dataRows objectAtIndex:selectedNationality][@"country_name"];
    }
    //
}
- (void)didSelectCountrywithCountryCode:(NSString *)countryCode;
{
    if (isNationalitySelcted)
    {
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
    NSString *resultString = [[countryCode componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        NSArray *ar =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"telephone_code == %@",resultString]];
        if (ar&&ar.count>0) {
            selectedNationality = (int)[_dataRows indexOfObject:[ar firstObject]];
        }
        else{
            selectedNationality = 0;
            
        }    }
    else
    {
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
        NSString *resultString = [[countryCode componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];

        selectedCountryCode = [NSNumber numberWithInteger:[resultString integerValue]];
        NSArray *ar =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"telephone_code == %@",resultString]];
        if (ar&&ar.count>0) {
            currentIndex = (int)[_dataRows indexOfObject:[ar firstObject]];
        }
        else{
            currentIndex = 0;
            
        }
        
        [_txtBirthDate becomeFirstResponder];
    }
    [self settingTheCodeAndCountry];
}
- (UIImage *)getCountryImageForNumber:(NSNumber *)countryCode
{
    

    NSArray *regionCodeArray = [NBMetadataHelper regionCodeFromCountryCode:countryCode];
    NSString *regionCode = [regionCodeArray objectAtIndex:0];
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[regionCode lowercaseString]]];
}
 
@end

