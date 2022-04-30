//
//  FacilitiesViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 28/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "FacilitiesViewController.h"
#import "FacilitiesCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "URLConstants.h"
@interface FacilitiesViewController ()

@end

@implementation FacilitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.availableServices count];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    
//    //if(indexPath.row%2==0)
//        cell.transform = CGAffineTransformMakeTranslation(0.f, 100);
//   // else
//    //    cell.transform = CGAffineTransformMakeTranslation(0, 100);
//    
//    // cell.transform = CGAffineTransformMakeTranslation(50.f, 100);
//    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=(FacilitiesCellTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"FacilitiesCellTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString*imgName=[[self.availableServices objectAtIndex:indexPath.item] valueForKey:@"image"];
    NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    [cell.iconImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
    cell.titleLBL.text=[[self.availableServices objectAtIndex:indexPath.item] valueForKey:@"name"];
    return cell;
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
