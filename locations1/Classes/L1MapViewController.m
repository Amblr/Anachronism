//
//  L1MapViewController.m
//  locations1
//
//  Created by Joe Zuntz on 16/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1MapViewController.h"
#import "L1Node.h"
//#import "L1MapImageOverlay.h"
//#import "L1MapImageOverlayView.h"
#import "L1Path.h"
#import "SimulatedUserLocation.h"
//#import "L1Pin.h"
#import "L1Overlay.h"
#import "L1OverlayView.h"
#import "ManualUserLocation.h"

@implementation L1MapViewController
@synthesize  delegate;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


-(void) awakeFromNib
{
	[super awakeFromNib];
    self.singleOverlayView=nil;
	
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    [super viewDidLoad];
	primaryMapView.delegate=self;
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 51.75;
    newRegion.center.longitude = -1.25;
    newRegion.span.latitudeDelta = 0.04;
    newRegion.span.longitudeDelta = 0.04;
	
    [primaryMapView setRegion:newRegion animated:YES];
    
    SimulatedLocationManager * fakeManager = [SimulatedLocationManager sharedSimulatedLocationManager];
    [fakeManager.delegates addObject:self];
    
    fakeUserLocation = [[SimulatedUserLocation alloc] init];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}
//
//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//
//- (void)dealloc {
//    [super dealloc];
//}

-(void) zoomToCoordinate:(CLLocationCoordinate2D) coordinate
{
    MKMapRect rect = [primaryMapView visibleMapRect];
    rect.origin = MKMapPointForCoordinate(coordinate);
    [primaryMapView setVisibleMapRect:MKMapRectOffset(rect, -rect.size.width/2, -rect.size.height/2) animated:YES];

}

-(void) zoomToNode:(L1Node*) node
{
    CLLocationCoordinate2D centerCoord = [node coordinate];
    [self zoomToCoordinate:centerCoord];

}


-(void) zoomInToNode:(L1Node*) node
{
    CLLocationCoordinate2D centerCoordinate = node.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000., 1000.);
    [primaryMapView setRegion:region animated:YES];

}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	NSObject<MKAnnotation> * nodeObject = view.annotation;
	if ([nodeObject isKindOfClass:[L1Node class]]){
		L1Node * node = (L1Node*)nodeObject;
        SEL clickedNode = @selector(didSelectNode:);
        if ([self.delegate respondsToSelector:clickedNode]) [self.delegate performSelector:clickedNode withObject:node];
        [self zoomToNode:node];
	}
}

-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray*) annotationViews
{
	
}


//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//	id<MKAnnotation> annotation = view.annotation;
//	if (![annotation isKindOfClass:[L1Node class]]) return;
//	L1Node * node = (L1Node*)annotation;
//	[self.navigationController pushViewController:self.nodeContentViewController animated:YES];
//	[self.nodeContentViewController setName:node.name];
//	[self.nodeContentViewController setText:node.text];
//}



-(MKAnnotationView *)annotationViewFor:(MKMapView *)mapView forNode:(L1Node*)node{

	
//	if (!node.visible){
//        NSLog(@"Inivisible node: %@",node.name);
//        return nil;   
//    }
    if ((!node.visible) || node.mode==L1NodeWaypoint) {
        MKAnnotationView * nonView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"InvisibleNode"];
        if (!nonView){
            nonView = [[[MKAnnotationView alloc] initWithAnnotation:node reuseIdentifier:@"InvisibleNode"] autorelease];
        }
        return nonView;
    }
    
	MKAnnotationView * annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"node"];
	
	if (!annotationView){
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:node reuseIdentifier:@"node"] autorelease];
	}
    MKPinAnnotationView * pinView = (MKPinAnnotationView*) annotationView;
	annotationView.enabled = node.visible;
	annotationView.canShowCallout = NO;
    if (node.mode==L1NodeActive) pinView.pinColor = MKPinAnnotationColorGreen;
    if (node.mode==L1NodeInActive) pinView.pinColor = MKPinAnnotationColorPurple;
    if (node.mode==L1NodePointOfInterest) pinView.pinColor = MKPinAnnotationColorPurple;
    if (node.mode==L1NodeWaypoint) pinView.enabled=NO;

    
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	annotationView.leftCalloutAccessoryView = rightButton;
	
		
	return annotationView;
}

-(void) addManualUserLocationAt:(CLLocationCoordinate2D)coordinate
{
    ManualUserLocation * manualLocation = [[ManualUserLocation alloc] initWithCoordinate:coordinate];
    [primaryMapView addAnnotation:manualLocation];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
        
    if ([annotation isKindOfClass:[SimulatedUserLocation class]]){
        SimulatedUserLocation * sim = (SimulatedUserLocation*) annotation;
        return [sim viewForSimulatedLocationWithIdentifier:@"SimulatedUserLocation"];
    }

    
	if ([annotation isKindOfClass:[L1Node class]]){
		return [self annotationViewFor:mapView forNode:(L1Node*)annotation];
	}
    
    if ([annotation isKindOfClass:[ManualUserLocation class]]){
        MKPinAnnotationView * pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ManualUserLocation"];
        pin.draggable = YES;
        pin.pinColor = MKPinAnnotationColorRed;
        return [pin autorelease];
    }
    
	return nil;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
//	NSLog(@"Getting view overlay: %@",overlay);
	if ([overlay isKindOfClass:[MKPolygon class]]){
		MKPolygonView * polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
		UIColor * color = [[UIColor redColor] colorWithAlphaComponent:0.25];
		polygonView.fillColor = color;	
		return [polygonView autorelease];
	}
    
    else if ([overlay isKindOfClass:[MKPolyline class]]){
        MKPolylineView * polylineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline*) overlay];
//        NSLog(@"overlay = %@",overlay);
//        NSLog(@"poly line = %@", polylineView.polyline);
        polylineView.strokeColor = [UIColor purpleColor];
        polylineView.lineWidth = 4.0;
        return [polylineView autorelease];
    }
    
    else if ([overlay isKindOfClass:[L1Overlay class]]){
        L1OverlayView * overlayView = [[L1OverlayView alloc]initWithOverlay:overlay];
        self.singleOverlayView=overlayView;
        return [overlayView autorelease];
    }
    
    else if ([overlay isKindOfClass:[MKCircle class]]){
        MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle*)overlay];
        circleView.alpha = 0.33;
        circleView.fillColor = [UIColor greenColor];
        return [circleView autorelease];
    }
	
	return nil;
}

-(void) addImageOverlay:(L1Overlay*) overlay
{
    [primaryMapView addOverlay:overlay];

}

-(L1Overlay*) addOverlayImage:(UIImage*)image bottomLeft:(CLLocationCoordinate2D)bottomLeft topRight:(CLLocationCoordinate2D) topRight
{
    
    L1Overlay * overlay = [[L1Overlay alloc] initWithImage:image 
                                withLowerLeftCoordinate:bottomLeft 
                                withUpperRightCoordinate:topRight];
    [primaryMapView addOverlay:overlay];
    return [overlay autorelease];

}


//Add a stand-alone node.
-(void) addNode:(L1Node*) node
{
    if ([primaryMapView.annotations containsObject:node]) return;
    node.mode = L1NodeInActive;
    [primaryMapView addAnnotation:node];
    
}

-(void) nodeSource:(id) nodeManager didReceiveNodes:(NSDictionary*) nodes
{
	NSLog(@"Received %d nodes", [nodes count]);
    for(L1Node * node in [nodes allValues]){
		if (node.visible) [primaryMapView addAnnotation:node];
	}
    
    NSLog(@"Adding fake location");
    [primaryMapView addAnnotation:fakeUserLocation];

    if ([nodes count]){
        L1Node * firstNode = [[nodes allValues] objectAtIndex:0];
        CLLocationCoordinate2D centerCoordinate = firstNode.coordinate;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000., 1000.);
        [primaryMapView setRegion:region animated:YES];
     }
    
}


-(void) pathSource:(id) pathManager didReceivePaths:(NSDictionary*) paths
{
    NSLog(@"Received %d paths",[paths count]);
    for (L1Path * path in [paths allValues]){
        [primaryMapView addOverlay:[path polyline]];
    }
    
    
}

-(void) removeOverlay
{
    L1Overlay * overlay = singleOverlayView.overlay;
    [primaryMapView removeOverlay:overlay];
    self.singleOverlayView=nil;
    
}

-(void)removePaths
{
    NSArray * overlays = [primaryMapView overlays];
    for (NSObject<MKOverlay> * overlay in overlays){
        if ([overlay isKindOfClass:[MKPolyline class]]) [primaryMapView removeOverlay:overlay];
    }
}


-(void) addPath:(L1Path*)path
{
    MKPolyline * newLine = [path polyline];
    for (L1Node * node in path.nodes){
        if (node.visible) node.mode=L1NodeActive;
        else node.mode=L1NodeWaypoint;
        if (![primaryMapView.annotations containsObject:node]){
            [primaryMapView addAnnotation:node];
        }
    }
    [primaryMapView addOverlay:newLine];
    
}

-(L1Scenario*) scenario
{
    return scenario;
}

-(void) setScenario:(L1Scenario *)newScenario
{
	[scenario autorelease];
	scenario = newScenario;
	scenario.delegate=self;
}


-(void) locationManager:(SimulatedLocationManager*) locationManager didUpdateToLocation:(CLLocation*)toLocation fromLocation: (CLLocation*)fromLocation
{
        [primaryMapView removeAnnotation:fakeUserLocation]; 
        [primaryMapView addAnnotation:fakeUserLocation];

}

-(void) addOverlay:(id<MKOverlay>) overlay
{
    [primaryMapView addOverlay:overlay];

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    //The user just dragged our manual location to a new position.
    //This means we want to fake having moved.
    if ([annotationView.annotation isKindOfClass:[ManualUserLocation class]]){
        if (newState==MKAnnotationViewDragStateEnding && oldState==MKAnnotationViewDragStateDragging){
            ManualUserLocation * manualLocation = (ManualUserLocation *) annotationView.annotation;
            CLLocationCoordinate2D coordinates = manualLocation.coordinate;
            SEL selector = @selector(manualLocationUpdate:);
            if ([self.delegate respondsToSelector:selector]){
                CLLocation * newLocation = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
                [self.delegate performSelector:selector withObject:newLocation];
                [newLocation autorelease];
            }
            
        }
    }
}


-(void) setColor:(UIColor*)color forCircle:(MKCircle*) circle
{
    MKOverlayView * overlayView = [primaryMapView viewForOverlay:circle];
    if (!overlayView) return;
    if (![overlayView isKindOfClass:[MKCircleView class]]){
        NSLog(@"WEIRD.  Circle does not have circle view.");
        return;
    }
    MKCircleView * circleView = (MKCircleView*) overlayView;
    circleView.fillColor = color;
}

@synthesize nodeContentViewController;
@synthesize singleOverlayView;
@end
