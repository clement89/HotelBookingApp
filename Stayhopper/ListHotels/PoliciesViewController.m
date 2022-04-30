//
//  PoliciesViewController.m
//  Stayhopper
//
//  Created by antony on 07/12/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "PoliciesViewController.h"
#import "URLConstants.h"

@interface PoliciesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation PoliciesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
      _lblTitle.superview.layer.shadowOpacity = 0.3;
      _lblTitle.superview.layer.shadowRadius = 2.0;
      _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
       _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
       _lblTitle.textColor = kColorDarkBlueThemeColor;
    self.view.backgroundColor = kColorProfilePages;
    // Do any additional setup after loading the view.
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
