//
//  SettingsViewController.m
//  Stayhopper
//
//  Created by antony on 03/10/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "SettingsViewController.h"
#import "URLConstants.h"
#import "ProfileListTableViewCell.h"
#import "TERMSWEBViewController.h"
@interface SettingsViewController ()
{
    NSArray *listArray,*imageArray;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    
    self.view.backgroundColor = kColorProfilePages;
    listArray = [[NSArray alloc]initWithObjects:@"Terms & Conditions",@"Privacy Policy", nil];;
    imageArray = [[NSArray alloc]initWithObjects:@"Get help",@"Listproprty", nil];//CJC 11

    
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

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (indexPath.row==0) {
        //Terms & conditions
//        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
//        TERMSWEBViewController *vc = [y   instantiateViewControllerWithIdentifier:@"SettingsViewController"];
//        [self.navigationController pushViewController:vc animated:YES];

        
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        
        TERMSWEBViewController *vc = [y   instantiateViewControllerWithIdentifier:@"TERMSWEBViewController"];
        vc.WEBSTRING=@"https://stayhopper.com/terms-and-conditions?noheader";//CJC 6
        vc.titleString = @"Terms & conditions";

        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:TRUE completion:^{
             
        }];
       // vc.fromString=@"presentViewTab";
       // [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==1) {
        // Privacy Policy
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main_New" bundle:nil];
        
        TERMSWEBViewController *vc = [y   instantiateViewControllerWithIdentifier:@"TERMSWEBViewController"];
//        vc.WEBSTRING=@"https://stayhopper.com/terms.html#noheader";
        vc.titleString = @"Privacy policy";
        vc.WEBSTRING=@"https://stayhopper.com/privacy-policy?noheader";//CJC 6

        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:TRUE completion:^{
             
        }];
        
      
    }
    else if (indexPath.row==2) {
        
    }
    

}

@end
