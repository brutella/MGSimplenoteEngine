//
//  MGSimplenote.h
//  MGSimplenoteEngine
//
//  Created by Martin Gordon on 4/5/10.
//  Copyright 2010 Martin Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGSNObject.h"

/**
 * This class represents a note. In general, a note object is generated by retrieving the index. However,
 * since all the data is not sent by the index, each note must pull it's data individually.
 *
 * For locally created notes, create an MGSimplenote object (using alloc/init), set the text and call -pushToRemote.
 *
 * Sample usage:
 *    // Retrieve index (see MGSimplenoteIndex header).
 *    MGSimplenote *note = [index.contents objectAtIndex:0];
 *    [note addObserver:self forSelector:@selector(pullFromRemote)
 *              success:@selector(notePulled:) failure:@selector(notePullFailed:)];
 *
 *    // Note from index or created locally
 *    note.text = @"Modified Note!";
 *    [note addObserver:self forSelector:@selector(pushToRemote)
 *              success:@selector(notePushed:) failure:@selector(notePushFailed:)];
 *    [note pushToRemote];
 */

@interface MGSimplenote : MGSNObject {
	NSString *key, *text;
	NSDate *modifyDate, *createDate;
	NSNumber *deleted;

    NSNumber *syncNum, *version, *minVersion;
    NSString *shareKey, *publishKey;
    NSArray *systemTags, *tags;
}

@property (nonatomic, copy) NSString *key, *text;
@property (nonatomic, retain) NSDate *modifyDate, *createDate;
@property (nonatomic, retain) NSNumber *deleted;

@property (nonatomic, retain) NSNumber *syncNum, *version, *minVersion;
@property (nonatomic, copy) NSString *shareKey, *publishKey;
@property (nonatomic, retain) NSArray *systemTags, *tags;

+ (id)noteWithDictionary:(NSDictionary *)dict;

- (void)pullFromRemote;
- (void)pushToRemote;
- (void)deleteNote;

@end
