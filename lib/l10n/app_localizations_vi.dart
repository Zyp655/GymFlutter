// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'GymFit Pro';

  @override
  String get discover => 'Khám phá';

  @override
  String get favorites => 'Yêu thích';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get searchHint => 'Tìm phòng gym...';

  @override
  String get noGymsFound => 'Không tìm thấy phòng gym';

  @override
  String get noGymsDescription =>
      'Hãy thử điều chỉnh tìm kiếm hoặc bộ lọc, hoặc thêm phòng gym mới.';

  @override
  String get addGym => 'Thêm Gym';

  @override
  String get editGym => 'Sửa Gym';

  @override
  String get deleteGym => 'Xóa Gym';

  @override
  String get deleteConfirmTitle => 'Xóa phòng gym?';

  @override
  String get deleteConfirmMessage =>
      'Bạn có chắc muốn xóa phòng gym này? Hành động này không thể hoàn tác.';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get save => 'Lưu';

  @override
  String get gymAddedSuccess => 'Thêm phòng gym thành công';

  @override
  String get gymUpdatedSuccess => 'Cập nhật phòng gym thành công';

  @override
  String get gymDeletedSuccess => 'Xóa phòng gym thành công';

  @override
  String get errorOccurred => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get requiredField => 'Trường này bắt buộc';

  @override
  String get invalidEmail => 'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String get invalidPhone => 'Vui lòng nhập số điện thoại hợp lệ';

  @override
  String get invalidRating => 'Đánh giá phải từ 0 đến 5';

  @override
  String get welcomeBack => 'Chào mừng trở lại';

  @override
  String get signInToContinue => 'Đăng nhập để tiếp tục';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get noAccount => 'Chưa có tài khoản?';

  @override
  String get hasAccount => 'Đã có tài khoản?';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get continueAsGuest => 'Tiếp tục với vai trò khách';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get enterEmailAddress => 'Nhập địa chỉ email của bạn';

  @override
  String get passwordResetSent => 'Đã gửi email đặt lại mật khẩu';

  @override
  String get send => 'Gửi';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get joinApp => 'Tham gia GymFit Pro';

  @override
  String get createAccountSubtitle => 'Tạo tài khoản để đồng bộ dữ liệu';

  @override
  String get or => 'HOẶC';

  @override
  String get reviews => 'Đánh giá';

  @override
  String get noReviewsYet => 'Chưa có đánh giá. Hãy là người đầu tiên!';

  @override
  String get writeReview => 'Viết đánh giá';

  @override
  String get submit => 'Gửi';

  @override
  String get rating => 'Đánh giá';

  @override
  String get comment => 'Bình luận';

  @override
  String get shareExperience => 'Chia sẻ trải nghiệm của bạn...';

  @override
  String get reviewAdded => 'Đã thêm đánh giá!';

  @override
  String get pleaseSignInToReview => 'Vui lòng đăng nhập để viết đánh giá';

  @override
  String get oopsError => 'Ồ! Đã xảy ra lỗi';

  @override
  String get retry => 'Thử lại';

  @override
  String get all => 'Tất cả';

  @override
  String get about => 'Giới thiệu';

  @override
  String get contactInformation => 'Thông tin liên hệ';

  @override
  String get phone => 'Điện thoại';

  @override
  String get premiumFacilities => 'Tiện ích cao cấp';

  @override
  String get peakHoursAnalytics => 'Thống kê giờ cao điểm';

  @override
  String get theme => 'Giao diện';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get themeSystem => 'Hệ thống';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageName => 'Language / Ngôn ngữ';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get appVersion => 'Phiên bản ứng dụng';

  @override
  String get signedOutSuccess => 'Đã đăng xuất thành công';

  @override
  String get signInToAccount => 'Đăng nhập vào tài khoản';

  @override
  String get syncFavorites => 'Đồng bộ yêu thích và dữ liệu trên các thiết bị';

  @override
  String memberSince(String date) {
    return 'Thành viên từ $date';
  }

  @override
  String get noEmail => 'Không có email';

  @override
  String get favoritesCount => 'YÊU THÍCH';

  @override
  String get syncStatus => 'ĐỒNG BỘ';

  @override
  String get synced => 'Đã đồng bộ';

  @override
  String get syncing => 'Đang đồng bộ...';

  @override
  String get basicInformation => 'Thông tin cơ bản';

  @override
  String get gymName => 'Tên Gym *';

  @override
  String get address => 'Địa chỉ *';

  @override
  String get description => 'Mô tả *';

  @override
  String get contactInfo => 'Thông tin liên hệ';

  @override
  String get phoneNumber => 'Số điện thoại *';

  @override
  String get details => 'Chi tiết';

  @override
  String get emailField => 'Email *';

  @override
  String get imageUrl => 'URL hình ảnh *';

  @override
  String get ratingField => 'Đánh giá (0-5) *';

  @override
  String get openingHours => 'Giờ mở cửa *';

  @override
  String get latitude => 'Vĩ độ';

  @override
  String get longitude => 'Kinh độ';

  @override
  String get facilities => 'Tiện ích';

  @override
  String get statistics => 'Thống kê';

  @override
  String get noFavorites => 'Chưa có yêu thích';

  @override
  String get noFavoritesDescription => 'Khám phá và lưu phòng gym yêu thích!';

  @override
  String get discoverGyms => 'Khám phá Gym';

  @override
  String get onboardingTitle1 => 'Khám phá Phòng Gym';

  @override
  String get onboardingDesc1 =>
      'Tìm các trung tâm thể dục cao cấp và phòng tập boutique gần bạn với thông tin chi tiết.';

  @override
  String get onboardingTitle2 => 'Lưu Yêu thích';

  @override
  String get onboardingDesc2 =>
      'Tạo bộ sưu tập cá nhân các phòng gym hàng đầu để truy cập nhanh mọi lúc.';

  @override
  String get onboardingTitle3 => 'Đồng bộ Đa thiết bị';

  @override
  String get onboardingDesc3 =>
      'Dữ liệu và yêu thích của bạn được tự động sao lưu và đồng bộ mọi nơi.';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get next => 'Tiếp';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get error => 'Lỗi';

  @override
  String get gymDataNotAvailable => 'Dữ liệu phòng gym không có sẵn.';

  @override
  String get pageNotFound => 'Không tìm thấy trang';

  @override
  String get aiAssistant => 'AI';

  @override
  String get typeMessage => 'Nhập tin nhắn...';

  @override
  String get aiThinking => 'AI đang suy nghĩ...';

  @override
  String get aiWelcomeMessage =>
      'Hỏi tôi bất cứ điều gì về phòng gym, lịch tập, hay dinh dưỡng! Tôi ở đây để giúp bạn đạt mục tiêu thể hình 💪';

  @override
  String get recommendations => 'Gợi ý';

  @override
  String get recommendedForYou => 'Gợi ý cho bạn';

  @override
  String get getRecommendations => 'Nhận gợi ý từ AI';

  @override
  String get aiSuggestion1 => 'Gợi ý lịch tập cho người mới 🏋️';

  @override
  String get aiSuggestion2 => 'Phòng gym gần tôi nhất? 📍';

  @override
  String get aiSuggestion3 => 'Chế độ dinh dưỡng tăng cơ 🥩';

  @override
  String get aiSuggestion4 => 'Làm sao chọn phòng gym phù hợp? 🤔';
}
