//
//  AboutTabedViewController.m
//  Stayhopper
//
//  Created by Bryno Baby on 28/09/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import "AboutTabedViewController.h"
#import "DescriptionDetailsViewController.h"
#import "FacilitiesViewController.h"
#import "PiliciesDetailsViewController.h"
#import "URLConstants.h"


@interface AboutTabedViewController ()
 

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation AboutTabedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
   _lblTitle.superview.layer.shadowOpacity = 0.3;
   _lblTitle.superview.layer.shadowRadius = 2.0;
   _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
_lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
_lblTitle.textColor = kColorDarkBlueThemeColor;

self.view.backgroundColor = kColorProfilePages;
    _lblTitle.text = self.selectedPropName;
    
    menueArray=[[NSArray alloc]initWithObjects:@"DESCRIPTION",@"FACILITIES",@"POLICIES", nil];
    self.slideImgWidth.constant=100;
    selectedPropLBL.text=self.selectedPropName;
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    
    self.slideImgWidth.constant=100;
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DescriptionDetailsViewController  *roomsListViewController = [storyBoard instantiateViewControllerWithIdentifier:@"DescriptionDetailsViewController"];
   
    roomsListViewController.dataDIC=self.loadedDIC;
    roomsListViewController.view.frame = CGRectMake(0,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
    [self addChildViewController:roomsListViewController];
    [menuDetailsScrolView addSubview:roomsListViewController.view];
    
    /////////
    
    FacilitiesViewController  *aboutPropertyViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FacilitiesViewController"];
   // aboutPropertyViewController.selectedProperty=self.selectedProperty;
    //aboutPropertyViewController.loadedsProperty=self.loadedProperty;
    NSMutableArray* srviceArray=[[NSMutableArray alloc]init];
    for(NSDictionary* dicVal in [self.loadedDIC  objectForKey:@"rooms"])
    {
        for(NSDictionary* dicValue in [dicVal objectForKey:@"services"])
            
            
        {
            BOOL isAvailbale=NO;
            
            for(NSDictionary* dicAdded in srviceArray)
            {
                if([[dicAdded valueForKey:@"_id"] isEqualToString:[dicValue valueForKey:@"_id"]])
                    isAvailbale=YES;
            }
            if(!isAvailbale)
                [srviceArray addObject:dicValue];
        }
    }
    
    aboutPropertyViewController.availableServices=srviceArray;
    

    
    aboutPropertyViewController.view.frame = CGRectMake(menuDetailsScrolView.frame.size.width*1,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
    [self addChildViewController:aboutPropertyViewController];
    [menuDetailsScrolView addSubview:aboutPropertyViewController.view];
    
    ///////
    
    
    PiliciesDetailsViewController  *reviewListViewController = [storyBoard instantiateViewControllerWithIdentifier:@"PiliciesDetailsViewController"];
    reviewListViewController.view.frame = CGRectMake(menuDetailsScrolView.frame.size.width*2,0,menuDetailsScrolView.frame.size.width,menuDetailsScrolView.frame.size.height);
    
    reviewListViewController.dataDIC=self.loadedDIC;
    [self addChildViewController:reviewListViewController];
    [menuDetailsScrolView addSubview:reviewListViewController.view];
    
    /////////
   
    menuDetailsScrolView.contentSize=CGSizeMake(menuDetailsScrolView.frame.size.width*3, 0);
    clickedIndex=[self.indexString integerValue];
    
    [self loadViewSubViewsToScrollView:[self.indexString integerValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return menueArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        typeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"TypeCollectionViewCell" forIndexPath:indexPath];
        
        typeCell.type.text=[menueArray objectAtIndex:indexPath.item];
       // [typeCell.type setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        
        return typeCell;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return CGSizeMake(100, collectionView.frame.size.height);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
        [UIView animateWithDuration:0.5f animations:^{
            
            _slideImgLeading.constant=indexPath.item*100;
            [self.view layoutIfNeeded];
            
        }];
        clickedIndex=indexPath.item;
        [self loadViewSubViewsToScrollView:indexPath.item];
        //   [_mallOptionsCollectionView reloadData];
        
    
}
-(void)loadViewSubViewsToScrollView:(NSInteger)index{
    
    if(clickedIndex==0){
        [UIView animateWithDuration:0.5f animations:^{
            menuDetailsScrolView.contentOffset=CGPointMake(0,0);
        }];
    }
    else if(clickedIndex==1){
        [UIView animateWithDuration:0.5f animations:^{
            menuDetailsScrolView.contentOffset=CGPointMake((menuDetailsScrolView.frame.size.width),0);
        }];
    }
    else if(clickedIndex==2){
        [UIView animateWithDuration:0.5f animations:^{
            menuDetailsScrolView.contentOffset=CGPointMake(2*(menuDetailsScrolView.frame.size.width),0);
        }];
    }
    else if(clickedIndex==3){
        [UIView animateWithDuration:0.5f animations:^{
            menuDetailsScrolView.contentOffset=CGPointMake(3*(menuDetailsScrolView.frame.size.width),0);
        }];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _slideImgLeading.constant=index*100;
        [self.view layoutIfNeeded];
    }];
    clickedIndex=index;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)backFunction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
};
@end
