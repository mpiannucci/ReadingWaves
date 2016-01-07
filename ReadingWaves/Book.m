//
//  Book.m
//  ReadingWaves
//
//  Created by Matthew Iannucci on 1/7/16.
//  Copyright © 2016 Matthew Iannucci. All rights reserved.
//

#import "Book.h"

static NSString * const BOOK_DETAIL_BASE_URL = @"https://openlibrary.org/api/books?bibkeys=OLID:%@&format=json&jscmd=data";

@interface Book ()

- (void) fixEmptyValues;

@end

@implementation Book {
    BOOL hasFetchedDetails;
}

- (id) init {
    self = [super init];
    
    // Initialize each object knowing they don't have their details yet
    hasFetchedDetails = false;
    
    return self;
}

- (BOOL) fetchDetails {
    // We only want to grab details once per object to return if the details are already read.
    if (hasFetchedDetails) {
        return YES;
    }
    
    // Get the data from the api using the books identifier
    NSString *bookAPIURL = [NSString stringWithFormat:BOOK_DETAIL_BASE_URL, self.bookID];
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:bookAPIURL]];
    
    // If theres no data return false to show failure
    if (data == nil) {
        NSLog(@"Failed to download book data from OpenLibrary\n");
        return NO;
    }
    
    // Convert the raw data to json
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    if (error != nil) {
        NSLog(@"Failed to serialize json with error: %@", error);
        return NO;
    }
    
    // Get the books details using its id as the key
    NSString *bookKey = [NSString stringWithFormat:@"OLID:%@", self.bookID];
    NSDictionary *bookDetails = [json objectForKey:bookKey];
    
    // Using the book object get the rest of the books information.
    self.subtitle = [bookDetails objectForKey:@"subtitle"];
    self.weight = [bookDetails objectForKey:@"weight"];
    self.pageCount = [bookDetails objectForKey:@"number_of_pages"];
    self.coverArtURL = [[bookDetails objectForKey:@"cover"] objectForKey:@"large"];
    self.publishDate = [bookDetails objectForKey:@"publish_date"];
    
    // There may be multiple publishers so we do the same thing we did for the authors
    NSArray *publishers = [bookDetails objectForKey:@"publishers"];
    NSMutableArray *parsedPublishers = [[NSMutableArray alloc] init];
    for (NSDictionary *publisher in publishers) {
        [parsedPublishers addObject:[publisher objectForKey:@"name"]];
    }
    self.publishers = [parsedPublishers componentsJoinedByString:@","];
    
    // Make sure there is something to display for every field
    [self fixEmptyValues];
    
    return YES;
}

- (void) fixEmptyValues {
    if ([self.subtitle length] == 0) {
        self.subtitle = @"No subtitle or description available";
    }
}

@end
