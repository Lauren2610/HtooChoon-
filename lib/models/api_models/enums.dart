import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum Role { ADMIN, SCHOOL_ADMIN, TEACHER, STUDENT }

@JsonEnum(alwaysCreate: true)
enum SubmissionStatus { SUBMITTED, GRADED }

@JsonEnum(alwaysCreate: true)
enum InvitationStatus { PENDING, ACCEPTED, REJECTED }

@JsonEnum(alwaysCreate: true)
enum LiveSessionStatus { SCHEDULED, LIVE, ENDED }

@JsonEnum(alwaysCreate: true)
enum AttendanceStatus { PRESENT, LATE, LEFT, ABSENT }

@JsonEnum(alwaysCreate: true)
enum OtpType { VERIFY_EMAIL, RESET_PASSWORD, TWO_FACTOR_SETUP }

@JsonEnum(alwaysCreate: true)
enum ProgramType { DEGREE, CERTIFICATION, BOOTCAMP }

@JsonEnum(alwaysCreate: true)
enum CourseType { SKILL, ACADEMIC, TEST_PREP }

@JsonEnum(alwaysCreate: true)
enum EnrollmentStatus { PENDING, ACTIVE, COMPLETED, DROPPED }
