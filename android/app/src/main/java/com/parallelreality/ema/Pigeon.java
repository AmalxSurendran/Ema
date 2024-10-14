// Autogenerated from Pigeon (v4.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.parallelreality.ema;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Pigeon {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class PlatformPose {
    /** A map of all the landmarks in the detected pose. */
    private @NonNull Map<Long, PlatformPoseLandmark> landmarks;
    public @NonNull Map<Long, PlatformPoseLandmark> getLandmarks() { return landmarks; }
    public void setLandmarks(@NonNull Map<Long, PlatformPoseLandmark> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"landmarks\" is null.");
      }
      this.landmarks = setterArg;
    }

    /**Constructor is private to enforce null safety; use Builder. */
    private PlatformPose() {}
    public static final class Builder {
      private @Nullable Map<Long, PlatformPoseLandmark> landmarks;
      public @NonNull Builder setLandmarks(@NonNull Map<Long, PlatformPoseLandmark> setterArg) {
        this.landmarks = setterArg;
        return this;
      }
      public @NonNull PlatformPose build() {
        PlatformPose pigeonReturn = new PlatformPose();
        pigeonReturn.setLandmarks(landmarks);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("landmarks", landmarks);
      return toMapResult;
    }
    static @NonNull PlatformPose fromMap(@NonNull Map<String, Object> map) {
      PlatformPose pigeonResult = new PlatformPose();
      Object landmarks = map.get("landmarks");
      pigeonResult.setLandmarks((Map<Long, PlatformPoseLandmark>)landmarks);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class PlatformPoseLandmark {
    /** The landmark type. */
    private @NonNull Long type;
    public @NonNull Long getType() { return type; }
    public void setType(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"type\" is null.");
      }
      this.type = setterArg;
    }

    /** Gives x coordinate of landmark in image frame. */
    private @NonNull Double x;
    public @NonNull Double getX() { return x; }
    public void setX(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"x\" is null.");
      }
      this.x = setterArg;
    }

    /** Gives y coordinate of landmark in image frame. */
    private @NonNull Double y;
    public @NonNull Double getY() { return y; }
    public void setY(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"y\" is null.");
      }
      this.y = setterArg;
    }

    /** Gives z coordinate of landmark in image space. */
    private @NonNull Double z;
    public @NonNull Double getZ() { return z; }
    public void setZ(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"z\" is null.");
      }
      this.z = setterArg;
    }

    /** Gives the likelihood of this landmark being in the image frame. */
    private @NonNull Double likelihood;
    public @NonNull Double getLikelihood() { return likelihood; }
    public void setLikelihood(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"likelihood\" is null.");
      }
      this.likelihood = setterArg;
    }

    /**Constructor is private to enforce null safety; use Builder. */
    private PlatformPoseLandmark() {}
    public static final class Builder {
      private @Nullable Long type;
      public @NonNull Builder setType(@NonNull Long setterArg) {
        this.type = setterArg;
        return this;
      }
      private @Nullable Double x;
      public @NonNull Builder setX(@NonNull Double setterArg) {
        this.x = setterArg;
        return this;
      }
      private @Nullable Double y;
      public @NonNull Builder setY(@NonNull Double setterArg) {
        this.y = setterArg;
        return this;
      }
      private @Nullable Double z;
      public @NonNull Builder setZ(@NonNull Double setterArg) {
        this.z = setterArg;
        return this;
      }
      private @Nullable Double likelihood;
      public @NonNull Builder setLikelihood(@NonNull Double setterArg) {
        this.likelihood = setterArg;
        return this;
      }
      public @NonNull PlatformPoseLandmark build() {
        PlatformPoseLandmark pigeonReturn = new PlatformPoseLandmark();
        pigeonReturn.setType(type);
        pigeonReturn.setX(x);
        pigeonReturn.setY(y);
        pigeonReturn.setZ(z);
        pigeonReturn.setLikelihood(likelihood);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("type", type);
      toMapResult.put("x", x);
      toMapResult.put("y", y);
      toMapResult.put("z", z);
      toMapResult.put("likelihood", likelihood);
      return toMapResult;
    }
    static @NonNull PlatformPoseLandmark fromMap(@NonNull Map<String, Object> map) {
      PlatformPoseLandmark pigeonResult = new PlatformPoseLandmark();
      Object type = map.get("type");
      pigeonResult.setType((type == null) ? null : ((type instanceof Integer) ? (Integer)type : (Long)type));
      Object x = map.get("x");
      pigeonResult.setX((Double)x);
      Object y = map.get("y");
      pigeonResult.setY((Double)y);
      Object z = map.get("z");
      pigeonResult.setZ((Double)z);
      Object likelihood = map.get("likelihood");
      pigeonResult.setLikelihood((Double)likelihood);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class PlatformInputImage {
    /** The bytes of the image. */
    private @NonNull List<byte[]> planes;
    public @NonNull List<byte[]> getPlanes() { return planes; }
    public void setPlanes(@NonNull List<byte[]> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"planes\" is null.");
      }
      this.planes = setterArg;
    }

    private @NonNull InputImageData inputImageData;
    public @NonNull InputImageData getInputImageData() { return inputImageData; }
    public void setInputImageData(@NonNull InputImageData setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"inputImageData\" is null.");
      }
      this.inputImageData = setterArg;
    }

    /**Constructor is private to enforce null safety; use Builder. */
    private PlatformInputImage() {}
    public static final class Builder {
      private @Nullable List<byte[]> planes;
      public @NonNull Builder setPlanes(@NonNull List<byte[]> setterArg) {
        this.planes = setterArg;
        return this;
      }
      private @Nullable InputImageData inputImageData;
      public @NonNull Builder setInputImageData(@NonNull InputImageData setterArg) {
        this.inputImageData = setterArg;
        return this;
      }
      public @NonNull PlatformInputImage build() {
        PlatformInputImage pigeonReturn = new PlatformInputImage();
        pigeonReturn.setPlanes(planes);
        pigeonReturn.setInputImageData(inputImageData);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("planes", planes);
      toMapResult.put("inputImageData", (inputImageData == null) ? null : inputImageData.toMap());
      return toMapResult;
    }
    static @NonNull PlatformInputImage fromMap(@NonNull Map<String, Object> map) {
      PlatformInputImage pigeonResult = new PlatformInputImage();
      Object planes = map.get("planes");
      pigeonResult.setPlanes((List<byte[]>)planes);
      Object inputImageData = map.get("inputImageData");
      pigeonResult.setInputImageData((inputImageData == null) ? null : InputImageData.fromMap((Map)inputImageData));
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class InputImageData {
    /** Size of image. */
    private @NonNull Long height;
    public @NonNull Long getHeight() { return height; }
    public void setHeight(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"height\" is null.");
      }
      this.height = setterArg;
    }

    private @NonNull Long width;
    public @NonNull Long getWidth() { return width; }
    public void setWidth(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"width\" is null.");
      }
      this.width = setterArg;
    }

    private @NonNull Long imageRotation;
    public @NonNull Long getImageRotation() { return imageRotation; }
    public void setImageRotation(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"imageRotation\" is null.");
      }
      this.imageRotation = setterArg;
    }

    /** Format of the input image. */
    private @NonNull Long inputImageFormat;
    public @NonNull Long getInputImageFormat() { return inputImageFormat; }
    public void setInputImageFormat(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"inputImageFormat\" is null.");
      }
      this.inputImageFormat = setterArg;
    }

    /**
     * The plane attributes to create the image buffer on iOS.
     *
     * Not used on Android.
     */
    private @NonNull List<InputImagePlaneMetadata> planeData;
    public @NonNull List<InputImagePlaneMetadata> getPlaneData() { return planeData; }
    public void setPlaneData(@NonNull List<InputImagePlaneMetadata> setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"planeData\" is null.");
      }
      this.planeData = setterArg;
    }

    /**Constructor is private to enforce null safety; use Builder. */
    private InputImageData() {}
    public static final class Builder {
      private @Nullable Long height;
      public @NonNull Builder setHeight(@NonNull Long setterArg) {
        this.height = setterArg;
        return this;
      }
      private @Nullable Long width;
      public @NonNull Builder setWidth(@NonNull Long setterArg) {
        this.width = setterArg;
        return this;
      }
      private @Nullable Long imageRotation;
      public @NonNull Builder setImageRotation(@NonNull Long setterArg) {
        this.imageRotation = setterArg;
        return this;
      }
      private @Nullable Long inputImageFormat;
      public @NonNull Builder setInputImageFormat(@NonNull Long setterArg) {
        this.inputImageFormat = setterArg;
        return this;
      }
      private @Nullable List<InputImagePlaneMetadata> planeData;
      public @NonNull Builder setPlaneData(@NonNull List<InputImagePlaneMetadata> setterArg) {
        this.planeData = setterArg;
        return this;
      }
      public @NonNull InputImageData build() {
        InputImageData pigeonReturn = new InputImageData();
        pigeonReturn.setHeight(height);
        pigeonReturn.setWidth(width);
        pigeonReturn.setImageRotation(imageRotation);
        pigeonReturn.setInputImageFormat(inputImageFormat);
        pigeonReturn.setPlaneData(planeData);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("height", height);
      toMapResult.put("width", width);
      toMapResult.put("imageRotation", imageRotation);
      toMapResult.put("inputImageFormat", inputImageFormat);
      toMapResult.put("planeData", planeData);
      return toMapResult;
    }
    static @NonNull InputImageData fromMap(@NonNull Map<String, Object> map) {
      InputImageData pigeonResult = new InputImageData();
      Object height = map.get("height");
      pigeonResult.setHeight((height == null) ? null : ((height instanceof Integer) ? (Integer)height : (Long)height));
      Object width = map.get("width");
      pigeonResult.setWidth((width == null) ? null : ((width instanceof Integer) ? (Integer)width : (Long)width));
      Object imageRotation = map.get("imageRotation");
      pigeonResult.setImageRotation((imageRotation == null) ? null : ((imageRotation instanceof Integer) ? (Integer)imageRotation : (Long)imageRotation));
      Object inputImageFormat = map.get("inputImageFormat");
      pigeonResult.setInputImageFormat((inputImageFormat == null) ? null : ((inputImageFormat instanceof Integer) ? (Integer)inputImageFormat : (Long)inputImageFormat));
      Object planeData = map.get("planeData");
      pigeonResult.setPlaneData((List<InputImagePlaneMetadata>)planeData);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class InputImagePlaneMetadata {
    /** The row stride for this color plane, in bytes. */
    private @NonNull Long bytesPerRow;
    public @NonNull Long getBytesPerRow() { return bytesPerRow; }
    public void setBytesPerRow(@NonNull Long setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"bytesPerRow\" is null.");
      }
      this.bytesPerRow = setterArg;
    }

    private @Nullable Long bytesPerPixel;
    public @Nullable Long getBytesPerPixel() { return bytesPerPixel; }
    public void setBytesPerPixel(@Nullable Long setterArg) {
      this.bytesPerPixel = setterArg;
    }

    /** Height of the pixel buffer on iOS. */
    private @Nullable Long height;
    public @Nullable Long getHeight() { return height; }
    public void setHeight(@Nullable Long setterArg) {
      this.height = setterArg;
    }

    /** Width of the pixel buffer on iOS. */
    private @Nullable Long width;
    public @Nullable Long getWidth() { return width; }
    public void setWidth(@Nullable Long setterArg) {
      this.width = setterArg;
    }

    /**Constructor is private to enforce null safety; use Builder. */
    private InputImagePlaneMetadata() {}
    public static final class Builder {
      private @Nullable Long bytesPerRow;
      public @NonNull Builder setBytesPerRow(@NonNull Long setterArg) {
        this.bytesPerRow = setterArg;
        return this;
      }
      private @Nullable Long bytesPerPixel;
      public @NonNull Builder setBytesPerPixel(@Nullable Long setterArg) {
        this.bytesPerPixel = setterArg;
        return this;
      }
      private @Nullable Long height;
      public @NonNull Builder setHeight(@Nullable Long setterArg) {
        this.height = setterArg;
        return this;
      }
      private @Nullable Long width;
      public @NonNull Builder setWidth(@Nullable Long setterArg) {
        this.width = setterArg;
        return this;
      }
      public @NonNull InputImagePlaneMetadata build() {
        InputImagePlaneMetadata pigeonReturn = new InputImagePlaneMetadata();
        pigeonReturn.setBytesPerRow(bytesPerRow);
        pigeonReturn.setBytesPerPixel(bytesPerPixel);
        pigeonReturn.setHeight(height);
        pigeonReturn.setWidth(width);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("bytesPerRow", bytesPerRow);
      toMapResult.put("bytesPerPixel", bytesPerPixel);
      toMapResult.put("height", height);
      toMapResult.put("width", width);
      return toMapResult;
    }
    static @NonNull InputImagePlaneMetadata fromMap(@NonNull Map<String, Object> map) {
      InputImagePlaneMetadata pigeonResult = new InputImagePlaneMetadata();
      Object bytesPerRow = map.get("bytesPerRow");
      pigeonResult.setBytesPerRow((bytesPerRow == null) ? null : ((bytesPerRow instanceof Integer) ? (Integer)bytesPerRow : (Long)bytesPerRow));
      Object bytesPerPixel = map.get("bytesPerPixel");
      pigeonResult.setBytesPerPixel((bytesPerPixel == null) ? null : ((bytesPerPixel instanceof Integer) ? (Integer)bytesPerPixel : (Long)bytesPerPixel));
      Object height = map.get("height");
      pigeonResult.setHeight((height == null) ? null : ((height instanceof Integer) ? (Integer)height : (Long)height));
      Object width = map.get("width");
      pigeonResult.setWidth((width == null) ? null : ((width instanceof Integer) ? (Integer)width : (Long)width));
      return pigeonResult;
    }
  }

  public interface Result<T> {
    void success(T result);
    void error(Throwable error);
  }
  private static class PlatformPoseDetectorCodec extends StandardMessageCodec {
    public static final PlatformPoseDetectorCodec INSTANCE = new PlatformPoseDetectorCodec();
    private PlatformPoseDetectorCodec() {}
    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return InputImageData.fromMap((Map<String, Object>) readValue(buffer));
        
        case (byte)129:         
          return InputImagePlaneMetadata.fromMap((Map<String, Object>) readValue(buffer));
        
        case (byte)130:         
          return PlatformInputImage.fromMap((Map<String, Object>) readValue(buffer));
        
        case (byte)131:         
          return PlatformPose.fromMap((Map<String, Object>) readValue(buffer));
        
        case (byte)132:         
          return PlatformPoseLandmark.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value)     {
      if (value instanceof InputImageData) {
        stream.write(128);
        writeValue(stream, ((InputImageData) value).toMap());
      } else 
      if (value instanceof InputImagePlaneMetadata) {
        stream.write(129);
        writeValue(stream, ((InputImagePlaneMetadata) value).toMap());
      } else 
      if (value instanceof PlatformInputImage) {
        stream.write(130);
        writeValue(stream, ((PlatformInputImage) value).toMap());
      } else 
      if (value instanceof PlatformPose) {
        stream.write(131);
        writeValue(stream, ((PlatformPose) value).toMap());
      } else 
      if (value instanceof PlatformPoseLandmark) {
        stream.write(132);
        writeValue(stream, ((PlatformPoseLandmark) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface PlatformPoseDetector {
    void processImage(@NonNull PlatformInputImage inputImage, Result<PlatformPose> result);
    void closeDetector();

    /** The codec used by PlatformPoseDetector. */
    static MessageCodec<Object> getCodec() {
      return       PlatformPoseDetectorCodec.INSTANCE;    }
    /**Sets up an instance of `PlatformPoseDetector` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, PlatformPoseDetector api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.PlatformPoseDetector.processImage", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              assert args != null;
              PlatformInputImage inputImageArg = (PlatformInputImage)args.get(0);
              if (inputImageArg == null) {
                throw new NullPointerException("inputImageArg unexpectedly null.");
              }
              Result<PlatformPose> resultCallback = new Result<PlatformPose>() {
                public void success(PlatformPose result) {
                  wrapped.put("result", result);
                  reply.reply(wrapped);
                }
                public void error(Throwable error) {
                  wrapped.put("error", wrapError(error));
                  reply.reply(wrapped);
                }
              };

              api.processImage(inputImageArg, resultCallback);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
              reply.reply(wrapped);
            }
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.PlatformPoseDetector.closeDetector", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              api.closeDetector();
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  @NonNull private static Map<String, Object> wrapError(@NonNull Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    return errorMap;
  }
}