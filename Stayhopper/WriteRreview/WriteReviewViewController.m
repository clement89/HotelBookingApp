//
//  WriteReviewViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 19/10/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "WriteReviewViewController.h"
#import "RequestUtil.h"
#import "MARKRangeSlider.h"
#import "MessageViewController.h"

@interface WriteReviewViewController ()<WebData>
@property (nonatomic, strong) MARKRangeSlider *rangeSlider;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *starWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *starheight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn10Star;

@end

@implementation WriteReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ratingLBL.text=@"Good";
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    self.view.backgroundColor = kColorProfilePages;
    
    

//    self.starWidth.constant=(ratingSubView.frame.size.width-22)/10;
//    self.starheight.constant=(ratingSubView.frame.size.width-22)/10;
    submitButton.clipsToBounds=YES;
    submitButton.layer.cornerRadius=4;
    
    commentTV.clipsToBounds=YES;
    commentTV.layer.cornerRadius=6;
    commentTV.layer.borderWidth=0.5;
    commentTV.layer.borderColor=[UIColor lightGrayColor].CGColor;
    selectedValue=10;
    commentTV.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);

    [self buttonCliak:_btn10Star];
}
-(void)viewWillAppear:(BOOL)animated
{
  //  [super viewWillAppear:YES];
   // [self.view layoutIfNeeded];

//    self.buttonwidth.constant=(ratingSubView.frame.size.width-0)/10;
//    self.buttonHeight.constant=(ratingSubView.frame.size.width-0)/10;
//  [self.view layoutIfNeeded];
   // self.rangeSlider.frame=self.slider1.frame;
   // self.rangeSlider.center=self.slider1.center;
}
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider
{
    if(slider.leftValue<=0)
    {
        ratingLBL.text=@"No Review";
    }else if(slider.leftValue<=2)
    {
        ratingLBL.text=@"Poor";
    }else if(slider.leftValue<=4.0)
    {
        ratingLBL.text=@"Average";
    }
    else if(slider.leftValue<=6.0)
    {
        ratingLBL.text=@"Good";
    }else if(slider.leftValue<=8.0)
    {
        ratingLBL.text=@"Very Good";
    }
    else
       ratingLBL.text=@"Excellent";
 //   ratingLBL.text=[NSString stringWithFormat:@"%@",slider.leftValue];
   
//    self.sliderLBl.text=[NSString stringWithFormat:@"%.0f AED - %.0f AED",slider.leftValue, slider.rightValue];
//
//    currentString=[NSString stringWithFormat:@"%@price=%@",self.valueString,[NSString stringWithFormat:@"%.0f,%.0f",slider.leftValue, slider.rightValue]];
//    selectionString=[NSString stringWithFormat:@"AED %.0f - %.0f",slider.leftValue, slider.rightValue];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)submitAction:(id)sender
{
if(commentTV.text.length!=0)
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

    
    [reqData setObject:self.propertyID forKey:@"property"];
    [reqData setObject:[NSString stringWithFormat:@"%ld",(long)selectedValue] forKey:@"value"];
    [reqData setObject:commentTV.text forKey:@"comment"];
    [reqData setObject:self.bookingID forKey:@"booking_id"];
    [reqData setObject:self.ub_id forKey:@"ub_id"];

    
    //   NSString* locationString=[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    
    //   "email:saleeshprakash@gmail.com
    //subject:test
    //message:Hello this is test"
//    "user:5b8e6cb3898f39016f758eef
//property:5b9f800de74bc64ce6807f14
//value:4
//comment:good facilities"
    
    [self.view endEditing:YES];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
     [util postRequest:reqData withToken:TRUE toUrl:@"userratings" type:@"POST"];
}
    else
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Warning";
        vc.messageString=@"Enter your comments";
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
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
-(IBAction)buttonCliak:(UIButton*)sender
{
    selectedValue=sender.tag;
    for (UIButton *btn in sender.superview.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag<=selectedValue) {
                btn.selected = TRUE;
            }
            else{
                btn.selected = FALSE;

            }
        }
    }
 
    if(selectedValue<=0)
    {
        ratingLBL.text=@"No Review";
    }else if(selectedValue<=2)
    {
        ratingLBL.text=@"Poor";
    }else if(selectedValue<=4.0)
    {
        ratingLBL.text=@"Average";
    }
    else if(selectedValue<=6.0)
    {
        ratingLBL.text=@"Good";
    }else if(selectedValue<=8.0)
    {
        ratingLBL.text=@"Very Good";
    }
    else
        ratingLBL.text=@"Excellent";
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
    
    
    [hud hideAnimated:YES afterDelay:0];
    
    // [propertyArray removeAllObjects];
    
    //    if([rawData objectForKey:@"data"])
    //    {
    //
    //
    //                //loadingLBL.text=@"Your list is empty";
    //                UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //                MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    //                vc.imageName=@"Success";
    //                vc.messageString=@"Feedback Sent";
    //                vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    //                [self.view addSubview:vc.view];
    //
    //    }
    //    else
    //    {
    // loadingLBL.hidden=NO;
    // loadingLBL.text=@"Your list is empty";
    //loadingLBL.text=@"Your list is empty";
    
    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
    if ([rawData[@"status"] isEqualToString:@"Success"]) {
        vc.imageName=@"Succses";
        vc.messageString=rawData[@"message"];//@"Thank you for posting review";

    }
    else{
        vc.imageName=@"Failed";
        vc.messageString=rawData[@"message"];//@"Thank you for posting review";

    }
    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
    [[[UIApplication sharedApplication] keyWindow] addSubview:vc.view];
    [self moveBack];

    //   }
    // [listingTBV reloadData];
}
-(void)moveBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
@end
