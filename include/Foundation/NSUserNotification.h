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

#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>

typedef NS_ENUM(NSInteger, NSUserNotificationActivationType) {
    NSUserNotificationActivationTypeNone = 0,
    NSUserNotificationActivationTypeContentsClicked = 1,
    NSUserNotificationActivationTypeActionButtonClicked = 2,
    NSUserNotificationActivationTypeReplied = 3,
};

@interface NSUserNotification : NSObject <NSCopying> {
    NSString *_title;
    NSString *_informativeText;
    NSString *_soundName;
    NSString *_actionButtonTitle;
    NSDictionary *_userInfo;
    BOOL _hasActionButton;
    BOOL _presented;
    NSUserNotificationActivationType _activationType;
    id _uniqueId;
}
@property(copy) NSString *title;
@property(copy) NSString *informativeText;
@property(copy) NSString *soundName;
@property(copy) NSString *actionButtonTitle;
@property(copy) NSDictionary *userInfo;
@property BOOL hasActionButton;
@property(readonly, getter=isPresented) BOOL presented;
@property(readonly) NSUserNotificationActivationType activationType;
@end

@interface NSUserNotificationAction : NSObject <NSCopying>
@end

@protocol NSUserNotificationCenterDelegate <NSObject>
@end

@interface NSUserNotificationCenter : NSObject {
    id<NSUserNotificationCenterDelegate> _delegate;
}

@property(class, readonly, strong) NSUserNotificationCenter *defaultUserNotificationCenter;
@property(assign) id<NSUserNotificationCenterDelegate> delegate;

- (void)deliverNotification:(NSUserNotification *)notification;
- (void)removeDeliveredNotification:(NSUserNotification *)notification;

@end

FOUNDATION_EXPORT NSString * const NSUserNotificationDefaultSoundName;
