package com.example.lg_widget_poc

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

class LgWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                setOnClickPendingIntent(R.id.btn_reset, HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("lgWidget://reset")))
                setOnClickPendingIntent(R.id.btn_shutdown, HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("lgWidget://shutdown")))
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}