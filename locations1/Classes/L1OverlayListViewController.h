//
//  L1OverlayListViewController.h
//  locations1
//
//  Created by Joe Zuntz on 07/06/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface L1OverlayListViewController : UITableViewController {
    NSObject * delegate;
    NSMutableArray * overlays;
}
- (id)initWithStyle:(UITableViewStyle)style overlays:(NSArray*) overlayArray;

@property (retain) NSObject * delegate;
@end
