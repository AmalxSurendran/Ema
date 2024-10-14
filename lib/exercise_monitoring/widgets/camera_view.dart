
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../pigeon.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.onImage,
      this.onScreenModeChanged,
      this.initialDirection = CameraLensDirection.front})
      : super(key: key);

  final Function(PlatformInputImage inputImage) onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  int _cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;

  @override
  void initState() {
    super.initState();

    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
          (element) => element.lensDirection == widget.initialDirection,
        ),
      );
    }

    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return _liveFeedBody();
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    return CameraPreview(_controller!);
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
    // _controller!.setZoomLevel(zoomLevel);
  }

  Future _stopLiveFeed() async {
    if(_controller!=null) {
      await _controller?.stopImageStream();
      await _controller?.dispose();
    }
    _controller = null;
  }

  Future _processCameraImage(CameraImage image) async {
    final List<Uint8List> planes = [];
    for (final Plane plane in image.planes) {
      planes.add(plane.bytes);
    }

    final camera = cameras[_cameraIndex];
    final imageRotation = camera.sensorOrientation;
    final inputImageFormat = image.format.raw;
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
            bytesPerPixel: plane.bytesPerPixel);
      },
    ).toList();

    final inputImageData = InputImageData(
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
      height: image.height,
      width: image.width,
    );

    final inputImage =
        PlatformInputImage(planes: planes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
}
