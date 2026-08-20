/*
 This file is part of Osxie.

 Copyright (C) 2019 Lubos Dolezel

 Osxie is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Osxie is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Osxie.  If not, see <http://www.gnu.org/licenses/>.
*/

#import <Foundation/NSUserNotification.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSProcessInfo.h>

extern int osxie_dbus_portal_notify(void *portal, const char *app_name,
                                    const char *summary, const char *body,
                                    const char *icon_name);

@implementation NSUserNotification

@synthesize title = _title;
@synthesize informativeText = _informativeText;
@synthesize soundName = _soundName;
@synthesize actionButtonTitle = _actionButtonTitle;
@synthesize userInfo = _userInfo;
@synthesize hasActionButton = _hasActionButton;
@synthesize presented = _presented;
@synthesize activationType = _activationType;

- (id)copyWithZone:(NSZone *)zone
{
	NSUserNotification *copy = [[NSUserNotification alloc] init];
	copy.title = _title;
	copy.informativeText = _informativeText;
	copy.soundName = _soundName;
	copy.actionButtonTitle = _actionButtonTitle;
	copy.userInfo = _userInfo;
	copy.hasActionButton = _hasActionButton;
	return copy;
}

@end

@implementation NSUserNotificationAction

- (id)copyWithZone:(NSZone *)zone
{
	return nil;
}

@end

@implementation NSUserNotificationCenter

static NSUserNotificationCenter *_defaultUserNotificationCenter = nil;

@synthesize delegate = _delegate;

+ (NSUserNotificationCenter *)defaultUserNotificationCenter {
	if (_defaultUserNotificationCenter == nil) {
		_defaultUserNotificationCenter = [[NSUserNotificationCenter alloc] init];
	}
	return _defaultUserNotificationCenter;
}

- (void)deliverNotification:(NSUserNotification *)notification {
	if (!notification) return;

	const char *appName = [[[NSBundle mainBundle] infoDictionary][@"CFBundleName"] UTF8String];
	if (!appName) appName = [[[NSProcessInfo processInfo] processName] UTF8String];
	const char *title = [notification.title UTF8String];
	const char *body = [notification.informativeText UTF8String];

	if (osxie_dbus_portal_notify) {
		osxie_dbus_portal_notify(NULL, appName,
			title ? title : "",
			body ? body : "",
			"");
	}
}

- (void)removeDeliveredNotification:(NSUserNotification *)notification {
}

@end

NSString * const NSUserNotificationDefaultSoundName = @"DefaultSoundName";
