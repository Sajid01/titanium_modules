
//
// Copyright 2011 Box.net, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "BoxPublicShareOperation.h"

@implementation BoxPublicShareOperation

@synthesize targetID = _targetID;
@synthesize targetType = _targetType;
@synthesize password = _password;
@synthesize message = _message;
@synthesize emails = _emails;
@synthesize authToken = _authToken;

@synthesize sharedURL = _sharedURL;

+ (BoxPublicShareOperation *)operationForTargetID:(int)targetID
									   targetType:(NSString *)targetType
										 password:(NSString *)password
										  message:(NSString *)message
										   emails:(NSArray *)emails
										authToken:(NSString *)authToken
										 delegate:(id<BoxOperationDelegate>)delegate
{
	return [[[BoxPublicShareOperation alloc] initForTargetID:targetID
												  targetType:targetType
													password:password
													 message:message
													  emails:emails
												   authToken:authToken
													delegate:delegate] autorelease];
}

- (id)initForTargetID:(int)targetID
		   targetType:(NSString *)targetType
			 password:(NSString *)password
			  message:(NSString *)message
			   emails:(NSArray *)emails
			authToken:(NSString *)authToken
			 delegate:(id<BoxOperationDelegate>)delegate
{
	if (self = [super initForType:BoxOperationTypePublicShare delegate:delegate]) {
		self.targetID = targetID;
		self.targetType = targetType;
		self.password = password;
		self.message = message;
		self.emails = emails;
		self.authToken = authToken;
	}

	return self;
}

- (void)dealloc {
	self.targetType = nil;
	self.password = nil;
	self.message = nil;
	self.emails = nil;
	self.authToken = nil;
	if (self.sharedURL) {
		[_sharedURL release];
	}

	[super dealloc];
}

- (NSURL *)url {
	return [NSURL URLWithString:[BoxRESTApiFactory publicShareURLStringForAuthToken:self.authToken
																		   targetID:self.targetID
																		 targetType:self.targetType
																		   password:self.password
																			message:self.message
																			 emails:self.emails]];
}

- (NSString *)successCode {
	return @"share_ok";
}

- (NSArray *)resultKeysOfInterest {
	return [NSArray arrayWithObjects:@"status", @"public_name", nil];
}

- (void)processResult:(NSDictionary *)result {
	if ([result objectForKey:@"public_name"]) {
		_sharedURL = [[NSURL URLWithString:[NSString stringWithFormat:
										   @"https://www.box.net/shared/%@", 
										   [result objectForKey:@"public_name"]]] retain];
	}

	[super processResult:result];
}

@end
