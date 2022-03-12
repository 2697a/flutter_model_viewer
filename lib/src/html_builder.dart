/* This is free and unencumbered software released into the public domain. */

import 'dart:convert' show htmlEscape;

import 'package:flutter/material.dart';

abstract class HTMLBuilder {
  HTMLBuilder._();

  static String build(
      {final String htmlTemplate = '',
        required final String src,
        final Color backgroundColor = const Color(0x00ffffff),
        final String? rotationPerSecond,
        final String? alt,
        final bool? ar,
        final List<String>? arModes,
        final String? arScale,
        final bool? autoRotate,
        final int? autoRotateDelay,
        final bool? autoPlay,
        final bool? cameraControls,
        final String? iosSrc}) {
    final html = StringBuffer(htmlTemplate);
    html.writeln('<style scoped>*{-webkit-touch-callout:none;-webkit-user-select:none;-khtml-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;}</style>');
    html.write('<model-viewer id="toggle-model"');
    //去除海报闪烁
    html.write(' seamless-poster');
    html.write(' bounds="tight"');

    html.write(' environment-image="neutral"');
    //添加3D资源
    html.write(' src="${htmlEscape.convert(src)}"');
    //关闭演示模式
    html.write(' interaction-prompt="none"');
    //设置触摸滑动方向 xy轴均可
    html.write(' touch-action="pan-x pan-y"');
    html.write(' style="background-color: rgb(${backgroundColor.red}, ${backgroundColor.green}, ${backgroundColor.blue});"');

    if (alt != null) {
      html.write(' alt="${htmlEscape.convert(alt)}"');
    }
    // TODO: animation-name
    // TODO: animation-crossfade-duration
    if (ar ?? false) {
      html.write(' ar');
    }
    if (arModes != null) {
      html.write(' ar-modes="${htmlEscape.convert(arModes.join(' '))}"');
    }
    if (arScale != null) {
      html.write(' ar-scale="${htmlEscape.convert(arScale)}"');
    }
    //是否开启自动旋转
    if (autoRotate ?? false) {
      html.write(' auto-rotate rotation-per-second="${rotationPerSecond ?? '40deg'}"');
      //手指离开多久之后开始自动旋转
      if (autoRotateDelay != null) {
        html.write(' auto-rotate-delay="$autoRotateDelay"');
      }
    }
    //自动播放动画
    if (autoPlay ?? false) {
      html.write(' autoplay');
    }
    // TODO: skybox-image
    //开启相机控制
    if (cameraControls ?? false) {
      html.write(' camera-controls');
    }

    // TODO: camera-orbit
    // TODO: camera-target
    // TODO: environment-image
    // TODO: exposure
    // TODO: field-of-view
    // TODO: interaction-policy
    // TODO: interaction-prompt
    // TODO: interaction-prompt-style
    // TODO: interaction-prompt-threshold
    if (iosSrc != null) {
      html.write(' ios-src="${htmlEscape.convert(iosSrc)}"');
    }
    // TODO: max-camera-orbit
    // TODO: max-field-of-view
    // TODO: min-camera-orbit
    // TODO: min-field-of-view
    // TODO: poster
    // TODO: loading
    // TODO: quick-look-browsers
    // TODO: reveal
    // TODO: shadow-intensity
    // TODO: shadow-softness
    html.writeln('>');
    // html.writeln('<div  slot="poster"></div>');
    html.writeln('<div slot="progress-bar"></div slot="">');
    html.writeln('<div slot="interaction-prompt"></div>');
    html.writeln('</model-viewer>');

    //当模型可见时通知外部
    var visibleScript = 'var modelViewer = document.querySelector("#toggle-model");'
        'var device = navigator.userAgent;'
        'var isAndroid = device.indexOf("Android") > -1 || device.indexOf("Adr") > -1;'
        'var isIOS = !!device.match(/\\(i[^;]+;( U;)? CPU.+Mac OS X/);'
        'modelViewer.addEventListener("model-visibility", (event) => { '
        'if(isAndroid){'
        'ModelVisibility.postMessage(event.detail.visible);'
        '}'
        'if(isIOS){'
        'window.webkit.messageHandlers.ModelVisibility.postMessage(event.detail.visible);'
        '}'
        '}, true);';
    //解决H5在IOS的WebView下上拉下拉会带动整个WebView出现空白
    visibleScript+='document.body.addEventListener("touchmove", function(e) {if(e._isScroller) return;e.preventDefault();}, {passive: false});';
    html.writeln('<script type="text/javascript">$visibleScript</script>');
    return html.toString();
  }
}
