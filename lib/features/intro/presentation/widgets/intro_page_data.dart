class IntroPageData {
  final String title;
  final String description;
  final String lottieAsset; // 또는 imagePath
  final List<String> features;

  const IntroPageData({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.features,
  });

  static final pages = [
    const IntroPageData(
      title: '매일의 감정을\n기록하세요',
      description: '하루의 기분을 이모지로 표현하고\n소중한 순간들을 기록해보세요',
      lottieAsset: '📝', // 실제로는 lottie 파일 경로
      features: ['다양한 기분 이모지', '간편한 일기 작성', '나만의 스타일 선택'],
    ),
    const IntroPageData(
      title: '추억을 아름답게\n정리하세요',
      description: '달력으로 한눈에 보고\n태그로 쉽게 찾아보세요',
      lottieAsset: '📅',
      features: ['직관적인 달력 뷰', '스마트 태그 시스템', '강력한 검색 기능'],
    ),
    const IntroPageData(
      title: '나의 성장을\n확인하세요',
      description: '감정 패턴을 분석하고\n긍정적인 변화를 발견하세요',
      lottieAsset: '📊',
      features: ['감정 통계 분석', '작성 습관 추적', '성장 그래프'],
    ),
    const IntroPageData(
      title: '안전하게\n보관하세요',
      description: '소중한 일기를 안전하게 보호하고\n언제든 되돌아볼 수 있어요',
      lottieAsset: '🔒',
      features: ['로컬 저장으로 프라이버시 보호', '자동 백업', '비밀번호 잠금'],
    ),
  ];
}
