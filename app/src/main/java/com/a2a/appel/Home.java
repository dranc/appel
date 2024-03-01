package com.a2a.appel;

import com.android.vending.billing.IInAppBillingService;
import com.google.ads.AdRequest;
import com.google.ads.AdSize;
import com.google.ads.AdView;

import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.content.ServiceConnection;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.provider.ContactsContract.CommonDataKinds.Phone;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class Home extends FragmentActivity {	

	private static String MY_BANNER_UNIT_ID = "a14d7791a4d2c1e";
	private static final int PICK_CONTACT_REQUEST = 1;
	private static final int MAKE_DONATION_REQUEST = 2; 

	private AdView mAdView;
	private ViewPager mPager;
	private ScreenSlidePagerAdapter mPagerAdapter;

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home);

		RelativeLayout rl = (RelativeLayout) findViewById(R.id.footer);
		rl.setAnimation(AnimationUtils.loadAnimation(this, R.anim.footer));

		LinearLayout layout = (LinearLayout)findViewById(R.id.ad);
		mAdView = new AdView(this, AdSize.BANNER, MY_BANNER_UNIT_ID);
		layout.addView(mAdView);
		AdRequest request = new AdRequest();
		mAdView.loadAd(request);

		bindService(new 
				Intent("com.android.vending.billing.InAppBillingService.BIND"),
				mServiceConn, Context.BIND_AUTO_CREATE);
	}

	public void onResume(){
		if(mPager == null)
			if(Preferences.getNumber(this) != null)
				startCall();
			else
				startConfigure();
		super.onResume();
	}

	private void startCall(){
		String name = Preferences.getName(this);
		final String number = Preferences.getNumber(this);

		((TextView) findViewById(R.id.number_name)).setText(name);
		((TextView) findViewById(R.id.number_number)).setText(number);

		View pb = (View) findViewById(R.id.progressbar);
		Animation anim = AnimationUtils.loadAnimation(this, R.anim.progressbar);
		anim.setDuration(Preferences.getTime(this) * 1000);
		anim.setAnimationListener(new AnimationListener() {
			public void onAnimationStart(Animation animation) {
			}

			public void onAnimationRepeat(Animation animation) {
			}

			public void onAnimationEnd(Animation animation) {
				Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + number));
				startActivity(intent);

				finish();
			}
		});

		pb.startAnimation(anim);
	}

	public void onPause(){
		if(mPager == null){
			View pb = (View) findViewById(R.id.progressbar);
			pb.setAnimation(null);
		}
		super.onPause();
	}

	private void startConfigure(){
		LinearLayout ll = (LinearLayout) findViewById(R.id.body);
		ll.removeAllViews();		
		LayoutInflater layoutInflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);    
		ll.addView(layoutInflater.inflate(R.layout.fragment_configure, null)); 

		mPager = (ViewPager) ll.findViewById(R.id.pager);
		mPagerAdapter = new ScreenSlidePagerAdapter(getSupportFragmentManager());
		mPager.setAdapter(mPagerAdapter);

		final PageIndicator titleIndicator = (PageIndicator)findViewById(R.id.pageIndicator);
		titleIndicator.setViewPager(mPager);

		mPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
			public void onPageSelected(int arg0) {
				titleIndicator.setPageSelected(arg0);
				Button bPrevious = (Button) findViewById(R.id.bPrevious);
				Button bNext = (Button) findViewById(R.id.bNext);
				if(arg0 == 0)
					bPrevious.setVisibility(View.INVISIBLE);
				else if(arg0 == mPager.getAdapter().getCount()-1)
					bNext.setText(getResources().getText(R.string.over));
				else{
					bPrevious.setVisibility(View.VISIBLE);
					bNext.setText(getResources().getText(R.string.next));
				}
				mPagerAdapter.getItem(arg0).update((LinearLayout) findViewById(R.id.body), getApplicationContext());
			}

			public void onPageScrolled(int arg0, float arg1, int arg2) {

			}

			public void onPageScrollStateChanged(int arg0) {

			}
		}); 
		Button bNext = (Button) findViewById(R.id.bNext);
		bNext.setText(getResources().getText(R.string.next));
	}

	public void onDestroy() {
		mAdView.destroy();
		if(mServiceConn != null)
			unbindService(mServiceConn);
		super.onDestroy();
	}

	public void onBackPressed() {
		if(mPager == null || mPager.getCurrentItem() == 0) 
			super.onBackPressed();
		else
			mPager.setCurrentItem(mPager.getCurrentItem() - 1);

	}

	public void onClickAddShortcut(View view){
		Intent shortcutIntent = new Intent();
		shortcutIntent.setClassName(getPackageName(), getClass().getName());
		shortcutIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		shortcutIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

		Intent addIntent = new Intent();
		addIntent.putExtra(Intent.EXTRA_SHORTCUT_INTENT, shortcutIntent);
		addIntent.putExtra(Intent.EXTRA_SHORTCUT_NAME, getResources().getString(R.string.app_name));
		addIntent.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE, Intent.ShortcutIconResource.fromContext(this, R.drawable.ic_launcher));
		addIntent.setAction("com.android.launcher.action.INSTALL_SHORTCUT");
		sendBroadcast(addIntent);
	}    

	public void onClickChooseNumber(View view){
		Intent pickContactIntent = new Intent(Intent.ACTION_PICK, Uri.parse("content://contacts"));
		pickContactIntent.setType(Phone.CONTENT_TYPE);
		startActivityForResult(pickContactIntent, PICK_CONTACT_REQUEST);  
	}

	public void onClickNext(View view){
		if(mPager == null)
			startConfigure();
		else
			if(mPager.getCurrentItem() != mPager.getAdapter().getCount()-1)
				mPager.setCurrentItem(mPager.getCurrentItem()+1);
		/*
			else
				super.onBackPressed();
				*/
	}

	public void onClickPrevious(View view){
		mPager.setCurrentItem(mPager.getCurrentItem()-1);
	}

	public void onClickDonate(View view){
		try {
			String sku = "id_make_a_donation";
			Bundle buyIntentBundle = mService.getBuyIntent(3, getPackageName(),
					sku, "inapp", null);//"bGoa+V7g/yqDXvKRqq+JTFn4uQZbPiQJo4pf9RzJ");
			PendingIntent pendingIntent = buyIntentBundle.getParcelable("BUY_INTENT");

			startIntentSenderForResult(pendingIntent.getIntentSender(),	MAKE_DONATION_REQUEST, 
					new Intent(), Integer.valueOf(0), Integer.valueOf(0), Integer.valueOf(0));
		}
		catch (SendIntentException e) {
			e.printStackTrace();
		}
		catch (RemoteException e) {
			e.printStackTrace();
		}
	}

	public void onClickRate(View view){
		Toast.makeText(this, getResources().getText(R.string.support_thanks_in_advance), Toast.LENGTH_LONG).show();

		final String requete = "market://details?id=com.a2a.appel";
		Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(requete));
		startActivity(intent);
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == PICK_CONTACT_REQUEST) {
			if (resultCode == RESULT_OK) {
				Uri contactUri = data.getData();                
				String[] projection = {Phone.NUMBER, Phone.DISPLAY_NAME};

				// Perform the query on the contact to get the NUMBER column
				// We don't need a selection or sort order (there's only one result for the given URI)
				// CAUTION: The query() method should be called from a separate thread to avoid blocking
				// your app's UI thread. (For simplicity of the sample, this code doesn't do that.)
				// Consider using CursorLoader to perform the query.
				Cursor cursor = getContentResolver().query(contactUri, projection, null, null, null);
				cursor.moveToFirst();

				String number = cursor.getString(cursor.getColumnIndex(Phone.NUMBER));
				String name = cursor.getString(cursor.getColumnIndex(Phone.DISPLAY_NAME));

				Preferences.setName(this, name);
				Preferences.setNumber(this, number);

				((TextView) findViewById(R.id.number_name)).setText(name);
				((TextView) findViewById(R.id.number_number)).setText(number);
			}
		}
		else if (requestCode == MAKE_DONATION_REQUEST) {           		        
			if (resultCode == RESULT_OK) {
				Toast.makeText(this, getResources().getText(R.string.support_thanks), Toast.LENGTH_LONG).show();
			}
		}
	}

	IInAppBillingService mService;
	ServiceConnection mServiceConn = new ServiceConnection() {
		public void onServiceDisconnected(ComponentName name) {
			mService = null;
		}

		public void onServiceConnected(ComponentName name, 
				IBinder service) {
			mService = IInAppBillingService.Stub.asInterface(service);
		}
	};

	private class ScreenSlidePagerAdapter extends FragmentStatePagerAdapter {
		private static final int NUM_PAGES = 5;

		public ScreenSlidePagerAdapter(FragmentManager fm) {
			super(fm);
		}

		public ConfigurePageFragment getItem(int position) {
			ConfigurePageFragment cpg = new ConfigurePageFragment();
			cpg.setPosition(position);
			return cpg;
		}

		public int getCount() {
			return NUM_PAGES;
		}
	}	
}
