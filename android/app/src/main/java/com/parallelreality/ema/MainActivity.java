package com.parallelreality.ema;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterFragmentActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Pigeon.PlatformPoseDetector.setup(flutterEngine.getDartExecutor().getBinaryMessenger(),new PoseDetectorImpl(getApplicationContext()));
    }
}
