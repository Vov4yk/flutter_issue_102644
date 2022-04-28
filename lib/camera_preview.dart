import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraAttachmentPreview extends StatefulWidget {
  final void Function() onPhoto;
  final void Function()? onVideo;
  CameraAttachmentPreview({required this.onPhoto, this.onVideo});
  @override
  State<StatefulWidget> createState() {
    return CameraAttachmentPreviewState();
  }
}

class CameraAttachmentPreviewState extends State<CameraAttachmentPreview>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _cameraAvailable = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _initCamera();
    } else if (state == AppLifecycleState.paused) {
      _cameraController?.dispose();
    }
  }

  _initCamera() {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      availableCameras().then((value) async {
        if (!mounted) {
          return;
        }
        if (value.isEmpty) {
          setState(() {
            _cameraAvailable = false;
          });
          return;
        }
        await _setupCamera(value);
      });
    });
  }

  _setupCamera(List<CameraDescription> value) async {
    try {
      final cameraController =
          CameraController(value[0], ResolutionPreset.medium);
      cameraController.addListener(() {});
      _cameraController = cameraController;

      await _cameraController?.initialize();
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {
      setState(() {
        _cameraAvailable = false;
      });
      print('Failed to create camera with $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 88,
      color: Colors.transparent,
      child: _body(),
    );
  }

  Widget _body() {
    if (_cameraController == null || !_cameraAvailable) {
      return _noCameraView();
    }
    return AnimatedOpacity(
      opacity: 1,
      duration: Duration(seconds: 3),
      child: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          _cameraView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => widget.onPhoto(),
                icon: Icon(Icons.camera_alt),
              ),
              if (widget.onVideo != null)
                IconButton(
                  onPressed: () => widget.onVideo!(),
                  icon: Icon(Icons.videocam),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cameraView() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Hero(
        tag: 'cameraView',
        child: CameraPreview(_cameraController!),
        transitionOnUserGestures: true,
      ),
    );
  }

  Widget _noCameraView() {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.elliptical(20, 16),
      ),
      child: Container(
        width: 56,
        height: 56,
        color: Colors.black,
        child: Center(
          child: _cameraAvailable
              ? CircularProgressIndicator.adaptive()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    Text(
                      'Camera not available',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}
