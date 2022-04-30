//
//  BookingConfirmationNewViewController.m
//  Stayhopper
//
//  Created by antony on 21/11/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "BookingConfirmationNewViewController.h"
#import "URLConstants.h"
#import "RequestUtil.h"
#import "MessageViewController.h"
#import "CountryListDataSource.h"
#import "MBProgressHUD.h"
#import "CircleProgressBar.h"
#import "UIImageView+WebCache.h"
#import "CountrySelectionVC.h"
#import "NBMetadataHelper.h"
#import <WebKit/WebKit.h>
#import "BookingDetailsNewViewController.h"
#import "LoginViewController.h"
#import "TERMSWEBViewController.h"
#import "Stayhopper-Swift.h"
@import Firebase;



@interface BookingConfirmationNewViewController ()
{
    NSArray *nationalityArray;
    NSNumber *selectedCountryCode;
    int selectedNationality;
    BOOL isNationalitySelcted;
    int currentIndex;
    BOOL isImageChanged;
    MBProgressHUD *hud;
    NSString* cCode;
    NSString* selectedTitle;
    NSString *promocode,*promDiscount;
    WKWebView *webView;
    NSString *hotelImageURl;
    NSString *book_id;
    BOOL isArrowAnimationHappening;
    BOOL oneTimeForPreview;
    float previewContainerHeight;
    NSString *selectedFavId;
    float convinienceFee,totalAmount,vatamount,tourismFee,MuncipalityFee,serviceCharge,nowyoupayAmount,atHotelPayAmount,payableAmount;
    NSString *currencyString;
}
@property (weak, nonatomic) IBOutlet UIButton *btnApplyPromo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDiscountHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxestitleBototm;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxestitleTop;
@property (weak, nonatomic) IBOutlet UIButton *btnPayLater;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintNowPayHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewConveneienceFree;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewRoom;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewNowAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewHotelPayAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewBottomVatContents;
@property (weak, nonatomic) IBOutlet UILabel *lblPreviewDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblHoursss;

@property (weak, nonatomic) IBOutlet UILabel *lblPreviewTimeTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnArrow;
@property (weak, nonatomic) IBOutlet CircleProgressBar *progressCircle;
@property (weak, nonatomic) IBOutlet UIImageView *imgHotelImage;
@property (weak, nonatomic) IBOutlet UILabel *lblHotelName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblProgress;

@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPaytmentAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblGuestCount;

@property (weak, nonatomic) IBOutlet UIView *viewPricePreview;


@property (weak, nonatomic) IBOutlet UIButton *btnAcceptRules;
@property (weak, nonatomic) IBOutlet UIButton *btnPayNow;
@property (weak, nonatomic) IBOutlet UIButton *btnSendBestDeals;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMr;
@property (strong, nonatomic) NSArray *dataRows;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UIButton *btnSavingsInfo;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEMail;

@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtPromCOde;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIImageView *imgCountry;


@property (weak, nonatomic) IBOutlet UILabel *lblSavings;
@property (weak, nonatomic) IBOutlet UILabel *lblAED;
@property (strong, nonatomic) IBOutlet UIButton* favoriteButton;
@property (strong, nonatomic) IBOutlet UILabel* priceLBL;
@property (strong, nonatomic) IBOutlet UILabel* userReviewLBL;
@property (strong, nonatomic) IBOutlet UILabel* userReviewLBLValue;

@property (strong, nonatomic) IBOutlet UILabel* userRatingValueLBL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPreviewBottomContainerBotom;
@property (weak, nonatomic) IBOutlet UIView *viewPreviewBottomCont;
@property (weak, nonatomic) IBOutlet UILabel *lblAcceptTheRules;

@property (weak, nonatomic) IBOutlet UIView *viewCardShadow;


@end

@implementation BookingConfirmationNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  /*  _lblAcceptTheRules.userInteractionEnabled = TRUE;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionRules:)];
    [recognizer setNumberOfTapsRequired:1];
   
   _lblAcceptTheRules.userInteractionEnabled = YES;
   [_lblAcceptTheRules addGestureRecognizer:recognizer];
*/
    
//    NSRange range = [[_lblAcceptTheRules.attributedText string] rangeOfString:@"rules"];
//    self.lblAcceptTheRules.selectedRange = range;
//    UITextRange *textRange = [self.textView selectedTextRange];
//    CGRect textRect = [self.textView firstRectForRange:textRange];
//    CGRect convertedRect = [self.view convertRect:textRect fromView:self.textView];

//    UIButton *button = [[UIButton alloc]initWithFrame:convertedRect];
//    [button setBackgroundColor:[UIColor clearColor]];
//    [button addTarget:self action:@selector(textTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];

    

    [self loadDefaultvalues];
    promocode = @"";
    _lblHoursss.layer.cornerRadius = 5.;
    
    _imgHotelImage.superview.layer.cornerRadius = 6;
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    self.view.backgroundColor = kColorCommonBG;
    
    _btnCancel.superview.layer.shadowOffset = CGSizeMake(0, -2);
    _btnCancel.superview.layer.shadowOpacity = 0.3;
    _btnCancel.superview.layer.shadowRadius = 2.0;
    _btnCancel.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    [Commons paddingtoTextField:_txtFirstname];
    [Commons paddingtoTextField:_txtLastName];
    [Commons paddingtoTextField:_txtEMail];
    [Commons paddingtoTextField:_txtCountry];
    [Commons paddingtoTextField:_txtPromCOde];
    [Commons paddingtoTextField:_txtCity];

    int numberOfrooms  = [[[_selectedRooms allValues] valueForKeyPath:@"@sum.self"] intValue];
    _lblGuestCount.text  = [NSString stringWithFormat:@"%d Rooms %@ Adults",numberOfrooms,_selectedDetails[@"numberAdults"]];//CJC 7
    
    
    
    NSDate *chekindt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",_selectedDetails[@"checkinDate"],_selectedDetails[@"checkinTime"]] Format:@"dd/MM/yyyy HH:mm"];
    NSDate *chekoutdt = [Commons getDateFromString:[NSString stringWithFormat:@"%@ %@",_selectedDetails[@"checkoutDate"],_selectedDetails[@"checkoutTime"]] Format:@"dd/MM/yyyy HH:mm"];
    
 //   datestr=[NSString stringWithFormat:@"%@",[Commons stringFromDate:chekindt Format:@"MMM dd, yyyy hh:mm"]];

 
    NSTimeInterval secondsBetween = [chekoutdt timeIntervalSinceDate:chekindt];
    //monthly paynow
    //hourly paylater
   
    if ([_selectedDetails[@"bookingType"] isEqualToString:@"hourly"]) {
        float hrs = (float)secondsBetween / (60.*60.);
 
        if (hrs==24.) {
            _lblPreviewTimeTitle.text = @"Total days";
            _lblPreviewTime.text = [NSString stringWithFormat:@"%@ day",@1];

        }
        else if (hrs>24.0) {
            _lblPreviewTimeTitle.text = @"Total days";
            float remsec = (float)secondsBetween - 60.*60*24.*(int)(hrs/24);
            float hrsnew = (float)remsec / (60.*60.);

            _lblPreviewTime.text = [NSString stringWithFormat:@"%d days, %0.1f hours",(int)hrs/24,hrsnew];

        }
        else{
            _lblPreviewTimeTitle.text = @"Total hours";
            _lblPreviewTime.text = [NSString stringWithFormat:@"%0.1f hours",hrs];

        }
        
        [self selectPaymentOption:_btnPayLater];//CJC 1

    }
    else{
        int numberOfDays = secondsBetween / 86400;
        _lblPreviewTimeTitle.text = @"Total days";

        _lblPreviewTime.text = [NSString stringWithFormat:@"%d days",numberOfDays];

        [self selectPaymentOption:_btnPayLater];

    }
    
 
    NSString *datestr;
//    datestr=[NSString stringWithFormat:@"%@",[Commons stringFromDate:chekindt Format:@"MMM dd, yyyy hh:mm a"]];
    
    //CJC checkout date added. 

   datestr =[NSString stringWithFormat:@"%@ - %@",[Commons stringFromDate:chekindt Format:@"MMM dd hh:mm a"],[Commons stringFromDate:chekoutdt Format:@"MMM dd hh:mm a"]];

    
    _lblDateTime.text  =datestr;//CJC 7
        
    _txtFirstname.layer.cornerRadius = 6.;
    _txtLastName.layer.cornerRadius = _txtFirstname.layer.cornerRadius;
    _txtEMail.layer.cornerRadius = _txtFirstname.layer.cornerRadius;
    _txtLastName.layer.cornerRadius = _txtFirstname.layer.cornerRadius;
    _txtCountry.layer.cornerRadius = _txtFirstname.layer.cornerRadius;
    _txtPromCOde.layer.cornerRadius = _txtFirstname.layer.cornerRadius;
    
    _txtCity.layer.cornerRadius = _txtFirstname.layer.cornerRadius;
    _txtPhoneNumber.superview.layer.cornerRadius = _txtFirstname.layer.cornerRadius;

    cCode=@"971";
    currentIndex = -1;
    selectedNationality = -1;
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];

    
     if([[NSUserDefaults standardUserDefaults]objectForKey:@"cityName" ])
         _txtCity.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"cityName" ];
     if([[NSUserDefaults standardUserDefaults]objectForKey:@"countryName" ])
         _txtCountry.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"countryName" ];
  
  
     if([[NSUserDefaults standardUserDefaults]objectForKey:@"lastName" ])
         _txtLastName.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"lastName" ];
     
     //    [[NSUserDefaults standardUserDefaults]setObject:lastNameTF.text forKey:@"lastName"];
     NSString *mob=[[NSUserDefaults standardUserDefaults]objectForKey:@"mobileNumber" ];
     if(mob)
     {
         mob = [mob stringByReplacingOccurrencesOfString:@"+" withString:@""];
         _txtPhoneNumber.text=mob;
         
       //  if([mobileNumberTF.text containsString:@"+"])
         {
             if([mob containsString:@"-"])
             {
                 cCode=[[mob componentsSeparatedByString:@"-"] objectAtIndex:0];
                 
                 
                 if([[_txtPhoneNumber.text componentsSeparatedByString:@"-"] count]>1)
                 {
                     _txtPhoneNumber.text=[[_txtPhoneNumber.text componentsSeparatedByString:@"-"] objectAtIndex:1];
                 }
             }
         }
     }
    _lblCountryCode.text = [NSString stringWithFormat:@"+%@",cCode];
 
     NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
     NSString *resultString = [[cCode componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
         NSArray *ar =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"telephone_code == %@",resultString]];
         if (ar&&ar.count>0) {
             currentIndex = (int)[_dataRows indexOfObject:[ar firstObject]];
         }
     {
         if (_txtCountry.text>0) {
             NSArray *ar1 =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"country_name == [cd] %@",_txtCountry.text]];
             if (ar1&&ar1.count>0) {
                 selectedNationality = (int)[_dataRows indexOfObject:[ar1 firstObject]];
             }
             else{
                 NSArray *ar11 =  [_dataRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"country_code == [cd] %@",_txtCountry.text]];
                 if (ar11&&ar11.count>0) {
                     selectedNationality = (int)[_dataRows indexOfObject:[ar11 firstObject]];
                 }
             }

         }

         
     }

     
     
     
     
     
     if([[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail" ])
         _txtEMail.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"userEmail" ];
   //  emailTF.enabled = FALSE;
     
     if([[NSUserDefaults standardUserDefaults]objectForKey:@"userName" ])
         _txtFirstname.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"userName" ];
    
    
    // Do any additional setup after loading the view.
    [self titleSelectionAction:_btnMr];
   
    [self populatingHotelDetails:_selectedHotel];
    _imgCountry.image = [self getCountryImageForNumber:[NSNumber numberWithInt:[cCode intValue]]];
    _favoriteButton.selected = [Commons checkFavorites:_selectedHotel[@"_id"]];
    
    _lblHotelName.superview.clipsToBounds = TRUE;
    _lblHotelName.superview.layer.masksToBounds = TRUE;
    _lblHotelName.superview.layer.cornerRadius = 10.;
    _viewCardShadow.backgroundColor = [UIColor whiteColor];
    _viewCardShadow.clipsToBounds = TRUE;
    _viewCardShadow.layer.masksToBounds = FALSE;

    _viewCardShadow.layer.cornerRadius =  _lblHotelName.superview.layer.cornerRadius;
    _viewCardShadow.layer.shadowOffset = CGSizeMake(0, 2);
    _viewCardShadow.layer.shadowOpacity = 0.3;
    _viewCardShadow.layer.shadowRadius = 2.0;
    _viewCardShadow.layer.shadowColor = [UIColor grayColor].CGColor;

}
- (IBAction)rulesButtonCLikd:(id)sender {
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    
    TERMSWEBViewController *vc = [y   instantiateViewControllerWithIdentifier:@"TERMSWEBViewController"];
    vc.WEBSTRING=@"https://stayhopper.com/terms.html#noheader";
    vc.titleString = @"Terms & conditions";

    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:TRUE completion:^{
         
    }];
}
-(void)tapActionRules:(UITapGestureRecognizer*)sender
{
    return;
    if ([sender didTapAttributedTextInLabelWithLabel:_lblAcceptTheRules inRange:[[_lblAcceptTheRules.attributedText string] rangeOfString:@"rules"]]) {
       
    }
//    if ([sender tap]) {
//        <#statements#>
//    }
}
- (void)viewDidAppear:(BOOL)animated
{
    
}
- (IBAction)savingsInfoClikd:(id)sender {
    [Commons showAlertWithMessage:[NSString stringWithFormat:@"You are saving AED %@ from the market price",_btnSavingsInfo.restorationIdentifier]];

}
-(void)populatingHotelDetails:(NSDictionary*)item
{
    _lblAddress.text=@"";
    _userReviewLBL.text=@"";
    _userRatingValueLBL.text=@"";
    hotelImageURl = @"";
    _imgHotelImage.image = [UIImage imageNamed:@"QOMPlaceholder1"];
    if([item objectForKey:@"images"])
    {
        
        if([[item objectForKey:@"images"] count]>0)
        {
    NSString*imgName=[[item objectForKey:@"images"]objectAtIndex:0];
            hotelImageURl = imgName;
    NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,hotelImageURl]];
    [_imgHotelImage sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
        }
    }
    if([[item objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
    {
        _userRatingValueLBL.text=[NSString stringWithFormat:@"%@",[[item objectForKey:@"rating"] objectForKey:@"value"] ];

//        _propertyRatingImageview.image=[UIImage imageNamed:[utilObj checkRating:[[item objectForKey:@"rating"] objectForKey:@"value"] ]];
    }

    
    if([item objectForKey:@"userRating"])
    {
        _userReviewLBLValue.text=[NSString stringWithFormat:@"%0.2f",[[item  valueForKey:@"userRating"] floatValue] ];

//        _userRatingValueLBL.text=[NSString stringWithFormat:@"%@",[item  valueForKey:@"userRating"] ];
    }
    
    if([_userReviewLBLValue.text floatValue]<=0)
    {
        _userReviewLBL.text=@"No Review";
        
        //CJC 12
        _userReviewLBLValue.hidden = YES;
        _userReviewLBL.hidden = YES;
        /**/
        
    }else{
        _userReviewLBLValue.hidden = NO;
        _userReviewLBL.hidden = NO;
    }
        
    if([_userReviewLBLValue.text floatValue]<=2.0)
    {
        _userReviewLBL.text=@"Poor";
    }
    else if([_userReviewLBLValue.text floatValue]<=4.0)
    {
        _userReviewLBL.text=@"Average";
    }
    else if([_userReviewLBLValue.text floatValue]<=6.0)
    {
        _userReviewLBL.text=@"Good";
    }else if([_userReviewLBLValue.text floatValue]<8.0)
    {
        _userReviewLBL.text=@"Very Good";
    }
    else
        _userReviewLBL.text=@"Excellent";

    _userRatingValueLBL.superview.layer.cornerRadius= 2.5;
    _userReviewLBLValue.layer.cornerRadius= 2.5;
    
    if (_userReviewLBLValue.text.length>0) {
        NSString *hrlbl = _userReviewLBLValue.text;
        
        hrlbl = [NSString stringWithFormat:@" %@.",hrlbl];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:_userReviewLBLValue.textColor,NSFontAttributeName:_userReviewLBLValue.font}];

        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
        _userReviewLBLValue.attributedText = attr;
        _userReviewLBLValue.backgroundColor = [UIColor colorWithRed:0.757 green:0.784 blue:0.859 alpha:0.3];
        _userReviewLBLValue.clipsToBounds = TRUE;
        _userReviewLBLValue.layer.cornerRadius = 2.;
        
    }
    
    
  
    if([item objectForKey:@"location"]&&[item objectForKey:@"location"][@"address"])
    {
        _lblAddress.text = [item objectForKey:@"location"][@"address"];

    }
    else if([item objectForKey:@"contactinfo"])
    {

        if([[item objectForKey:@"contactinfo"] objectForKey:@"city"])
        {
            if([[item objectForKey:@"contactinfo"] objectForKey:@"city"][@"name"])

                _lblAddress.text=[[item objectForKey:@"contactinfo"] valueForKey:@"city"][@"name"];
        }
        else if([[item objectForKey:@"contactinfo"] objectForKey:@"country"])
        {
            if([[item objectForKey:@"contactinfo"] objectForKey:@"country"][@"name"])

                _lblAddress.text=[[item objectForKey:@"contactinfo"] valueForKey:@"country"][@"name"];
        }
        
    }
    else
        _lblAddress.text=@"";
    if([item objectForKey:@"name"])
    _lblHotelName.text=[item valueForKey:@"name"];
    else
        _lblHotelName.text=@"";
  NSString  *price = [NSString stringWithFormat:@"%@",[item objectForKey:@"priceSummary"][@"base"][@"amount"]];
    _priceLBL.text = price;
    NSString *savings = [NSString stringWithFormat:@"%@",[item objectForKey:@"priceSummary"][@"base"][@"savings"]];
    if (!savings || savings.length==0) {
        savings = @"0";
    }
    int tot = [savings intValue]+[price intValue];
    NSString *total = [NSString stringWithFormat:@"%d",tot];
    if ([savings intValue]==0) {
        _lblSavings.superview.hidden = TRUE;

    }
    else {
    _lblSavings.superview.hidden = FALSE;
    }
    _lblSavings.text = [NSString stringWithFormat:@"Saving AED %@",savings];
    _btnSavingsInfo.restorationIdentifier = savings;
    if (_lblSavings.superview.hidden) {
        _lblAED.text = @"AED";

    }
    else{
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"AED %@ ",total]];
        
                                        //  [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0] range:NSMakeRange(0, 3)];
        

        [str1 addAttribute:NSFontAttributeName value:_lblAED.font range:NSMakeRange(0, str1.length)];
            [str1 addAttribute:NSForegroundColorAttributeName value:_userReviewLBL.textColor range:NSMakeRange(0, str1.length)];
            
        [str1 addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:2] range:NSMakeRange(str1.length-total.length, total.length)];

        _lblAED.attributedText = str1;
    }
    _lblAED.textColor =  _userReviewLBL.textColor;
    _lblAED.hidden = FALSE;

 }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
     }
     [self settingTheCodeAndCountry];
 }
- (IBAction)arrowbtnClikd:(id)sender {
    if (isArrowAnimationHappening) {
        return;
    }
    isArrowAnimationHappening = TRUE;
    float botConst = 0.;
    float newAlpha = 0.;
    if (_viewPricePreview.hidden) {
        _viewPricePreview.hidden = FALSE;
        _viewPricePreview.alpha = 0.0;
        newAlpha =1.0;
        _constraintPreviewBottomContainerBotom.constant = -1*_viewPreviewBottomCont.frame.size.height;
    }
    else{
        _viewPricePreview.alpha = 1.0;
        newAlpha = 0.0;
        _constraintPreviewBottomContainerBotom.constant = 0;

        botConst = -1*_viewPreviewBottomCont.frame.size.height;
    }
    [self.view layoutIfNeeded];

       [UIView animateWithDuration:0.3
           animations:^{
           _constraintPreviewBottomContainerBotom.constant = botConst;
           _btnArrow.transform = CGAffineTransformRotate(_btnArrow.transform, M_PI);
           _viewPricePreview.alpha = newAlpha;

           [self.view layoutIfNeeded]; // Called on parent view
       } completion:^(BOOL finished) {
           isArrowAnimationHappening = FALSE;
           if (newAlpha==0.0) {
               _viewPricePreview.hidden = TRUE;
           }

            
       }] ;
    
}
-(void)settingTheCodeAndCountry{
     if (!isNationalitySelcted) {

         _lblCountryCode.text = [NSString stringWithFormat:@"+%@",cCode];
         _imgCountry.image = [self getCountryImageForNumber:[NSNumber numberWithInt:[cCode intValue]]];
       //  countryTF.text = [NSString stringWithFormat:@"+%@",selectedCountryCode];

     }
     else
     {
         _txtCountry.text = [_dataRows objectAtIndex:selectedNationality][@"country_name"];
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
  
    
 }


 -(IBAction)countryCodeFunctionCode:(id)sender
 {
     [self countryCodeFunction:nil];
     return;
    
 }

- (IBAction)titleSelectionAction:(UIButton*)sender {
     {
        for (UIButton *btn in sender.superview.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                if (btn.layer.cornerRadius==0.0) {
                    btn.layer.cornerRadius = 6.;
                }
                if (btn == sender) {
                    btn.backgroundColor = _txtFirstname.backgroundColor;
                    [btn setTitleColor:kColorDarkBlueThemeColor forState:UIControlStateNormal];
                }
                else{
                    btn.backgroundColor = UIColorFromRGB(0xd5d5db);
                    [btn setTitleColor:[UIColor colorWithRed:26./255. green:30./255. blue:102./255. alpha:0.5] forState:UIControlStateNormal];
                }
            }
        }
    }
    selectedTitle =sender.restorationIdentifier;

}
- (IBAction)selectPaymentOption:(UIButton*)sender {
    for (UIButton *btn in sender.superview.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {

            {
                if (btn==sender) {
                    btn.selected = TRUE;
                }
                else{
                    btn.selected = FALSE;

                }
            }
            
            
        }
    }
    if (_btnPayNow.isSelected) {
        _constraintNowPayHeight.constant = 0.;
        _lblPreviewNowAmount.superview.hidden = TRUE;
        _lblPreviewHotelPayAmount.superview.hidden = TRUE;
        _lblTaxestitleTop.hidden = FALSE;
    }
    else{
        _constraintNowPayHeight.constant = _lblPreviewTime.superview.frame.size.height;
        _lblPreviewNowAmount.superview.hidden = FALSE;
        _lblPreviewHotelPayAmount.superview.hidden = FALSE;
        _lblTaxestitleTop.hidden = TRUE;

    }
    _lblTaxestitleBototm.hidden = !_lblTaxestitleTop.hidden;

    [self.view layoutIfNeeded];
    [self setPayNowAndPayAthotelwithDiscount];
}
- (IBAction)sendBestdealsAction:(UIButton*)sender {
    sender.selected = !sender.selected;
}
- (IBAction)acceptRulesAction:(UIButton*)sender {
    sender.selected = !sender.selected;

}
- (IBAction)phoneCodeSelectionAction:(id)sender {
    [self countryCodeFunction:nil];

}
- (IBAction)nationalitySelection:(id)sender {
    [self selectNationality:nil];
}
 
- (IBAction)CONTINUEBTNCLIKD:(id)sender {
    NSString *errorMessageString = @"";
    if ([Commons trimWhitespacesAndGivingCorrectString:_txtFirstname.text].length==0) {
        [_txtFirstname becomeFirstResponder];
        errorMessageString = @"First name cannot be empty";
    }
    else if ([Commons trimWhitespacesAndGivingCorrectString:_txtLastName.text].length==0) {
        [_txtLastName becomeFirstResponder];
        errorMessageString = @"Last name cannot be empty";
    }
    else if ([Commons trimWhitespacesAndGivingCorrectString:_txtCountry.text].length==0) {
      //  [_txtFirstname becomeFirstResponder];
        errorMessageString = @"Country cannot be empty";
    }
    else if ([Commons trimWhitespacesAndGivingCorrectString:_txtPhoneNumber.text].length<8) {
        [_txtPhoneNumber becomeFirstResponder];
        errorMessageString = @"Enter a valid phone number";
    }
    else if (![Commons validateEmail:_txtEMail.text]) {
        [_txtFirstname becomeFirstResponder];
        errorMessageString = @"Enter a valid email";
    }
    else if (_btnAcceptRules.selected==FALSE) {
        //[_txtFirstname becomeFirstResponder];
        errorMessageString = @"To proceed you need to accept our terms and conditions";
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
       
        if (errorMessageString.length==0) {
           
            NSString *bookingFee =[NSString stringWithFormat:@"%0.2f",convinienceFee];
            NSString *paymentAmt = [NSString stringWithFormat:@"%0.2f",payableAmount];
            NSString *totalAmt= [NSString stringWithFormat:@"%0.2f",totalAmount];
            NSString *currencyCode = currencyString;
            NSString *trip_type = @"LEISURE";
            NSMutableDictionary *params= [@{@"title":selectedTitle,
                                            @"firstName":_txtFirstname.text,
                                            @"lastName":_txtLastName.text,
                                            @"nationality":_txtCountry.text,
                                            @"city":_txtCity.text,
                                            @"mobile":[NSString stringWithFormat:@"%@-%@",_lblCountryCode.text,_txtPhoneNumber.text],
                                            @"email":_txtEMail.text,
                                            @"property":_selectedDetails[@"property_id"],
                                            @"numberAdults":_selectedDetails[@"numberAdults"],
                                            @"numberChildren":_selectedDetails[@"numberChildren"],
                                            @"checkinDate":_selectedDetails[@"checkinDate"],
                                            @"checkinTime":_selectedDetails[@"checkinTime"],
                                            @"checkoutDate":_selectedDetails[@"checkoutDate"],
                                            @"checkoutTime":_selectedDetails[@"checkoutTime"],
                                            @"bookingType":_selectedDetails[@"bookingType"],
                                            @"bookingFee":bookingFee,
                                            @"paymentAmt":paymentAmt,
                                            @"totalAmt":totalAmt,
                                            @"currencyCode":currencyCode,
                                            
                    } mutableCopy];
            
            
            //CJC 14
            [FIRAnalytics logEventWithName:@"total_amount"
                                parameters:@{
                                             @"amount": totalAmt
                                             }];
            
            
            for (NSString *roomid in [_selectedRooms allKeys]) {
                params[[NSString stringWithFormat:@"room[%@]",roomid]] = _selectedRooms[roomid];
                
            }
            if (promocode.length>0) {
                params[@"promocode"] = promocode;
                params[@"discount"] = promDiscount;
             }
            [self sendWSRequestWithParams:params andUrl:@"bookings"];

             //    [{"key":"promocode","value":"WELCOME","description":"Eg: WELCOME","type":"text"}]
            //    discount
        }
        else{
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=errorMessageString;
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry"
                                                                                 message:@"Kindly login to book the hotel"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Login"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:TRUE completion:^{
               
                dispatch_async(dispatch_get_main_queue(), ^(void){
                     //Run UI Updates
                    
                    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
                    LoginViewController *vc=[storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    vc.fromString=@"presentViewTab";
                    [self.navigationController pushViewController:vc animated:YES];
                 });
                
            }];
            

             
        }]; //You can use a block here to handle a press on this button
        UIAlertAction *actioncanel = [UIAlertAction actionWithTitle:@"Canel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actioncanel];
        [alertController addAction:actionOk];

        
        [self presentViewController:alertController animated:YES completion:nil];

    }
   
}
- (IBAction)favOrUnfavAcrion:(UIButton*)button
{
     {
        
         
         if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]){////CJC 9
             
             selectedFavId =_selectedHotel[@"_id"];//CJC 9
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
        
       
    }
}
- (IBAction)backBtnAction:(id)sender {

    if (webView) {
        
        
        //CJC 14
        [FIRAnalytics logEventWithName:@"Abandoned_checkout"
                            parameters:@{
                                         @"amount": @""
                                         }];
        
        
        webView.navigationDelegate = nil;
        
        [webView removeFromSuperview];
        webView = nil;
        return;
    }
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (UIImage *)getCountryImageForNumber:(NSNumber *)countryCode
{
    

    NSArray *regionCodeArray = [NBMetadataHelper regionCodeFromCountryCode:countryCode];
    NSString *regionCode = [regionCodeArray objectAtIndex:0];
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[regionCode lowercaseString]]];
}
- (IBAction)applyPromoCodeAction:(id)sender {
    if (_txtPromCOde.text.length>0) {
        if (promocode.length>0) {
            _txtPromCOde.text=@"";
            promocode= @"";
            promDiscount =@"";
            _txtPromCOde.enabled = TRUE;//

            [_btnApplyPromo setTitle:@"APPLY" forState:UIControlStateNormal];
            [self setPayNowAndPayAthotelwithDiscount];

        }
        else
        {
         [_btnApplyPromo setTitle:@"REMOVE" forState:UIControlStateNormal];
            _txtPromCOde.enabled = NO;//CJC

        [self sendWSRequestWithParams:@{@"promocode":_txtPromCOde.text} andUrl:@"bookings/checkpromo"];
        
            //CJC 14
            [FIRAnalytics logEventWithName:@"apply_promocode"
                                parameters:@{
                                             @"promocode": _txtPromCOde.text
                                             }];
            
    }
  
}

}
-(void)sendWSRequestWithParams:(NSDictionary*)par andUrl:(NSString*)url
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
    [self.view endEditing:YES];
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
        [util postRequest:par withToken:TRUE toUrl:[NSString stringWithFormat: url] type:@"POST"];
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
 
    if([rawData objectForKey:@"data"])
    {
        if (rawData[@"data"][@"discount"]) {
            {
                
                //CJC 14
                [FIRAnalytics logEventWithName:@"discount"
                                    parameters:@{
                                                 @"amount": rawData[@"data"][@"discount"]
                                                 }];
                
                
                
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Succses";
                vc.messageString=[NSString stringWithFormat:@"Successfully applied the promocode of %@%@",rawData[@"data"][@"discount"],@"%"];
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
                promocode = rawData[@"data"][@"code"];
                promDiscount = rawData[@"data"][@"discount"];
              //  _txtPromCOde.enabled = FALSE;
                [_btnApplyPromo setTitle:@"REMOVE" forState:UIControlStateNormal];
                [self setPayNowAndPayAthotelwithDiscount];

            }
        }
        else
        {
            
        }
     
    }
 
    else if([rawData objectForKey:@"message"])

    {
         if (selectedFavId&&[[[rawData objectForKey:@"message"] lowercaseString] containsString:@"favourites"]) {
                _favoriteButton.selected = !_favoriteButton.selected;
                [Commons addOrRomoveToFavselectedFavId:selectedFavId shouldAdd:_favoriteButton.selected];

                selectedFavId = nil;
                UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
                vc.imageName=@"Succses";
                vc.messageString=[rawData objectForKey:@"message"];
                vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
                [self.view addSubview:vc.view];
                 
            }
        else if ([rawData objectForKey:@"status"] &&[[rawData objectForKey:@"status"] isEqualToString:@"Success"]&&[rawData objectForKey:@"payment_link"]) {
           /* UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Succses";
            vc.messageString=[rawData objectForKey:@"message"];
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];*/
            book_id = [rawData objectForKey:@"book_id"];
            
            
            //This configuration for fit to size
            NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

            WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
            WKUserContentController *wkUController = [[WKUserContentController alloc] init];
            [wkUController addUserScript:wkUScript];

            WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
           wkWebConfig.userContentController = wkUController;

            
            
         //   WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
            float ypos = _lblTitle.superview.frame.size.height+_lblTitle.superview.frame.origin.y+10;
            webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, ypos, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-ypos) configuration:wkWebConfig];
            webView.scrollView.delegate = self;
            webView.navigationDelegate = self;
            webView.backgroundColor = [UIColor whiteColor];
            NSURL *nsurl=[NSURL URLWithString:[rawData objectForKey:@"payment_link"]];
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            

            
            [webView loadRequest:nsrequest];

            [self.view addSubview:webView];
            
        }
        
        else {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
            if ([[[rawData objectForKey:@"message"] lowercaseString] containsString:@"promocode"]) {
                promDiscount =@"";
                promocode = @"";
                [self setPayNowAndPayAthotelwithDiscount];

            }
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
            vc.messageString=@"Some error occured. Please try again";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            }
            [hud hideAnimated:YES afterDelay:0];

        }
    }
    [hud hideAnimated:YES afterDelay:0];

}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.pinchGestureRecognizer.enabled = NO;
}

- (void)userContentController:(WKUserContentController *)userContentController
                        didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *sentData = (NSDictionary *)message.body;
    NSString *messageString = sentData[@"message"];
    NSLog(@"userContentController Message received: %@", messageString);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSURLRequest *request = navigationAction.request;
    NSString *url = [[request URL]absoluteString];
    NSLog(@"decidePolicyForNavigationAction url %@",url);
    if (url&&[[url lowercaseString] containsString:@"success?booking_id="]) {
        webView.navigationDelegate = nil;
        [webView removeFromSuperview];
        
        [self gotoSuccessPage:book_id];
        
    }
    else if (url&&[[url lowercaseString] containsString:@"failed?booking_id="]) {
        webView.navigationDelegate = nil;
        [webView removeFromSuperview];
        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=@"Some error occured. Please try again";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(IBAction)backFunction:(id)sender
{
    [self backBtnAction:nil];
//    [self.navigationController popViewControllerAnimated:YES];
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
    if ([[errorMessage lowercaseString] containsString:@"promocode"])
    {
        //CJC
        _txtPromCOde.text=@"";
        promocode= @"";
        promDiscount =@"";
        _txtPromCOde.enabled = TRUE;//
        [_btnApplyPromo setTitle:@"APPLY" forState:UIControlStateNormal];

        
            [self setPayNowAndPayAthotelwithDiscount];

    }
    [self.view addSubview:vc.view];
    }
}
    -(void)gotoSuccessPage:(NSString*)bookingId
    {
      
          NSString*lat = @"";
          NSString*longt = @"";
    
        if([_selectedHotel objectForKey:@"location"])
              {
                   NSArray *latlong = _selectedHotel[@"location"][@"coordinates"];
                  if ([latlong isKindOfClass:[NSArray class]]&&latlong.count>=2) {
                      lat = latlong[1];
                      longt = latlong[0];

                  }
//                  else{
//                      latlong = [_selectedHotel objectForKey:@"location"][@"coordinates"];
//                     if ([latlong isKindOfClass:[NSArray class]]&&latlong.count>=2) {
//                         lat = latlong[0];
//                         longt = latlong[1];
//
//                     }
//
//                  }
              }
          UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
          BookingDetailsNewViewController *vcDet = [y   instantiateViewControllerWithIdentifier:@"BookingDetailsNewViewController"];
          vcDet.bookingID = bookingId;
           vcDet.hotelName = _lblHotelName.text;
           vcDet.hotelAddress = _lblAddress.text;
           vcDet.guestCount = _lblGuestCount.text;
           vcDet.timeString = _lblDateTime.text;
           vcDet.latitude = lat;
           vcDet.longitude = longt;
           vcDet.imageURL = hotelImageURl;
            vcDet.isForCompletion = TRUE;
           [self.navigationController pushViewController:vcDet animated:TRUE];

    }
-(void)loadDefaultvalues
{
    NSMutableArray *selRoomValues = [[NSMutableArray alloc] init];
    NSString *roomTypeString = @"";
    currencyString =[NSString stringWithFormat:@"%@",_selectedHotel[@"currency"][@"code"]];

    
    NSArray *fullRoomsValues = _selectedHotel[@"rooms"];
    NSArray *selroomIds = [_selectedRooms allKeys];
    convinienceFee = 0.;
    atHotelPayAmount = 0.0;
  
    vatamount = 0.;
    tourismFee= 0.0;
    MuncipalityFee = 0.0;
    serviceCharge = 0.0;
    NSMutableArray *room_type_ar = [[NSMutableArray alloc] init];
    for (NSDictionary *singleroom in fullRoomsValues)
    {
        if ([selroomIds containsObject:singleroom[@"_id"]]) {
            [selRoomValues addObject:singleroom];
          //  if (roomTypeString.length==0)
            {
             //   if (![room_type_ar containsObject:singleroom[@"room_type"][@"name"]])
                {
                    [room_type_ar addObject:singleroom[@"room_type"][@"name"]];

                }
 
            }
            NSDictionary *priceSummary = singleroom[@"priceSummary"];
            float numberOfRoomsselected = [_selectedRooms[singleroom[@"_id"]] floatValue];
            totalAmount = totalAmount+[priceSummary[@"base"][@"amount"] floatValue]*numberOfRoomsselected;
            if ([priceSummary[@"bookingFee"][@"amount"] floatValue]>convinienceFee) {
                convinienceFee = [priceSummary[@"bookingFee"][@"amount"] floatValue];
            }
            atHotelPayAmount = atHotelPayAmount+[priceSummary[@"payAtHotel"][@"amount"] floatValue]*numberOfRoomsselected;
            NSArray *breakdown= priceSummary [@"taxes"][@"breakdown"];
            for (NSDictionary *tax in breakdown) {
                NSString *label = tax[@"label"];
                if ([label containsString:@"VAT"]) {
                    vatamount = vatamount+ numberOfRoomsselected* [tax[@"amount"] floatValue];
                }
                else if ([label containsString:@"Municipality"]) {
                    MuncipalityFee = MuncipalityFee+ numberOfRoomsselected* [tax[@"amount"] floatValue];
                }
                else if ([label containsString:@"Tourism"]) {
                    tourismFee = tourismFee+ numberOfRoomsselected* [tax[@"amount"] floatValue];
                }
                else if ([label containsString:@"Service"]) {
                    serviceCharge = serviceCharge+ numberOfRoomsselected* [tax[@"amount"] floatValue];
                }
            }
            
        }
    }
        
    _lblPreviewPrice.text  = [NSString stringWithFormat:@"%@ %0.2f",currencyString,totalAmount];
    _lblPreviewConveneienceFree.text  = [NSString stringWithFormat:@"%@ %0.2f",currencyString,convinienceFee];
    _lblPreviewTotalAmount.text = [NSString stringWithFormat:@"%@ %0.2f",currencyString,(totalAmount+convinienceFee)];
   // totalAmount =  ;
//    _lblPreviewBottomVatContents.text = [NSString stringWithFormat:@"Excluding VAT %@ %0.2f %@, Tourism fee VAT %@ %0.2f %@, Muncipality fee VAT %@ %0.2f %@, Service charge VAT %@ %0.2f %@",currencyString,vatamount,@"(5%)",currencyString,tourismFee,@"(5%)",currencyString,MuncipalityFee,@"(7%)",currencyString,serviceCharge,@"(10%)"];
    _lblPreviewBottomVatContents.text = [NSString stringWithFormat:@"Excluding VAT %@ %0.2f %@, Tourism fee %@ %0.2f %@, Muncipality fee %@ %0.2f %@, Service charge %@ %0.2f %@",currencyString,vatamount,@"(5%)",currencyString,tourismFee,@"",currencyString,MuncipalityFee,@"(7%)",currencyString,serviceCharge,@"(10%)"];

    _lblPreviewRoom.text =[room_type_ar componentsJoinedByString:@", "];// roomTypeString;
    
    _lblHoursss.text=@"";
               if ([[_selectedHotel objectForKey:@"stayDuration"] isKindOfClass:[NSDictionary class]])
               {
                   _lblHoursss.text = [NSString stringWithFormat:@" %@ ",[_selectedHotel objectForKey:@"stayDuration"][@"label"]];
                   
               }
    else if ([[_selectedHotel objectForKey:@"stayDuration"] isKindOfClass:[NSString class]])
    {
        _lblHoursss.text = [NSString stringWithFormat:@" %@ ",[_selectedHotel objectForKey:@"stayDuration"]];

    }
    NSString *hrlbl = self.lblHoursss.text;
    if (hrlbl.length)
    {
        hrlbl = [NSString stringWithFormat:@".  %@  .",hrlbl];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:hrlbl attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FontMedium size:12]}];

        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, 1)];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} range:NSMakeRange(hrlbl.length-1, 1)];
        self.lblHoursss.attributedText = attr;
        self.lblHoursss.backgroundColor = UIColorFromRGB(0xFF4848);
    }
          
             
    //CJC 14
    
    [FIRAnalytics logEventWithName:@"total_hours"
                        parameters:@{
                                     @"hours": self.lblHoursss.text
                                     }];
    
}
-(void)setPayNowAndPayAthotelwithDiscount
{
    NSString *titleStrr;
    NSString *amountString;
    float amount = totalAmount;

    if (_btnPayNow.isSelected)
    {
        if (promocode.length>0)
        {
            float convAfterdisc = convinienceFee*[promDiscount floatValue]/100.0;
            _lblPreviewDiscount.text = [NSString stringWithFormat:@"-%@ %0.2f",currencyString,convAfterdisc];//CJC
            _constraintDiscountHeight.constant = _lblPreviewPrice.superview.frame.size.height;
            _lblPreviewDiscount.superview.hidden = FALSE;

            convAfterdisc =  convinienceFee -  convinienceFee*[promDiscount floatValue]/100.0;

            amount = amount +convAfterdisc;
        }
       else
       {
           amount = amount+ convinienceFee;
           _constraintDiscountHeight.constant = 0;
           _lblPreviewDiscount.superview.hidden = TRUE;

       }
 
         titleStrr = [NSString stringWithFormat:@"Total %@",currencyString];
         amountString = [NSString stringWithFormat:@"%0.2f",amount];

    }
    else
    {
        
        //CJC 1.1
        if ([_selectedDetails[@"bookingType"] isEqualToString:@"hourly"]) {
            _lblPreviewHotelPayAmount.text = [NSString stringWithFormat:@"%@ %0.2f",currencyString,atHotelPayAmount];
        }else{
            _lblPreviewHotelPayAmount.text = [NSString stringWithFormat:@"Taxes and charges"];
            _lblTaxestitleBototm.hidden = YES;
        }
 
        
        
        if (promocode.length>0)
        {
 
            float convAfterdisc = convinienceFee*[promDiscount floatValue]/100.0;
            _lblPreviewDiscount.text = [NSString stringWithFormat:@"-%@ %0.2f",currencyString,convAfterdisc];//CJC
            _constraintDiscountHeight.constant = _lblPreviewPrice.superview.frame.size.height;
            _lblPreviewDiscount.superview.hidden = FALSE;
            convAfterdisc =  convinienceFee -  convinienceFee*[promDiscount floatValue]/100.0;

            amount = (totalAmount +convAfterdisc-atHotelPayAmount);

          //  amount = amount+ convinienceFee*[promDiscount floatValue]/100.0;
        }
       else
       {
         //  amount = amount+ convinienceFee;
           amount = (totalAmount+convinienceFee-atHotelPayAmount);
           _lblPreviewNowAmount.text = [NSString stringWithFormat:@"%@ %0.2f",currencyString,amount];
           _constraintDiscountHeight.constant = 0;
           _lblPreviewDiscount.superview.hidden = TRUE;
       }
        _lblPreviewNowAmount.text = [NSString stringWithFormat:@"%@ %0.2f",currencyString,amount];

        titleStrr = [NSString stringWithFormat:@"Now you pay %@",currencyString];
        amountString = [NSString stringWithFormat:@"%0.2f",amount];

    }
    payableAmount = amount;

    NSString *completeString = [NSString stringWithFormat:@"%@\n%@",titleStrr,amountString];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:completeString];
    [attr addAttributes:@{NSForegroundColorAttributeName:kColorDarkBlueThemeColor,NSFontAttributeName:[UIFont fontWithName:FontMedium size:20]}
                  range:NSMakeRange(0,completeString.length)];
    [attr addAttributes:@{NSForegroundColorAttributeName:_lblPreviewTimeTitle.textColor,NSFontAttributeName:[UIFont fontWithName:FontRegular size:12]}
                  range:NSMakeRange(0,titleStrr.length)];
    _lblPaytmentAmount.attributedText = attr;
    

    _lblPreviewTotalAmount.text = [NSString stringWithFormat:@"%@ %0.2f",currencyString,(totalAmount+payableAmount)];//CJC 18


}
@end
