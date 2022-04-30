//
//  WalkThroughViewController.m
//  WalkthroughPOC
//
//  Created by antony on 05/10/2020.
//

#import "WalkThroughViewController.h"
#import "URLConstants.h"
#import "AppDelegate.h"

@interface WalkThroughViewController ()
@property (nonatomic, strong) NSArray* descDetauls;
@property(nonatomic, retain) IBOutlet UIButton *btnNext;
@property(nonatomic, retain) IBOutlet UIButton *btnSkip;
@property(nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic, retain) IBOutlet UICollectionView *cvOverview;

@end

@implementation WalkThroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnNext.layer.cornerRadius = 5.;
    self.btnSkip.titleLabel.font = [UIFont fontWithName:FontMedium size:15];
    [self.btnSkip setTitleColor:UIColorFromRGB(0x0082d9) forState:UIControlStateNormal];

    
    self.descDetauls = [NSArray arrayWithObjects:@{@"image":@"Onboarding-1",
                                                   @"title":[NSString stringWithFormat:@"%@\n%@",
                                                             @"Get houlry booking",
                                                             @"for a fexible stay."],
                                                   @"sub":@"Pay for the time you stay. Enjoy anytime check-in and 24/7 facilities."},
                        
                        
                                            @{@"image":@"Onboarding-2",
                                            @"title":[NSString stringWithFormat:@"%@\n%@",
                                                             @"Save money with",
                                                             @" monthly booking facility."],
                                            @"sub":@"Get rid of long-term contracts or extra rents. Book month-wise with us."},
                        
                                            @{@"image":@"Onboarding-3",
                                              @"title":[NSString stringWithFormat:@"%@\n%@",
                                                        @"Enjoy unlimited services",
                                                        @"at premium hotels."],
                                              @"sub":@"ENjoy services like pool, meeting rooms and gyms with no added cost."},
                                           
                                            @{@"image":@"Onboarding-4",
                                              @"title":[NSString stringWithFormat:@"%@\n%@",
                                                        @"All properties covered",
                                                        @"for a stable stay."],
                                              @"sub":@"Choose from hotels, apartments or private properties in any region."},nil];
    
    
    

    [self.view bringSubviewToFront:_btnNext];
    

 

    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidAppear:(BOOL)animated
{

    
}
-(NSInteger) numberOfPages
{
    return self.descDetauls.count;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)changingRootView
{
   AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UIViewController *rootViewController = [storyboard instantiateInitialViewController];
    [appdel.window setRootViewController: rootViewController];

    return;
    UIView *snapShotView;
    snapShotView = [appdel.window snapshotViewAfterScreenUpdates: YES];
    [rootViewController.view addSubview: snapShotView];
    
    
    {
        [UIView animateWithDuration: 0.3 animations:^{
            
            snapShotView.layer.opacity = 0;
            snapShotView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
            
        } completion:^(BOOL finished) {
            
            [snapShotView removeFromSuperview];
            
        }];
    }
 
}
- (IBAction)skipBtnClikd:(id)sender {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:isWalkThroughDisplayed];
        [[NSUserDefaults standardUserDefaults] synchronize];

    if (_isFromSettings) {
        [self dismissViewControllerAnimated:TRUE completion:^{
                
        }];
    }
    else
    {
        [self changingRootView];
    }

}
- (IBAction)nextBtnClikd:(id)sender {
    
    NSInteger curpage =[self getCurrentPage];
    curpage++;
    if (curpage>=[self numberOfPages]) {
      [self skipBtnClikd:nil];
    }
    else
    {
        [_cvOverview setContentOffset:CGPointMake(curpage*_cvOverview.frame.size.width, 0) animated:TRUE];
    }
    
    NSLog(@"Current page - %ld",(long)curpage);
    
    if(curpage == [self.descDetauls count]-1){
        [_btnNext setTitle:@"Get Started" forState:UIControlStateNormal];
    }else{
        [_btnNext setTitle:@"Next" forState:UIControlStateNormal];
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger nPages = [self.descDetauls count];
    _pageControl.numberOfPages = nPages;
    return nPages;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = TRUE;
   
 
    UIImageView *img =[cell viewWithTag:1];
    UILabel *lbltitle = [cell viewWithTag:2];
    UILabel *lblDesc = [cell viewWithTag:3];
    
    lbltitle.text = self.descDetauls[indexPath.row][@"title"];
    lblDesc.text = self.descDetauls[indexPath.row][@"sub"];
    img.image = [UIImage imageNamed:self.descDetauls[indexPath.row][@"image"]];
    
    
    
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
        minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSInteger)getCurrentPage
{
    CGFloat width = _cvOverview.frame.size.width;
    NSInteger page = (_cvOverview.contentOffset.x + (0.5f * width)) / width;
    return page;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    self.pageControl.currentPage = [self getCurrentPage];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = [self getCurrentPage];

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
     {
        if(!decelerate){
            self.pageControl.currentPage = [self getCurrentPage];

        }
    }
    
    NSInteger curpage =[self getCurrentPage];
    
    NSLog(@"Current page - %ld",(long)curpage);
    //CJC last work
    if(curpage == [self.descDetauls count]-1){
        [_btnNext setTitle:@"Get Started" forState:UIControlStateNormal];
    }else{
        [_btnNext setTitle:@"Next" forState:UIControlStateNormal];
    }
    
}

@end
