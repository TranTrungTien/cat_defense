# Chiến lược triển khai Branching Merge và Evolution System

Tái cấu trúc hệ thống Merge từ tuyến tính (Lv1 -> Lv2) sang phân nhánh (Evolution Tree) và tích hợp UI chọn hướng tiến hóa.

## User Review Required

> [!IMPORTANT]
> Việc thay đổi cấu trúc `CatLevelData` sẽ ảnh hưởng đến logic nâng cấp hiện tại. Tôi sẽ tạm thời chia 15 loại mèo hiện có thành 3 nhánh chính: Gunner, Marksman, và Explosive để tận dụng Asset Spine.

## Proposed Changes

### Core Data & Models
#### [MODIFY] [game_data.dart](file:///C:/Users/cat_defense-master/lib/game_data.dart)
- Bổ sung `enum CatBranch { gunner, marksman, explosive, support }`.
- Thêm `List<int> evolutionIds` vào `CatLevelData` để định nghĩa các node con trong cây.
- Cấu trúc lại mảng `catLevels` theo sơ đồ tiến hóa (ví dụ: Cat 1 tiến hóa thành 2 hoặc 3).

### Gameplay Logic
#### [MODIFY] [placement_slot.dart](file:///C:/Users/cat_defense-master/lib/components/placement_slot.dart)
- Cập nhật hàm `onTapDown` và thêm logic xử lý va chạm khi Drag & Drop giữa các Slot.
- Khi 2 mèo cùng Level chạm nhau, kích hoạt tín hiệu mở Evolution UI thay vì nâng cấp tự động.

### UI / Overlay
#### [NEW] [evolution_overlay.dart](file:///C:/Users/cat_defense-master/lib/ui/evolution_overlay.dart)
- Tạo Widget Flutter hiển thị 2 lựa chọn tiến hóa.
- Hiển thị thông số so sánh: Damage, Range, Attack Speed.
- Gửi kết quả lựa chọn về Flame Engine để thực hiện chuyển đổi unit.

## Verification Plan

### Automated Tests
- Kiểm tra hàm `getEvolutionOptions(level)` trả về đúng danh sách ID theo cấu hình.

### Manual Verification
- Kéo 1 Cat Lv1 vào 1 Cat Lv1 khác trên màn hình.
- Xác nhận Overlay hiển thị đúng 2 lựa chọn (ví dụ: Rapid Cat vs Marksman Cat).
- Sau khi chọn, Cat trên Slot được thay thế bằng loại mới tương ứng.
