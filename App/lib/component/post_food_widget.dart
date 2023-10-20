import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:exif/exif.dart';
import 'package:flutter/Cupertino.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:gohan_map/colors/app_colors.dart';
import 'package:gohan_map/component/app_rating_bar.dart';
import 'package:gohan_map/utils/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PostFoodWidget extends StatelessWidget {
  const PostFoodWidget({
    Key? key,
    required this.images,
    required this.onImageAdded,
    required this.onImageDeleted,
    this.initialStar,
    required this.onStarChanged,
    this.initialDate,
    required this.onDateChanged,
    this.initialComment,
    required this.onCommentChanged,
    this.onCommentFocusChanged,
    required this.onPublicChanged,
    this.initialPublic,
  }) : super(key: key);
  final List<File> images;
  final Function(File) onImageAdded;
  final Function(int) onImageDeleted;

  final double? initialStar;
  final Function(double) onStarChanged;

  final DateTime? initialDate;
  final Function(DateTime) onDateChanged;

  final String? initialComment;
  final Function(String) onCommentChanged;

  final Function(bool)? onCommentFocusChanged;

  final Function(bool) onPublicChanged;
  final bool? initialPublic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StarSection(
          initialStar: initialStar,
          onChanged: onStarChanged,
        ),
        const SizedBox(height: 16),
        _ImgSection(
            images: images,
            onAdded: onImageAdded,
            onDeleted: onImageDeleted,
            onDateTimeChanged: (DateTime dateTime) {
              // date = dateTime;
              onDateChanged(dateTime);
            }),
        const SizedBox(height: 16),
        _DateSection(
          date: initialDate ?? DateTime.now(),
          onChanged: onDateChanged,
        ),
        const SizedBox(height: 16),
        _CommentSection(
          initialComment: initialComment,
          onChanged: onCommentChanged,
          onFocusChanged: onCommentFocusChanged,
        ),
        const SizedBox(height: 16),
        _PublicSection(
          isPublic: initialPublic ?? false,
          onChanged: onPublicChanged,
        ),
      ],
    );
  }
}

class _StarSection extends StatelessWidget {
  const _StarSection({
    this.initialStar,
    required this.onChanged,
  });

  final double? initialStar;
  final Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: _SectionTitle(icon: Icons.star_rounded, title: "評価"),
        ),
        AppRatingBar(
            initialRating: initialStar ?? 4.0, onRatingUpdate: onChanged),
      ],
    );
  }
}

class _ImgSection extends StatelessWidget {
  final List<File> images;
  final Function(File) onAdded;
  final Function(int) onDeleted;
  final Function(DateTime) onDateTimeChanged;
  const _ImgSection({
    required this.images,
    required this.onAdded,
    required this.onDeleted,
    required this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _SectionTitle(icon: Icons.camera_alt_rounded, title: "写真"),
        ),
        DottedBorder(
          padding: EdgeInsets.zero,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          dashPattern: const [5, 5],
          color: const Color(0xFF444444),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                _UploadButton(
                  isMax: images.length >= 4,
                  onPressed: (images.length >= 4)
                      ? null
                      : () {
                          //iOS風のアクションシート
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoActionSheet(
                                title: const Text('写真を追加'),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                      await takePhoto();
                                    },
                                    child: const Text('カメラで撮影'),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                      await pickImage();
                                    },
                                    child: const Text('アルバムから選択'),
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('キャンセル'),
                                ),
                              );
                            },
                          );
                        },
                ),
              ],
            ),
          ),
        ),
        //GridViewを使う
        if (images.isNotEmpty) const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 16 / 9,
          ),
          itemBuilder: (BuildContext context, int index) {
            return _SelectedImgWidget(
              image: images[index],
              onDeletePressed: () {
                onDeleted(index);
              },
            );
          },
        ),
      ],
    );
  }

  Future takePhoto() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxWidth: 1200);
      // 画像がnullの場合戻る
      if (image == null) return;

      final imageTemp = File(image.path);
      onAdded(imageTemp);
    } on PlatformException catch (e) {
      logger.e('Failed to pick image: $e');
    }
  }

  // 画像をギャラリーから選ぶ関数
  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, maxWidth: 1200);

      // 画像がnullの場合戻る
      if (image == null) return;

      final imageTemp = File(image.path);
      // 撮影日を読み取る
      final tags = await readExifFromBytes(await imageTemp.readAsBytes());
      if (tags.containsKey("Image DateTime")) {
        // フォーマットが全デバイスで正しいのかは検討
        var imageDateTime = DateFormat("yyyy:MM:dd HH:mm:ss")
            .parse(tags["Image DateTime"].toString());
        onDateTimeChanged(imageDateTime);
      }
      onAdded(imageTemp);
    } on PlatformException catch (e) {
      logger.e('Failed to pick image: $e');
    }
  }
}

class _SelectedImgWidget extends StatelessWidget {
  const _SelectedImgWidget({
    required this.image,
    required this.onDeletePressed,
  });

  final File? image;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //画像を表示
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              image!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: -4,
          top: -4,
          child: IconButton(
            onPressed: onDeletePressed,
            icon: const Icon(
              Icons.cancel,
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({
    required this.onPressed,
    this.isMax = false,
  });
  final VoidCallback? onPressed;
  final bool isMax;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isMax)
              const Icon(
                Icons.upload_rounded,
                color: Color(0xFF444444),
                size: 30,
              ),
            const SizedBox(
              width: 8,
            ),
            Text(
              (isMax) ? '写真は最大4枚まで' : '写真を追加する',
              style: TextStyle(
                  color: (isMax)
                      ? AppColors.greyDarkColor
                      : const Color(0xFF595959)),
            ),
          ],
        ),
      ),
    );
  }
}

//訪問日入力欄
class _DateSection extends StatelessWidget {
  const _DateSection({
    required this.date,
    required this.onChanged,
  });

  final DateTime date;
  final Function(DateTime) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _SectionTitle(icon: Icons.edit_calendar_rounded, title: "訪問日"),
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: Color(0xFF444444),
                      width: 1,
                    ),
                  ),
                  backgroundColor: AppColors.whiteColor,
                  foregroundColor: const Color(0xFF444444)),
              onPressed: () async {
                var results = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    weekdayLabels: ['日', '月', '火', '水', '木', '金', '土'],
                    selectedDayHighlightColor: AppColors.primaryColor,
                    cancelButton: const Text(
                      "キャンセル",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    okButton: const Text(
                      "決定",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  dialogSize: const Size(325, 400),
                  value: [date],
                  borderRadius: BorderRadius.circular(15),
                );
                if (results != null && results.isNotEmpty) {
                  onChanged(results.first!);
                }
              },
              child: Text(
                DateFormat('yyyy年MM月dd日').format(date),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
        ),
      ],
    );
  }
}

//コメント入力欄
class _CommentSection extends StatelessWidget {
  const _CommentSection({
    this.initialComment,
    required this.onChanged,
    this.onFocusChanged,
  });
  final String? initialComment;
  final Function(String) onChanged;
  final Function(bool)? onFocusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _SectionTitle(icon: Icons.comment_bank_rounded, title: "コメント"),
        ),
        Focus(
          onFocusChange: onFocusChanged,
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 3,
            initialValue: initialComment,
            decoration: InputDecoration(
              hintText: 'おいしかった！',
              filled: true,
              fillColor: AppColors.whiteColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.blackTextColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.blackTextColor,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _PublicSection extends StatelessWidget {
  const _PublicSection({
    this.isPublic = false,
    required this.onChanged,
  });
  final bool isPublic;
  final Function(bool) onChanged;
  @override
  Widget build(BuildContext context) {
    final String msg = (isPublic)
        ? "投稿した画像がおすすめ機能として他ユーザーに公開されることがあります\n※訪問日やコメントは公開されません"
        : "投稿した画像がおすすめ機能として他ユーザーに公開されることはありません";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: _SectionTitle(icon: Icons.lock_open_rounded, title: "公開設定"),
        ),
        Row(
          children: [
            const Text('画像の公開を許可'),
            const Spacer(),
            CupertinoSwitch(
              value: isPublic,
              onChanged: onChanged,
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
        Text(
          msg,
          style: const TextStyle(color: AppColors.greyDarkColor, fontSize: 10),
        )
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
  });
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 26,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
