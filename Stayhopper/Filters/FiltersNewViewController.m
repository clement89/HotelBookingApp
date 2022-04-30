//
//  FiltersNewViewController.m
//  Stayhopper
//
//  Created by antony on 20/11/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "FiltersNewViewController.h"
#import "MessageViewController.h"
#import "MBProgressHUD.h"
#import"RequestUtil.h"
#import "Stayhopper-Swift.h"
#import "SingletonClass.h"
#import "Enums.h"
static int minimumIteminSection = 3;

@interface FiltersNewViewController ()
{
    MBProgressHUD *hud;
    NSMutableSet *expandedSections,*didselectChanges;
    NSMutableArray *currentDictionary;
    int selMin,selMax;
    NSString *sortItem;
}
@property (weak, nonatomic) IBOutlet RangeSeekSlider *rangeSlider;

@property (weak, nonatomic) IBOutlet UIView *viewSortContainer;
@property (weak, nonatomic) IBOutlet UITableView *tblFilter;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstarint;

@end

@implementation FiltersNewViewController

@synthesize isFromMapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
    _lblTitle.textColor = kColorDarkBlueThemeColor;
    self.view.backgroundColor = kColorCommonBG;
    _tblFilter.backgroundColor = self.view.backgroundColor;
    _tblFilter.delegate  =self;
    _tblFilter.dataSource = self;
    expandedSections = [[NSMutableSet alloc] init];
    didselectChanges = [[NSMutableSet alloc] init];
    
    //CJC 10
    if(isFromMapView){
        _lblTitle.text = @"Filter";
        _sortView.hidden = YES;
        _heightConstarint.constant = 20;

    }else{
        _heightConstarint.constant = 70;

    }

   // currentDictionary = [[ NSMutableArray alloc] initWithArray:<#(nonnull NSArray *)#>];
     if ([[SingletonClass getInstance].filterListDictionary count] == 0) {
        [self loadApi];
    }
    selMin = [SingletonClass getInstance].selectedMinimumPrice;
    selMax = [SingletonClass getInstance].selectedMaximumPrice;
    if (selMin!=-1) {
        _rangeSlider.selectedMinValue  = (float)selMin;
        _rangeSlider.selectedMaxValue  = (float)selMax;


        
    }
    sortItem = [SingletonClass getInstance].currentSortSelection;
    [self setSortButtons];

    // Do any additional setup after loading the view.
}
- (IBAction)actionRangerSlider:(id)sender
{
    

  
    RangeSeekSlider *slider = (RangeSeekSlider *)sender;
   {
        
        [SingletonClass getInstance].selectedMinimumPrice = (int) (slider.selectedMinValue + 0.5);
       [SingletonClass getInstance].selectedMaximumPrice = (int) (slider.selectedMaxValue + 0.5);

       NSLog(@"min %d max %d",[SingletonClass getInstance].selectedMinimumPrice,[SingletonClass getInstance].selectedMaximumPrice);
    }
  
}
-(void)loadApi
{
    
    
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"";
    
    hud.mode=MBProgressHUDModeText;
    hud.margin = 0.f;
    hud.offset = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-50);
    hud.removeFromSuperViewOnHide = YES;
    NSMutableDictionary *reqData = [NSMutableDictionary dictionary];
    
  
    
    
    
    [self.view endEditing:YES];
    
    RequestUtil *util = [[RequestUtil alloc]init];
    util.webDataDelegate=(id)self;
    [util postRequest:reqData toUrl: [NSString stringWithFormat: @"properties/filters"] type:@"GET"];
    
    //  apiStatus=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webRawDataReceived:(NSDictionary *)rawData
{
if([rawData objectForKey:@"data"] )
{
  [SingletonClass getInstance].filterListDictionary = [rawData objectForKey:@"data"];
   

    [_tblFilter reloadData];
}
else
    {
        UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
        vc.imageName=@"Failed";
         if([rawData objectForKey:@"message"] )
         {
            vc.messageString=[rawData objectForKey:@"message"];

        }
        else
        {
            vc.messageString=@"Unable to load at this time! Try again later";

        }
        vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
        [self.view addSubview:vc.view];

    }
    [hud hideAnimated:YES afterDelay:0];

}
-(IBAction)backButtonActionn:(id)sender
{
    
      

    if (didselectChanges.count==0 && selMax ==[SingletonClass getInstance].selectedMaximumPrice
        && selMin==[SingletonClass getInstance].selectedMinimumPrice && [[SingletonClass getInstance].currentSortSelection isEqualToString:sortItem])
    {
        NSLog(@"no need to reload list arrayaaa");

    }
    else{
        NSLog(@"reload list arrayaaa");
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFilterItemsChanges object:nil];
    }
    [self dismissViewControllerAnimated:TRUE completion:^{
         
    }];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
float headerHt = 45;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return headerHt;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self shouldShowFooterInSection:section]) {
        return headerHt;

    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([[SingletonClass getInstance].filterListDictionary count] == 0) {
        return 0;
    }
    return kFilterCount;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"headerCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton *btnMore = [[cell.contentView viewWithTag:-10] viewWithTag:2];
    UILabel *lblTitle = [[cell.contentView viewWithTag:-10] viewWithTag:1];

    lblTitle.text = [NSString stringWithFormat:@"%@",[[SingletonClass getInstance] selectedFiltersArray][section][@"title"]];
    btnMore.hidden = TRUE;
    cell.contentView.backgroundColor = _tblFilter.backgroundColor;

    return cell.contentView;
 }
-(BOOL)shouldShowFooterInSection:(NSInteger)section
{
    NSArray *itemsArray = [[SingletonClass getInstance] filterListDictionary][[[SingletonClass getInstance] selectedFiltersArray][section][@"key"]];
    
    if ([itemsArray isKindOfClass:[NSArray class]]) {
        if ([expandedSections containsObject:[NSString stringWithFormat:@"%ld",(long)section]]) {
            return NO;
        }
        else
        {
            if (itemsArray.count<=minimumIteminSection) {
                return NO;
            }
            return YES;
            
        }
    }
    return NO;

}
-(void)moreButtonClikd:(UIButton*)button
{
    if ([expandedSections containsObject:button.restorationIdentifier]) {
        [expandedSections removeObject:button.restorationIdentifier] ;
    }
    else
    {
        [expandedSections addObject:button.restorationIdentifier] ;

        
    }
    [_tblFilter reloadData];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    if ([self shouldShowFooterInSection:section]) {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *btnMore = [[cell.contentView viewWithTag:-10] viewWithTag:2];
        UILabel *lblTitle = [[cell.contentView viewWithTag:-10] viewWithTag:1];
        NSArray *itemsArray = [[SingletonClass getInstance] filterListDictionary][[[SingletonClass getInstance] selectedFiltersArray][section][@"key"]];

        lblTitle.text = [NSString stringWithFormat:@"More (%d)",(int)itemsArray.count-minimumIteminSection];
        btnMore.hidden = FALSE;
        btnMore.restorationIdentifier = [NSString stringWithFormat:@"%ld",section];
        [btnMore addTarget:self action:@selector(moreButtonClikd:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentView.backgroundColor = _tblFilter.backgroundColor;
        return cell.contentView;
    }
    return nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *itemsArray = [[SingletonClass getInstance] filterListDictionary][[[SingletonClass getInstance] selectedFiltersArray][section][@"key"]];
    
    if ([itemsArray isKindOfClass:[NSArray class]]) {
        if ([expandedSections containsObject:[NSString stringWithFormat:@"%ld",(long)section]]) {
            return itemsArray.count;
        }
        else
        {
            return MIN(itemsArray.count, minimumIteminSection);
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *filt = [[SingletonClass getInstance] selectedFiltersArray][indexPath.section];
    NSArray *itemsArray = [[SingletonClass getInstance] filterListDictionary][filt[@"key"]];
    NSMutableSet *idsAr =filt[@"ids"];

    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"normalCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *imgIcon = [[cell.contentView viewWithTag:-10] viewWithTag:2];
    UILabel *lblTitle = [[cell.contentView viewWithTag:-10] viewWithTag:1];

    lblTitle.text = [NSString stringWithFormat:@"%@",itemsArray[indexPath.row][@"name"]];
    if ([idsAr containsObject:itemsArray[indexPath.row][@"_id"]]) {
        imgIcon.highlighted = TRUE;
    }
    else{
        imgIcon.highlighted = FALSE;

    }
    cell.contentView.backgroundColor = _tblFilter.backgroundColor;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *filt = [[[SingletonClass getInstance] selectedFiltersArray][indexPath.section] mutableCopy];
   NSArray *itemsArray = [[SingletonClass getInstance] filterListDictionary][filt[@"key"]];
    NSMutableSet *idsAr =filt[@"ids"];
    NSString *selId = itemsArray[indexPath.row][@"_id"];
    if ([idsAr containsObject:selId]) {
        [idsAr removeObject:selId];
    }
    else{
        [idsAr addObject:selId];

    }
    filt[@"ids"] = idsAr;
    
   
    [[SingletonClass getInstance] selectedFiltersArray][indexPath.section] =filt;
    if ([didselectChanges containsObject:selId]) {
        [didselectChanges removeObject:selId];

    }
    else{
        [didselectChanges addObject:selId];

    }
    
    [_tblFilter reloadData];
}
- (IBAction)btnSortSelectionChanged:(UIButton*)btn {
    if ([btn.restorationIdentifier isEqualToString:[SingletonClass getInstance].currentSortSelection]) {
        [SingletonClass getInstance].currentSortSelection = @"";
    }
    else{
        [SingletonClass getInstance].currentSortSelection = btn.restorationIdentifier;
    }
    [self setSortButtons];
}
-(void)setSortButtons
{
    for (UIButton *btn in _viewSortContainer.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.layer.cornerRadius==0.0) {
                btn.layer.cornerRadius = btn.frame.size.height/2.;
            }
            if ([btn.restorationIdentifier isEqualToString:[SingletonClass getInstance].currentSortSelection]) {
                btn.backgroundColor = kColorDarkBlueThemeColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else{
                btn.backgroundColor = UIColorFromRGB(0xC1C8DB);
                [btn setTitleColor:[UIColor colorWithRed:26./255. green:30./255. blue:102./255. alpha:0.5] forState:UIControlStateNormal];
            }
        }
    }
}
@end
