//
//  EditProfileViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 23/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "EditProfileViewController.h"
#import "MessageViewController.h"
#import "UIImageView+WebCache.h"
#import "CountryListViewController.h"
#import "URLConstants.h"
#import "CountryListViewController.h"
#import "CountrySelectionVC.h"
#import "CountryListDataSource.h"
#import <NBMetadataHelper.h>
#import <NBPhoneNumber.h>
#import <NBPhoneNumberUtil.h>

@interface EditProfileViewController ()<countryDelegate>
{
    NSArray *nationalityArray;
    NSNumber *selectedCountryCode;
    int selectedNationality;
    BOOL isNationalitySelcted;
    int currentIndex;
    BOOL isImageChanged;

}
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSArray *dataRows;

@end

    
@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self done:nil];
    countryTF.text=@"";
    mobileNumberTF.keyboardType = UIKeyboardTypeNumberPad;

    cCode=@"971";
    currentIndex = -1;
    selectedNationality = -1;
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
 
    
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    self.view.backgroundColor = kColorProfilePages;
    
    
    passwordButton.clipsToBounds=YES;
    profileButton.clipsToBounds=YES;
    profilePic.clipsToBounds=YES;
    apiStatus=YES;

    passwordButton.layer.cornerRadius=5;
    profileButton.layer.cornerRadius=5;
    profilePic.layer.cornerRadius=profilePic.frame.size.height/2;
    profilePic.layer.borderColor = [UIColor colorWithRed:16./255. green:11./255. blue:40./255. alpha:0.2].CGColor;
    profilePic.layer.borderWidth = 0.25;
    imageData=[[NSData alloc]init];
   
    profilePic.superview.clipsToBounds = TRUE;
    profilePic.superview.layer.cornerRadius = 10.;
    profilePic.superview.layer.shadowOffset = CGSizeMake(0, 2);
    profilePic.superview.layer.shadowOpacity = 0.3;
    profilePic.superview.layer.shadowRadius = 2.0;
    profilePic.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"cityName" ])
        cityNameTF.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"cityName" ];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"countryName" ])
        countryTF.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"countryName" ];
 
 
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"lastName" ])
        lastNameTF.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"lastName" ];
    
    //    [[NSUserDefaults standardUserDefaults]setObject:lastNameTF.text forKey:@"lastName"];
    NSString *mob=[[NSUserDefaults standardUserDefaults]objectForKey:@"mobileNumber" ];
    if(mob)
    {
        mob = [mob stringByReplacingOccurrencesOfString:@"+" withString:@""];
        mobileNumberTF.text=mob;
        
      //  if([mobileNumberTF.text containsString:@"+"])
        {
            if([mob containsString:@"-"])
            {
                cCode=[[mob componentsSeparatedByString:@"-"] objectAtIndex:0];
                
                
                if([[mobileNumberTF.text componentsSeparatedByString:@"-"] count]>1)
                {
                    mobileNumberTF.text=[[mobileNumberTF.text componentsSeparatedByString:@"-"] objectAtIndex:1];
                }
            }
        }
    }
    [countryCodeBTN setTitle:[NSString stringWithFormat:@"+%@",cCode] forState:UIControlStateNormal];

    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
    NSString *resultString = [[cCode componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        NSArray *ar =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"telephone_code == %@",resultString]];
        if (ar&&ar.count>0) {
            currentIndex = (int)[_dataRows indexOfObject:[ar firstObject]];
        }
    {
        if (countryTF.text>0) {
            NSArray *ar1 =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"country_name == [cd] %@",countryTF.text]];
            if (ar1&&ar1.count>0) {
                selectedNationality = (int)[_dataRows indexOfObject:[ar1 firstObject]];
            }
            else{
                NSArray *ar11 =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"country_code == [cd] %@",countryTF.text]];
                if (ar11&&ar11.count>0) {
                    selectedNationality = (int)[_dataRows indexOfObject:[ar11 firstObject]];
                }
            }

        }

        
    }

    
    
    
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail" ])
        emailTF.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail" ];
    emailTF.enabled = FALSE;
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userName" ])
        firstNameTF.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"userName" ];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userImage" ])
    {
        NSString*imgName=[[NSUserDefaults standardUserDefaults]objectForKey:@"userImage" ];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [profilePic sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"avatarimage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                profilePic.contentMode = UIViewContentModeScaleAspectFill;

            }
            else
            {
                profilePic.contentMode = UIViewContentModeCenter;

            }
        }];
    }
else
{
    profilePic.image = [UIImage imageNamed:@"avatarimage"];
    profilePic.contentMode = UIViewContentModeCenter;

}
    
    _imgFlag.image = [self getCountryImageForNumber:[NSNumber numberWithInt:[cCode intValue]]];

    
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
-(IBAction)saveProfileFunction:(id)sender
{
  if(firstNameTF.text.length!=0 && lastNameTF.text.length!=0 && mobileNumberTF.text.length!=0 && emailTF.text!=0 && cityNameTF.text.length!=0 && countryTF.text.length!=0)
  {
      
      if([self validateEmailWithString:emailTF.text])
      {
          
          if(mobileNumberTF.text.length>=8)
          {
              BOOL chk=YES;
              if([[self.countryCode titleLabel].text isEqualToString:@"+971"])
              {
                  if(mobileNumberTF.text.length==9)
                  {
                      
                  }
                  else
                  {
//                      UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                      MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
//                      vc.imageName=@"Warning";
//                      vc.messageString=@"Enter a valid mobile number";
//                      vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
//                      [self.view addSubview:vc.view];
//                      chk=NO;
                  }
              }
              
              if(chk)
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
          
          
      //    "user_id:5b8fa195aa96e368af8ec99d
//      firstname:Saleesh
//      lastname:Prakash
//      mobile:9946070864
//      email:saleeshprakash@gmail.com
//      city:city
//      country:india
//      image:"
          [reqData setObject:emailTF.text forKey:@"email"];
          [reqData setObject:[NSString stringWithFormat:@"%@ %@",firstNameTF.text,lastNameTF.text] forKey:@"name"];
         [reqData setObject:[NSString stringWithFormat:@"%@-%@",cCode,mobileNumberTF.text] forKey:@"mobile"];
            [reqData setObject:cityNameTF.text forKey:@"city"];
            [reqData setObject:countryTF.text forKey:@"country"];
                  if (isImageChanged) {
                      imageData = UIImageJPEGRepresentation( profilePic.image, 0.2);

                        [reqData setObject:imageData forKey:@"image"];

                  }
//             [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];
          [self.view endEditing:YES];
          
          RequestUtil *util = [[RequestUtil alloc]init];
          util.webDataDelegate=(id)self;
           //       [util sendRequestWithAuthToken:reqData toUrl:[NSString stringWithFormat: @"users/editprofile"]];
                  
      [util postMultipartRequestWithToken:reqData toUrl:[NSString stringWithFormat: @"users/editprofile"]];
              }
          }else{
              UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
              MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
              vc.imageName=@"Warning";
              vc.messageString=@"Mobile must contain at least 8 digits";
              vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
              [self.view addSubview:vc.view];
          }
      }else{
          UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
          MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
          vc.imageName=@"Warning";
          vc.messageString=@"Enter a valid email";
          vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
          [self.view addSubview:vc.view];
      }
  }
    else
    {
        
        if(firstNameTF.text.length==0)
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"First name is required";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }else if(lastNameTF.text.length==0 )
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Last name is required";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }else if( emailTF.text.length==0)
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Email is required";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }else if(![self validateEmailWithString:emailTF.text])
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Enter a valid email";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }else if( mobileNumberTF.text.length==0 )
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Mobile is required";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }else if(cityNameTF.text.length==0 )
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"City is required";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }else if( countryTF.text.length==0)
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Country name is required";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
            
        
        
    }
};

-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    
    [hud hideAnimated:YES afterDelay:0];
    if(![[rawData objectForKey:@"status"] isEqualToString:@"Failed"])
        
    {
        if([rawData objectForKey:@"data"])
        {
            NSDictionary *user = [Commons dictionaryByReplacingNullsWithStrings:[rawData objectForKey:@"data"]];
            
            [[NSUserDefaults standardUserDefaults]setObject:user forKey:@"userDetails"];
//            [[NSUserDefaults standardUserDefaults]setObject:[rawData objectForKey:@"token"] forKey:@"token" ];
            NSString *fname =@"";
            NSString *lname =  @"";
             if(firstNameTF.text)
                 
                 fname = firstNameTF.text;
            if(lastNameTF.text)
                
                lname = lastNameTF.text;
            if (cityNameTF.text) {
                [[NSUserDefaults standardUserDefaults]setObject:cityNameTF.text forKey:@"cityName"];

            }
            if (countryTF.text) {
                [[NSUserDefaults standardUserDefaults]setObject:countryTF.text forKey:@"nationalityName"];

            }

//            [[NSUserDefaults standardUserDefaults]setObject:lname forKey:@"lastName" ];
//            [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"email"] forKey:@"userEmail" ];
//            [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"country"] forKey:@"countryName" ];
//            [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"_id"] forKey:@"userID" ];
//            [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"mobile"] forKey:@"mobileNumber"];
//            [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"gender"] forKey:@"gender"];
//            if ([user objectForKey:@"image"]) {
//                [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"image"] forKey:@"userImage"];
//
//            }
//            if ([user objectForKey:@"city"]) {
//                [[NSUserDefaults standardUserDefaults]setObject:[user objectForKey:@"city"] forKey:@"cityName"];
//
//            }
    //        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@-%@",_lblCountryCode.text,_txtPhoneNumer.text] forKey:@"mobileNumber" ];
            
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [[NSUserDefaults standardUserDefaults]setObject:fname forKey:@"userName" ];

            if([user objectForKey:@"country"])
            [[NSUserDefaults standardUserDefaults]setObject:[user valueForKey:@"country"] forKey:@"nationalityName"];
            
            if([user objectForKey:@"city"])

            [[NSUserDefaults standardUserDefaults]setObject:[user valueForKey:@"city"] forKey:@"cityName"];
            
            if([user objectForKey:@"email"])

            [[NSUserDefaults standardUserDefaults]setObject:[user valueForKey:@"email"] forKey:@"userEmail"];
            
//            if([user objectForKey:@"last_name"])
//
            [[NSUserDefaults standardUserDefaults]setObject:lname forKey:@"lastName"];
            
            if([user objectForKey:@"mobile"])

                        [[NSUserDefaults standardUserDefaults]setObject:[user valueForKey:@"mobile"] forKey:@"mobileNumber"];
            
            if([user objectForKey:@"image"])

            [[NSUserDefaults standardUserDefaults]setObject:[user valueForKey:@"image"] forKey:@"userImage"];
            
//            if([user objectForKey:@"name"])
//
//             [[NSUserDefaults standardUserDefaults]setObject:[user valueForKey:@"name"] forKey:@"userName"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Succses";
            vc.messageString=@"Your Profile Has Been Updated!";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            [countryCodeBTN setTitle:[NSString stringWithFormat:@"+%@",cCode] forState:UIControlStateNormal];

            
        }
        else
            
        {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Succses";
        vc.messageString=@"Your Password Has Been Updated!";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            newPasswordTF.text = @"";
            oldPasswordTF.text = @"";
        [self.view addSubview:vc.view];
        }
       // [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];
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
-(void)viewDidAppear:(BOOL)animated
{
    bgScrollView.contentSize=CGSizeMake(0, passwordView.frame.size.height+passwordView.frame.origin.y+20);
}
-(IBAction)proPicFunction:(id)sender
{

 
    NSString *call, *message,*report,*block,*copy,*cancel,*options;
            call=@"From Camera";
            message=@"From Gallery";
            cancel=@"Cancel";
            options=@"Options";
    
        UIAlertController *actnSheet=[UIAlertController alertControllerWithTitle:options message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actnSheet addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction*action){
            
        }]];
        [actnSheet addAction:[UIAlertAction actionWithTitle:call style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
            [self camAction];
            
        }]];
        [actnSheet addAction:[UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self galleryAction];
            
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
   
    
};
-(void)camAction{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)galleryAction{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // output image
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
   
    imageData = UIImageJPEGRepresentation( chosenImage, 0.2);

    [picker dismissViewControllerAnimated:YES completion:nil];
    profilePic.image=[UIImage imageWithData:imageData];
    isImageChanged = TRUE;
   // imageData = UIImageJPEGRepresentation( profilePic.image, 0.2);

   // [self sendImageToServer];
    
}
-(IBAction)savePasswordFunction:(id)sender
{
    if(newPasswordTF.text.length!=0 )
    {
        if(newPasswordTF.text.length<6)
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"New Password must contain at least 6 characters";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }else  if([newPasswordTF.text isEqualToString:oldPasswordTF.text])
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
            [reqData setObject:newPasswordTF.text forKey:@"newpassword"];
          //  [reqData setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] forKey:@"user_id"];

            
            [self.view endEditing:YES];
            
            RequestUtil *util = [[RequestUtil alloc]init];
            util.webDataDelegate=(id)self;
            
            [util sendRequestWithAuthToken:reqData toUrl:[NSString stringWithFormat: @"users/change-password"]];
        }else{
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"New Password & Confirm Password should match";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
    }
    else
    {
        
        if(newPasswordTF.text.length==0)
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"New Password is required";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }else if(oldPasswordTF.text.length==0 )
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Confirm Password is required";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
        
        
        
    }
};
-(IBAction)backFunction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
};
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==countryTF)
    {
        [self.view endEditing:YES];
        [self selectNationality:nil];
        return NO;
    }
    [self done:nil];
    return YES;
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component
{
    
        return nationalityArray.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   
        return [NSString stringWithFormat:@"%@",[nationalityArray objectAtIndex:row]];
    
}


- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
   
        countryTF.text=[NSString stringWithFormat:@"%@",[nationalityArray objectAtIndex:row]];
    
}

- (IBAction)done:(id)sender
{
    pickerVieww.hidden=YES;
    doneView.hidden=YES;
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
        cCode = resultString;
        selectedCountryCode = [NSNumber numberWithInteger:[resultString integerValue]];
        NSArray *ar =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"telephone_code == %@",resultString]];
        if (ar&&ar.count>0) {
            currentIndex = (int)[_dataRows indexOfObject:[ar firstObject]];
        }
        else{
            currentIndex = 0;
            
        }
        
    }
    [self settingTheCodeAndCountry];
}
- (UIImage *)getCountryImageForNumber:(NSNumber *)countryCode
{
    

    NSArray *regionCodeArray = [NBMetadataHelper regionCodeFromCountryCode:countryCode];
    NSString *regionCode = [regionCodeArray objectAtIndex:0];
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[regionCode lowercaseString]]];
}
-(void)settingTheCodeAndCountry{
    if (!isNationalitySelcted) {

        [countryCodeBTN setTitle:[NSString stringWithFormat:@"+%@",cCode] forState:UIControlStateNormal];
        _imgFlag.image = [self getCountryImageForNumber:[NSNumber numberWithInt:[cCode intValue]]];

      //  countryTF.text = [NSString stringWithFormat:@"+%@",selectedCountryCode];

    }
    else
    {
        countryTF.text = [_dataRows objectAtIndex:selectedNationality][@"country_name"];
    }
    //
}

-(IBAction)selectCountry:(id)sender
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
-(IBAction)countryCodeFunction:(id)sender
{
    
    isNationalitySelcted = FALSE;
    [self selectCountry:nil];
}
- (IBAction)selectNationality:(id)sender
{
    isNationalitySelcted = TRUE;
    [self selectCountry:nil];
    return;
 
    ststusCountry=YES;

    
    [self.view endEditing:YES];
    
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    
    CountryListViewController *vc = [y   instantiateViewControllerWithIdentifier:@"CountryListViewController"];
    
    vc.delegate=self;
    if(cCode.length==0)
        vc.existingMobileNumber=@"+971-1234";
    else
        vc.existingMobileNumber=  [cCode stringByAppendingString:@"-"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    //    doneView.hidden=NO;
    //    pickerVieww.hidden=NO;
    //    pickerVieww.dataSource=self;
    //    pickerVieww.delegate=self;
    //    [UIView animateWithDuration:0.5f
    //                          delay:0
    //                        options:UIViewAnimationOptionCurveEaseIn
    //                     animations:^{
    //                         //[bgScrollView setContentOffset:CGPointMake(0, 500)];
    //
    //                     }
    //                     completion:nil];
}
-(void)countryFunctionByString:(NSString*)countryString value:(NSString*)countryCode
{
    if(ststusCountry)
        countryTF.text=countryString;
    else
    {
        cCode=countryCode;
        
        [countryCodeBTN setTitle:countryCode forState:UIControlStateNormal];
    }
//    [self. setTitle:countryCode forState:UIControlStateNormal];
}


-(IBAction)countryCodeFunctionCode:(id)sender
{
    [self countryCodeFunction:nil];
    return;
    ststusCountry=NO;
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CountryListViewController *vc = [y   instantiateViewControllerWithIdentifier:@"CountryListViewController"];
    vc.delegate=self;
    if(cCode.length==0)
        vc.existingMobileNumber=@"+971-1234";
    else
        vc.existingMobileNumber=  [cCode stringByAppendingString:@"-"];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
@end
