import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/services/endpoint_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebugConfigPage extends StatefulWidget {
  const DebugConfigPage({super.key});

  @override
  State<DebugConfigPage> createState() => _DebugConfigPageState();
}

class _DebugConfigPageState extends State<DebugConfigPage> {
  final TextEditingController _controller =
      TextEditingController(text: ApiConstant.baseURL);

  bool _saving = false;
  bool _testing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });

    await ApiConstant.setBaseUrlOverride(_controller.text);

    if (!mounted) return;

    setState(() {
      _saving = false;
    });

    Get.snackbar(
      'Base URL disimpan',
      ApiConstant.baseURL,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _reset() async {
    await ApiConstant.setBaseUrlOverride(null);

    if (!mounted) return;

    setState(() {
      _controller.text = ApiConstant.baseURL;
    });

    Get.snackbar(
      'Base URL direset',
      ApiConstant.baseURL,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _testConnection() async {
    setState(() {
      _testing = true;
    });

    final endpointService = Get.find<EndpointService>();
    final ok = await endpointService.testConnection();

    if (!mounted) return;

    setState(() {
      _testing = false;
    });

    Get.snackbar(
      'Tes koneksi',
      ok ? 'Berhasil terhubung' : 'Gagal terhubung',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Config'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Base URL',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'http://192.168.x.x:8000/api',
              ),
              keyboardType: TextInputType.url,
              autofillHints: const [AutofillHints.url],
            ),
            const SizedBox(height: 12),
            Text(
              'Aktif: ${ApiConstant.baseURL}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Simpan'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset default'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _testing ? null : _testConnection,
                  icon: _testing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.wifi_tethering),
                  label: const Text('Tes koneksi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
