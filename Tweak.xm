#define USE_REAL_PATH
#import "../EmojiLibrary/Header.h"
#import "../PSHeader/Misc.h"

%hook UIKeyboardEmojiCategory

+ (NSString *)localizedStringForKey: (NSString *)key {
    if ([key hasPrefix:@"Recents"])
        return %orig;
    NSBundle *bundle = [NSBundle bundleWithPath:realPath(@"/System/Library/TextInput/TextInput_emoji.bundle")];
    if (![bundle isLoaded])
    	[bundle load];
    return [bundle localizedStringForKey:key value:nil table:@"Localizable2"];
}

%end

%hook UIKeyboardEmojiCategory

%group iOS83Up

+ (NSString *)displayName: (NSInteger)categoryType {
    NSString *name = nil;
    switch (categoryType) {
        case 0:
            name = @"Frequently Used Category";
            break;
        case 1:
            name = @"People Category";
            break;
        case 2:
            name = @"Nature Category";
            break;
        case 3:
            name = @"Food & Drink Category";
            break;
        case 4:
            name = @"Activity Category";
            break;
        case 5:
            name = @"Travel & Places Category";
            break;
        case 6:
            name = @"Objects Category";
            break;
        case 7:
            name = @"Symbols Category";
            break;
        case 8:
            name = @"Flags";
            break;
    }
    return isiOS9Up ? [NSClassFromString(@"UIKeyboardEmojiCategory") localizedStringForKey:name] : [self localizedStringForKey:name];
}

%end

%group preiOS83

- (NSString *)displayName {
    NSString *name = nil;
    int categoryType = self.categoryType;
    if (categoryType < CATEGORIES_COUNT) {
        switch (categoryType) {
            case 0:
                name = @"Recents Category";
                break;
            case 1:
                name = @"People Category";
                break;
            case 2:
                name = @"Nature Category";
                break;
            case 3:
                name = @"Food & Drink Category";
                break;
            case 4:
                name = @"Activity Category";
                break;
            case 5:
                name = @"Travel & Places Category";
                break;
            case 6:
                name = @"Objects Category";
                break;
            case 7:
                name = @"Symbols Category";
                break;
            case 8:
                name = @"Flags";
                break;
        }
    }
    return [NSClassFromString(@"UIKeyboardEmojiCategory") localizedStringForKey:name];
}

%end

%group iOS78And83

- (NSString *)name {
    NSString *name = nil;
    int categoryType = self.categoryType;
    if (categoryType < CATEGORIES_COUNT) {
        switch (categoryType) {
            case 0:
                name = @"UIKeyboardEmojiCategoryRecent";
                break;
            case 1:
                name = @"UIKeyboardEmojiCategoryPeople";
                break;
            case 2:
                name = @"UIKeyboardEmojiCategoryNature";
                break;
            case 3:
                name = @"UIKeyboardEmojiCategoryFoodAndDrink";
                break;
            case 4:
                name = @"UIKeyboardEmojiCategoryCelebration";
                break;
            case 5:
                name = @"UIKeyboardEmojiCategoryActivity";
                break;
            case 6:
                name = @"UIKeyboardEmojiCategoryTravelAndPlaces";
                break;
            case 7:
                name = @"UIKeyboardEmojiCategoryObjectsAndSymbols";
                break;
            case 8:
                name = @"UIKeyboardEmojiCategoryFlags";
                break;
        }
    }
    return name;
}

%end

%end

%ctor {
    %init;
    BOOL iOS78 = isiOS78;
    BOOL iOS83Up = isiOS83Up;
    BOOL iOS9Up = isiOS9Up;
    if (!iOS83Up) {
        %init(preiOS83);
    }
    if (iOS78 || iOS83Up) {
        if (iOS83Up) {
            %init(iOS83Up);
        }
        if (!iOS9Up) {
            %init(iOS78And83);
        }
    }
}
