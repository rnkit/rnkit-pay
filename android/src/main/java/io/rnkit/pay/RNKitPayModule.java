
package io.rnkit.pay;

import android.app.Activity;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;

import com.facebook.react.bridge.JSApplicationIllegalArgumentException;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.yintong.pay.utils.BaseHelper;
import com.yintong.pay.utils.Constants;
import com.yintong.pay.utils.MobileSecurePayer;

import org.json.JSONObject;

public class RNKitPayModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private Promise _promise;

    public RNKitPayModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNKitPay";
    }

    @ReactMethod
    public void pay(@Nullable final String payType, @Nullable final String traderInfo, @Nullable final Promise promise) {
        this._promise = promise;
        MobileSecurePayer msp = new MobileSecurePayer();
        Activity activity = getCurrentActivity();
        if (activity == null) {
            throw new JSApplicationIllegalArgumentException("Tried to open a dialog while not attached to an Activity");
        }

        msp.payAuth(traderInfo, new Handler() {
                    @Override
                    public void handleMessage(Message msg) {
                        String strRet = (String) msg.obj;
                        switch (msg.what) {
                            case Constants.RQF_PAY: {
                                JSONObject objContent = BaseHelper.string2JSON(strRet);
                                String retCode = objContent.optString("ret_code");
                                String retMsg = objContent.optString("ret_msg");
                                if (Constants.RET_CODE_SUCCESS.equals(retCode)) {
                                    _promise.resolve(strRet);
                                } else {
                                    _promise.reject(retCode, retMsg);
                                }
                            }
                            break;
                        }
                        super.handleMessage(msg);
                    }
                },
                Constants.RQF_PAY, activity, false);
    }
}