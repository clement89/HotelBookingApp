//
//  PaymentViewViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 23/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "PaymentViewViewController.h"
#import "MessageViewController.h"
@interface PaymentViewViewController ()

@end

@implementation PaymentViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:self.pauURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [paymentWebView loadRequest:requestObj];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *currentURL = [NSString stringWithFormat:@"%@", webView.request.mainDocumentURL ];
    
    if([currentURL isEqualToString:self.pauURL])
    {
    }else{
         if([[currentURL uppercaseString] containsString:[@"success" uppercaseString]])
         {
             [self.navigationController popViewControllerAnimated:YES];

             [[NSNotificationCenter defaultCenter] postNotificationName:@"paymentDone" object:nil];
    }else if([[currentURL uppercaseString] containsString:[@"failed" uppercaseString]])
             {
                 
                 [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"payStatus"  ];
                 
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [self.navigationController popViewControllerAnimated:YES];

                 


             }
             
 }


}
  -(void)moveBack
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
