//
//  PlaceSearchViewController.m
//  Stayhopper
//
//  Created by antony on 17/08/2020.
//  Copyright © 2020 iROID Technologies. All rights reserved.
//

#import "PlaceSearchViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMapsBase/GoogleMapsBase.h>
#import "DurationSelectionViewController.h"
#import "Commons.h"
#import "MessageViewController.h"
@import Firebase;

@interface PlaceSearchViewController () <GMSAutocompleteFetcherDelegate>
{
    GMSAutocompleteFetcher* _fetcher;
    NSMutableArray *placesArray;

}
@property (weak, nonatomic) IBOutlet UITableView *tblPlaceListing;
@property (weak, nonatomic) IBOutlet UITextField *tvSearch;

@end

@implementation PlaceSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    placesArray = [[NSMutableArray alloc] init];
    
    _tvSearch.placeholder = @"Where do you want to stay ?";
     _tvSearch.superview.layer.shadowOffset = CGSizeMake(0, 2);
    _tvSearch.superview.layer.shadowOpacity = 0.3;
    _tvSearch.superview.layer.shadowRadius = 2.0;
    _tvSearch.superview.layer.shadowColor = [UIColor grayColor].CGColor;
    [_tvSearch addTarget:self
                   action:@selector(textFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];
    _fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:nil
                                                         filter:nil];
      _fetcher.delegate = self;

    [_tvSearch becomeFirstResponder];
    
    // Do any additional setup after loading the view.
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)textFieldDidChange:(UITextField *)textField {
  NSLog(@"%@", textField.text);
  [_fetcher sourceTextHasChanged:textField.text];
}
#pragma mark - GMSAutocompleteFetcherDelegate
- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    [_tblPlaceListing setContentOffset:_tblPlaceListing.contentOffset];
    [placesArray removeAllObjects];
    [placesArray addObjectsFromArray:predictions];
    [_tblPlaceListing reloadData];
    [_tblPlaceListing setContentOffset:CGPointZero];
    return;

  NSMutableString *resultsStr = [NSMutableString string];
  
  for (GMSAutocompletePrediction *prediction in predictions) {

      [resultsStr appendFormat:@"%@\n", [prediction.attributedPrimaryText string]];
  }
//  _resultText.text = resultsStr;
}

- (void)didFailAutocompleteWithError:(NSError *)error {
                UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
                 vc.imageName=@"Failed";
                 vc.messageString=error.localizedDescription;
                 vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
                 [self.view addSubview:vc.view];
 // _resultText.text = [NSString stringWithFormat:@"%@", error.localizedDescription];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    return [placesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"placecell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *title =[cell.contentView viewWithTag:1];
    UILabel *subtitle =[cell.contentView viewWithTag:2];
    GMSAutocompletePrediction *prediction = placesArray[indexPath.row];
    title.text = [[prediction.attributedPrimaryText string] capitalizedString];
    subtitle.text = [[prediction.attributedFullText string] capitalizedString];


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Commons showLoaderInViewController:self];
    GMSPlacesClient *client = [[GMSPlacesClient alloc] init];
    
    GMSAutocompletePrediction *prediction = placesArray[indexPath.row];
    
    NSLog(@"%@",@{
        @"name": [[prediction.attributedPrimaryText string] capitalizedString],
        @"full_text": [[prediction.attributedFullText string] capitalizedString]
        });
    
    
    
    //CJC 14
    
    [FIRAnalytics logEventWithName:@"Search_location"
                        parameters:@{
                                     @"location": [[prediction.attributedPrimaryText string] capitalizedString],
                                     @"address": [[prediction.attributedFullText string] capitalizedString]
                                     }];
    
    
//    [FIRAnalytics logEventWithName:kFIREventSearch
//                        parameters:@{
//                                     kFIRParameterItemID:@"",
//                                     kFIRParameterItemName:[[prediction.attributedPrimaryText string] capitalizedString],
//                                     kFIRParameterContentType:@"Search location"
//                                     }];
    
    
    
      [client lookUpPlaceID:prediction.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
          [Commons removeLoaderFromViewController:self];

          if (!error) {
              GMSPlace *place=result;
                 NSLog(@"Place name %@", place.name);
                  NSLog(@"Place address %@", place.formattedAddress);

                  NSString *lat =[NSString stringWithFormat:@"%f",place.coordinate.latitude];
                  NSString *lon =[NSString stringWithFormat:@"%f",place.coordinate.longitude];
                  [[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"pickupLat"];
                  [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"pickupLongt"];
                 
                  //FIXME:todo
                  
                 // [self weatherApi:place.coordinate.latitude longitude:place.coordinate.longitude];
                  NSString *placeString =[NSString stringWithFormat:@"%@",place.formattedAddress];
                  [[NSUserDefaults standardUserDefaults]setObject:place.name forKey:@"pickupLocationName"];
                   [[NSUserDefaults standardUserDefaults]setObject:place.formattedAddress forKey:@"chkingstring"];
              //    [self setLocationImage];

                  [[NSUserDefaults standardUserDefaults]synchronize];
              //    self.placeTxt.text=placeString;
              //    self.weatherLbl.text=[place.name uppercaseString];
              //
                  
                  
                  
                  
                  DurationSelectionViewController *durn =[[UIStoryboard storyboardWithName:@"Main_New" bundle:nil] instantiateViewControllerWithIdentifier:@"DurationSelectionViewController"];
                  durn.latitude = lat;
                  durn.longitude = lon;
                  durn.formattedAddress =place.formattedAddress;
                  durn.placeName = place.name;

                [self.navigationController pushViewController:durn animated:TRUE];

                  //[self.mapView addSubview:placePicker.view];
                  
               
          }
          else
          {
              UIStoryboard *y=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
              MessageViewController *vc = [y   instantiateViewControllerWithIdentifier:@"MessageViewController"];
              vc.imageName=@"Failed";
              vc.messageString=error.localizedDescription;
              vc.view.frame=CGRectMake(0, 0, self.view.frame.size.width, 145);
              [self.view addSubview:vc.view];

          }
           
      }];
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
