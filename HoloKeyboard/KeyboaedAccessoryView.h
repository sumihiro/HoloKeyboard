//
//  KeyboaedAccessoryView.h
//  HoloKeyboard
//
//  Created by Sumihiro Ueda on 2017/02/10.
//

#import <UIKit/UIKit.h>

typedef void(^KeyboaedAccessoryViewTap)();

@interface KeyboaedAccessoryView : UIView

@property (nonatomic,copy) KeyboaedAccessoryViewTap up;
@property (nonatomic,copy) KeyboaedAccessoryViewTap down;
@property (nonatomic,copy) KeyboaedAccessoryViewTap left;
@property (nonatomic,copy) KeyboaedAccessoryViewTap right;
@property (nonatomic,copy) KeyboaedAccessoryViewTap tab;
@property (nonatomic,copy) KeyboaedAccessoryViewTap reverseTab;
@property (nonatomic,copy) KeyboaedAccessoryViewTap space;
@property (nonatomic,copy) KeyboaedAccessoryViewTap enter;
@property (nonatomic,copy) KeyboaedAccessoryViewTap backSpace;

@end
