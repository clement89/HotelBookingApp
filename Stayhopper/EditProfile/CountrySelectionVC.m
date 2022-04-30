//
//  CountrySelectionVC.m
//  HHPOManagement
//
//  Created by XXX on 8/26/18.
//  Copyright © 2018 XXX. All rights reserved.
//

#import "CountrySelectionVC.h"
#import "CountryListDataSource.h"
#import "URLConstants.h"
#import "Commons.h"

@interface CountrySelectionVC ()
{
    BOOL oneTiemFlag;
    NSString *selectedCountryCode;

}
@property(nonatomic, retain)IBOutlet UITableView *tblCountries;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnDOne;

@end

@implementation CountrySelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
//_lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
_lblTitle.textColor = kColorDarkBlueThemeColor;

    
    _btnDone.titleLabel.font = _lblTitle.font;
    
//    self.view.backgroundColor = kThemeBGColor;
//    self.tblCountries.backgroundColor = kThemeBGColor;
    
   // [self.tblCountries setSeparatorColor:kThemeTableSeperatorColor];
    
    //    [self navigationItem].title =@"Your Country";
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backarrow"]
    //                                                             style:UIBarButtonItemStylePlain
    //                                                            target:self action:@selector(dismissVC)];
    //    self.navigationItem.leftBarButtonItem = left;
    
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    }
    if (_currentIndex>=0&&_currentIndex<_dataRows.count) {
        selectedCountryCode = [NSString stringWithFormat:@"+%@",[[_dataRows objectAtIndex:_currentIndex] valueForKey:kCountryCallingCode]];

    }
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
  
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
//    self.navigationController.navigationBarHidden = YES;
    
}
-(void)dismissVC
{
    [self.navigationController popViewControllerAnimated:TRUE];
    
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillLayoutSubviews

{
    if (oneTiemFlag==FALSE) {
        oneTiemFlag =TRUE;
        if(_currentIndex>=0 && _currentIndex<self.dataRows.count)
        {
            [self.tblCountries scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    
    
}
#pragma mark - Table view data source



#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"countryCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *country = (UILabel*) [cell.contentView viewWithTag:1];
    UILabel *code = (UILabel*) [cell.contentView viewWithTag:2];
    country.font = [UIFont fontWithName:_lblTitle.font.fontName size:country.font.pointSize];
    code.font = [UIFont fontWithName:_lblTitle.font.fontName size:code.font.pointSize];

    country.text = [[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryName];
    code.text = [NSString stringWithFormat:@"+%@",[[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode]];
    country.textColor =[UIColor blackColor];// kThemeTextColor;
    code.textColor =[UIColor blackColor];// kThemeTextColor;
    
    
    if (indexPath.row == _currentIndex)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
        // [cell.contentView viewWithTag:3] .backgroundColor=[UIColor colorWithRed:(168.0/255.0f) green:(209.0/255.0f) blue:(152.0/255.0f) alpha:1];
        
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        
        // [cell.contentView viewWithTag:3].backgroundColor=[UIColor whiteColor];
        
    }
    cell.backgroundColor = [UIColor whiteColor]; //kThemeBGColor;
    cell.contentView.backgroundColor = [UIColor whiteColor];// kThemeBGColor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != _currentIndex)
    {
        
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
        _currentIndex = (int)indexPath.row;
        selectedCountryCode = [NSString stringWithFormat:@"+%@",[[_dataRows objectAtIndex:indexPath.row] valueForKey:kCountryCallingCode]];
        [tableView reloadData];
        //   [tableView reloadRowsAtIndexPaths:@[oldIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }
    
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)doneAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(didSelectCountry:)]) {
        [self.delegate didSelectCountry:_currentIndex];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else if ([_delegate respondsToSelector:@selector(didSelectCountrywithCountryCode:)]) {
        [self.delegate didSelectCountrywithCountryCode:selectedCountryCode];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
        
    else {
        NSLog(@"CountryListView Delegate : didSelectCountry not implemented");
    }
    [self.navigationController popViewControllerAnimated:TRUE];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)doneBtnClikd:(id)sender {
    [self doneAction:nil];
}

@end
