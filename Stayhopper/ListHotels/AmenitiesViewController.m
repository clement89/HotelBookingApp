//
//  AmenitiesViewController.m
//  Stayhopper
//
//  Created by antony on 07/12/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "AmenitiesViewController.h"
#import "URLConstants.h"
#import "UIImageView+WebCache.h"

@interface AmenitiesViewController ()
{
    float policyHeight;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *cvDetails;

@end

@implementation AmenitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblTitle.superview.layer.shadowOffset = CGSizeMake(0, 2);
      _lblTitle.superview.layer.shadowOpacity = 0.3;
      _lblTitle.superview.layer.shadowRadius = 2.0;
      _lblTitle.superview.layer.shadowColor = [UIColor grayColor].CGColor;
       _lblTitle.font = [UIFont fontWithName:FontMedium size:_lblTitle.font.pointSize];
       _lblTitle.textColor = kColorDarkBlueThemeColor;
       self.view.backgroundColor = kColorProfilePages;
    if (_amentiesArray) {
        _lblTitle.text = @"Amenities";
    }
    else{
       {
           CGFloat width = [UIScreen mainScreen].bounds.size.width-2*_cvDetails.frame.origin.x; // whatever your desired width is
           CGRect rect = [_policyString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
           policyHeight = rect.size.height;
           
            _lblTitle.text = @"Policies";
        }
    }
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
- (IBAction)crossBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:^{
            
    }];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_amentiesArray) {
        return _amentiesArray.count;
    }
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *Cell;
    if (_amentiesArray) {
        Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UIImageView *imgView = [Cell.contentView viewWithTag:1];
        UILabel *lblT = [Cell.contentView viewWithTag:2];
        
        NSString*imgName=[[self.amentiesArray objectAtIndex:indexPath.row] valueForKey:@"image"];
        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
        [imgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""]];
        lblT.text = [[self.amentiesArray objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        
    //        NSString*imgName=[[cityArray objectAtIndex:indexPath.row] objectForKey:@"image"];
    //        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    //        [citiesCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder"]];
        
    }
    else{
        Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellwithLabel" forIndexPath:indexPath];
         UILabel *lblT = [Cell.contentView viewWithTag:1];
        lblT.attributedText = _policyString;
    //        NSString*imgName=[[cityArray objectAtIndex:indexPath.row] objectForKey:@"image"];
    //        NSURL*imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgName]];
    //        [citiesCell.img sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"QOMPlaceholder"]];
        
    }
    
    return Cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_amentiesArray) {
        float width = [UIScreen mainScreen].bounds.size.width-2*collectionView.frame.origin.x;
        width = width/2.;
        
        return CGSizeMake(width, 60.);

    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width-2*collectionView.frame.origin.x, policyHeight);
}
@end
