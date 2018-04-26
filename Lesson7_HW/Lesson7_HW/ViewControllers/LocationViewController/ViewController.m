//
//  ViewController.m
//  Lesson7_HW
//
//  Created by Nguyen Nam on 4/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>


@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>{
    CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocationManager];
    
    self.mapView.scrollEnabled = true;
    self.mapView.zoomEnabled = true;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = true;
    
}

// MARK: Functions
- (void) setupLocationManager{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

// MARK:
- (IBAction)addNewAnnotation:(UIButton *)sender {
    if ([_addressTextField.text isEqualToString:@""]){
        NSLog(@"missing data");
    }else{
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        [geocoder geocodeAddressString:_addressTextField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error != nil){
                NSLog(@"%@", error);
                return ;
            }
             CLLocation *location = placemarks.firstObject.location;
            [self makeAnnotaion:location];
        }];
        
    }
}

// Make new annotation by address
- (void)makeAnnotaion:(CLLocation *)location{
    // add new annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    // get location by placemarks
    annotation.coordinate = location.coordinate;
    annotation.title = _addressTextField.text;
    [self.mapView addAnnotation:annotation];
    // then camera center to that annotation
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:region animated:true];
    
    // and get distance from current location to this annotation
    CLLocationDistance distance = [currentLocation distanceFromLocation:location];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f m", distance];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

// MARK: Implement CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.firstObject;
    currentLocation = location;
    NSLog(@"%@", currentLocation);
    
    CLLocationDistance regionRadius = 1000;
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, regionRadius, regionRadius);
    [self.mapView setRegion:coordinateRegion animated:true];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusRestricted:
            NSLog(@"restricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"denied");
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"not detmermined");
        default:
            break;
    }
}

// MARK: Implement MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"did update user location");
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    NSLog(@"did add annotation");
}

@end









