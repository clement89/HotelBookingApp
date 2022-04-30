//
//  ReebookingViewController.m
//  Stayhopper
//
//  Created by iROID Technologies on 11/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ReebookingViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "MessageViewController.h"
#import "SearchWithLOcation.h"
#import "AvailabilityViewController.h"
#import "TermsAndConditionsViewController.h"
#import "PaymentViewViewController.h"
#import "BookingCompletedViewController.h"
#import "CountryListViewController.h"
#import "TERMSWEBViewController.h"

@interface ReebookingViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,countryDelegate>
{
    BOOL isForTitle;
    NSArray *nationalityArray,*TitleArray;
}
@end

@implementation ReebookingViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    NSUserDefaults* defaults1 = [NSUserDefaults standardUserDefaults];
    [defaults1 setValue:@"" forKey:@"booking_ID"];
    [defaults1 synchronize];
    discountPercentageLBL.text=@"";
    typeValue=@"Business";
    cCode=@"+971";
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"payStatus"  ];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    promoDiscount=15;
    promoStatus=NO;
    apiStatus=YES;
    doneView.hidden=YES;
    isForTitle=YES;
    _couponView.layer.cornerRadius=0;
    self.couponView.layer.borderWidth=1.0;
    self.couponView.layer.borderColor=grandTotalLBL.textColor.CGColor;
    nationalityArray=[[NSArray alloc]init];
    TitleArray=[[NSArray alloc]init];
    nationalityArray=@[@"Afghanistan",@"Albania",@"Algeria",@"Andorra",@"Angola",@"Anguilla",@"Antigua and Barbuda",@"Argentina",@"Armenia",@"Aruba",@"Australia",@"Austria",@"Azerbaijan",@"Bahamas",@"Bahrain"
                       ,@"Bangladesh",@"Barbados",@"Belgium",@"Belize",@"Benin",@"Bermuda",@"Bhutan",@"Bolivia, Plurinational State of",@"Bosnia and Herzegovina",@"Botswana",@"Brazil",@"Brunei Darussalam",@"Bulgaria",@"Burkina Faso",@"Burundi",@"Cambodia",@"Cameroon",@"Canada",@"Cape Verde",@"Cayman Islands",@"Central African Republic",@"Chad",@"Chile",@"China",@"Colombia",@"Comoros",@"Congo",@"Cook Islands",@"Costa Rica",@"Côte d'Ivoire",@"Croatia",@"Cuba",@"Cyprus",@"Czech Republic",@"Denmark",@"Djibouti",@"Dominica",@"Dominican Republic",@"Ecuador",@"Egypt",@"El Salvador",@"Equatorial Guinea",@"Eritrea",@"Estonia",@"Ethiopia",@"Faroe Islands",@"Falkland Islands (Malvinas)",@"Fiji",@"Finland",@"France",@"French Guiana",@"French Polynesia",@"Gabon"
                       ,@"Gambia"
                       ,@"Georgia"
                       ,@"Germany"
                       ,@"Gibraltar"
                       ,@"Greece"
                       ,@"Greenland"
                       ,@"Grenada"
                       ,@"Guadeloupe"
                       ,@"Guatemala"
                       ,@"Guinea"
                       ,@"Guinea-Bissau"
                       ,@"Guyana"
                       ,@"Haiti"
                       ,@"Honduras"
                       ,@"Hungary"
                       ,@"Iceland"
                       ,@"India"
                       ,@"Iraq"
                       ,@"Ireland"
                       ,@"Israel"
                       ,@"Italy"
                       ,@"Jamaica"
                       ,@"Japan"
                       ,@"Jordan"
                       ,@"Kazakhstan"
                       ,@"Kenya"
                       ,@"Kiribati"
                       ,@"Korea (North Korea)"
                       ,@"Korea (South Korea)"
                       ,@"Kuwait"
                       ,@"Kyrgyzstan"
                       ,@"Lao People's Democratic Republic"
                       ,@"Latvia"
                       ,@"Lebanon"
                       ,@"Lesotho"
                       ,@"Liberia"
                       ,@"Libya"
                       ,@"Liechtenstein"
                       ,@"Lithuania"
                       ,@"Luxembourg"
                       ,@"Malawi"
                       ,@"Malaysia"
                       ,@"Maldives"
                       ,@"Mali"
                       ,@"Marshall Islands"
                       ,@"Martinique"
                       ,@"Mauritania"
                       ,@"Mauritius"
                       ,@"Mexico"
                       ,@"Micronesia, Federated States of"
                       ,@"Mongolia"
                       ,@"Montenegro"
                       ,@"Montserrat"
                       ,@"Morocco"
                       ,@"Myanmar"
                       ,@"Namibia"
                       ,@"Nauru"
                       ,@"Nepal"
                       ,@"Netherlands"
                       ,@"New Zealand"
                       ,@"Nicaragua"
                       ,@"Niger"
                       ,@"Nigeria"
                       ,@"Niue"
                       ,@"Norway"
                       ,@"Oman"
                       ,@"Pakistan"
                       ,@"Palau"
                       ,@"Panama"
                       ,@"Papua New Guinea"
                       ,@"Paraguay"
                       ,@"Peru"
                       ,@"Philippines"
                       ,@"Poland"
                       ,@"Portugal"
                       ,@"Qatar"
                       ,@"Réunion"
                       ,@"Russian Federation"
                       ,@"Rwanda"
                       ,@"Saint Helena, Ascension and Tristan da Cunha"
                       ,@"Saint Kitts and Nevis"
                       ,@"Saint Lucia"
                       ,@"Saint Vincent and the Grenadines"
                       ,@"Samoa"
                       ,@"Saudi Arabia"
                       ,@"Senegal"
                       ,@"Seychelles"
                       ,@"Sierra Leone"
                       ,@"Singapore"
                       ,@"Slovenia"
                       ,@"Solomon Islands"
                       ,@"Somalia"
                       ,@"South Africa"
                       ,@"Spain"
                       ,@"Sri Lanka"
                       ,@"Sudan"
                       ,@"Swaziland"
                       ,@"Sweden"
                       ,@"Switzerland"
                       ,@"Syrian Arab Republic"
                       ,@"Tajikistan"
                       ,@"Thailand"
                       ,@"Timor-Leste"
                       ,@"Togo"
                       ,@"Tonga"
                       ,@"Trinidad and Tobago"
                       ,@"Tunisia"
                       ,@"Turkey"
                       ,@"Turks and Caicos Islands"
                       ,@"Uganda"
                       ,@"Ukraine"
                       ,@"United Arab Emirates"
                       ,@"United States"
                       ,@"Uruguay"
                       ,@"Uzbekistan"
                       ,@"Vanuatu"
                       ,@"Venezuela, Bolivarian Republic of"
                       ,@"Wallis and Futuna"
                       ,@"Yemen"
                       ,@"Zambia"
                       ];
    TitleArray=@[@"Mr",@"Mrs",@"Ms"];
    pickerVieww.hidden=YES;
    
    
    
    
    
    clickedIndex=0;
    [favoriteButton setImage:[UIImage imageNamed:@"FavoriteNormal"] forState:UIControlStateNormal];
    [favoriteButton setImage:[UIImage imageNamed:@"FavoriteActive"] forState:UIControlStateSelected];
    imageArray=[[NSMutableArray alloc]init];
    menueArray=[[NSArray alloc]initWithObjects:@"ABOUT",@"REVIEWS",@"NEARBY", nil];
    self.slideImgWidth.constant=[UIScreen mainScreen].bounds.size.width/3;
    //    UISwipeGestureRecognizer *upRecognizer= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    //    [upRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    //
    //    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    //    [downRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    //
    //    [bgScrollView addGestureRecognizer:upRecognizer];
    //    [bgScrollView addGestureRecognizer:downRecognizer];
    utilObj=[[RequestUtil alloc]init];
    if([UIScreen mainScreen].bounds.size.height>=812)
    {
        self.scrollTop.constant=-47;
        
        self.navigationTop.constant=-45;
        self.bottomConst.constant=-20;
    }
    else
    {
        self.navigationTop.constant=-20;
        self.bottomConst.constant=0;
        self.scrollTop.constant=-20;
    }
    // [self loadBasicInfo];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"NO" forKey:@"pushClick"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportpaymentDoneAction)   name:@"paymentDone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportpaymentFailedAction)   name:@"paymentFailed" object:nil];
}
-(void)reportpaymentDoneAction
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookingCompletedViewController *vc = [y   instantiateViewControllerWithIdentifier:@"BookingCompletedViewController"];
    vc.bookingIDVAl=self.bookingIDVAl;
    vc.rooCount=self.rooCount;
    vc.proName=self.proName;
    vc.totalPrice=self.totPrice;
    vc.paid=self.paid;
    vc.balance=self.balance;
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)reportpaymentFailedAction
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=@"Booking operation failed";
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"payStatus"  ];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.navigationController.view addSubview:vc.view];
    //  [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];
}
-(IBAction)editFunction:(UIButton*)sender
{
    NSArray * stack = self.navigationController.viewControllers;
    BOOL back=NO;
    for(UIViewController *controllres in stack)
    {
        if([controllres isKindOfClass:[SearchWithLOcation class]])
        {
            back=YES;
            
            [self.navigationController popToViewController:controllres animated:YES];
            break;
        }
        if([controllres isKindOfClass:[AvailabilityViewController class]])
        {
            back=YES;
            
            [self.navigationController popToViewController:controllres animated:YES];
            break;
        }
        
    }
    if(!back)
        [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)loadBasicInfo
{
    


//    if([[self.selectedProperty objectForKey:@"rating"] isKindOfClass:[NSDictionary class]])
//    {
//        ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[[self.selectedProperty objectForKey:@"rating"] objectForKey:@"value"] ]];
//    }
//    else
//        ratingImageView.image=[UIImage imageNamed:[utilObj checkRating:[self.selectedProperty objectForKey:@"rating"] ]];
//    cleaningSloat=@"0";
//
//    if ([self.loadedProperty objectForKey:@"rooms"]) {
//        for(NSDictionary* dic in [self.loadedProperty objectForKey:@"rooms"])
//        {   if([dic isKindOfClass:[NSDictionary class]])
//        {
//            if([dic objectForKey:@"extraslot_cleaning"] && ![[dic objectForKey:@"extraslot_cleaning"] isKindOfClass:[NSNull class]])
//            {
//                cleaningSloat=[NSString stringWithFormat:@"%@",[dic valueForKey:@"extraslot_cleaning"] ];
//                break;
//            }
//        }
//        else
//            cleaningSloat=@"0";
//
//        }
//    }
    
    
    NSString* Vat=@"%";
    NSString* Tourism=@"";
    NSString* Municipality=@"";
    NSString* Service=@"";
    
    
    if([[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ])
    {
        float  VatAmount=[[[[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ] objectForKey:@"excluding_vat"] floatValue];
        float  TAmount=[[[[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ] objectForKey:@"tourism_fee"] floatValue];
        float  MAmount=[[[[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ] objectForKey:@"muncipality_fee"] floatValue];
        float  SAmount=[[[[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ] objectForKey:@"service_charge"] floatValue];
        
        
//        Vat=[[NSString stringWithFormat:@"%.1f",VatAmount] stringByAppendingString:Vat];
//        Tourism=[[NSString stringWithFormat:@"%.1f",TAmount] stringByAppendingString:Tourism];
//        Service=[[NSString stringWithFormat:@"%.1f",SAmount] stringByAppendingString:Service];
//
//        Municipality=[Municipality stringByAppendingString:[NSString stringWithFormat:@"%.1f",MAmount]];
        
        
        
        
        //  Vat=[[NSString stringWithFormat:@"%.1f",VatAmount] stringByAppendingString:Vat];
        //   Tourism=[[NSString stringWithFormat:@"%.1f",TAmount] stringByAppendingString:Tourism];
        //   Service=[[NSString stringWithFormat:@"%.1f",SAmount] stringByAppendingString:Service];
        
        Vat=[[[[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ] objectForKey:@"excluding_vat"] stringByAppendingString:Vat];
        Tourism=[[[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ] objectForKey:@"tourism_fee"];
        Service=[[[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ] objectForKey:@"service_charge"];
        
        
        //     Municipality=[Municipality stringByAppendingString:[NSString stringWithFormat:@"%.1f",MAmount]];
        
        Municipality=[[[self.selectedProperty objectForKey:@"property"]objectForKey:@"payment" ] objectForKey:@"muncipality_fee"];
        
    }
    
    
    
    
    taxTextLBL.text=[NSString stringWithFormat:@"Excluding VAT %@, Tourism fee %@, Municipality fee %@ and Service charge %@",Vat,Tourism,Municipality,Service ];
    
    
    
    
    if([[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"nationality"])
    {
        nationalityTextfd.text=[[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"nationality"];
        NSDictionary*   codes = @{ @"Abkhazia"                                     : @"+7840",
                                   @"Abkhazia"                                     : @"+7940",
                                   @"Afghanistan"                                  : @"+93",
                                   @"Albania"                                      : @"+355",
                                   @"Algeria"                                      : @"+213",
                                   @"American Samoa"                               : @"+1684",
                                   @"Andorra"                                      : @"+376",
                                   @"Angola"                                       : @"+244",
                                   @"Anguilla"                                     : @"+1264",
                                   @"Antigua and Barbuda"                          : @"+1268",
                                   @"Argentina"                                    : @"+54",
                                   @"Armenia"                                      : @"+374",
                                   @"Aruba"                                        : @"+297",
                                   @"Ascension"                                    : @"+247",
                                   @"Australia"                                    : @"+61",

                                   @"Austria"                                      : @"+43",
                                   @"Azerbaijan"                                   : @"+994",
                                   @"Bahamas"                                      : @"+1242",
                                   @"Bahrain"                                      : @"+973",
                                   @"Bangladesh"                                   : @"+880",
                                   @"Barbados"                                     : @"+1246",
                                   @"Barbuda"                                      : @"+1268",
                                   @"Belarus"                                      : @"+375",
                                   @"Belgium"                                      : @"+32",
                                   @"Belize"                                       : @"+501",
                                   @"Benin"                                        : @"+229",
                                   @"Bermuda"                                      : @"+1441",
                                   @"Bhutan"                                       : @"+975",
                                   @"Bolivia"                                      : @"+591",
                                   @"Bosnia and Herzegovina"                       : @"+387",
                                   @"Botswana"                                     : @"+267",
                                   @"Brazil"                                       : @"+55",
                                   @"British Indian Ocean Territory"               : @"+246",
                                   @"British Virgin Islands"                       : @"+1284",
                                   @"Brunei"                                       : @"+673",
                                   @"Bulgaria"                                     : @"+359",
                                   @"Burkina Faso"                                 : @"+226",
                                   @"Burundi"                                      : @"+257",
                                   @"Cambodia"                                     : @"+855",
                                   @"Cameroon"                                     : @"+237",
                                   @"Canada"                                       : @"+1",
                                   @"Cape Verde"                                   : @"+238",
                                   @"Cayman Islands"                               : @"+ 345",
                                   @"Central African Republic"                     : @"+236",
                                   @"Chad"                                         : @"+235",
                                   @"Chile"                                        : @"+56",
                                   @"China"                                        : @"+86",
                                   @"Christmas Island"                             : @"+61",
                                   @"Cocos-Keeling Islands"                        : @"+61",
                                   @"Colombia"                                     : @"+57",
                                   @"Comoros"                                      : @"+269",
                                   @"Congo"                                        : @"+242",
                                   @"Congo, Dem. Rep. of (Zaire)"                  : @"+243",
                                   @"Cook Islands"                                 : @"+682",
                                   @"Costa Rica"                                   : @"+506",
                                   @"Ivory Coast"                                  : @"+225",
                                   @"Croatia"                                      : @"+385",
                                   @"Cuba"                                         : @"+53",
                                   @"Curacao"                                      : @"+599",
                                   @"Cyprus"                                       : @"+537",
                                   @"Czech Republic"                               : @"+420",
                                   @"Denmark"                                      : @"+45",
                                   @"Diego Garcia"                                 : @"+246",
                                   @"Djibouti"                                     : @"+253",
                                   @"Dominica"                                     : @"+1767",
                                   @"Dominican Republic"                           : @"+1809",

                                   @"East Timor"                                   : @"+670",
                                   @"Easter Island"                                : @"+56",
                                   @"Ecuador"                                      : @"+593",
                                   @"Egypt"                                        : @"+20",
                                   @"El Salvador"                                  : @"+503",
                                   @"Equatorial Guinea"                            : @"+240",
                                   @"Eritrea"                                      : @"+291",
                                   @"Estonia"                                      : @"+372",
                                   @"Ethiopia"                                     : @"+251",
                                   @"Falkland Islands"                             : @"+500",
                                   @"Faroe Islands"                                : @"+298",
                                   @"Fiji"                                         : @"+679",
                                   @"Finland"                                      : @"+358",
                                   @"France"                                       : @"+33",
                                   @"French Antilles"                              : @"+596",
                                   @"French Guiana"                                : @"+594",
                                   @"French Polynesia"                             : @"+689",
                                   @"Gabon"                                        : @"+241",
                                   @"Gambia"                                       : @"+220",
                                   @"Georgia"                                      : @"+995",
                                   @"Germany"                                      : @"+49",
                                   @"Ghana"                                        : @"+233",
                                   @"Gibraltar"                                    : @"+350",
                                   @"Greece"                                       : @"+30",
                                   @"Greenland"                                    : @"+299",
                                   @"Grenada"                                      : @"+1473",
                                   @"Guadeloupe"                                   : @"+590",
                                   @"Guam"                                         : @"+1671",
                                   @"Guatemala"                                    : @"+502",
                                   @"Guinea"                                       : @"+224",
                                   @"Guinea-Bissau"                                : @"+245",
                                   @"Guyana"                                       : @"+595",
                                   @"Haiti"                                        : @"+509",
                                   @"Honduras"                                     : @"+504",
                                   @"Hong Kong SAR China"                          : @"+852",
                                   @"Hungary"                                      : @"+36",
                                   @"Iceland"                                      : @"+354",
                                   @"India"                                        : @"+91",
                                   @"Indonesia"                                    : @"+62",
                                   @"Iran"                                         : @"+98",
                                   @"Iraq"                                         : @"+964",
                                   @"Ireland"                                      : @"+353",
                                   @"Israel"                                       : @"+972",
                                   @"Italy"                                        : @"+39",
                                   @"Jamaica"                                      : @"+1876",
                                   @"Japan"                                        : @"+81",
                                   @"Jordan"                                       : @"+962",
                                   @"Kazakhstan"                                   : @"+7 7",
                                   @"Kenya"                                        : @"+254",
                                   @"Kiribati"                                     : @"+686",
                                   @"North Korea"                                  : @"+850",
                                   @"South Korea"                                  : @"+82",
                                   @"Kuwait"                                       : @"+965",
                                   @"Kyrgyzstan"                                   : @"+996",
                                   @"Laos"                                         : @"+856",
                                   @"Latvia"                                       : @"+371",
                                   @"Lebanon"                                      : @"+961",
                                   @"Lesotho"                                      : @"+266",
                                   @"Liberia"                                      : @"+231",
                                   @"Libya"                                        : @"+218",
                                   @"Liechtenstein"                                : @"+423",
                                   @"Lithuania"                                    : @"+370",
                                   @"Luxembourg"                                   : @"+352",
                                   @"Macau SAR China"                              : @"+853",
                                   @"Macedonia"                                    : @"+389",
                                   @"Madagascar"                                   : @"+261",
                                   @"Malawi"                                       : @"+265",
                                   @"Malaysia"                                     : @"+60",
                                   @"Maldives"                                     : @"+960",
                                   @"Mali"                                         : @"+223",
                                   @"Malta"                                        : @"+356",
                                   @"Marshall Islands"                             : @"+692",
                                   @"Martinique"                                   : @"+596",
                                   @"Mauritania"                                   : @"+222",
                                   @"Mauritius"                                    : @"+230",
                                   @"Mayotte"                                      : @"+262",
                                   @"Mexico"                                       : @"+52",
                                   @"Micronesia"                                   : @"+691",
                                   @"Midway Island"                                : @"+1808",
                                   @"Micronesia"                                   : @"+691",
                                   @"Moldova"                                      : @"+373",
                                   @"Monaco"                                       : @"+377",
                                   @"Mongolia"                                     : @"+976",
                                   @"Montenegro"                                   : @"+382",
                                   @"Montserrat"                                   : @"+1664",
                                   @"Morocco"                                      : @"+212",
                                   @"Myanmar"                                      : @"+95",
                                   @"Namibia"                                      : @"+264",
                                   @"Nauru"                                        : @"+674",
                                   @"Nepal"                                        : @"+977",
                                   @"Netherlands"                                  : @"+31",
                                   @"Netherlands Antilles"                         : @"+599",
                                   @"Nevis"                                        : @"+1869",
                                   @"New Caledonia"                                : @"+687",
                                   @"New Zealand"                                  : @"+64",
                                   @"Nicaragua"                                    : @"+505",
                                   @"Niger"                                        : @"+227",
                                   @"Nigeria"                                      : @"+234",
                                   @"Niue"                                         : @"+683",
                                   @"Norfolk Island"                               : @"+672",
                                   @"Northern Mariana Islands"                     : @"+1670",
                                   @"Norway"                                       : @"+47",
                                   @"Oman"                                         : @"+968",
                                   @"Pakistan"                                     : @"+92",
                                   @"Palau"                                        : @"+680",
                                   @"Palestinian Territory"                        : @"+970",
                                   @"Panama"                                       : @"+507",
                                   @"Papua New Guinea"                             : @"+675",
                                   @"Paraguay"                                     : @"+595",
                                   @"Peru"                                         : @"+51",
                                   @"Philippines"                                  : @"+63",
                                   @"Poland"                                       : @"+48",
                                   @"Portugal"                                     : @"+351",
                                   @"Puerto Rico"                                  : @"+1787",
                                   @"Puerto Rico"                                  : @"+1939",
                                   @"Qatar"                                        : @"+974",
                                   @"Reunion"                                      : @"+262",
                                   @"Romania"                                      : @"+40",
                                   @"Russia"                                       : @"+7",
                                   @"Rwanda"                                       : @"+250",
                                   @"Samoa"                                        : @"+685",
                                   @"San Marino"                                   : @"+378",
                                   @"Saudi Arabia"                                 : @"+966",
                                   @"Senegal"                                      : @"+221",
                                   @"Serbia"                                       : @"+381",
                                   @"Seychelles"                                   : @"+248",
                                   @"Sierra Leone"                                 : @"+232",
                                   @"Singapore"                                    : @"+65",
                                   @"Slovakia"                                     : @"+421",
                                   @"Slovenia"                                     : @"+386",
                                   @"Solomon Islands"                              : @"+677",
                                   @"South Africa"                                 : @"+27",
                                   @"South Georgia and the South Sandwich Islands" : @"+500",
                                   @"Spain"                                        : @"+34",
                                   @"Sri Lanka"                                    : @"+94",
                                   @"Sudan"                                        : @"+249",
                                   @"Suriname"                                     : @"+597",
                                   @"Swaziland"                                    : @"+268",
                                   @"Sweden"                                       : @"+46",
                                   @"Switzerland"                                  : @"+41",
                                   @"Syria"                                        : @"+963",
                                   @"Taiwan"                                       : @"+886",
                                   @"Tajikistan"                                   : @"+992",
                                   @"Tanzania"                                     : @"+255",
                                   @"Thailand"                                     : @"+66",
                                   @"Timor Leste"                                  : @"+670",
                                   @"Togo"                                         : @"+228",
                                   @"Tokelau"                                      : @"+690",
                                   @"Tonga"                                        : @"+676",
                                   @"Trinidad and Tobago"                          : @"+1868",
                                   @"Tunisia"                                      : @"+216",
                                   @"Turkey"                                       : @"+90",
                                   @"Turkmenistan"                                 : @"+993",
                                   @"Turks and Caicos Islands"                     : @"+1649",
                                   @"Tuvalu"                                       : @"+688",
                                   @"Uganda"                                       : @"+256",
                                   @"Ukraine"                                      : @"+380",
                                   @"UAE"                                          : @"+971",
                                   @"United Kingdom"                               : @"+44",
                                   @"United States"                                : @"+1",
                                   @"Uruguay"                                      : @"+598",
                                   @"U.S. Virgin Islands"                          : @"+1340",
                                   @"Uzbekistan"                                   : @"+998",
                                   @"Vanuatu"                                      : @"+678",
                                   @"Venezuela"                                    : @"+58",
                                   @"Vietnam"                                      : @"+84",
                                   @"Wake Island"                                  : @"+1808",
                                   @"Wallis and Futuna"                            : @"+681",
                                   @"Yemen"                                        : @"+967",
                                   @"Zambia"                                       : @"+260",
                                   @"Zanzibar"                                     : @"+255",
                                   @"Zimbabwe"                                     : @"+263"
                                   };


        if([codes objectForKey:nationalityTextfd.text])
        {
            cCode=[codes objectForKey:nationalityTextfd.text];

        }
    }
    
    if([self.selectedProperty objectForKey:@"trip_type"] )
    {
        if([[self.selectedProperty objectForKey:@"trip_type"] isEqualToString:@"BUSINESS"])
        {
            businessBtn.selected=YES;
            individualBtn.selected=NO;

        }
        else
        {
            businessBtn.selected=NO;

            individualBtn.selected=YES;
        }

    }

    
    
    if([[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"city"])
        cityNameTF.text=[[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"city"];

    if([[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"title"])
        [titleBtn setTitle:[[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"title"] forState:UIControlStateNormal];

    if([[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"last_name"])
        lastNameTF.text=[[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"last_name"];

    //    [[NSUserDefaults standardUserDefaults]setObject:lastNameTF.text forKey:@"lastName"];

    if([[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"mobile"])
    {
        mobileTF.text=[[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"mobile"];
  //      if([mobileTF.text containsString:@"+"])
//        {
//            if([mobileTF.text containsString:@"-"])
//            {
//                cCode=[[mobileTF.text componentsSeparatedByString:@"-"] objectAtIndex:0];
//
//
//                if([[mobileTF.text componentsSeparatedByString:@"-"] count]>1)
//                {
//                    mobileTF.text=[[mobileTF.text componentsSeparatedByString:@"-"] objectAtIndex:1];
//                }
//            }
//        }
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"mobileNumberBooking" ])
            mobileTF.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"mobileNumberBooking" ];
    }


    emailTF.text=[[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"email"];
    firstNameTF.text=[[self.selectedProperty objectForKey:@"guestinfo"] objectForKey:@"first_name"];

    taxAmount=0.0;
    if([self.selectedProperty objectForKey:@"payment"])
        if([[self.selectedProperty objectForKey:@"payment"] objectForKey:@"tax"])
        {
            //   taxAmount=[[[self.selectedProperty objectForKey:@"payment"] objectForKey:@"tax"] floatValue];

        }

    packofhoursLBL.text=[NSString stringWithFormat:@"%@h",[self.selectedProperty objectForKey:@"smallest_slot"]];
//    ditanceLBL.text=[NSString stringWithFormat:@"- from %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLocationName"] ];
//    if([self.loadedProperty objectForKey:@"distance"] && [self.loadedProperty objectForKey:@"distance_unit"] )
//    {
//        if(![[self.loadedProperty objectForKey:@"distance"] isKindOfClass:[NSNull class]])
//        {
//            ditanceLBL.text=[NSString stringWithFormat:@"%.2f %@ from %@",[[self.loadedProperty objectForKey:@"distance"] floatValue],[self.loadedProperty objectForKey:@"distance_unit"],[[NSUserDefaults standardUserDefaults] objectForKey:@"pickupLocationName"] ];
//        }
//        else
//            ditanceLBL.text=@"0.0Kms";
//
//    }
    [imageArray removeAllObjects];
    if([[self.selectedProperty objectForKey:@"property"] objectForKey:@"images"])
        for(NSString* imageString in [[self.selectedProperty objectForKey:@"property"] objectForKey:@"images"])
        {
            [imageArray addObject:imageString];
            //  [imageArray addObject:imageString];

        }
    [imageCollectionView reloadData];


    if(imageArray.count==0)
    {
        countLBL.text=@"0/0";
    }
    else
    {
        countLBL.text=[NSString stringWithFormat:@"1/%lu",(unsigned long)imageArray.count ];

    }

    NSString* price=@"0";
    //  NSString* discountPrice=@"0";
    // cell.propertyLocationLBL.text=@"";
    userReviewValueLBL.text=@"0";
  
    if([[self.selectedProperty objectForKey:@"property"] objectForKey:@"name"])
        propertyNameLBL.text=[[self.selectedProperty objectForKey:@"property"] objectForKey:@"name"];
    else
        propertyNameLBL.text=@"";
    self.proName=propertyNameLBL.text;;

   
    price=@"0.0";
    
    totalPrice=[[self.selectedProperty objectForKey:@"total_amt"] floatValue];
  self.totPrice=[self.selectedProperty objectForKey:@"total_amt"];
  
    promoDiscount=[[self.selectedProperty objectForKey:@"rebooking_price"] floatValue];
    


    taxAmount=(taxAmount/100)*totalPrice;
    [self calculateAmount];
    
    
    
    
//    _rooCount=[NSString stringWithFormat:@"%f",[[self.selectedProperty objectForKey:@"rebooking_price"] floatValue]];
    NSInteger roomCount=0;
    
    for(NSDictionary* dic in [self.selectedProperty objectForKey:@"room"])
    {
        if([dic objectForKey:@"number"])
        {
            roomCount=roomCount+[[dic objectForKey:@"number"] integerValue];
        }
        
    }
    self.rooCount=[NSString stringWithFormat:@"%ld",(long)roomCount];;
    roomsLBL.text=[NSString stringWithFormat:@"%ld",(long)roomCount];
    
    NSString *roomsString=@"ROOM";
    NSString *adultsString=@"ADULT";
    NSString *childString=@"CHILD";

    if(roomCount>1)
    {
        roomsString=@"ROOMS";
    }
    if([[self.selectedProperty objectForKey:@"no_of_adults"] integerValue]>1)
    {
        adultsString=@"ADULTS";
    }
    if([[self.selectedProperty objectForKey:@"no_of_children"] integerValue]>1)
    {
        childString=@"CHILDREN'S";
    }


    if([[self.selectedProperty objectForKey:@"no_of_children"] integerValue]!=0)
    {
         adultsAndRoomsLBL.text= [NSString stringWithFormat:@"%ld %@, %@ %@, %@ %@",(long)roomCount,roomsString,[self.selectedProperty objectForKey:@"no_of_adults"],adultsString,[self.selectedProperty objectForKey:@"no_of_children"],childString];
    }
     
    else
    {
         adultsAndRoomsLBL.text= [NSString stringWithFormat:@"%ld %@, %@ %@",(long)roomCount,roomsString,[self.selectedProperty objectForKey:@"no_of_adults"],adultsString];
    }

   
    
    
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//    NSDate *selectedDate=[dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedDate"] ];
//    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
//    [dateFormatter2 setDateFormat:@"MMM dd"];
//    [dateFormatter2 setTimeZone:[NSTimeZone localTimeZone]];
//
//    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc]init];
//    [dateFormatter3 setDateFormat:@"MMMM dd, yyyy"];
//    [dateFormatter3 setTimeZone:[NSTimeZone localTimeZone]];
//    NSString* nextDayString2=[dateFormatter3 stringFromDate:selectedDate];
//    dayLBL.text=nextDayString2;
//
//    NSString* checkinTime=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"];
//    checkinTime= [checkinTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
//
//    [dateFormatter3 setDateFormat:@"HH:mm"];
//
//    NSDate*datePassed=[dateFormatter3 dateFromString:checkinTime];
//    [dateFormatter3 setDateFormat:@"hh:mm"];
//    NSString*selectedTime=[dateFormatter3 stringFromDate:datePassed];
//
//    [dateFormatter3 setDateFormat:@"hh:mm a"];
//    NSString*amOrPm=[dateFormatter3 stringFromDate:datePassed];
//    if([amOrPm containsString:@"AM"])
//        chekinTimeLBL.text=[NSString stringWithFormat:@"%@ AM",selectedTime];
//    else
//        chekinTimeLBL.text=[NSString stringWithFormat:@"%@ PM",selectedTime];
//    packofhoursLBL.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"];
//
//    //   chekinTimeLBL.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedTime"];
//    NSString* nextDayString=[dateFormatter2 stringFromDate:selectedDate];
//    sloatDateLBL.text=[NSString stringWithFormat:@"%@-%@-%@",nextDayString,[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedSloat"],[utilObj convertTime]];
    
    
    
    self.menuDetailsScrollViewHeight.constant= [UIScreen mainScreen].bounds.size.height-(topView.frame.origin.y+topView.frame.size.height)-165;
    
}


-(void)loadApi
{
    apiStatus=YES;
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
    
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    
    [util postRequest:reqData toUrl:[NSString stringWithFormat: @"bookings/booking_det?book_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"book_id"]] type:@"GET"];
    
    
}
-(void)calculateAmount
{
    totalTariffLBL.text=[NSString stringWithFormat:@"AED %.2f",totalPrice];
    //  taxLBL.text=[NSString stringWithFormat:@"AED %.2f",taxAmount];
    grandTotalLBL.text=[NSString stringWithFormat:@"AED %.2f",taxAmount+totalPrice+promoDiscount];
    nowPayLBL.text=[NSString stringWithFormat:@"AED %.2f",promoDiscount];
    bookingFeeLBL.text=[NSString stringWithFormat:@"AED %.2f",promoDiscount];
    payathotelLBL.text=[NSString stringWithFormat:@"AED %.2f",taxAmount+totalPrice];
    
    _totPrice=[NSString stringWithFormat:@"AED %.2f",taxAmount+totalPrice+promoDiscount];
    _paid=[NSString stringWithFormat:@"AED %.2f",promoDiscount];
    _balance=[NSString stringWithFormat:@"AED %.2f",taxAmount+totalPrice];
    _proName=propertyNameLBL.text;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [self loadApi];
    //    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    //    {
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width,1350);
    
    
    
    if( [[[NSUserDefaults standardUserDefaults]objectForKey:@"payStatus"] isEqualToString:@"YES"])
    {
        [self reportpaymentFailedAction];
    }
    
    
  //  [self loadBasicInfo];
    
    // }
    //    else
    //    {
    //        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //        LoginViewController *vc = [y   instantiateViewControllerWithIdentifier:@"LoginViewController"];
    //
    //        vc.fromString=@"presentView";
    //        [self.navigationController pushViewController:vc animated:YES];
    //
    ////        vc.providesPresentationContextTransitionStyle = YES;
    ////        vc.definesPresentationContext = YES;
    ////        [vc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    ////        [self.navigationController presentViewController:vc animated:YES completion:nil];
    //    }
    
}



- (IBAction)done:(id)sender
{
    pickerVieww.hidden=YES;
    doneView.hidden=YES;
}

- (IBAction)lastnameEditEnd:(id)sender
{
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 300)];
                         
                     }
                     completion:nil];
}

- (IBAction)lastnameEditBegin:(id)sender
{
    
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 500)];
                         
                     }
                     completion:nil];
}

- (IBAction)selectTitle:(id)sender
{
    
    
    for(UIView *vieww in fieldView.subviews)
    {
        for(UIView *field in vieww.subviews)
        {
            if([field isKindOfClass:[UITextField class]])
            {
                [field resignFirstResponder];
            }
        }
    }
    doneView.hidden=NO;
    pickerVieww.hidden=NO;
    isForTitle=YES;
    pickerVieww.dataSource=self;
    pickerVieww.delegate=self;
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 500)];
                         
                     }
                     completion:nil];
}

- (IBAction)selectNationality:(id)sender
{
    
    
    
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
    nationalityTextfd.text=countryString;
    cCode=countryCode;
    //    [self. setTitle:countryCode forState:UIControlStateNormal];
}











-(IBAction)terms:(id)sender
{
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
    TERMSWEBViewController *vc = [y   instantiateViewControllerWithIdentifier:@"TERMSWEBViewController"];
    //   vc.WEBSTRING=@"https://stayhopper.com/privacy.html#noheader";
    
    vc.WEBSTRING=@"https://stayhopper.com/terms.html#noheader";
    [self.navigationController pushViewController:vc animated:YES];
    
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://stayhopper.com/privacy.html"]];
    //
    //    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    TermsAndConditionsViewController *vc = [y   instantiateViewControllerWithIdentifier:@"TermsAndConditionsViewController"];
    //
    //     vc.fromString=@"presentViewTab";
    //    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component
{
    if(isForTitle==YES)
        return 3;
    else
        return nationalityArray.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(isForTitle==YES)
    {
        return [NSString stringWithFormat:@"%@",[TitleArray objectAtIndex:row]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@",[nationalityArray objectAtIndex:row]];
    }
}


- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    if(isForTitle==YES)
        [titleBtn setTitle:[NSString stringWithFormat:@"%@",[TitleArray objectAtIndex:row]] forState:UIControlStateNormal];
    
    else
        nationalityTextfd.text=[NSString stringWithFormat:@"%@",[nationalityArray objectAtIndex:row]];
    
}




- (IBAction)emailEditEnd:(id)sender
{
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 300)];
                         
                     }
                     completion:nil];
}

- (IBAction)emailEditBegin:(id)sender
{
    
    
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 500)];
                         
                     }
                     completion:nil];
    
}

- (IBAction)mobileEditEnd:(id)sender
{
    
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 300)];
                         
                     }
                     completion:nil];
    
}

- (IBAction)mobileEditBegin:(id)sender {
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 500)];
                         
                     }
                     completion:nil];
}

- (IBAction)cityEditEnd:(id)sender {
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 300)];
                         
                     }
                     completion:nil];
}

- (IBAction)cityEditBegin:(id)sender {
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 500)];
                         
                     }
                     completion:nil];
}

- (IBAction)firstNameEditBegin:(id)sender
{
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 500)];
                         
                     }
                     completion:nil];
}

- (IBAction)firstNameEditEnd:(id)sender
{
    [UIView animateWithDuration:0.5f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 300)];
                         
                     }
                     completion:nil];
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return imageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    homeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    
    NSString*imgName=[imageArray objectAtIndex:indexPath.item];
    NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    [homeCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder1"]];
    
    
    
    
    return homeCell;
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView==imageCollectionView)
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    
    return CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.height);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //            MallDetailsViewController *menuView=[storyBoard instantiateViewControllerWithIdentifier:@"MallDetailsViewController"];
    //            [self.navigationController pushViewController:menuView animated:YES];
    
    
    
    
}
-(IBAction)favoriteFunction:(UIButton*)sender
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"loadStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [utilObj addOrRemoveFavorites:[self.selectedProperty objectForKey:@"_id"] userID:@""];
        
        if(sender.isSelected)
        {
            sender.selected=NO;
        }
        else
        {
            sender.selected=YES;
            
        }
    }
    
}
-(IBAction)backFunction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
};
-(IBAction)shareFunction:(id)sender
{
    
};
-(IBAction)checkFunction:(UIButton*)sender
{
    if(sender==businessBtn || sender==individualBtn)
    {
        typeValue=sender.titleLabel.text;
        
        if(sender==businessBtn)
        {
            businessBtn.selected=YES;
            individualBtn.selected=NO;
            
        }else  if(sender==individualBtn)
        {
            businessBtn.selected=NO;
            individualBtn.selected=YES;
            
        }
        
    }
    else
    {
        if(sender.isSelected)
        {
            sender.selected=NO;
        }
        else
        {
            sender.selected=YES;
            
        }
    }
}


- (void)Uploadprogress
{
    //  hud.progress = progress=hud.progress+0.05;
    hud.progress=hud.progress+0.05;
    //    if(hud.progress>1)
    //        hud.progress=0;
}
-(IBAction)payNowFunction:(UIButton*)sender;
{
    if(rulesBtn.isSelected )
    {
        
        
        if(emailTF.text.length!=0 && cityNameTF.text.length!=0 &&nationalityTextfd.text.length!=0 &&lastNameTF.text.length!=0 &&firstNameTF.text.length!=0  ) {
            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"";
            
            hud.mode=MBProgressHUDModeText;
            hud.margin = 0.f;
            hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
            hud.removeFromSuperViewOnHide = YES;
            
            hud.progress=0;
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
            reqData = [NSMutableDictionary dictionary];
         
            apiStatus=NO;
         
            if(promoStatus)
            {
                
                NSString* amountTest=discountPercentageLBL.text;
                amountTest=[amountTest stringByReplacingOccurrencesOfString:@"discount applied" withString:@""];
                
                amountTest=[amountTest stringByReplacingOccurrencesOfString:@"-" withString:@""];
                amountTest=[amountTest stringByReplacingOccurrencesOfString:@"%" withString:@""];
                amountTest=[amountTest stringByReplacingOccurrencesOfString:@" " withString:@""];
                float discount=(([amountTest floatValue]/100)*15);
//                [reqData setObject:[NSString stringWithFormat:@"%.2f",15.0f-discount] forKey:@"payment_amt"];
             //   [reqData setValue:[NSString stringWithFormat:@"%.2f",discount] forKey:@"discount"];
                 [reqData setObject:[NSString stringWithFormat:@"%f",promoDiscount] forKey:@"amt_payable"];
                [reqData setValue:couponTF.text forKey:@"promocode"];
                
            }
            else
            {
                [reqData setObject:[NSString stringWithFormat:@"%f",promoDiscount] forKey:@"amt_payable"];
              
                
            }
          

          [reqData setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"book_id"] forKey:@"book_id"];
            
            [util postRequest:reqData toUrl:@"bookings/extendedbooking" type:@"POST"];
            
            
            
            
            
        }else
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Warning";
            vc.messageString=@"Please fill mandatory fields";
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
        }
        
    }
    else
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"To proceed you need to accept our terms and conditions";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
    }
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    if(apiStatus)
    {
        if(rawData!=nil)
        {
            
            
            
            
            [hud hideAnimated:YES afterDelay:0];
            
            if([rawData objectForKey:@"message"])
            {
                UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
                vc.imageName=@"Failed";
                vc.messageString=[rawData objectForKey:@"message"];
                vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
                [self.view addSubview:vc.view];
                [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];

            }
            else
            {
            
            self.selectedProperty=rawData;
            [self loadBasicInfo];
            }
            
        }
    }
    else
    {
    
    if([rawData objectForKey:@"data"])
    {
        [hud hideAnimated:YES afterDelay:0];
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Succses";
        vc.messageString=[rawData objectForKey:@"message"];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        //[self.navigationController.view addSubview:vc.view];
        [self.view addSubview:vc.view];
        
        [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];
        
        
        
        
    }
    else
    {
        [hud hideAnimated:YES afterDelay:0];
        
        if([[[rawData objectForKey:@"status"] uppercaseString] containsString:@"FAILED"])
        {
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            vc.imageName=@"Failed";
            vc.messageString=[rawData objectForKey:@"message"];
            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            [self.view addSubview:vc.view];
            //  [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            
            
            [hud hideAnimated:YES afterDelay:0];
            //        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            //        vc.imageName=@"Succses";
            //        vc.messageString=[rawData objectForKey:@"message"];
            //        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            //        //[self.navigationController.view addSubview:vc.view];
            //        [self.view addSubview:vc.view];
            //
            //       [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];
            
            
            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PaymentViewViewController *vc = [y   instantiateViewControllerWithIdentifier:@"PaymentViewViewController"];
            vc.pauURL=[rawData objectForKey:@"payment_link"];
            self.bookingIDVAl=[rawData objectForKey:@"book_id"];

            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[rawData objectForKey:@"booking_id"] forKey:@"booking_ID"];
            [defaults synchronize];
            [self.navigationController pushViewController:vc animated:YES];
            
            //            UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //            MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
            //            vc.imageName=@"Succses";
            //            vc.messageString=[rawData objectForKey:@"message"];
            //            vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
            //            [self.view addSubview:vc.view];
            //             //[self.navigationController.view addSubview:vc.view];
            //            [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];
        }
        
    }
    }
    
    
}
-(void)moveBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    //  loadingLBL.text=@"There are no available rooms with your search criteria";
    hud.margin = 10.f;
    //hud.label.text = response;
    [hud hideAnimated:YES afterDelay:0];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=response;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    if(apiStatus)
    {
        [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];

    }
    else
    {
   
    }
    
}
-(void)webRawDataReceivedWithError:(NSString *)errorMessage
{
    // loadingLBL.text=@"There are no available rooms with your search criteria";
    hud.margin = 10.f;
    //hud.label.text = response;
    [hud hideAnimated:YES afterDelay:0];
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=errorMessage;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
    if(apiStatus)
    {
       [self performSelector:@selector(moveBack) withObject:nil afterDelay:3];

    }
    else
    {
   
    }
}
//-(void)moveBack
//{
//    
//}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==nationalityTextfd)
    {
        [self.view endEditing:YES];
        [self selectNationality:nil];
        return NO;
    }
    pickerVieww.hidden=YES;
    doneView.hidden=YES;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField==firstNameTF)
    {
        
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. "] invertedSet];
            NSString *filteredstring  = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            if(![string isEqualToString:filteredstring])
                
                return ([string isEqualToString:filteredstring]);
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            return (newString.length<=21);
        }
        
        
        
        
    }else  if(textField==lastNameTF)
    {
        
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. "] invertedSet];
            NSString *filteredstring  = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            if(![string isEqualToString:filteredstring])
                
                return ([string isEqualToString:filteredstring]);
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            return (newString.length<=21);
        }
        
        //        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //        if(newText.length>20)
        //        {
        //
        //
        //
        //            return NO;
        //        }
        
        
        
        
    }else  if(textField==mobileTF)
    {
        
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if(newText.length>11)
        {
            return NO;
        }
        
        
        
        
    }
    
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
- (IBAction)applayPromocode:(id)sender
{
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"";
    
    hud.mode=MBProgressHUDModeText;
    hud.margin = 0.f;
    hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
    hud.removeFromSuperViewOnHide = YES;
    
    hud.progress=0;
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        hud.progress=hud.progress+0.05;
        if(hud.progress>1)
        {
            [timer invalidate];
        }
    }];
    [self.view endEditing:YES];
    {
        NSString* locationString=@" ";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"])
        {
            
            locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        }
        
        NSString* postString=[NSString stringWithFormat:@"user=%@&promocode=%@",locationString,couponTF.text];
       
        
        
        NSString *requstUrl=[NSString stringWithFormat:@"https://extranet.stayhopper.com/api/bookings/checkpromo"];
        
        
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
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [hud hideAnimated:YES afterDelay:0];
                                    
                                    discountPercentageLBL.text=[NSString stringWithFormat:@"%@%@ discount applied",[[parsedObject objectForKey:@"data"]valueForKey:@"discount"],@"%" ];
                                    
                                    NSString* amountTest=discountPercentageLBL.text;
                                    amountTest=[amountTest stringByReplacingOccurrencesOfString:@"discount applied" withString:@""];
                                    amountTest=[amountTest stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                    amountTest=[amountTest stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    amountTest=[amountTest stringByReplacingOccurrencesOfString:@"%" withString:@""];
                                    float discount=(([amountTest floatValue]/100)*promoDiscount);
                                    
                                    promoDiscount=promoDiscount-discount;
                                    
                                    
                                    promoStatus=YES;
                                    [self calculateAmount];
                                    
                                });
                                
                                
                                
                                
                                
                            }
                            else
                            {
                                
                            }
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                discountPercentageLBL.text=@"Invalid Code";
                                promoDiscount=15;
                                [self calculateAmount];
                                [hud hideAnimated:YES afterDelay:0];
                                
                                // couponTF.text=@"";
                            });
                            
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
@end
