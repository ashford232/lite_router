
# LiteRouter

A lightweight navigation helper for Flutter.

## Installation

```bash
flutter pub add lite_router
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:lite_router/lite_router.dart';

final router = LiteRouter();

MaterialApp(
  navigatorKey: router.navigatorKey,
  home: const HomePage(),
);
```

## Navigation

```dart
router.push(const ProfilePage());
router.replace(const LoginPage());
router.to(const HomePage());
router.back();
```
