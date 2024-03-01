package com.a2a.appel;

import android.content.Context;
import android.content.res.Resources;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;

public class ConfigurePageFragment extends Fragment {

	private static final int WELCOME = 0;
	private static final int NUMBER = 1;
	private static final int TIME = 2;
	private static final int SHORTCUT = 3;
	private static final int SUPPORT = 4;

	private int mPosition;
	private ViewGroup mViewGroup;

	public void setPosition(int position){
		mPosition = position;
	}

	public void update(final LinearLayout ll, final Context context){
		switch (mPosition) {
		case NUMBER:
			String name = Preferences.getName(context);
			String number = Preferences.getNumber(context);

			((TextView) ll.findViewById(R.id.number_name)).setText(name);
			((TextView) ll.findViewById(R.id.number_number)).setText(number);
			break;
		case TIME:
			SeekBar seekbar = (SeekBar) ll.findViewById(R.id.seekBar);
			seekbar.setOnSeekBarChangeListener(new OnSeekBarChangeListener(){
				public void onProgressChanged(SeekBar arg0, int arg1, boolean arg2) {
					if(arg0.getProgress() == 0)
						arg0.setProgress(1);
					if(arg0.getProgress() == arg0.getMax())
						arg0.setProgress(arg0.getMax()-1);

					Resources res = context.getResources();
					String s = res.getQuantityString(R.plurals.time_content, arg0.getProgress(), arg0.getProgress());
					((TextView) ll.findViewById(R.id.time_content)).setText(s);
				}

				public void onStartTrackingTouch(SeekBar arg0) {
				}

				public void onStopTrackingTouch(SeekBar arg0) {
					Preferences.setTime(context, arg0.getProgress());
				}
			});

			seekbar.setProgress(Preferences.getTime(context));
			Resources res = context.getResources();
			String s = res.getQuantityString(R.plurals.time_content, seekbar.getProgress(), seekbar.getProgress());
			((TextView) ll.findViewById(R.id.time_content)).setText(s);
			break;		
		}
	}    

	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mViewGroup = (ViewGroup) inflater.inflate(getRessource(), container, false);
		return mViewGroup;
	}

	private int getRessource(){
		switch (mPosition) {
		case WELCOME:
			return R.layout.configure_welcome;
		case NUMBER:
			return R.layout.configure_number;
		case TIME:
			return R.layout.configure_time;		
		case SHORTCUT:
			return R.layout.configure_shortcut;
		case SUPPORT:
			return R.layout.configure_support;
		}
		return -1;
	}
}
