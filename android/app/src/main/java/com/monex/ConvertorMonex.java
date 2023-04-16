package com.monex;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

import org.json.JSONException;
import org.json.JSONObject;


/**
 * Implementation of App Widget functionality.
 * App Widget Configuration implemented in {@link ConvertorMonexConfigureActivity ConvertorMonexConfigureActivity}
 */
public class ConvertorMonex extends AppWidgetProvider {

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {

        try {
            SharedPreferences sharedPref = context.getSharedPreferences("DATA", Context.MODE_PRIVATE);
            String stringJsonData = sharedPref.getString("convertorMonex", "{\"from\":'Euro', \"to\": 'USD', \"amount\": 300, \"result\": 303}");
            JSONObject widgetData = new JSONObject(stringJsonData);

            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.convertor_monex);


            views.setTextViewText(R.id.fromCurrency, widgetData.getString("from"));
            views.setTextViewText(R.id.fromValue, widgetData.getString("amount"));
            views.setTextViewText(R.id.toCurrency, widgetData.getString("to"));
            views.setTextViewText(R.id.toValue, widgetData.getString("result"));

            appWidgetManager.updateAppWidget(appWidgetId, views);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // updating all of widgets that are active.
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        // Delete widget will delete the data associated with.
        for (int appWidgetId : appWidgetIds) {
            ConvertorMonexConfigureActivity.deleteTitlePref(context, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // functionality when widget is created.
    }

    @Override
    public void onDisabled(Context context) {
        // functionality when widget is last
    }
}