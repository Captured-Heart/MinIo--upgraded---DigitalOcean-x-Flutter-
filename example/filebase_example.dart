import 'dart:developer';

import 'package:minio_flutter/minio.dart';

void main() async {
  Minio.init(
    endPoint: 's3.filebase.com',
    accessKey: '<YOUR_ACCESS_KEY>',
    secretKey: '<YOUR_SECRET_KEY>',
  );

  final buckets = await Minio.shared.listBuckets();
  log('buckets: $buckets');

  final objects = await Minio.shared.listObjects(buckets.first.name).toList();
  log('objects: $objects');
}
