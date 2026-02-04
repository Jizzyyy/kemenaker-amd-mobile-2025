package com.example.aplikasi_pencatatan_keuangan

import android.app.Notification
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

class PaymentNotificationListenerService : NotificationListenerService() {
  override fun onNotificationPosted(sbn: StatusBarNotification?) {
    if (sbn == null) return

    val notification = sbn.notification ?: return
    val extras = notification.extras ?: return

    val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
    val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
    val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
    val finalText = if (!bigText.isNullOrBlank()) bigText else text

    if (title.isBlank() && finalText.isBlank()) return

    val data = JSONObject()
    data.put("packageName", sbn.packageName ?: "")
    data.put("title", title)
    data.put("text", finalText)
    data.put("postedAt", sbn.postTime)
    data.put("notificationKey", sbn.key ?: "")

    val prefs = applicationContext.getSharedPreferences(
      "payment_notification_listener",
      Context.MODE_PRIVATE
    )

    val existing = prefs.getString("pending_notifications", "[]") ?: "[]"
    val array = JSONArray(existing)
    array.put(data)
    val trimmed = JSONArray()
    val start = if (array.length() > 50) array.length() - 50 else 0
    for (i in start until array.length()) {
      trimmed.put(array.getJSONObject(i))
    }
    prefs.edit().putString("pending_notifications", trimmed.toString()).apply()
  }
}
