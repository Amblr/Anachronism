//
//  L1ScenarioList.h
//  locations1
//
//  Created by Joe Zuntz on 12/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleURLConnection.h"

@interface L1ScenarioList : NSObject<UITableViewDataSource> {

    //JAZ - At this point it has become clear that I should just have a scenarioInfo object with one of these each.
    NSMutableArray *thumbnails;
    NSMutableArray *images;
    NSMutableArray *thumbnailURLs;
    NSMutableArray *imageURLs;
    NSMutableArray *descriptions;
    NSMutableArray *titles;
    NSMutableArray *IDs;
    NSString * url;
    NSObject * delegate;
    BOOL ready;
    SimpleURLConnection * connection;
}

-(id) initWithString:(NSString*) scenariosURL;
-(id) initWithFakeScenario;

-(void) updateScenarios;
-(void) downloadImages;

-(void) downloaded:(NSData*) data withResponse:(NSHTTPURLResponse*) response;
-(void) failedDownloadWithError:(NSError*) error;

@property (readonly) BOOL ready;
@property (retain) NSObject *delegate;
@property (retain) NSMutableArray *thumbnails;
@property (retain) NSMutableArray *images;
@property (retain) NSMutableArray *thumbnailURLs;
@property (retain) NSMutableArray *imageURLs;
@property (retain) NSMutableArray *descriptions;
@property (retain) NSMutableArray *titles;
@property (retain) NSMutableArray *IDs;

@property (retain) NSString *url;
@property (retain) SimpleURLConnection *connection;

@end
