//
//  TempMapViewController.h
//  Stayhopper
//
//  Created by Bryno Baby on 22/08/18.
//  Copyright © 2018 iROID Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@import GoogleMaps;
@interface TempMapViewController : UIViewController
{
    GMSMapView* mapView;
}
@property(nonatomic,retain)NSString* latitudeValue;
@property(nonatomic,retain)NSString* longitudeValue;

@end
