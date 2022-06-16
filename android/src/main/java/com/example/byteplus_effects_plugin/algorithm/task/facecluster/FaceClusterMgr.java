package com.example.byteplus_effects_plugin.algorithm.task.facecluster;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.os.Messenger;

import com.example.byteplus_effects_plugin.common.utils.ToastUtils;
import com.example.byteplus_effects_plugin.core.util.LogUtils;

import java.util.List;

public class FaceClusterMgr extends Handler {
    private Context mContext;

    private ClusterCallback mCallback;
    volatile static boolean isRunning = false;

    public interface ClusterCallback {
        void onClusterCallback(List<List<String>> result, int clusterNums);
        void onClusterProcess(int process);
    }

    private FaceClusterThread mClusterThread;
    private Messenger mMessenger;


    public FaceClusterMgr(Context context, ClusterCallback callback) {
        this.mContext = context;
        mClusterThread = new FaceClusterThread(mContext);
        mClusterThread.start();
        mMessenger = new Messenger(this);
        this.mCallback = callback;

    }

    @Override
    public void handleMessage(Message msg) {
        int what = msg.what;
        switch (what) {
            case FaceClusterHandler.SUCCESS:
                if (null != mCallback && isRunning) {
                    List<List<String>> result = (List<List<String>>) msg.obj;
                    int clusterNums = msg.arg1;
                    mCallback.onClusterCallback(result, clusterNums);
                    isRunning = false;
                }
                break;
            case FaceClusterHandler.ERROR_PHOTO:
                ToastUtils.show("failed to get image, delete");
                break;

        }

    }

    public void cluster(List<String> data) {
        LogUtils.d("start cluster");
        if (null == mClusterThread || null == mMessenger || null == mCallback || isRunning) {
            return;
        }
        isRunning = true;
        Message msg = mClusterThread.getHandler().obtainMessage(FaceClusterHandler.CLUSTER);
        msg.obj = data;
        msg.replyTo = mMessenger;
        msg.sendToTarget();
    }

    public void clean() {
        LogUtils.d("FaceClusterMgr clean");
        if (null == mClusterThread || null == mMessenger || null == mCallback) {
            return;
        }
        isRunning = false;
    }

    public void release() {
        if (mClusterThread != null) {
            mClusterThread.quit();
            mClusterThread = null;
        }
        if (mMessenger != null) {
            mMessenger = null;
        }
        removeCallbacksAndMessages(null);

    }


}
