// import 'package:dio/dio.dart';
// import 'package:htoochoon_flutter/models/api_models/course_model.dart';
// import 'package:htoochoon_flutter/models/api_models/organization_model.dart';
// import 'package:htoochoon_flutter/models/api_models/school_model.dart';
// import 'package:htoochoon_flutter/models/api_models/user_model.dart';
// import 'package:htoochoon_flutter/models/auth/auth_model.dart';
// import 'package:retrofit/retrofit.dart';
//
// part 'api_service.g.dart';
//
// @RestApi()
// abstract class ApiService {
//   factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
//
//   /// REGISTER
//   @POST("/auth/register")
//   Future<RegisterResponse> register(@Body() RegisterRequest body);
//
//   /// REQUEST OTP
//   @POST("/auth/request-otp")
//   Future<RequestOtpResponse> requestOtp(@Body() RequestOtpRequest request);
//
//   /// VERIFY OTP
//   @POST("/auth/verify-otp")
//   Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);
//
//   /// LOGIN
//   @POST("/auth/login")
//   Future<LoginResponse> login(@Body() LoginRequest request);
//
//   /// RESET PASSWORD
//   @POST("/auth/reset-password")
//   Future<ResetPasswordResponse> resetPassword(
//     @Body() ResetPasswordRequest request,
//   );
//
//   /// FETCH USer
//   @POST("/auth/me")
//   Future<User> fetchMe();
// }
import 'package:dio/dio.dart';
import 'package:htoochoon_flutter/models/api_models/course_model.dart';
import 'package:htoochoon_flutter/models/api_models/live_session_model.dart';
import 'package:htoochoon_flutter/models/api_models/organization_model.dart';
import 'package:htoochoon_flutter/models/api_models/program_model.dart';
import 'package:htoochoon_flutter/models/api_models/school_model.dart';
import 'package:htoochoon_flutter/models/api_models/submission_model.dart';
import 'package:htoochoon_flutter/models/api_models/user_model.dart';
import 'package:htoochoon_flutter/models/auth/auth_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // =========================================================
  // 🔐 AUTH
  // =========================================================

  @POST("/auth/register")
  Future<RegisterResponse> register(@Body() RegisterRequest body);

  @POST("/auth/request-otp")
  Future<RequestOtpResponse> requestOtp(@Body() RequestOtpRequest request);

  @POST("/auth/verify-otp")
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST("/auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST("/auth/reset-password")
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequest request,
  );

  @GET("/auth/me")
  Future<User> fetchMe();

  // =========================================================
  // 👤 USERS
  // =========================================================

  @GET("/users")
  Future<List<User>> getUsers();

  @GET("/users/{id}")
  Future<User> getUser(@Path("id") String id);

  @POST("/users")
  Future<User> createUser(@Body() CreateUserRequest request);

  @PATCH("/users/{id}")
  Future<User> updateUser(
    @Path("id") String id,
    @Body() Map<String, dynamic> body, // or UpdateUserRequest
  );

  @DELETE("/users/{id}")
  Future<void> deleteUser(@Path("id") String id);

  // =========================================================
  // 🏫 SCHOOLS
  // =========================================================

  @GET("/schools")
  Future<List<SchoolResponse>> getSchools();

  @GET("/schools/{id}")
  Future<SchoolResponse> getSchool(@Path("id") String id);

  @POST("/schools")
  Future<SchoolResponse> createSchool(@Body() SchoolRequest request);

  @PATCH("/schools/{id}")
  Future<SchoolResponse> updateSchool(
    @Path("id") String id,
    @Body() UpdateSchoolRequest request,
  );

  @DELETE("/schools/{id}")
  Future<void> deleteSchool(@Path("id") String id);

  // =========================================================
  // 🏢 ORGANIZATIONS
  // =========================================================

  @GET("/organizations")
  Future<List<OrganizationResponse>> getOrganizations();

  @GET("/organizations/{id}")
  Future<OrganizationResponse> getOrganization(@Path("id") String id);

  @POST("/organizations")
  Future<OrganizationResponse> createOrganization(
    @Body() OrganizationRequest request,
  );

  @PATCH("/organizations/{id}")
  Future<OrganizationResponse> updateOrganization(
    @Path("id") String id,
    @Body() OrganizationRequest request,
  );

  @DELETE("/organizations/{id}")
  Future<void> deleteOrganization(@Path("id") String id);

  // =========================================================
  // 📚 COURSES
  // =========================================================

  @GET("/courses")
  Future<List<CourseResponse>> getCourses();

  @GET("/courses/{id}")
  Future<CourseResponse> getCourse(@Path("id") String id);

  @POST("/courses")
  Future<CourseResponse> createCourse(@Body() CourseRequest request);

  @PATCH("/courses/{id}")
  Future<CourseResponse> updateCourse(
    @Path("id") String id,
    @Body() CourseRequest request,
  );

  @DELETE("/courses/{id}")
  Future<void> deleteCourse(@Path("id") String id);

  // =========================================================
  // 🎓 PROGRAMS
  // =========================================================

  @GET("/programs")
  Future<List<ProgramResponse>> getPrograms();

  @GET("/programs/{id}")
  Future<ProgramResponse> getProgram(@Path("id") String id);

  @POST("/programs")
  Future<ProgramResponse> createProgram(@Body() ProgramRequest request);

  @PATCH("/programs/{id}")
  Future<ProgramResponse> updateProgram(
    @Path("id") String id,
    @Body() ProgramRequest request,
  );

  @DELETE("/programs/{id}")
  Future<void> deleteProgram(@Path("id") String id);

  // =========================================================
  // 📝 SUBMISSIONS
  // =========================================================

  @GET("/submissions")
  Future<List<SubmissionResponse>> getSubmissions();

  @GET("/submissions/{id}")
  Future<SubmissionResponse> getSubmission(@Path("id") String id);

  @POST("/submissions")
  Future<SubmissionResponse> createSubmission(
    @Body() SubmissionRequest request,
  );

  @PATCH("/submissions/{id}")
  Future<SubmissionResponse> updateSubmission(
    @Path("id") String id,
    @Body() Map<String, dynamic> body, // grading, etc.
  );

  // =========================================================
  // 🎥 LIVE SESSIONS
  // =========================================================

  @GET("/live-sessions")
  Future<List<LiveSessionResponse>> getLiveSessions();

  @GET("/live-sessions/{id}")
  Future<LiveSessionResponse> getLiveSession(@Path("id") String id);

  @POST("/live-sessions")
  Future<LiveSessionResponse> createLiveSession(
    @Body() LiveSessionRequest request,
  );

  @PATCH("/live-sessions/{id}")
  Future<LiveSessionResponse> updateLiveSession(
    @Path("id") String id,
    @Body() UpdateLiveSessionRequest request,
  );

  @DELETE("/live-sessions/{id}")
  Future<void> deleteLiveSession(@Path("id") String id);
}
