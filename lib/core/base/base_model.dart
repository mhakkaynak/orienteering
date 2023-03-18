abstract class BaseModel<T>{
   Map<String, dynamic> toJson();

  T fromJson(dynamic json);
}