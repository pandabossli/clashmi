import 'dart:async';

import 'package:clashmi/app/clash/clash_http_api.dart';
import 'package:clashmi/app/local_services/vpn_service.dart';
import 'package:clashmi/app/modules/biz.dart';
import 'package:clashmi/app/modules/node_demo_manager.dart';
import 'package:flutter/material.dart';
import 'package:libclash_vpn_service/state.dart';

class SimpleHomeScreen extends StatefulWidget {
  const SimpleHomeScreen({super.key});

  @override
  State<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends State<SimpleHomeScreen> {
  static const Duration _refreshInterval = Duration(seconds: 1);
  static const Duration _connectTimeout = Duration(seconds: 15);

  late final void Function(FlutterVpnServiceState, Map<String, String>)
  _stateListener;

  FlutterVpnServiceState _state = FlutterVpnServiceState.disconnected;
  Timer? _timer;
  num _upload = 0;
  num _download = 0;
  bool _isWorking = false;

  @override
  void initState() {
    super.initState();
    Biz.initHomeFinish();
    _stateListener = _handleStateChange;
    VPNService.onEventStateChanged.add(_stateListener);
    _loadInitialState();
    _timer = Timer.periodic(_refreshInterval, (_) => _refreshTraffic());
  }

  Future<void> _loadInitialState() async {
    final current = await VPNService.getState();
    if (!mounted) {
      return;
    }
    setState(() {
      _state = current;
    });
  }

  void _handleStateChange(
    FlutterVpnServiceState state,
    Map<String, String> params,
  ) {
    if (!mounted) {
      return;
    }
    setState(() {
      _state = state;
      if (state != FlutterVpnServiceState.connected) {
        _upload = 0;
        _download = 0;
      }
    });
  }

  Future<void> _refreshTraffic() async {
    if (_state != FlutterVpnServiceState.connected) {
      return;
    }
    final result = await NodeDemoManager.getUsedTrafficTotals();
    if (!mounted) {
      return;
    }
    if (result.error != null || result.data == null) {
      return;
    }
    setState(() {
      _upload = result.data!.upload;
      _download = result.data!.download;
    });
  }

  Future<void> _toggleVpn() async {
    if (_isWorking) {
      return;
    }
    setState(() {
      _isWorking = true;
    });
    try {
      if (_state == FlutterVpnServiceState.connected) {
        await VPNService.stop();
      } else {
        final err = await VPNService.start(_connectTimeout);
        if (err != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err.message)),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isWorking = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    VPNService.onEventStateChanged.remove(_stateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadText = ClashHttpApi.convertTrafficToStringDouble(_upload);
    final downloadText = ClashHttpApi.convertTrafficToStringDouble(_download);
    final isConnected = _state == FlutterVpnServiceState.connected;
    final buttonLabel = isConnected ? '断开' : '连接';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: _isWorking ? null : _toggleVpn,
                child: Text(buttonLabel),
              ),
              const SizedBox(height: 24),
              Text('上传流量: $uploadText'),
              const SizedBox(height: 12),
              Text('下载流量: $downloadText'),
            ],
          ),
        ),
      ),
    );
  }
}
