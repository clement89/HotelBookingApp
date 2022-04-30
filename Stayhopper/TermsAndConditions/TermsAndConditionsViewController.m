//
//  TermsAndConditionsViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "TermsAndConditionsViewController.h"
#import "MessageViewController.h"
@interface TermsAndConditionsViewController ()

@end

@implementation TermsAndConditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *htmlString = @"<h1>Header</h1><h2>Subheader</h2><p>Some <em>text</em></p><img src='http://blogs.babble.com/famecrawler/files/2010/11/mickey_mouse-1097.jpg' width=70 height=100 />";
//
//    NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
//                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//                                            documentAttributes: nil
//                                            error: nil
//                                            ];
//    termsAndConditions.attributedText = attributedString;
    
    [self loadApi];
    // Do any additional setup after loading the view.
}
-(void)loadApi
{
    
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"";
    
    hud.mode=MBProgressHUDModeText;
    hud.margin = 0.f;
    hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
    hud.removeFromSuperViewOnHide = YES;
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    
  
    
    
    
    [self.view endEditing:YES];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"termsAndConditions"] type:@"GET"];
    
    //  apiStatus=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    [hud hideAnimated:YES afterDelay:0];
if([rawData objectForKey:@"data"] )
{
    if([[rawData objectForKey:@"data"] count ]>0)
    {
    NSDictionary*dic=[[rawData objectForKey:@"data"] objectAtIndex:0];
   ///termsandconditions
        NSString *htmlString =[dic valueForKey:@"description"];
    
  //  htmlString = [htmlString stringByAppendingString:@"<style>body{font-family:'YOUR_FONT_HERE'; font-size:'SIZE';}</style>"];
    /*Example:
     
     htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",_myLabel.font.fontName,_myLabel.font.pointSize]];
     */
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    termsAndConditions.attributedText = attributedString;
    }
}
    
}
-(IBAction)backFunction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
{
    
    hud.margin = 10.f;
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
    [hud hideAnimated:YES afterDelay:0];
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    vc.imageName=@"Failed";
    vc.messageString=errorMessage;
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [self.view addSubview:vc.view];
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
