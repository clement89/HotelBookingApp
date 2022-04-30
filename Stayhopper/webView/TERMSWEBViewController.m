//
//  TERMSWEBViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 21/11/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "TERMSWEBViewController.h"
#import "URLConstants.h"
@interface TERMSWEBViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgCross;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation TERMSWEBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
        _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
       _lblTitle.superview.layer.shadowOpacity = 0.3;
       _lblTitle.superview.layer.shadowRadius = 2.0;
       _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
        self.view.backgroundColor = kColorProfilePages;
    paymentWebView.backgroundColor =kColorProfilePages;
//    paymentWebView.clipsToBounds = TRUE;
//    paymentWebView.layer.cornerRadius = 10.;
    // Do any additional setup after loading the view.
   // https://stayhopper.com/privacy.html
    
    //CJC 6
    NSURL *url = [NSURL URLWithString:@"https://stayhopper.com/privacy-policy?noheader"];
    
   
    if (_isForOffers) {
        _imgCross.image =[UIImage imageNamed:@"Vector_left_arrow"];

    }
    
    if(self.WEBSTRING!=nil)
    {


        url= [NSURL URLWithString:self.WEBSTRING];
        
    }
    
   
    
    
    
    
    _lblTitle.text = @"";
    if (_titleString) {
        _lblTitle.text = _titleString;
    }
    
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [paymentWebView loadRequest:requestObj];
}
    -(IBAction)backFunction:(id)sender
    {
        [self.navigationController popViewControllerAnimated:YES];
    };
- (IBAction)crossButtonClikd:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:TRUE];

    }
    else
    {
        [self dismissViewControllerAnimated:TRUE completion:^{
                
        }];

    }
  
    
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
