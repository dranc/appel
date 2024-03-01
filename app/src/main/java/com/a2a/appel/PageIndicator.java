package com.a2a.appel;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class PageIndicator extends LinearLayout {

	private static final long ANIMATION_DURATION = 300; 
	private static final int MARGIN = 10; 
	private int _old = 0;

	public PageIndicator(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public void setPageSelected(int page) {
		View vNew = getChildAt(page);
		ScaleAnimation saNew = new ScaleAnimation(
				0.5f, 1, 0.5f, 1, 
				Animation.RELATIVE_TO_SELF, 0.5f,
				Animation.RELATIVE_TO_SELF, 0.5f);
		saNew.setDuration(ANIMATION_DURATION);

		View vOld = getChildAt(_old);
		ScaleAnimation saOld = new ScaleAnimation(
				1, 0.5f, 1, 0.5f, 
				Animation.RELATIVE_TO_SELF, 0.5f,
				Animation.RELATIVE_TO_SELF, 0.5f);
		saOld.setDuration(ANIMATION_DURATION);
		saOld.setFillAfter(true);

		_old = page;
		
		vOld.startAnimation(saOld);
		vNew.startAnimation(saNew);
	}

	public void setViewPager(ViewPager pager) {
		LayoutParams params = new LayoutParams(
				LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		params.setMargins(MARGIN, MARGIN, MARGIN, MARGIN);

		if(pager.getAdapter().getCount()>0){		
			ImageView iv = new ImageView(getContext());
			iv.setImageResource(R.drawable.circle_indicator);
			iv.setLayoutParams(params);
			addView(iv);

			ScaleAnimation saOld = new ScaleAnimation(1, 0.5f, 1, 0.5f, 
					Animation.RELATIVE_TO_SELF, 0.5f,
					Animation.RELATIVE_TO_SELF, 0.5f);
			saOld.setFillAfter(true);
			
			for(int i=1 ; i<pager.getAdapter().getCount() ; i++){
				iv = new ImageView(getContext());
				iv.setImageResource(R.drawable.circle_indicator);
				iv.setLayoutParams(params);
				iv.startAnimation(saOld);

				addView(iv);
			}
		}
	}
}
