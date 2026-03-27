package com.example.lg_widget_poc

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

class StatusWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.status_widget_layout)
            views.setOnClickPendingIntent(R.id.btn_refresh, HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("lgWidget://check_status")))

            val status = widgetData.getString("lg_status", "UNKNOWN")
            if (status == "ONLINE") {
                views.setTextViewText(R.id.tv_status, "ONLINE")
                views.setInt(R.id.widget_background, "setBackgroundColor", Color.parseColor("#4CAF50"))
            } else if (status == "OFFLINE") {
                views.setTextViewText(R.id.tv_status, "OFFLINE")
                views.setInt(R.id.widget_background, "setBackgroundColor", Color.parseColor("#F44336"))
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}