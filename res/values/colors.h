//
//  colors.h
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#define CLEAR_COLOR [UIColor clearColor]
#define WHITE_COLOR [UIColor whiteColor]
#define BLACK_COLOR [UIColor blackColor]

#define COLORV(__value__) (__value__/255.0)
#define COLOR(__r__, __g__, __b__) [UIColor colorWithRed:COLORV(__r__) green:COLORV(__g__) blue:COLORV(__b__) alpha:1.0]

#define GREY(__value__) COLOR(__value__, __value__, __value__)

#define MENU_BACKGROUND_COLOR GREY(80)
#define MENU_RIGHT_BAR_LIGHT_COLOR COLORV(212)
#define MENU_RIGHT_BAR_DARK_COLOR COLORV(100)

#define MENU_ITEM_DIVIDER_COLOR GREY(170)

#define FLASH_CARD_LINE_COLOR COLOR(76, 137, 187)