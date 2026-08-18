/** Implementation of NSObject+NSComparisonMethods for GNUStep
   Copyright (C) 2008 Free Software Foundation, Inc.
   Written by:  Gregory Casamento <greg_casamento@yahoo.com>
   Date: 2008
   This file is part of the GNUstep Base Library.
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02111 USA.
   <title>NSObject+NSComparisonMethods category reference</title>
   $Date: 2008-11-26 04:20:34 -0500 (Wed, 26 Nov 2008) $ $Revision: 27135 $
*/

#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import "NSObjectInternal.h"

@interface NSObject (NSComparisonMethods)
- (BOOL) doesContain: (id) object;
- (BOOL) isCaseInsensitiveLike: (id) object;
- (BOOL) isEqualTo: (id) object;
- (BOOL) isGreaterThan: (id) object;
- (BOOL) isGreaterThanOrEqualTo: (id) object;
- (BOOL) isLessThan: (id) object;
- (BOOL) isLessThanOrEqualTo: (id) object;
- (BOOL) isLike: (NSString *)object;
- (BOOL) isNotEqualTo: (id) object;
@end

@implementation NSObject (NSComparisonMethods)
- (BOOL) doesContain: (id) object
{
  if (object)
    {
      if ([self isKindOfClass: [NSArray class]])
	{
	  return [(NSArray *)self containsObject: object];
	}
    }
  return NO;
}

static BOOL NSLikeMatchWithFlags(NSString *receiver, NSString *pattern, NSStringCompareOptions options)
{
  NSUInteger rlen = [receiver length];
  NSUInteger plen = [pattern length];

  if (plen == 0)
    {
      return rlen == 0;
    }

  if ([pattern rangeOfString:@"*"].location == NSNotFound &&
      [pattern rangeOfString:@"?"].location == NSNotFound)
    {
      return [receiver compare: pattern options: options] == NSOrderedSame;
    }

  const unichar *rchars = malloc((rlen + 1) * sizeof(unichar));
  const unichar *pchars = malloc((plen + 1) * sizeof(unichar));
  [receiver getCharacters: (unichar *)rchars range: NSMakeRange(0, rlen)];
  [pattern getCharacters: (unichar *)pchars range: NSMakeRange(0, plen)];

  BOOL (^matchUnichars)(unichar, unichar) = ^BOOL (unichar a, unichar b) {
    if (a == b)
      {
        return YES;
      }
    if ((options & NSCaseInsensitiveSearch) != 0)
      {
        return [[NSString stringWithCharacters: &a length: 1] caseInsensitiveCompare: [NSString stringWithCharacters: &b length: 1]] == NSOrderedSame;
      }
    return NO;
  };

  /* Greedy wildcard matcher with backtracking (SQL LIKE semantics:
     '*' matches any sequence, '?' matches a single character). */
  NSUInteger i = 0;
  NSUInteger j = 0;
  NSUInteger starR = NSNotFound;
  NSUInteger starP = NSNotFound;

  while (i < rlen)
    {
      if (j < plen && pchars[j] == '*')
        {
          starR = i;
          starP = j++;
        }
      else if (j < plen && (pchars[j] == '?' || matchUnichars(rchars[i], pchars[j])))
        {
          i++;
          j++;
        }
      else if (starP != NSNotFound)
        {
          i = ++starR;
          j = starP + 1;
        }
      else
        {
          break;
        }
    }

  while (j < plen && pchars[j] == '*')
    {
      j++;
    }

  BOOL result = (i == rlen && j == plen);

  free((void *)rchars);
  free((void *)pchars);
  return result;
}

- (BOOL) isCaseInsensitiveLike: (id) object
{
  if (![self isNSString__] || ![object isNSString__])
    {
      return NO;
    }
  return NSLikeMatchWithFlags((NSString *)self, (NSString *)object, NSCaseInsensitiveSearch);
}

- (BOOL) isEqualTo: (id) object
{
  return [self isEqual: object];
}

- (BOOL) isGreaterThan: (id) object
{
  return ([self compare: object] == NSOrderedDescending);
}

- (BOOL) isGreaterThanOrEqualTo: (id) object
{
  return ([self compare: object] == NSOrderedDescending ||
	  [self compare: object] == NSOrderedSame);
}

- (BOOL) isLessThan: (id) object
{
  return ([self compare: object] == NSOrderedAscending);
}

- (BOOL) isLessThanOrEqualTo: (id) object
{
  return ([self compare: object] == NSOrderedAscending ||
	  [self compare: object] == NSOrderedSame);
}

- (BOOL) isLike: (NSString *)object
{
  if (![self isNSString__] || ![object isNSString__])
    {
      return NO;
    }
  return NSLikeMatchWithFlags((NSString *)self, object, 0);
}

- (BOOL) isNotEqualTo: (id) object
{
  return !([self isEqual: object]);
}
@end
