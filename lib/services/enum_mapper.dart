import 'package:enciphered_app/widgets/enums/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

IconData getPlatformIcon(PlatformType type) {
  switch (type) {
    case PlatformType.github:
      return FontAwesomeIcons.github;
    case PlatformType.instagram:
      return FontAwesomeIcons.instagram;
    case PlatformType.gmail:
      return Icons.mail_outline;
    case PlatformType.twitter:
      return FontAwesomeIcons.twitter;
    case PlatformType.discord:
      return FontAwesomeIcons.discord;
    case PlatformType.steam:
      return FontAwesomeIcons.steam;
    case PlatformType.other:
    // ignore: unreachable_switch_default
    default:
      return Icons.language;
  }
}
