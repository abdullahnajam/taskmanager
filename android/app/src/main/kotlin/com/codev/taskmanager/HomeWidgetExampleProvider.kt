package com.codev.taskmanager
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/*class HomeWidgetExampleProvider : AppWidgetProvider()*/

class HomeWidgetExampleProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                // Open App on Widget Click
                /*val pendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java, Uri.parse("myAppWidget://updatecounter"))
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)*/

                val counter = widgetData.getString("timerTextView", "00:00")



                setTextViewText(R.id.timerTextView, counter)
// get reference to button
                //val btn_click_me = findViewById(R.id.hourOne) as Button
// set on-click listener
                /*btn_click_me.setOnClickListener {
                    widgetData.set("timerTextView", "")

                }*/

                // Pending intent to update counter on button click
                val button1Intent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java, Uri.parse("myAppWidget://homeOne"))
                setOnClickPendingIntent(R.id.hourOne, button1Intent)

                val button2Intent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java, Uri.parse("myAppWidget://homeTwo"))
                setOnClickPendingIntent(R.id.hourTwo, button2Intent)

                val button3Intent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java, Uri.parse("myAppWidget://homeThree"))
                setOnClickPendingIntent(R.id.hourThree, button3Intent)

                val button4Intent = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java, Uri.parse("myAppWidget://homeFour"))
                setOnClickPendingIntent(R.id.hourFour, button4Intent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}