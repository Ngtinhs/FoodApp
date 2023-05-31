# TripletFood - Ứng dụng đặt món ăn trực tuyến

TripletFood là một ứng dụng di động cho phép khách hàng đặt món ăn từ nhà hàng và quản lý thông tin món ăn, đơn đặt món từ trang admin. Ứng dụng này được phát triển bằng framework Flutter và sử dụng MySQL làm cơ sở dữ liệu phía backend. Trang admin được xây dựng thêm bằng ReactJS và sắp tới sẽ phát triển thêm trang dành cho User.

## Chức năng

### Trang khách hàng

- Đăng nhập và đăng ký tài khoản
- Tìm kiếm món ăn
- Xem menu, giá cả và thông tin chi tiết về mỗi món ăn
- Thêm và đặt món ăn
- Theo dõi đơn đặt món và cập nhật trạng thái đơn đặt món
- Cập nhật thông tin cá nhân
- Đánh giá và nhận xét về nhà hàng và món ăn (Sẽ cải tiến)
<div>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240694032-395c0bd7-a551-4c02-a166-be51cd556fb2.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240694772-ce2b1da2-5818-46a3-b32a-af6ec604baa6.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240695087-ba0ca549-22f5-4400-9628-83684d4cc635.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240695092-7e3ed342-6560-4c38-abcf-b646d8a169d5.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240695106-22cb8013-defe-4b13-89f0-bbb0e5915e46.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240695102-7369bb01-c85f-471a-9c17-3fa53f1742cb.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240695080-ac66fcb2-bd52-4c56-8a60-7f1a2a06c43c.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240695068-6a4d520f-3113-4189-82c4-593d16ee8aab.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240695084-5cdc1ed2-7b4c-4189-b3cb-6e0997539c94.PNG" width="195px"/>
<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/76445000/240695096-95db339a-6809-4870-83ad-f851050ca958.PNG" width="195px"/>
</div>



### Trang admin

- Đăng nhập vào trang admin
- Quản lý danh mục món ăn
- Quản lý danh sách món ăn
- Quản lý đơn đặt món và cập nhật trạng thái đơn đặt món
- Quản lý khách hàng
- Xem thông báo và thông tin thống kê


<div>
<img src="https://user-images.githubusercontent.com/76445000/240698658-e9acfcf6-4a5c-4588-9bb0-1922c49ecd0b.PNG" width="195px"/>
<img src="https://user-images.githubusercontent.com/76445000/240698675-28a57e41-2ddf-4ff8-8a40-e5326bd984a6.PNG" width="195px"/>
<img src="https://user-images.githubusercontent.com/76445000/240698684-8b4e748d-68ac-486c-af50-042b95100a50.PNG" width="195px"/>
<img src="https://user-images.githubusercontent.com/76445000/240698703-cca6c612-375d-474a-855b-086d357719cb.PNG" width="195px"/>
<img src="https://user-images.githubusercontent.com/76445000/240698715-49d8b337-9ad2-408e-ac14-24da81b8d63b.PNG" width="195px"/>
<img src="https://user-images.githubusercontent.com/76445000/240698722-600c0cfb-d830-475a-b7e8-72c1063b00e7.PNG" width="195px"/>
</div>

<div>
<img src="https://user-images.githubusercontent.com/76445000/240699349-6b16226f-4969-4882-9f40-33734fa0c991.PNG" width="780px"/>
<img src="https://user-images.githubusercontent.com/76445000/240699364-1760c20e-651a-4b72-879d-91af862d7648.PNG" width="780px"/>
<img src="https://user-images.githubusercontent.com/76445000/240699355-9302bc07-b49c-46f4-bd84-5b0f07a64c33.PNG" width="780px"/>
<img src="https://user-images.githubusercontent.com/76445000/240699375-07d2ea36-e2f0-4ecd-92b7-9628b1134256.PNG" width="780px"/>
<img src="https://user-images.githubusercontent.com/76445000/240699342-c304fc1d-2c40-4eb7-b907-8a9e4676b4a9.PNG" width="780px"/>
</div>







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
