//
//  MapViewController.m
//  Travelog
//
//  Created by Edo williams on 10/29/13.
//  Copyright (c) 2013 Edo williams. All rights reserved.
//

#import "MapViewController.h"
#import "Travelog.h"
#import "CheckInViewController.h"

@interface MapViewController ()

@end


@implementation MapViewController {
    
    NSArray *travelogs;
}


@synthesize managedObjectContext, mapView;

//this will tell teh notifcation to add self(this view controller) to the observer for any chnages
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
    }
    
    return self;
}

//calling the updatelocation will thrwo away old pins and make new pins
//for newly fethced travelog objects
- (void)contextDidChange:(NSNotification *)notification
{
    if ([self isViewLoaded]) {
        [self updateLocations];
    }
}

//we tell NSNotification to stop sending notifictaio when the object no longer exist
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                            name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLocations];
    
    if ([travelogs count] > 0) {
        [self showTags];
    }
}


//calculates a reasonable region that fits all location objects
- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations
{
    MKCoordinateRegion region;
    
    //there is no annotations, so center map on user's current position
    if ([annotations count] == 0) {
        region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
    }
    
    //there is only one annotation, so center map on that one annotation
    else if ([annotations count] == 1)
    {
        id <MKAnnotation> annotation = [annotations lastObject];
        region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000);
    }
    
    //there are two or more annotations, so calculate the extent of their reach and add a little padding
    else
    {
        CLLocationCoordinate2D topLeftCoord;
        topLeftCoord.latitude = -90;
        topLeftCoord.longitude = 180;
        
        CLLocationCoordinate2D bottomRightCoord;
        bottomRightCoord.latitude = 90;
        bottomRightCoord.longitude = -180;
        
        for (id <MKAnnotation> annotation in annotations) {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        }
        
        const double extraSpace = 1.1;
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2.0;
        region.center.longitude = topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2.0;
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace;
        region.span.longitudeDelta = fabs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace;
    }
    
    return [self.mapView regionThatFits:region];
    
}


- (IBAction)WhereAmI
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 1000, 1000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (IBAction)showTags
{
    MKCoordinateRegion region = [self regionForAnnotations:travelogs];
    [self.mapView setRegion:region animated:YES];
}

- (void)updateLocations
{
    //fetch data from coredata
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travelog" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    
    NSError *error;
    NSArray *foundObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //execute fecthed data here
    if (foundObjects == nil) {
        NSLog(@"Error: %@", error);
        abort();
    }
    
    //we adding pins on the map
    if (travelogs != nil) {
        [self.mapView removeAnnotations:travelogs];
    }
    
    travelogs = foundObjects;
    [self.mapView addAnnotations:travelogs];
    
}

//because the segue is not connected to any particular control inteh view controller, we haveto
//trigger manually, we send along teh button as teh sender
- (void)ShowtagDetails:(UIButton *)button
{
    [self performSegueWithIdentifier:@"EditTag" sender:button];
}

//get the travelogs object from our travelog array using the tag property of the button as the indx in that array
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditTag"]) {
        CheckInViewController *controller= segue.destinationViewController;
        
        controller.managedObjectContext = self.managedObjectContext;
        
        Travelog *travelog = [travelogs objectAtIndex:((UIButton *)sender).tag];
        controller.travelogToEdit = travelog;
    }
}


#pragma mark - MKMapviewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //because MKAnnotation is a protocol, there are many objects it contains
    //ie the blue dot that represent the users current location
    //so we use isKindOdClass to determine whether teh annotation is a location object, is so we continue
    if ([annotation isKindOfClass:[Travelog class]]) {
        
        //reuse an annotaion view object and create pins
        static NSString *identifier = @"Travelog";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        //set some properties to configure the look and feel ofthe annotation view
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            //annotationView.animatesDrop = NO;
            //annotationView.pinColor = MKPinAnnotationColorPurple;
            NSLog(@"image file:%@", [NSString stringWithFormat:@"%@.png",((Travelog *)annotation).tag]);
            annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",
                                                        [((Travelog *)annotation).tag lowercaseString]]
                                                        ];
            
            
            //create a disclosure button and hook up a touch up inside event with a showtagsdetails method
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self action:@selector(ShowtagDetails:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
        }
        
        else
        {
            annotationView.annotation = annotation;
        }
        
        //now that the annotation is constructed we obtain the refrence to the button so
        //we can find the travelog object array
        UIButton *button = (UIButton *)annotationView.rightCalloutAccessoryView;
        button.tag = [travelogs indexOfObject:(Travelog *)annotation];
        
        return annotationView;
    }
    
    return nil;
}


@end
