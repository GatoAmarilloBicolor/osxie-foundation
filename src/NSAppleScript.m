/*
 This file is part of Osxie.

 Copyright (C) 2019 Lubos Dolezel

 Darling is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Darling is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Darling.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Foundation/NSAppleScript.h>
#import <Foundation/NSMethodSignature.h>
#import <Foundation/NSInvocation.h>

NSString *const NSAppleScriptErrorMessage = @"NSAppleScriptErrorMessage";
NSString *const NSAppleScriptErrorNumber = @"NSAppleScriptErrorNumber";
NSString *const NSAppleScriptErrorAppName = @"NSAppleScriptErrorAppName";
NSString *const NSAppleScriptErrorBriefMessage = @"NSAppleScriptErrorBriefMessage";
NSString *const NSAppleScriptErrorRange = @"NSAppleScriptErrorRange";

@implementation NSAppleScript

- (id)copyWithZone:(NSZone *)zone
{
	NSLog(@"NSAppleScript copyWithZone:");
	return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes: "v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"Stub called: %@ in %@", NSStringFromSelector([anInvocation selector]), [self class]);
}

@end
