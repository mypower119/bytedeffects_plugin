package com.example.byteplus_effects_plugin.algorithm.task.faceverify;

import static com.bytedance.labcv.effectsdk.BytedEffectConstants.BytedResultCode.BEF_RESULT_INVALID_LICENSE;
import static com.bytedance.labcv.effectsdk.BytedEffectConstants.BytedResultCode.BEF_RESULT_SUC;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;

import androidx.annotation.NonNull;

import com.example.byteplus_effects_plugin.common.utils.BitmapUtils;
import com.example.byteplus_effects_plugin.common.utils.ToastUtils;
import com.example.byteplus_effects_plugin.core.algorithm.AlgorithmResourceHelper;
import com.example.byteplus_effects_plugin.core.algorithm.FaceVerifyAlgorithmTask;
import com.example.byteplus_effects_plugin.core.license.EffectLicenseHelper;
import com.example.byteplus_effects_plugin.core.util.OrientationSensor;
import com.example.byteplus_effects_plugin.core.util.timer_record.LogTimerRecord;
import com.example.byteplus_effects_plugin.R;
import com.bytedance.labcv.effectsdk.BefFaceFeature;
import com.bytedance.labcv.effectsdk.BytedEffectConstants;

import java.nio.ByteBuffer;

public class FaceVerifyThreadHandler extends Handler {
    public static final int VERIFY = 2001;
    public static final int SET_ORIGINAL = 2002;
    public static final int SUCCESS = 2003;
    public static final int FACE_DETECT = 2005;

    private static final String THREAD_NAME = "FAVE VERIFY THREAD";

    private HandlerThread mHandlerThread;
    private Context mContext;
    private FaceVerifyAlgorithmTask mFaceVerify;
    private BefFaceFeature mOriginalFeature;
    private boolean isRunning = false;
    private final Object mLock = new Object();

    private FaceVerifyThreadHandler(HandlerThread thread, Context context) {
        super(thread.getLooper());
        mHandlerThread = thread;
        mContext = context;
        initVerify(context);
    }

    private void initVerify(@NonNull final  Context context) {
        mFaceVerify = new FaceVerifyAlgorithmTask(context, new AlgorithmResourceHelper(context), EffectLicenseHelper.getInstance(context));
        int ret = mFaceVerify.initTask();
        if (ret == BEF_RESULT_INVALID_LICENSE) {
            ToastUtils.show(mContext.getResources().getString(R.string.tab_face_verify) + mContext.getResources().getString(R.string.invalid_license_file));
        } else if (ret != BEF_RESULT_SUC) {
            ToastUtils.show("FaceVerify Initialization failed");
        }
    }

    void resume() {
        isRunning = true;
    }

    void pause() {
        isRunning = false;
        synchronized (mLock) {
            mOriginalFeature = null;
        }
        removeCallbacksAndMessages(null);
    }

    void quit() {
        isRunning = false;
        synchronized (mLock) {
            mOriginalFeature = null;
        }
        mHandlerThread.quit();
        removeCallbacksAndMessages(null);

        if (mFaceVerify != null) {
            mFaceVerify.destroyTask();
            mFaceVerify = null;
        }
    }

    @Override
    public void handleMessage(Message msg) {
        if (!isRunning || null == mFaceVerify) {
            return;
        }
        Messenger messenger = msg.replyTo;
        Message resultMsg = obtainMessage();
        switch (msg.what) {
            case VERIFY:
                synchronized (mLock) {
                    if (null == mOriginalFeature || mOriginalFeature.getValidFaceNum() != 1)
                        return;
                    ByteBuffer resizeInputBuffer = (ByteBuffer) msg.obj;
                    int width = msg.arg1;
                    int height = msg.arg2;
                    FaceVerifyResult faceVerifyResult = faceVerify(resizeInputBuffer, width, height);
                    try {
                        resultMsg.what = SUCCESS;
                        resultMsg.obj = faceVerifyResult;
                        messenger.send(resultMsg);
                    } catch (RemoteException ex) {
                        ex.printStackTrace();
                    }
                }
                break;
            case SET_ORIGINAL:
                synchronized (mLock) {
                    Bitmap bitmap = (Bitmap) msg.obj;
                    mOriginalFeature = getOriginalFaceFeature(bitmap);
                    resultMsg.what = FACE_DETECT;
                    resultMsg.arg1 = (mOriginalFeature == null ? 0 : mOriginalFeature.getValidFaceNum());
                    try {
                        messenger.send(resultMsg);
                    } catch (RemoteException ex) {
                        ex.printStackTrace();
                    }
                }
                break;
        }
    }

    private FaceVerifyResult faceVerify(ByteBuffer resizeInputBuffer, int width, int height) {
        BytedEffectConstants.Rotation rotation = OrientationSensor.getOrientation();
        //   {zh} 暂时修复横屏检测不到人脸的问题       {en} Temporarily fix the problem that the face cannot be detected on the horizontal screen  
        // Temporary fix for landscape screen not detecting faces
        if (rotation == BytedEffectConstants.Rotation.CLOCKWISE_ROTATE_270) {
            rotation = BytedEffectConstants.Rotation.CLOCKWISE_ROTATE_0;
        }
        long start = System.currentTimeMillis();
        LogTimerRecord.RECORD("faceVerify");
        BefFaceFeature currentFeature = mFaceVerify.extractFeatureSingle(resizeInputBuffer, BytedEffectConstants.PixlFormat.RGBA8888, width, height, 4 * width, rotation);
        if (null != currentFeature && currentFeature.getValidFaceNum() > 0) {
            FaceVerifyResult result = new FaceVerifyResult();
            double dist = mFaceVerify.verify(mOriginalFeature.getFeatures()[0], currentFeature.getFeatures()[0]);
            LogTimerRecord.STOP("faceVerify");
            long end = System.currentTimeMillis();
            result.setSimilarity(mFaceVerify.distToScore(dist));
            result.setValidFaceNum(currentFeature.getValidFaceNum());
            result.setCost((end - start));
            return result;
        }
        return null;
    }

    private BefFaceFeature getOriginalFaceFeature(Bitmap mOriginalBitmap) {
        if (mOriginalBitmap != null) {
            ByteBuffer buffer = BitmapUtils.bitmap2ByteBuffer(mOriginalBitmap);
            return mFaceVerify.extractFeature(buffer, BytedEffectConstants.PixlFormat.RGBA8888, mOriginalBitmap.getWidth(), mOriginalBitmap.getHeight(), 4 * mOriginalBitmap.getWidth(), BytedEffectConstants.Rotation.CLOCKWISE_ROTATE_0);
        }
        return null;

    }

    static FaceVerifyThreadHandler createFaceVerifyHandlerThread(final Context context) {
        HandlerThread thread = new HandlerThread(THREAD_NAME);
        thread.start();
        return new FaceVerifyThreadHandler(thread, context);
    }
}
