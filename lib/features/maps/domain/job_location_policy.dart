class JobLocationPermission {
  const JobLocationPermission({
    required this.jobIsActive,
    required this.authorizedByGateway,
  });

  final bool jobIsActive;
  final bool authorizedByGateway;

  bool get canCapture => jobIsActive && authorizedByGateway;
}

