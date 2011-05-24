//
//  L1ScenarioList.m
//  locations1
//
//  Created by Joe Zuntz on 12/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1ScenarioList.h"
#import "SBJsonParser.h"


@implementation L1ScenarioList
@synthesize thumbnails, images, descriptions, titles, url, thumbnailURLs, imageURLs, connection, IDs, ready, delegate;


//-(id) init
//{
//    self = [super init];
//    if (self){
//        self.
//        self.thumbnails = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"lyra-icon.png"], [UIImage imageNamed:@"solar-icon.png"], [UIImage imageNamed:@"london-icon.jpeg"], nil];
//
//        self.descriptions = [NSMutableArray arrayWithObjects:@"A new short story from master storyteller, Philip Pullman, set in the Oxford of Lyra's world in His Dark Materials trilogy, bound with a beautifully illustrated map.", @"Our solar neighborhood is an exciting place. The Solar System is full of planets, moons, asteroids, comets, minor planets, and many other exciting objects. Learn about Io, the explosive moon that orbits the planet Jupiter, or explore the gigantic canyons and deserts on Mars.",@"London has a recorded history that goes back over 2,000 years. During this time, it has grown to become one of the most significant financial and cultural capitals of the world. It has experienced plague, devastating fire, civil war, aerial bombardment and terrorist attacks.", nil];
//
//        self.images = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"lyras-oxford.jpeg"], [UIImage imageNamed:@"solar-system.jpeg"], [UIImage imageNamed:@"london.jpeg"], nil];
//
//        self.titles = [NSMutableArray arrayWithObjects:@"Lyra's Oxford", @"Walk The Solar System",@"The History Of London", nil];
//        
//        
//    }
//    return self;
//    
//}

-(id) initWithFakeScenario
{
    self = [super init];
    if (self){
        self.url = nil;
        self.thumbnails = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"lyra-icon.png"]];
        self.IDs = [NSMutableArray arrayWithObject:@"Lyra-Scenario"];
        self.descriptions = [NSMutableArray arrayWithObject:@"A scenario that I just made up."];
        self.images = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"lyras-oxford.jpeg"]];
        self.titles = [NSMutableArray arrayWithObject:@"Lyra Scenario"];
        ready=YES;
    }
    return self;
}

-(id) initWithURL:(NSString*) scenariosURL
{
    self = [super init];
    if (self){
        self.url = scenariosURL;
        ready=NO;
        self.thumbnails = [NSMutableArray array];
        self.IDs = [NSMutableArray array];
        self.descriptions = [NSMutableArray array];
        self.images = [NSMutableArray array];
        self.titles = [NSMutableArray array];
        [self updateScenarios];
    }
    return self;
    
}
-(void) updateScenarios
{
    self.connection = [[[SimpleURLConnection alloc] initWithURL:self.url delegate:self passSelector:@selector(downloaded:withResponse:) failSelector:@selector(failedDownloadWithError:)] autorelease];
    [self.connection runRequest];
}

-(void) failedDownloadWithError:(NSError*) error
{
    NSLog(@"Failed to download URL: %@",error);
    
}
-(void) downloaded:(NSData*) data withResponse:(NSHTTPURLResponse*) response
{
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
	NSArray * scenarioArray = [parser objectWithData:data];
	[parser release];
    
    self.thumbnailURLs = [NSMutableArray arrayWithCapacity:[scenarioArray count]];
    self.imageURLs= [NSMutableArray arrayWithCapacity:[scenarioArray count]];



    //description, icon, splash_screen, title
    for (NSDictionary * scenarioDictionary in scenarioArray){
       
        [self.titles addObject:[scenarioDictionary objectForKey:@"title"]];
        [self.descriptions addObject:[scenarioDictionary objectForKey:@"description"]];
        [self.thumbnailURLs addObject:[scenarioDictionary objectForKey:@"icon_url"]];
        [self.imageURLs addObject:[scenarioDictionary objectForKey:@"splash_screen_url"]];
        [self.IDs addObject:[scenarioDictionary objectForKey:@"id"]];
        NSLog(@"%@",scenarioDictionary);
        NSLog(@"Found scenario: %@ (%@)",[self.titles lastObject], [self.IDs lastObject]);
    }
    [self downloadImages];
}

-(void) downloadImages
{
    NSLog(@"Downloading Scenario Images");
    for (NSString * imageURLString in self.imageURLs)
    {
        
        if (imageURLString && (![imageURLString isEqual: [NSNull null]])){
            NSString * fullURLString = [@"http://warm-earth-179.heroku.com" stringByAppendingString:imageURLString];
            NSURL * imageURL = [NSURL URLWithString:fullURLString];
            NSLog(@"%@",fullURLString);
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            [self.images addObject:image];
        }
        else{
            [self.images addObject:nil];
        }
    }

    
    for (NSString * imageURLString in self.thumbnailURLs)
    {
        if (imageURLString && (![imageURLString isEqual: [NSNull null]])){
            NSString * fullURLString = [@"http://warm-earth-179.heroku.com" stringByAppendingString:imageURLString];
            NSURL * imageURL = [NSURL URLWithString:fullURLString];
            NSLog(@"%@",fullURLString);
            NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage * image = [UIImage imageWithData:imageData];
            [self.thumbnails addObject:image];
        }
        else{
            [self.thumbnails addObject:nil];
            
        }
    }
    
    ready = YES;
    if (delegate){
        SEL finisher = @selector(scenarioListDidFinishedLoading:);
        if ([delegate respondsToSelector:finisher]){
            [delegate performSelector:finisher withObject:self];
        }
    }

}
                       

-(NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    if (ready) return [self.IDs count];
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSUInteger item = [indexPath indexAtPosition:1];
    NSLog(@"CELL: %@",indexPath);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.imageView.image = [self.thumbnails objectAtIndex:item];
    cell.textLabel.text = [self.titles objectAtIndex:item];
    cell.textLabel.numberOfLines = 2;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return [cell autorelease];
    
    
}

@end
