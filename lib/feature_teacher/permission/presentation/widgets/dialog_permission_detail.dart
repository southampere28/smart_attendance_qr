import 'package:absensi_qr/configs/api_constant.dart';
import 'package:absensi_qr/constant/app_color.dart';
import 'package:absensi_qr/constant/app_font_style.dart';
import 'package:absensi_qr/constant/spacing_size.dart';
import 'package:absensi_qr/core/helper/date_helper.dart';
import 'package:absensi_qr/domain/enum/permission_status_enum.dart';
import 'package:absensi_qr/domain/enum/permission_type_enum.dart';
import 'package:absensi_qr/feature_teacher/permission/presentation/widgets/form_permission_rejection.dart';
import 'package:absensi_qr/models/model_merging/permission_student_item.dart';
import 'package:flutter/material.dart';

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
    final datePermissionFormatted =
        DateHelper.formatToDayDateMonthIndonesia(permission.datePermission);
    final student = permissionData.student;
    final status = permission.status;
    final statusColor = _statusColor(status);
    final isWaiting = status == PermissionStatusEnum.proses;

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
              // ── Header: title + close ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 30, width: 30),
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
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: AppColor.inactiveColor,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // ── Person icon + nama siswa + status ──────────────────────
              Row(
                children: [
                  const Icon(Icons.person,
                      color: AppColor.primaryColor, size: 24),
                  SpacingSize.spacingSMWidth,
                  Expanded(
                    child: Text(
                      student.name,
                      style: AppFontStyle.primaryText
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    status.title,
                    style: AppFontStyle.smallText.copyWith(color: statusColor),
                  ),
                ],
              ),

              SpacingSize.spacingBaseHeight,

              // ── Info rows ───────────────────────────────────────────────
              _InfoRow(
                label: 'Tanggal Izin',
                value: datePermissionFormatted,
              ),
              SpacingSize.spacingMDHeight,
              _InfoRow(
                label: 'Jumlah Hari',
                value: '${permission.dayCount} hari',
              ),
              SpacingSize.spacingMDHeight,
              _InfoRow(
                label: 'Jenis Perizinan',
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
                imageUrl:
                    '${ApiConstant.permissionEvidenceURL}/${permission.evidence}',
                onTap: permission.evidence.isNotEmpty
                    ? () => _openFullscreen(context,
                        '${ApiConstant.permissionEvidenceURL}/${permission.evidence}')
                    : null,
              ),

              // ── Alasan penolakan (hanya saat status ditolak) ────────────
              if (status == PermissionStatusEnum.ditolak) ...[
                SpacingSize.spacingBaseHeight,
                Text(
                  'Alasan Penolakan',
                  style: AppFontStyle.subTitleText.copyWith(fontSize: 12),
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
                    permission.feedback.isNotEmpty
                        ? permission.feedback
                        : 'Tidak ada alasan penolakan',
                    style: AppFontStyle.primaryText.copyWith(
                      color: AppColor.errorColor,
                    ),
                  ),
                ),
              ],

              // ── Tombol Tolak / Setuju (hanya saat status proses) ────────
              if (isWaiting) ...[
                const Divider(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // delegate showing rejection form to caller/controller
                          onReject();
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
          // ikon fullscreen + label di tengah
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
