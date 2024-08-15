# minio_flutter

Unofficial MinIO Dart Client SDK that provides simple APIs to access any Amazon S3 compatible object storage server.

## Initialize

**MinIO**

```dart
Minio.init(
  endPoint: 'play.min.io',
  accessKey: 'Q3AM3UQ867SPQQA43P2F',
  secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
  region: 'us-east-1',
);
```

**AWS S3**

```dart
Minio.init(
  endPoint: 's3.amazonaws.com',
  accessKey: 'YOUR-ACCESSKEYID',
  secretKey: 'YOUR-SECRETACCESSKEY',
  region: 'us-east-1',
);
```

**Filebase**

```dart
Minio.init(
  endPoint: 's3.filebase.com',
  accessKey: 'YOUR-ACCESSKEYID',
  secretKey: 'YOUR-SECRETACCESSKEY',
  useSSL: true,
);
```

**File upload**
```dart
import 'package:minio_flutter/io.dart';
import 'package:minio_flutter/minio.dart';

void main() async {
  Minio.init(
    endPoint: 'play.min.io',
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
  );

  await Minio.shared.fPutObject('mybucket', 'myobject', 'path/to/file');
}
```

For complete example, see: [example]

> To use `fPutObject()` and `fGetObject`, you have to `import 'package:minio/io.dart';`

**Upload with progress**
```dart
import 'package:minio_flutter/minio.dart';

void main() async {
  Minio.init(
    endPoint: 'play.min.io',
    accessKey: 'Q3AM3UQ867SPQQA43P2F',
    secretKey: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
  );

  await Minio.shared.putObject(
    'mybucket', 
    'myobject', 
    Stream<Uint8List>.value(Uint8List(1024)),
    onProgress: (bytes) => print('$bytes uploaded'),
  );
}
```

**Get object**

```dart
import 'dart:io';
import 'package:minio_flutter/minio.dart';

void main() async {
  Minio.init(
    endPoint: 's3.amazonaws.com',
    accessKey: 'YOUR-ACCESSKEYID',
    secretKey: 'YOUR-SECRETACCESSKEY',
  );

  final stream = await Minio.shared.getObject('BUCKET-NAME', 'OBJECT-NAME');

  // Get object length
  print(stream.contentLength);

  // Write object data stream to file
  await stream.pipe(File('output.txt').openWrite());
}
```

## License

MIT
