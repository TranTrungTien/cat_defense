# Kế hoạch Nâng cấp và Tăng cường Game Cat Defense

Bản nâng cấp này nhằm mục đích hoàn thiện logic game, đưa 15 loại Mèo và các loại Quái vật vào hoạt động thực tế, đồng thời triển khai hệ thống kỹ năng và cải thiện giao diện người dùng.

## Mục tiêu chính
- **Hệ thống Mèo linh hoạt**: Hỗ trợ 15 cấp độ mèo với chỉ số (sát thương, tốc độ bắn) và ngoại hình Spine khác nhau.
- **Hệ thống Quái vật đa dạng**: Triển khai các loại Zombie khác nhau (Regular, Shield, Boss) với HP và tốc độ biến thiên.
- **Hệ thống Kỹ năng**: Hiện thực hóa kỹ năng đặt Chông (Spikes) và Thuốc nổ (TNT).
- **Cải thiện UI/UX**: Cho phép chọn cấp độ mèo để mua và hiển thị thông tin trực quan hơn.

## Các thay đổi đề xuất

### 1. Dữ liệu Game (Data Layer)

#### [MODIFY] [game_data.dart](file:///C:/Users/Administrator/StudioProjects/cat_defense/lib/game_data.dart)
- Cập nhật registry đầy đủ cho 15 loại mèo.
- Thêm định nghĩa cho các loại Zombie khác nhau (từ ảnh 3).

### 2. Thành phần Game (Components)

#### [MODIFY] [cat_component.dart](file:///C:/Users/Administrator/StudioProjects/cat_defense/lib/components/cat_component.dart)
- Cho phép nhận `CatLevelData` để thay đổi thuộc tính và animation.
- Tích hợp sát thương từ dữ liệu cấp độ vào viên đạn.

#### [MODIFY] [enemy_component.dart](file:///C:/Users/Administrator/StudioProjects/cat_defense/lib/components/enemy_component.dart)
- Cho phép nhận `EnemyTypeData` để thay đổi HP, tốc độ và skin Spine.
- Cải thiện logic chết và phần thưởng.

#### [MODIFY] [placement_slot.dart](file:///C:/Users/Administrator/StudioProjects/cat_defense/lib/components/placement_slot.dart)
- Cập nhật logic mua mèo: sử dụng đúng giá tiền (`cost`) từ mèo đang được chọn.

#### [NEW] [spikes_component.dart](file:///C:/Users/Administrator/StudioProjects/cat_defense/lib/components/skills/spikes_component.dart)
- Thành phần kỹ năng Chông: gây sát thương liên tục cho Zombie đi ngang qua.

#### [NEW] [tnt_component.dart](file:///C:/Users/Administrator/StudioProjects/cat_defense/lib/components/skills/tnt_component.dart)
- Thành phần kỹ năng TNT: nổ và gây sát thương diện rộng.

### 3. Logic lõi (Core Logic)

#### [MODIFY] [cat_defense_game.dart](file:///C:/Users/Administrator/StudioProjects/cat_defense/lib/cat_defense_game.dart)
- Cải thiện Spawner để spawn nhiều loại quái vật dựa trên Wave hiện tại.
- Thêm cơ chế chọn loại mèo để đặt (không chỉ mặc định Level 3).
- Triển khai logic nạp kỹ năng.

### 4. Giao diện (UI)

#### [MODIFY] [game_ui.dart](file:///C:/Users/Administrator/StudioProjects/cat_defense/lib/ui/game_ui.dart)
- Cập nhật thanh chọn Mèo: Cho phép duyệt qua các cấp độ mèo đã mở khóa.
- Gắn logic kích hoạt kỹ năng vào các nút bấm dưới đáy màn hình.

## Kế hoạch kiểm chứng

### Kiểm tra tự động
- Chạy `flutter test` để đảm bảo không có lỗi runtime cơ bản (nếu có test suite).

### Kiểm tra thủ công
- Đặt thử các cấp độ mèo khác nhau và kiểm tra xem chúng có gây sát thương khác nhau không.
- Kiểm tra xem Zombie có thuộc tính khác nhau (tốc độ, máu) có xuất hiện không.
- Kích hoạt TNT và Chông để xem hiệu ứng và sát thương diện rộng.
- Kiểm tra việc trừ tiền và giới hạn vị trí đặt mèo.
