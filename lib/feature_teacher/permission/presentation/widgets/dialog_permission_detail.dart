import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/domain/enum/permission_type_enum.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/widgets/form_permission_rejection.dart';
import 'package:absensi_qr/models/model_merging/permission_student_item.dart';
import 'package:flutter/material.dart';

/// Dialog detail perizinan siswa.
///
/// Tampilkan dengan:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => DialogPermissionDetail(
///     permissionData: item,
///     onAccept: () { ... },
///     onReject: () { ... },
///   ),
/// );
/// ```
class DialogPermissionDetail extends StatelessWidget {
  const DialogPermissionDetail({
    super.key,
    required this.permissionData,
    required this.onAccept,
    required this.onReject,
    this.widthFactor = 0.88,
  });

  final PermissionStudentItem permissionData;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  /// Lebar dialog sebagai fraksi lebar layar. Default 0.88 = 88%.
  final double widthFactor;

  Color _statusColor(PermissionStatusEnum status) {
    switch (status) {
      case PermissionStatusEnum.diterima:
        return AppColor.successColor;
      case PermissionStatusEnum.ditolak:
        return AppColor.errorColor;
      case PermissionStatusEnum.proses:
        return AppColor.warningColor;
      default:
        return AppColor.inactiveColor;
    }
  }

  void _openFullscreen(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullscreenImagePage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final permission = permissionData.permission;
    final student = permissionData.student;
    final status = permission.status;
    final statusColor = _statusColor(status);
    final isWaiting = status == PermissionStatusEnum.proses;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * widthFactor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header: nama siswa + badge status ──────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      student.name,
                      style: AppFontStyle.primaryText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SpacingSize.spacingSMWidth,
                  _StatusBadge(status: status, color: statusColor),
                ],
              ),

              const Divider(height: 24),

              // ── Info rows ───────────────────────────────────────────────
              _InfoRow(
                label: 'Jumlah Hari',
                value: '${permission.dayCount} hari',
              ),
              SpacingSize.spacingMDHeight,
              _InfoRow(
                label: 'Alasan',
                value: permission.reason.title,
              ),
              SpacingSize.spacingMDHeight,
              _InfoRow(
                label: 'Keterangan',
                value: permission.information.isNotEmpty
                    ? permission.information
                    : '-',
              ),

              SpacingSize.spacingBaseHeight,

              // ── Bukti pendukung ─────────────────────────────────────────
              Text(
                'Bukti Pendukung',
                style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
              ),
              SpacingSize.spacingSMHeight,
              _EvidenceImage(
                imageUrl: 'https://dummyimage.com/600x400/000/fff.png&text=anjay',
                onTap: permission.evidence.isNotEmpty
                    ? () => _openFullscreen(context, permission.evidence)
                    : null,
              ),

              // ── Tombol Tolak / Setuju (hanya saat status proses) ────────
              if (isWaiting) ...[
                const Divider(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // onReject();
                          showDialog(
                            context: context,
                            builder: (context) => FormPermissionRejection(onSubmit: onReject),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.errorColor,
                          side: const BorderSide(color: AppColor.errorColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Tolak'),
                      ),
                    ),
                    SpacingSize.spacingMDWidth,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onAccept();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.successColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Setuju'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, required this.color});

  final PermissionStatusEnum status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status.title,
        style: AppFontStyle.subTitleText.copyWith(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
          ),
        ),
        Text(
          ': ',
          style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            style: AppFontStyle.primaryText.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _EvidenceImage extends StatelessWidget {
  const _EvidenceImage({required this.imageUrl, this.onTap});

  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.colorBackgroundApp,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Tidak ada bukti pendukung',
            style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      height: 180,
                      color: AppColor.colorBackgroundApp,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: AppColor.colorBackgroundApp,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColor.inactiveColor,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          // hint ikon fullscreen di pojok kanan bawah
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.fullscreen,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fullscreen image viewer ─────────────────────────────────────────────────

class _FullscreenImagePage extends StatelessWidget {
  const _FullscreenImagePage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 5.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) => progress == null
                ? child
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}
