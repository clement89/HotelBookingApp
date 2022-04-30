//
//  NotificationsViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "NotificationsViewController.h"
#import "MessageViewController.h"
#import "NotificationsTableViewCell.h"
@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex=-1;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
     // if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"])
    [self loadApi];
//    else
//    {
//        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
//        vc.imageName=@"Failed";
//        vc.messageString=@"";
//        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
//        [self.view addSubview:vc.view];
//    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"])

    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"notifications/new?user_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"]] type:@"GET"];
    else
         [util postRequest:reqData toUrl: [NSString stringWithFormat: @"notifications/new?user_id="] type:@"GET"];
    
  //  [util postRequest:reqData toUrl: [NSString stringWithFormat: @"notifications/new?user_id=5c122298352c8811a4b4105f"] type:@"GET"];
}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
   
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  
    hud.margin = 10.f;
    [hud hideAnimated:YES afterDelay:0];
    if([rawData objectForKey:@"data"])
    {
        listArray=[rawData objectForKey:@"data"];
    }
    
    
    
    for(NSDictionary* dic in listArray)
    {
        if(![[dic valueForKey:@"read_status"] boolValue])
        {
            [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
            
        }
    }
    [listingTableView reloadData];
    if([rawData objectForKey:@"message"] )
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
        vc.messageString=[rawData objectForKey:@"message"];
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(NotificationsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NotificationsTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLBL.text=[[listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    
   
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[listArray objectAtIndex:indexPath.row] valueForKey:@"body"]]];
    NSInteger leng2=str2.length;
    
    [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:15.0] range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, leng2)];
    
    
    cell.desceriptionTV.attributedText=str2;
    if([[[listArray objectAtIndex:indexPath.row] valueForKey:@"read_status"] boolValue])
    {
      cell.bgView.alpha=.5;
    }else{cell.bgView.alpha=1;}
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    NSDictionary *attributesName = @{NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaA-Regular" size:21.0f]};
    
    
    CGRect r1 = [[[listArray objectAtIndex:indexPath.row] valueForKey:@"body"] boundingRectWithSize:CGSizeMake((tableView.frame.size.width-50), 0)
                                                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                attributes:attributesName
                                                                                                   context:nil];
    
    
    return r1.size.height+100;
    //You can set height of cell here.
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(indexPath.row%2==0)
    //        cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
    //    else
    //        cell.transform = CGAffineTransformMakeTranslation(0, 100);
    //    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    //    cell.layer.shadowOffset = CGSizeMake(10, 10);
    //    cell.alpha = 0;
    //
    //    //2. Define the final state (After the animation) and commit the animation
    //    [UIView beginAnimations:@"rotation" context:NULL];
    //    [UIView setAnimationDuration:0.3];
    //    cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
    //    cell.alpha = 1;
    //    cell.layer.shadowOffset = CGSizeMake(0, 0);
    //    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if(![[[listArray objectAtIndex:indexPath.row] valueForKey:@"read_status"] boolValue])

    {
    RequestUtil *util1 = [[RequestUtil alloc]init];
 NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    [reqData setObject:[[listArray objectAtIndex:indexPath.row] objectForKey:@"_id"] forKey:@"id"];

        [util1 postRequest:reqData toUrl: [NSString stringWithFormat: @"notifications/read"] type:@"POST"];
        if([UIApplication sharedApplication].applicationIconBadgeNumber>0)
         [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber-1;
        
    }
   
    
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        if(![[[[listArray objectAtIndex:indexPath.row] objectForKey:@"notification_type"] uppercaseString] isEqualToString:@"GENERAL"])
        {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userID"])
        {
            if([[listArray objectAtIndex:indexPath.row] objectForKey:@"book_id"])
            {
                if([[[[listArray objectAtIndex:indexPath.row] objectForKey:@"notification_type"] uppercaseString] isEqualToString:@"EXTEND"])
                {
                    [defaults setValue:@"Rebooking" forKey:@"pushClick"];
                    
                    [defaults setValue:[[listArray objectAtIndex:indexPath.row] objectForKey:@"book_id"] forKey:@"book_id"];
                    
                    [defaults setValue:[[listArray objectAtIndex:indexPath.row] objectForKey:@"notification_type"] forKey:@"type"];
                    
                    
                 //   [defaults setValue:@"YES" forKey:@"fromClickNoti"];
                    [defaults synchronize];

                      [[NSNotificationCenter defaultCenter] postNotificationName:@"pushClick" object:nil];
                }
                else
                {
                    if( [[listArray objectAtIndex:indexPath.row] objectForKey:@"notification_type"])
                    {
                        [defaults setValue:[[listArray objectAtIndex:indexPath.row] objectForKey:@"notification_type"] forKey:@"pushClick"];
                        
                        [defaults setValue:[[listArray objectAtIndex:indexPath.row] objectForKey:@"book_id"] forKey:@"book_id"];
                        
                        [defaults setValue:[[listArray objectAtIndex:indexPath.row] objectForKey:@"notification_type"] forKey:@"type"];
                       // [defaults setValue:@"YES" forKey:@"fromClickNoti"];
                        [defaults synchronize];

                        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushClick" object:nil];

                    }
                }
                
            }
        }
        }else
        {
            
            [self.navigationController popViewControllerAnimated:YES];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"toHome" object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toHome)   name:@"toHome" object:nil];
        }
    }
    
}

@end


