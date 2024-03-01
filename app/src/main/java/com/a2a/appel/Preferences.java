package com.a2a.appel;

import android.content.Context;
import android.content.SharedPreferences;

public final class Preferences {
	private static final String PREFS = "prefs";
	
	private static final String PREFS_NAME = "name";	
	private static final String PREFS_NUMBER = "number";
	private static final String PREFS_TIME = "time";
	
	public static String getNumber(final Context pContexte){
		return Preferences.loadString(pContexte, PREFS_NUMBER, null);
	}
	
	public static void setNumber(final Context pContexte, String num){
		Preferences.saveString(pContexte, PREFS_NUMBER, num);
	}
	
	public static String getName(final Context pContexte){
		return Preferences.loadString(pContexte, PREFS_NAME, null);
	}
	
	public static void setName(final Context pContexte, String name){
		Preferences.saveString(pContexte, PREFS_NAME, name);
	}
	
	public static int getTime(final Context pContexte){
		return Preferences.loadInt(pContexte, PREFS_TIME, 3);
	}
	
	public static void setTime(final Context pContexte, int temps){
		Preferences.saveInt(pContexte, PREFS_TIME, temps);
	}
		
	private static int loadInt(final Context pContexte, final String key, final int sinon) {
		SharedPreferences settings = pContexte.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
		return settings.getInt(key, sinon);
	}
	
	private static void saveInt(final Context pContexte, final String key,
			final int pValeur) {
		SharedPreferences settings = pContexte.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = settings.edit();
		editor.putInt(key, pValeur);
		editor.commit();
	}	
	
	private static String loadString(final Context pContexte, final String key, final String sinon) {
		SharedPreferences settings = pContexte.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
		return settings.getString(key, sinon);
	}
	
	private static void saveString(final Context pContexte, final String key,
			final String pValeur) {
		SharedPreferences settings = pContexte.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = settings.edit();
		editor.putString(key, pValeur);
		editor.commit();
	}	
}
