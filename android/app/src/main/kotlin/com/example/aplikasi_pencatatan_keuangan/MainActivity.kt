package com.example.aplikasi_pencatatan_keuangan

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.provider.Settings
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {
  private val channelName = "payment_notification_listener"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
      .setMethodCallHandler { call, result ->
        when (call.method) {
          "getPendingNotifications" -> {
            val prefs = applicationContext.getSharedPreferences(
              "payment_notification_listener",
              Context.MODE_PRIVATE
            )
            val raw = prefs.getString("pending_notifications", "[]") ?: "[]"
            val array = JSONArray(raw)
            val list = ArrayList<HashMap<String, Any?>>()
            for (i in 0 until array.length()) {
              val obj = array.getJSONObject(i)
              val map = HashMap<String, Any?>()
              map["packageName"] = obj.optString("packageName")
              map["title"] = obj.optString("title")
              map["text"] = obj.optString("text")
              map["postedAt"] = obj.optLong("postedAt")
              map["notificationKey"] = obj.optString("notificationKey")
              list.add(map)
            }
            prefs.edit().putString("pending_notifications", "[]").apply()
            result.success(list)
          }
          "peekPendingNotifications" -> {
            val prefs = applicationContext.getSharedPreferences(
              "payment_notification_listener",
              Context.MODE_PRIVATE
            )
            val raw = prefs.getString("pending_notifications", "[]") ?: "[]"
            val array = JSONArray(raw)
            val list = ArrayList<HashMap<String, Any?>>()
            for (i in 0 until array.length()) {
              val obj = array.getJSONObject(i)
              val map = HashMap<String, Any?>()
              map["packageName"] = obj.optString("packageName")
              map["title"] = obj.optString("title")
              map["text"] = obj.optString("text")
              map["postedAt"] = obj.optLong("postedAt")
              map["notificationKey"] = obj.optString("notificationKey")
              list.add(map)
            }
            result.success(list)
          }
          "clearPendingNotifications" -> {
            val prefs = applicationContext.getSharedPreferences(
              "payment_notification_listener",
              Context.MODE_PRIVATE
            )
            prefs.edit().putString("pending_notifications", "[]").apply()
            result.success(true)
          }
          "openNotificationAccessSettings" -> {
            val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            result.success(true)
          }
          else -> result.notImplemented()
        }
      }
  }
}
