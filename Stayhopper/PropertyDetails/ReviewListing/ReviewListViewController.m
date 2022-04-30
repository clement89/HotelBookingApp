//
//  ReviewListViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 29/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "ReviewListViewController.h"
#import "MessageViewController.h"
#import "NotificationsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "URLConstants.h"
@interface ReviewListViewController ()

@end

@implementation ReviewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // selectedIndex=-1;

    
    status=YES;
    listingTableView.estimatedRowHeight = 160.0;
    listingTableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = kColorHotelDetailsBG;
    listingTableView.backgroundColor = kColorHotelDetailsBG;
    ratingUserCount.backgroundColor = [UIColor clearColor];
    ratingUserCount.superview.backgroundColor = kColorHotelDetailsBG;
    // Do any additional setup after loading the view.
   // [self loadApi];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if(self.dataArray.count!=0)
    {
        NOreviewratingValue.hidden=YES;

    ratingValue.text=[NSString stringWithFormat:@"%.1f ",[self.ratingValue1 floatValue]];
    ratingUserCount.text=[NSString stringWithFormat:@"From %lu People",(unsigned long)self.dataArray.count];
        
        if([self.ratingValue1 floatValue]<=2.0)
    {
        ratingString.text=@"Poor";
    }
    else if([self.ratingValue1 floatValue]<=4.0)
    {
        ratingString.text=@"Average";
    }
    else if([self.ratingValue1 floatValue]<=6.0)
    {
        ratingString.text=@"Good";
    }else if([self.ratingValue1 floatValue]<8.0)
    {
        ratingString.text=@"Very Good";
    }
    else
        ratingString.text=@"Excellent";
    }
    else{
        
        NOreviewratingValue.hidden=NO;

    }
//    
//    if([self.ratingValue1 floatValue]<=0)
//    {
//        
//        //CJC 3
//        ratingString.text=@"";
//        ratingUserCount.text = @"There are no customer reviews yet.";
//        ratingValue.text = @"";
//
//        
//        
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)loadApi
//{
//
//
//
//    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.label.text = @"";
//
//    hud.mode=MBProgressHUDModeText;
//    hud.margin = 0.f;
//    hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
//    hud.removeFromSuperViewOnHide = YES;
//    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
//
//
//
//
//    [self.view endEditing:YES];
//
//    RequestUtil *util = [[RequestUtil alloc]init];
//    util.webDataDelegate=(id)self;
//    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"notifications"] type:@"GET"];
//
//    //  apiStatus=NO;
//}


-(void)webRawDataReceived:(NSDictionary *)rawData
{
//    hud.margin = 10.f;
//    [hud hideAnimated:YES afterDelay:0];
//    if([rawData objectForKey:@"data"])
//    {
//        listArray=[rawData objectForKey:@"data"];
//    }
//    [listingTableView reloadData];
    
    
}
-(IBAction)backFunction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)requestUtil:(RequestUtil *)util error:(NSString *)response
//{
//
////   // hud.margin = 10.f;
////   // [hud hideAnimated:YES afterDelay:0];
////
////    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
////    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
////    vc.imageName=@"Failed";
////    vc.messageString=response;
////    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
////    [self.view addSubview:vc.view];
//
//
//}
//-(void)webRawDataReceivedWithError:(NSString *)errorMessage
//{
//  //  hud.margin = 10.f;
//   // [hud hideAnimated:YES afterDelay:0];
//    
//    UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
//    vc.imageName=@"Failed";
//    vc.messageString=errorMessage;
//    vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
//    [self.view addSubview:vc.view];
//}
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(ReviewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ReviewTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"comment"]]];
    NSInteger leng2=str2.length;
    
    [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:14.0] range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSForegroundColorAttributeName value:cell.commentsTV.textColor range:NSMakeRange(0, leng2)];
    
    cell.commentsTV.attributedText=str2;
//    [cell.commentsTV sizeToFit];
    cell.nameLBL.text=@"Unknown";
    if([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"user"])
    {
      if([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"name"])
            cell.nameLBL.text=[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"name"];
        
        
        
        if([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"image"])
            {
                NSString*imgName=[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"image"];
                NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
                [cell.proPic sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder"]];
                
                
                
            }
        else
            cell.proPic.image=[UIImage imageNamed:@"QOMPlaceholder"];
        
        
        
    }
    
   // cell.titleLBL.text=[[listArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    //cell.desceriptionTV.text=[[listArray objectAtIndex:indexPath.row] valueForKey:@"description"];
    if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"value"] floatValue]<=0)
    {
        cell.ratingLBL.text=@"No Review";
    }else if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"value"] floatValue]<=2.0)
    {
        cell.ratingLBL.text=@"Poor";
    }
    else if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"value"] floatValue]<=4.0)
    {
        cell.ratingLBL.text=@"Average";
    }
    else if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"value"] floatValue]<=6.0)
    {
        cell.ratingLBL.text=@"Good";
    }else if([[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"value"] floatValue]<8.0)
    {
        cell.ratingLBL.text=@"Very Good";
    }
    else
        cell.ratingLBL.text=@"Excellent";
    
    cell.lblTitle.text = cell.nameLBL.text;
    cell.nameLBL.text =  @"";
    cell.commentID=[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"_id"];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"comment"]]];
    NSInteger leng2=str2.length;
    
    [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"ProximaNovaA-Regular" size:14.0] range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng2)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, leng2)];
    
    NSDictionary *attributesName = @{NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaA-Regular" size:14.0f]};


    CGRect r1 = [[[self.dataArray objectAtIndex:indexPath.row] valueForKey:@"comment"] boundingRectWithSize:CGSizeMake((tableView.frame.size.width-70), 0)
                                                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                attributes:attributesName
                                                                                                   context:nil];
//    CGRect r1 = [[[listArray objectAtIndex:indexPath.row] valueForKey:@"description"] boundingRectWithSize:CGSizeMake((tableView.frame.size.width-40), 0)
//                                                                                                   options:NSStringDrawingUsesLineFragmentOrigin
//                                                                                                attributes:attributesName
//                                                                                                   context:nil];
    
    
    return r1.size.height+180;
    
   
    
    return str2.size.height+108;
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
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        if(status)
 [[NSNotificationCenter defaultCenter] postNotificationName:@"movetobottom" object:nil];
        status=YES;
        // Scroll down direction
    } else {
        if(status)
        {
            listingTableView.contentOffset=CGPointMake(0, 0);
        }
        status=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"movetotop" object:nil];
        // Scroll to up
    }
    // self.lastContentOffset = currentOffset;
}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"movetotop" object:nil];
//}
@end



