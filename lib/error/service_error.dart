enum ServiceErrors {
  NO_USER_FOUND(message: "No Users Found");

  final String message;

  const ServiceErrors({
    required this.message
  });

}