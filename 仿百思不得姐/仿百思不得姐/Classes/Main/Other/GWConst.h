
// 常用的常量的定义
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GWTopicType) {
    GWTopicTypeAll = 1,
    GWTopicTypePicture = 10,
    GWTopicTypeWord = 29,
    GWTopicTypeAudio = 31,
    GWTopicTypeVideo = 41
};

/** 精华-顶部标题的高度 */
UIKIT_EXTERN CGFloat const GWTitilesViewH;
/** 精华-顶部标题的Y */
UIKIT_EXTERN CGFloat const GWTitilesViewY;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const GWTopicCellMargin;
/** 精华-cell-文字内容的Y值 */
UIKIT_EXTERN CGFloat const GWTopicCellTextY;
/** 精华-cell-底部工具条的高度 */
UIKIT_EXTERN CGFloat const GWTopicCellBottomBarH;

/** 精华-cell-图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const GWTopicCellPictureMaxH;
/** 精华-cell-图片帖子一旦超过最大高度,就是用Break */
UIKIT_EXTERN CGFloat const GWTopicCellPictureBreakH;

/** XMGUser模型-性别属性值 */
UIKIT_EXTERN NSString * const GWUserSexMale;
UIKIT_EXTERN NSString * const GWUserSexFemale;

/** 精华-cell-最热评论标题的高度 */
UIKIT_EXTERN CGFloat const GWTopicCellTopCmtTitleH;

