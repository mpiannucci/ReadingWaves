//
//  DetailViewController.h
//  ReadingWaves
//
//  Created by Matthew Iannucci on 1/7/16.
//  Copyright © 2016 Matthew Iannucci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Book *book;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

