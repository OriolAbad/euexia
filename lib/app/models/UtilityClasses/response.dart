class Response<T> {
  T? content;
  String? error;
  bool isSuccess;

  Response({
    this.content,
    this.error, 
    required this.isSuccess,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response<T>(
      content: json['content'],
      error: json['error'],
      isSuccess: json['isSuccess'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objeto': content,
      'error': error,
      'isSuccess': isSuccess,
    };
  }
}