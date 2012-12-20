//
//  MapViewController.m
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "WMSOverlay.h"
#import "WMSOverlayView.h"

@implementation MapViewController

//----------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//---------------------------------------------------
- (void)dealloc {
    self.mkMapView.delegate = nil;
    
}
//----------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CGRect initFrame = CGRectMake(0, 0, 380, 460);
    MKMapView *mkMapView = [[MKMapView alloc] initWithFrame:initFrame];
    self.view = mkMapView;
    
    mkMapView.mapType = MKMapTypeStandard;
    mkMapView.delegate = self;
    
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

//----------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//---------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = TRUE;
    [super viewWillAppear:animated];
}
//---------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
//---------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
//---------------------------------------------------------
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//----------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

//----------------------------------------------------------------------------
-(MKMapView*) mkMapView {
    return (MKMapView *) self.view;
    
}
// -- loads set of WMS stored as array with BBOX %f, %f, %f, %f
//----------------------------------------------------------------------------
-(void) addWMSOverlays: (NSArray*) overlays{
    for ( WMSOverlay *wmsOverlay in overlays){
        // -- add overlay
        [ self.mkMapView addOverlay:wmsOverlay];
        
    }
    
}


#pragma mark -- MKMapView delegate

//---------------------------------------------------------------------------------------------------
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    WMSOverlayView *wmsOverlayView = [[WMSOverlayView alloc] initWithWMSLayer:overlay MapView:self.mkMapView];
    
    return wmsOverlayView;
}


@end
