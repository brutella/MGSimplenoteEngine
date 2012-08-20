//
//  MGSimplenoteSyncSession.m
//  MGSimpleNoteEngine
//
//  Created by Martin Gordon on 4/12/10.
//  Copyright 2010 Martin Gordon. All rights reserved.
//

#import "MGSimplenoteSyncSession.h"
#import "MGSimplenoteSyncStatus.h"

@implementation MGSimplenoteSyncSession

@synthesize completedItems, failedItems, totalItems;
@synthesize errors;
@synthesize status;

- (id)init {
	self = [super init];
	if (self != nil) {
		errors = [NSMutableArray array];
		status = [MGSimplenoteSyncStatus notStartedStatus];
		completedItems = 0;
		failedItems = 0;
		totalItems = 0;
	}
	return self;
}


- (void)beginWithTotalItemCount:(NSInteger)count {
	self.completedItems = 0;
	self.failedItems = 0;
	self.totalItems = count;
	
	errors = [NSMutableArray array];
	
	self.status = [MGSimplenoteSyncStatus inProgressStatus];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MGSimplenoteSyncBeginNotification" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self, @"session", nil]];
}

- (void)inProgress {
	if ([self.errors count] == 0 && failedItems == 0) {
		self.status = [MGSimplenoteSyncStatus completeStatus];
	} else {
		self.status = [MGSimplenoteSyncStatus completeWithErrorsStatus];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MGSimplenoteSyncProgressNotification" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self, @"session", nil]];
}


- (void)replaceCompleted:(NSInteger)completeCount failed:(NSInteger)failedCount {
	completedItems = completeCount;
	failedItems = failedCount;
	[self inProgress];
}


- (void)updateCompleted:(NSInteger)completeCount failed:(NSInteger)failedCount {
	completedItems += completeCount;
	failedItems += failedCount;
	[self inProgress];	
}


- (void)complete {
	if ([self.errors count] == 0 && failedItems == 0) {
		self.status = [MGSimplenoteSyncStatus completeStatus];
	} else {
		self.status = [MGSimplenoteSyncStatus completeWithErrorsStatus];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MGSimplenoteSyncCompleteNotification" object:self userInfo:[NSDictionary dictionaryWithObject:self forKey:@"session"]];
}

- (BOOL)allItemsComplete {
	return (completedItems + failedItems == totalItems);
}


@end
