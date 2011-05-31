//
//  MediaListViewController.h
//  locations1
//
//  Created by Joe Zuntz on 31/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L1Node.h"

@interface MediaListViewController : UITableViewController {
    L1Node * node;
}
@property (retain) L1Node * node;

@end
