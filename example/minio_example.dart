import 'dart:developer';

import 'package:minio_flutter/io.dart';
import 'package:minio_flutter/minio.dart';

void main() async {
  Minio.init(
    endPoint: 'play.min.io',
    accessKey: '',
    secretKey: '',
  );

  const bucket = '00test';
  const object = 'custed.png';
  const copy1 = 'custed.copy1.png';
  const copy2 = 'custed.copy2.png';

  if (!await Minio.shared.bucketExists(bucket)) {
    await Minio.shared.makeBucket(bucket);
    log('bucket $bucket created');
  } else {
    log('bucket $bucket already exists');
  }

  final poller = Minio.shared.listenBucketNotification(
    bucket,
    events: [
      's3:ObjectCreated:*',
    ],
  );
  poller.stream.listen((event) {
    log('--- event: ${event['eventName']}');
  });

  final region = await Minio.shared.getBucketRegion('00test');
  log('--- object region:');
  log(region);

  final etag = await Minio.shared.fPutObject(bucket, object, 'example/$object');
  log('--- etag:');
  log(etag);

  final url =
      await Minio.shared.presignedGetObject(bucket, object, expires: 1000);
  log('--- presigned url:');
  log(url);

  final copyResult1 =
      await Minio.shared.copyObject(bucket, copy1, '$bucket/$object');
  final copyResult2 =
      await Minio.shared.copyObject(bucket, copy2, '$bucket/$object');
  log('--- copy1 etag: ${copyResult1.eTag}');
  log('--- copy2 etag: ${copyResult2.eTag}');

  await Minio.shared.fGetObject(bucket, object, 'example/$copy1');
  log('--- copy1 downloaded');

  await Minio.shared.listObjects(bucket).forEach((chunk) {
    for (final o in chunk.objects) {
      log('--- objects: ${o.key}');
    }
  });

  await Minio.shared.listObjectsV2(bucket).forEach((chunk) {
    for (final o in chunk.objects) {
      log('--- objects(v2): ${o.key}');
    }
  });

  final stat = await Minio.shared.statObject(bucket, object);
  log('--- object stat: ${stat.etag}, ${stat.size}, ${stat.lastModified}, ${stat.metaData}');

  await Minio.shared.removeObject(bucket, object);
  log('--- object removed');

  await Minio.shared.removeObjects(bucket, [copy1, copy2]);
  log('--- copy1, copy2 removed');

  await Minio.shared.removeBucket(bucket);
  log('--- bucket removed');

  poller.stop();
}
