# TripletFood - Ứng dụng đặt món ăn trực tuyến

TripletFood là một ứng dụng di động cho phép khách hàng đặt món ăn từ các nhà hàng và quản lý thông tin món ăn, đơn hàng từ trang admin. Ứng dụng này được phát triển bằng framework Flutter và sử dụng MySQL làm cơ sở dữ liệu phía backend. Trang admin được xây dựng thêm bằng ReactJS và sắp tới sẽ phát triển thêm trang dành cho User.

## Chức năng

### Trang khách hàng

- Đăng nhập và đăng ký tài khoản
- Tìm kiếm sản phẩm
- Xem menu, giá cả và thông tin chi tiết về mỗi món ăn
- Thêm và đặt món ăn
- Theo dõi đơn hàng và cập nhật trạng thái đơn hàng
- Cập nhật thông tin cá nhân
- Đánh giá và nhận xét về nhà hàng và món ăn (Sẽ cải tiến)

### Trang admin

- Đăng nhập vào trang admin
- Quản lý danh mục món ăn
- Quản lý danh sách món ăn
- Quản lý đơn hàng và cập nhật trạng thái đơn hàng
- Quản lý khách hàng
- Xem thông báo và thông tin thống kê

## Cài đặt

1. Clone dự án từ kho lưu trữ: `git clone https://github.com/Ngtinhs/FoodApp`
2. Di chuyển vào thư mục dự án backend: `cd be_foodapp`
- Chạy lệnh php artisan migrate: chạy migration để tạo table với column
- Tiếp theo chạy php artisan db:seed: chạy các dữ liệu mẫu ban đầu
- Cuối cùng chạy php artisan serve: để chạy BE
3. Di chuyển vào thư mục dự án cline: `cd food-app`
4. Cài đặt các dependencies cho phía client: `cd foodapp && flutter pub get`
5. Cài đặt các dependencies cho trang admin: `cd admin && npm install`

## Sử dụng

1. Khởi chạy ứng dụng di động trên máy ảo hoặc thiết bị di động: `flutter run`
2. Khởi chạy trang admin trên môi trường phát triển: `cd admin && npm start`

## Yêu cầu hệ thống

- Phiên bản Flutter: 3.7.8 trở lên
- Phiên bản Xampp: 7.4 trở lên
- Composer: 2.5.5
- Phiên bản Node.js: 14.17.0 trở lên
- Máy ảo, sử dụng Android Studio sdk 31


## Đóng góp

Chúng tôi rất hoan nghênh đóng góp của bạn vào dự án. Nếu bạn muốn đóng góp, hãy làm theo các bước sau:

1. Fork dự án
2. Tạo một nhánh mới (`git checkout -b tennhanh`)
3. Commit các thay đổi của bạn (`git commit -am 'Thêm chức năng abc'`)
4. Push nhánh (`git push origin tennhanh`)
5. Tạo một yêu cầu pull mới
