# Flutter Local Notifications - Required for scheduled notifications
-keep class com.dexterous.** { *; }
-keep class org.threeten.** { *; }

# Keep flutter_local_notifications classes
-keep class com.dexterous.flutterlocal_notifications.** { *; }
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep notification receiver and alarm manager related classes
-keep class **.R$* {
    <fields>;
}
-keep class *.R$* {
    public static <fields>;
}

# Keep all View constructors for layout inflation
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Important: Keep enumerations
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes EnclosingMethod