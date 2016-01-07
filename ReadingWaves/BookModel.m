//
//  BookModel.m
//  ReadingWaves
//
//  Created by Matthew Iannucci on 1/7/16.
//  Copyright © 2016 Matthew Iannucci. All rights reserved.
//

#import "BookModel.h"
#import "Book.h"

// OpenLibrary API URL
static NSString * const OCEAN_BOOKS_URL = @"https://openlibrary.org/subjects/ocean.json?limit=20";

@implementation BookModel

@synthesize books;

+ (instancetype) sharedModel {
    static BookModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version!
        _sharedModel = [[self alloc] init];
    });
    
    return _sharedModel;
}

- (id) init {
    self = [super init];
    
    // Set up the data container for the books
    books = [[NSMutableArray alloc] init];
    
    return self;
}

- (BOOL) fetchBooks {
    // Fetch with a mutex to make sure only one operation is happening in the
    // singleton at a time. Not really a risk for a single view controller but
    // its good practice for scale.
    @synchronized(self) {
        // For now disallow refreshing. Its gunna be pretty much the same every launch anyways
        if ([books count] != 0) {
            return YES;
        }
        
        // Get the data from the api
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:OCEAN_BOOKS_URL]];
        
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
        
        // Get the list of books. It is a json array filled with objects that will be parsed to Book objects
        NSArray *worksList = [json objectForKey:@"works"];
        for (NSDictionary *bookFound in worksList) {
            
            // Create a new book
            Book *newBook = [[Book alloc] init];
            
            // Parse out the metadeta for now and leave the details to be fetched later
            // Start with the title
            newBook.title = [bookFound objectForKey:@"title"];
            
            // Get all of the authors because there may be more than one
            NSArray *authors = [bookFound objectForKey:@"authors"];
            NSMutableArray *parsedAuthorList = [[NSMutableArray alloc] init];
            for (NSDictionary *author in authors) {
                [parsedAuthorList addObject:[author objectForKey:@"name"]];
            }
            
            // Join all of the names to create a single author line
            newBook.author = [parsedAuthorList componentsJoinedByString:@", "];
            
            // Last thing we need is the book ID so we can fetch the details later
            newBook.bookID = [bookFound objectForKey:@"cover_edition_key"];
            
            // Fetch the details! We could do this dynamically instead but for now lets download everything at once
            [newBook fetchDetails];
            
            // Add the book you found to the list
            [books addObject:newBook];
        }
        
        // Make sure books were actually found for the query
        if ([books count] == 0) {
            return NO;
        }
        
        return YES;
    }
}

@end
