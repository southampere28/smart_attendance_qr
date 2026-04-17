import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/domain/enum/permission_type_enum.dart';
import 'package:absensi_qr/features/widgets/button_primary_widget.dart';
import 'package:absensi_qr/models/permission_model.dart';
import 'package:flutter/material.dart';

class DialogPermissionDetailStudent extends StatelessWidget {
  const DialogPermissionDetailStudent({
    super.key,
    required this.permissionData,
    required this.studentName,
    required this.onTap,
    required this.widthFactor,
  });

  final PermissionModel permissionData;
  final String studentName;
  final VoidCallback onTap;
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
    final permission = permissionData;
    final status = permission.status;
    final statusColor = _statusColor(status);
    final isRejected = status == PermissionStatusEnum.ditolak;
    final feedbackValue = (permission.feedback.split('').isNotEmpty
        ? permission.feedback
        : 'Tidak ada alasan penolakan');

    return Dialog(
      insetPadding: EdgeInsets.zero,
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
              // Header: Judul + Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                  ),
                  Expanded(
                    child: Text(
                      'Detail Perizinan',
                      style: AppFontStyle.primaryText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColor.inactiveColor,
                        size: 30,
                      )),
                ],
              ),

              const Divider(height: 24),

              // ── Info rows ───────────────────────────────────────────────
              _InfoStudentPermission(
                studentName: studentName,
                status: status,
                statusColor: statusColor,
              ),
              SpacingSize.spacingSMHeight,
              _InfoRow(
                label: 'Jenis',
                value: permission.reason.title,
              ),
              SpacingSize.spacingXSHeight,
              _InfoRow(
                label: 'Jumlah Hari',
                value: '${permission.dayCount} hari',
              ),
              SpacingSize.spacingXSHeight,
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
                style: AppFontStyle.subTitleText,
              ),
              SpacingSize.spacingSMHeight,
              _EvidenceImage(
                imageUrl:
                    '${ApiConstant.permissionEvidenceURL}/${permission.evidence}',
                onTap: permission.evidence.isNotEmpty
                    ? () => _openFullscreen(context,
                        '${ApiConstant.permissionEvidenceURL}/${permission.evidence}')
                    : null,
              ),

              // Tombol aksi buat ulang perizinan.
              if (isRejected) ...[
                SpacingSize.spacingBaseHeight,
                Text(
                  'Alasan Penolakan',
                  style: AppFontStyle.subTitleText,
                ),
                SpacingSize.spacingXSHeight,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.errorColor),
                  ),
                  child: Text(
                    feedbackValue,
                    style: AppFontStyle.primaryText.copyWith(
                      color: AppColor.errorColor,
                    ),
                  ),
                ),
                const Divider(height: 28),
                Row(
                  children: [
                    SpacingSize.spacingMDWidth,
                    Expanded(
                        child: ButtonPrimaryWidget(
                      title: 'Ajukan Kembali',
                      callback: onTap,
                    )),
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

class _InfoStudentPermission extends StatelessWidget {
  const _InfoStudentPermission({
    required this.studentName,
    required this.status,
    required this.statusColor,
  });

  final String studentName;
  final PermissionStatusEnum status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.person, color: AppColor.primaryColor, size: 24),
        SpacingSize.spacingSMWidth,
        Expanded(
          child: Text(
            studentName,
            style:
                AppFontStyle.primaryText.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          status.title,
          style: AppFontStyle.smallText.copyWith(color: statusColor),
        ),
      ],
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
            style: AppFontStyle.subTitleText,
          ),
        ),
        Text(
          ': ',
          style: AppFontStyle.subTitleText,
        ),
        Expanded(
          child: Text(
            value,
            style: AppFontStyle.primaryText,
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
            style: AppFontStyle.subTitleText,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : Container(
                            height: 180,
                            color: AppColor.colorBackgroundApp,
                            child: const Center(
                                child: CircularProgressIndicator()),
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
                  // semi-transparent black overlay on top of image
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // hint ikon fullscreen di pojok kanan bawah
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SpacingSize.spacingXSHeight,
              Text('Lihat Gambar',
                  style: AppFontStyle.whiteText.copyWith(fontSize: 14)),
            ],
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
