# 📱 Line A Day – 프로젝트 문서

## 앱 개요
**Line A Day**는 감정 중심의 일기 작성 애플리케이션입니다.  
사용자가 매일의 감정을 기록하고, 추억을 정리하며, 자신의 성장을 확인할 수 있도록 돕는 앱입니다.

---

## 🎯 핵심 기능

### 1. 일기 관리 (Diary)
- ✍️ 일기 작성 (제목, 내용, 감정, 사진, 날씨, 위치, 태그)
- 📅 캘린더 기반 일기 조회
- 🔍 검색 기능 (제목, 내용, 태그)
- 😊 감정별 필터링
- 📝 임시 저장(Draft) 기능
- 🖼️ 다중 이미지 첨부

### 2. 감정 통계 (Statistics)
- 📊 기간별 통계 (주간 / 월간 / 연간)
- 📈 감정 분포 차트
- 🏆 TOP 3 감정 분석
- 📉 일기 작성 빈도 그래프

### 3. 목표 & 뱃지 (Goals)
- 🎯 주간 / 월간 작성 목표
- 🔥 연속 작성(Streak) 추적
- 😊 긍정 감정 비율 목표
- 🏅 목표 달성 뱃지 시스템

### 4. 설정 (Settings)
- 🔒 앱 잠금 (비밀번호 / 생체 인증)
- 🔔 알림 설정 (요일별 시간 설정)
- 💾 백업 & 복원 (앱 내부 / 파일 / Google Drive)
- 🎨 테마 설정 (다크모드, 컬러 테마)
- 📊 사용 통계

---

## 🏗️ 아키텍처 구조

```
Presentation Layer (View + ViewModel + State)
            ↓
      Domain Layer (Use Cases + Repositories)
            ↓
       Data Layer (Repository Impl + Data Sources)
```

상태 관리: **Riverpod (StateNotifier)**

---

## 📦 패키지 구조

```
lib/
├── core/                           # 핵심 공통 기능
│   ├── base/                       # 추상 클래스
│   │   ├── base_state.dart
│   │   ├── base_view_model.dart
│   │   └── use_case.dart
│   ├── config/                     # 앱 설정
│   │   ├── routes.dart             # 라우팅
│   │   └── theme/
│   │       └── theme.dart          # 테마 설정
│   ├── database/                   # Isar 데이터베이스
│   │   ├── isar_service.dart
│   │   ├── diary_entity.dart       # 일기 Entity
│   │   └── diary_entity.g.dart     # Generated
│   ├── storage/                    # SharedPreferences
│   │   ├── storage_service.dart
│   │   └── storage_keys.dart
│   ├── error/                      # 에러 처리
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   └── services/                   # 공통 서비스
│       ├── notification_service.dart    # 알림
│       ├── auth_service.dart            # 인증 (생체인증/비밀번호)
│       ├── backup_service.dart          # 백업/복원
│       ├── image_picker_service.dart    # 이미지 선택
│       ├── app_lifecycle_service.dart   # 앱 생명주기
│       ├── app_lock_manager.dart        # 앱 잠금 관리
│       └── google_drive_service.dart    # Google Drive 연동
│
├── shared/                         # 공유 리소스
│   ├── constants/                  # 상수
│   │   ├── app_constants.dart
│   │   ├── emotion_constants.dart
│   │   ├── weather_constants.dart
│   │   └── bottom_tap_name.dart
│   ├── widgets/                    # 공통 위젯
│   │   ├── buttons/
│   │   ├── dialogs/
│   │   ├── indicators/
│   │   ├── calendar/
│   │   └── animations/
│   └── extensions/                 # 확장 메서드 (향후)
│
├── features/                       # 기능별 모듈
│   ├── diary/                      # 일기
│   │   ├── domain/
│   │   │   └── repository/
│   │   │       ├── diary_repository.dart
│   │   │       └── draft_repository.dart
│   │   ├── data/
│   │   │   ├── model/
│   │   │   │   └── diary_model.dart
│   │   │   └── repository/
│   │   │       ├── diary_repository_impl.dart
│   │   │       └── draft_repository_impl.dart
│   │   └── presentation/
│   │       ├── diary_list/         # 일기 목록
│   │       ├── diary_write/        # 일기 작성/수정
│   │       └── diary_detail/       # 일기 상세
│   │
│   ├── emoji/                      # 감정 통계
│   │   ├── presentation/
│   │   │   ├── select/             # 이모지 스타일 선택
│   │   │   └── statistic/          # 감정 통계
│   │
│   ├── goal/                       # 목표 & 뱃지
│   │   ├── domain/
│   │   │   └── model/
│   │   │       └── goal_model.dart
│   │   └── presentation/
│   │       ├── goal_view.dart
│   │       └── view_model/
│   │
│   ├── settings/                   # 설정
│   │   ├── domain/
│   │   │   ├── model/
│   │   │   │   ├── theme_model.dart
│   │   │   │   └── backup_info.dart
│   │   │   └── repository/
│   │   │       └── backup_repository.dart
│   │   ├── data/
│   │   │   └── repository/
│   │   │       └── backup_repository_impl.dart
│   │   └── presentation/
│   │       ├── setting_home/       # 설정 메인
│   │       ├── security/           # 보안 설정
│   │       ├── notification/       # 알림 설정
│   │       ├── backup/             # 백업 관리
│   │       └── theme/              # 테마 설정
│   │
│   ├── auth/                       # 인증
│   │   └── presentation/
│   │       ├── lock_view.dart      # 잠금 화면
│   │       └── view_model/
│   │
│   ├── intro/                      # 온보딩
│   │   └── presentation/
│   │       ├── intro_view.dart
│   │       └── widgets/
│   │
│   └── main/                       # 메인 네비게이션
│       └── presentation/
│           ├── main_view.dart
│           └── view_model/
│
└── di/                             # 의존성 주입
    ├── providers.dart              # 모든 Providers
    └── database_provider.dart
```

---

## 🔧 주요 기술 스택

### 상태 관리
- flutter_riverpod - StateNotifier 기반 상태 관리

### 데이터베이스

- isar - 로컬 NoSQL 데이터베이스
- isar_generator - Code Generation

### 로컬 저장소

- shared_preferences - 간단한 키-값 저장
- local_auth - 생체 인증 (지문/얼굴)

### UI/UX

- fl_chart - 차트/그래프
- table_calendar - 캘린더
- smooth_page_indicator - 페이지 인디케이터
- image_picker - 이미지 선택

### 알림
- flutter_local_notifications - 로컬 푸시 알림
- timezone - 타임존 처리

### 백업

- google_sign_in - Google 로그인
- googleapis - Google Drive API
- archive - 압축 (ZIP)
- file_picker - 파일 선택

### 유틸리티

- intl - 다국어/날짜 포맷
- path_provider - 파일 경로
- uuid - UUID 생성

--- 

## 🚀 향후 개선 방향
### Use Case Layer 도입
- 현재 ViewModel에서 직접 Repository를 호출하고 있으나, 추후 Use Case 레이어를 추가하여 비즈니스 로직을 분리할 예정
```
features/
  ├── diary/
  │   ├── domain/
  │   │   ├── model/
  │   │   ├── repository/
  │   │   └── use_cases/           # 추가 예정
  │   │       ├── get_diaries_use_case.dart
  │   │       ├── save_diary_use_case.dart
  │   │       └── ...
```

### Error Handling 개선
- Failure 클래스를 활용한 에러 처리
- Either<Failure, T> 패턴 도입

### 테스트 코드 작성
- Unit Tests (Use Cases, ViewModels)
- Widget Tests
- Integration Tests


