package com.parallelreality.ema;

import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageFormat;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.YuvImage;
import android.os.Environment;
import android.util.Log;
import android.util.Size;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.Tasks;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.pose.Pose;
import com.google.mlkit.vision.pose.PoseDetection;
import com.google.mlkit.vision.pose.PoseLandmark;
import com.google.mlkit.vision.pose.accurate.AccuratePoseDetectorOptions;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import java.nio.ReadOnlyBufferException;
import java.util.HashMap;
import java.util.Map;

public class PoseDetectorImpl implements Pigeon.PlatformPoseDetector {
    com.google.mlkit.vision.pose.PoseDetector poseDetector;
    Context appContext;

    public PoseDetectorImpl(Context applicationContext) {
        appContext = applicationContext;
    }

    @Override
    public void processImage(@NonNull Pigeon.PlatformInputImage inputImage, Pigeon.Result<Pigeon.PlatformPose> result) {

        InputImage finalImage = InputImage.fromByteArray(
                YUV_420_888toNV21(inputImage),
                Math.toIntExact(inputImage.getInputImageData().getWidth()),
                Math.toIntExact(inputImage.getInputImageData().getHeight()),
                Math.toIntExact(inputImage.getInputImageData().getImageRotation()),
                InputImage.IMAGE_FORMAT_NV21
        );
//        YuvImage yuvImage = new YuvImage(finalImage.getByteBuffer().array(), ImageFormat.NV21, finalImage.getWidth(),
//                finalImage.getHeight(), null);
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        yuvImage.compressToJpeg(new Rect(0, 0, finalImage.getWidth(), finalImage.getHeight()), 100, baos);
//        byte[] jdata = baos.toByteArray();
//        Bitmap bmp = BitmapFactory.decodeByteArray(jdata, 0, jdata.length);
//        //create a file
//        ContextWrapper cw = new ContextWrapper(appContext);
//        File directory = cw.getDir("imageDir", Context.MODE_PRIVATE);
//        File file = new File(directory, "blazeImage" + ".jpg");
//        if (!file.exists()) {
//            Log.d("BITSAVE", file.toString());
//            FileOutputStream fos = null;
//            try {
//                fos = new FileOutputStream(file);
//                bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos);
//                fos.flush();
//                fos.close();
//            } catch (java.io.IOException e) {
//                e.printStackTrace();
//            }
//        }
        if (poseDetector == null) {
            AccuratePoseDetectorOptions options =
                    new AccuratePoseDetectorOptions.Builder()
                            .setDetectorMode(AccuratePoseDetectorOptions.STREAM_MODE)
                            .setPreferredHardwareConfigs(AccuratePoseDetectorOptions.CPU_GPU)
                            .build();
            poseDetector = PoseDetection.getClient(options);
        }
        new Thread(() -> {
            try {
                Pose thePose = Tasks.await(poseDetector.process(finalImage));
                Pigeon.PlatformPose.Builder poseBuilder = new Pigeon.PlatformPose.Builder();
                Map<Long, Pigeon.PlatformPoseLandmark> landmarks = new HashMap<>();
                if (!thePose.getAllPoseLandmarks().isEmpty()) {
                    for (PoseLandmark poseLandmark : thePose.getAllPoseLandmarks()) {
                        Pigeon.PlatformPoseLandmark.Builder landmarkBuilder = new Pigeon.PlatformPoseLandmark.Builder();
                        landmarkBuilder.setType((long) poseLandmark.getLandmarkType());
                        landmarkBuilder.setX((double) poseLandmark.getPosition3D().getX());
                        landmarkBuilder.setY((double) poseLandmark.getPosition3D().getY());
                        landmarkBuilder.setZ((double) poseLandmark.getPosition3D().getZ());
                        landmarkBuilder.setLikelihood((double) poseLandmark.getInFrameLikelihood());
                        landmarks.put((long) poseLandmark.getLandmarkType(), landmarkBuilder.build());
                    }
                }
                poseBuilder.setLandmarks(landmarks);
                result.success(poseBuilder.build());
            } catch (Exception e) {
                e.printStackTrace();
                result.error(e);
            }
        }).start();
    }

    @Override
    public void closeDetector() {
        if (poseDetector == null) return;
        poseDetector.close();
    }

    private static byte[] YUV_420_888toNV21(Pigeon.PlatformInputImage image) {

        int width = Math.toIntExact(image.getInputImageData().getWidth());
        int height = Math.toIntExact(image.getInputImageData().getHeight());
        int ySize = width * height;
        int uvSize = width * height / 4;

        byte[] nv21 = new byte[ySize + uvSize * 2];

        ByteBuffer yBuffer = ByteBuffer.wrap(image.getPlanes().get(0)); // Y
        ByteBuffer uBuffer = ByteBuffer.wrap(image.getPlanes().get(1)); // U
        ByteBuffer vBuffer = ByteBuffer.wrap(image.getPlanes().get(2)); // V

        int rowStride = Math.toIntExact(image.getInputImageData().getPlaneData().get(0).getBytesPerRow());
        assert (Math.toIntExact(image.getInputImageData().getPlaneData().get(0).getBytesPerPixel()) == 1);

        int pos = 0;

        if (rowStride == width) { // likely
            yBuffer.get(nv21, 0, ySize);
            pos += ySize;
        } else {
            long yBufferPos = -rowStride; // not an actual position
            for (; pos < ySize; pos += width) {
                yBufferPos += rowStride;
                yBuffer.position((int) yBufferPos);
                yBuffer.get(nv21, pos, width);
            }
        }

        rowStride = Math.toIntExact(image.getInputImageData().getPlaneData().get(2).getBytesPerRow());
        int pixelStride = Math.toIntExact(image.getInputImageData().getPlaneData().get(2).getBytesPerPixel());

        assert (rowStride == Math.toIntExact(image.getInputImageData().getPlaneData().get(1).getBytesPerRow()));
        assert (pixelStride == Math.toIntExact(image.getInputImageData().getPlaneData().get(1).getBytesPerPixel()));

        if (pixelStride == 2 && rowStride == width && uBuffer.get(0) == vBuffer.get(1)) {
            // maybe V an U planes overlap as per NV21, which means vBuffer[1] is alias of uBuffer[0]
            byte savePixel = vBuffer.get(1);
            try {
                vBuffer.put(1, (byte) ~savePixel);
                if (uBuffer.get(0) == (byte) ~savePixel) {
                    vBuffer.put(1, savePixel);
                    vBuffer.position(0);
                    uBuffer.position(0);
                    vBuffer.get(nv21, ySize, 1);
                    uBuffer.get(nv21, ySize + 1, uBuffer.remaining());

                    return nv21; // shortcut
                }
            } catch (ReadOnlyBufferException ex) {
                // unfortunately, we cannot check if vBuffer and uBuffer overlap
            }

            // unfortunately, the check failed. We must save U and V pixel by pixel
            vBuffer.put(1, savePixel);
        }

        // other optimizations could check if (pixelStride == 1) or (pixelStride == 2),
        // but performance gain would be less significant

        for (int row = 0; row < height / 2; row++) {
            for (int col = 0; col < width / 2; col++) {
                int vuPos = col * pixelStride + row * rowStride;
                nv21[pos++] = vBuffer.get(vuPos);
                nv21[pos++] = uBuffer.get(vuPos);
            }
        }

        return nv21;
    }

}
