//
//  GetHelpViewController.m
//  Stayhopper
//
//  Created by antony on 03/10/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "GetHelpViewController.h"
#import "URLConstants.h"
#import "ProfileListTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface GetHelpViewController ()
{
    NSArray *listArray,*imageArray;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation GetHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
    self.view.backgroundColor = kColorProfilePages;
    listArray = [[NSArray alloc]initWithObjects:@"FAQ",@"Support email submission",@"Whatsapp Business chat", nil];;
    imageArray = [[NSArray alloc]initWithObjects:@"Frequent",@"Support email",@"Whatsapp Business chat",@"logout", nil];;

    
    // Do any additional setup after loading the view.
}
- (IBAction)backButtonActionn:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  ProfileListTableViewCell* cell=(ProfileListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"ProfileListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImage.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.listTitle.text=[listArray objectAtIndex:indexPath.row];
    UIImageView *imgArrow =[cell.contentView viewWithTag:3];
    imgArrow.hidden = FALSE;

    if (indexPath.row==2) {
        imgArrow.hidden = TRUE;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.row==0) {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        
        UIViewController *vc = [y   instantiateViewControllerWithIdentifier:@"FAQViewController"];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:TRUE completion:^{
             
        }];
       // vc.fromString=@"presentViewTab";
       // [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==1) {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        
        UIViewController *vc = [y   instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:TRUE completion:^{
             
        }];
        
       /* if([MFMailComposeViewController canSendMail]) {
               MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
               mailCont.mailComposeDelegate = (id)self;
                [mailCont setToRecipients:[NSArray arrayWithObject:@"support@stayhopper.com"]];
               [mailCont setSubject:@""];
               [mailCont setMessageBody:[@"" stringByAppendingString:@""] isHTML:NO];
               [self presentViewController:mailCont animated:YES completion:nil];
           }
        else
        {
            
        }*/
    }
    else if (indexPath.row==2) {
        NSString *completePhoneNumber = @"971564174254";
        NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.whatsapp.com/send?phone=%@&text=",completePhoneNumber]];
        
        NSURL *whatsappURLAppInstalled = [NSURL URLWithString:@"whatsapp://send?text=Hello%2C%20World!"];
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURLAppInstalled]) {
            if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
                [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
            }
            else
            {
                
            }
        }

    }
    

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    //handle any error
    [controller dismissViewControllerAnimated:YES completion:nil];
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
