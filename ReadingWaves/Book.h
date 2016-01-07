//
//  Book.h
//  ReadingWaves
//
//  Created by Matthew Iannucci on 1/7/16.
//  Copyright © 2016 Matthew Iannucci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Book : NSObject

@property (strong, nonatomic) NSString *bookID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *coverArtURL;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSNumber *pageCount;
@property (strong, nonatomic) NSString *publishDate;
@property (strong, nonatomic) NSString *publishers;
@property (strong, nonatomic) UIImage *coverImage;

- (BOOL) fetchDetails;

@end
