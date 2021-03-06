/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UAPushSettingsAliasViewController.h"
#import "UAPush.h"

enum {
    SectionDesc        = 0,
    SectionAlias       = 1,
    SectionCount       = 2
};

enum {
    AliasSectionInputRow = 0,
    AliasSectionRowCount = 1
};

enum {
    DescSectionText   = 0,
    DescSectionRowCount = 1
};

@implementation UAPushSettingsAliasViewController

@synthesize tableView;
@synthesize aliasCell;
@synthesize textCell;
@synthesize textLabel;
@synthesize aliasField;

- (void)dealloc {
	
    RELEASE_SAFELY(tableView);
    RELEASE_SAFELY(aliasCell);
    RELEASE_SAFELY(textCell);
    RELEASE_SAFELY(textLabel);
    RELEASE_SAFELY(aliasField);
	
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Device Alias";
    
    aliasField.text = [UAPush shared].alias;
    textLabel.text = @"Assign an alias to a device or a group of devices to simplify "
                     @"the process of sending notifications.";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDelegate

#define kCellPaddingHeight 10

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionDesc) {
        CGFloat height = [textLabel.text sizeWithFont:textLabel.font
                          constrainedToSize:CGSizeMake(300, 1500)
                              lineBreakMode:UILineBreakModeWordWrap].height;
        return height + kCellPaddingHeight * 2;
    } else {
        return 44;
    }

}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case SectionAlias:
            return AliasSectionRowCount;
        case SectionDesc:
            return DescSectionRowCount;
        default:
            break;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SectionAlias) {
        return aliasCell;
    } else if (indexPath.section == SectionDesc) {
        return textCell;
    }
    
    return nil;
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
	NSString *newAlias = aliasField.text;
	
	// Trim leading whitespace
	NSRange range = [newAlias rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
	NSString *result = [newAlias stringByReplacingCharactersInRange:range withString:@""];
	
    if ([result length] != 0) {
        [[UAPush shared] setAlias:result];
        [[UAPush shared] updateRegistration];
    } else {
		textField.text = nil;
		[[UAPush shared] setAlias:nil];
        [[UAPush shared] updateRegistration];
	}
}

@end
