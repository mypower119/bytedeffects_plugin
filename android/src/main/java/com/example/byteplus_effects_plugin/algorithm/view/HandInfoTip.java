package com.example.byteplus_effects_plugin.algorithm.view;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.byteplus_effects_plugin.R;
import com.bytedance.labcv.effectsdk.BefHandInfo;

public class HandInfoTip extends ResultTip<BefHandInfo.BefHand> {
    private static final String TAG = "HandInfoTip";
    private TextView tvGesture;
    private TextView tvPunching;
    private TextView tvClapping;
    static String[] HandTypes = {
            "heart_a",
            "heart_b",
            "heart_c",
            "heart_d",
            "ok",
            "hand_open",
            "thumb_up",
            "thumb_down",
            "rock",
            "namaste",
            "palm_up",
            "fist",
            "index_finger_up",
            "double_finger_up",
            "victory",
            "big_v",
            "phonecall",
            "beg",
            "thanks",
            "unknown",
            "cabbage",
            "three",
            "four",
            "pistol",
            "rock2",
            "swear",
            "holdface",
            "salute",
            "spread",
            "pray",
            "qigong",
            "slide",
            "palm_down",
            "pistol2",
            "naruto01",
            "naruto02",
            "naruto03",
            "naruto04",
            "naruto05",
            "naruto07",
            "naruto08",
            "naruto09",
            "naruto10",
            "naruto11",
            "naruto12",
            "spiderman",
            "avengers",
            "raise",
    };

    private int height = getResources().getDimensionPixelSize(R.dimen.hand_info_height);

    public HandInfoTip(@NonNull Context context) {
        super(context);
        addLayout(context, R.layout.view_hand_info);
        tvGesture = findViewById(R.id.tv_gesture);
        tvPunching = findViewById(R.id.tv_punching);
        tvClapping = findViewById(R.id.tv_clapping);
    }

    public HandInfoTip(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public HandInfoTip(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    void updateInfo(BefHandInfo.BefHand info) {
        if (null == info) return;
        if (null == tvGesture) return;
        String gestureStr = "unknown";
        if (info.getAction() != 99 && info.getAction() < HandTypes.length) {
            gestureStr = HandTypes[info.getAction()];
        }
        switch (info.getSeqAction()) {
            case 1:
                Log.d(TAG, "info.getSeqAction() =" + info.getSeqAction());

                tvPunching.setBackgroundColor(getResources().getColor(R.color.selected_color));


                tvClapping.setBackgroundColor(Color.TRANSPARENT);
                break;
            case 2:
                Log.d(TAG, "info.getSeqAction() =" + info.getSeqAction());

                tvClapping.setBackgroundColor(getResources().getColor(R.color.selected_color));
                tvPunching.setBackgroundColor(Color.TRANSPARENT);
                break;
            default:
                tvPunching.setBackgroundColor(Color.TRANSPARENT);
                tvClapping.setBackgroundColor(Color.TRANSPARENT);


        }

        tvGesture.setText(gestureStr);

        Rect rect = new Rect(info.getRect());
        getRectInScreenCord(rect);
        int top = rect.top;
        int left = rect.left;
        MarginLayoutParams marginLayoutParams = (MarginLayoutParams) this.getLayoutParams();
        marginLayoutParams.leftMargin = left;
        marginLayoutParams.topMargin = top > height ? (top - height) : 0;
        setLayoutParams(marginLayoutParams);
    }
}
