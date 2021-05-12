import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:obs_websocket/obsWebsocket.dart';
import 'package:obs_websocket/src/model/authRequiredResponse.dart';
import 'package:obs_websocket/src/model/mediaStateResponse.dart';
import 'package:obs_websocket/src/model/scene.dart';
import 'package:obs_websocket/src/model/streamSetting.dart';
import 'package:obs_websocket/src/model/streamSettingsResponse.dart';
import 'package:obs_websocket/src/model/streamStatusResponse.dart';
import 'package:obs_websocket/src/model/studioModeStatus.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class ObsWebSocket {
  final String connectUrl;

  final IOWebSocketChannel channel;

  late final Stream<dynamic> broadcast;

  final List<Function> listeners = [];

  int message_id = 0;

  ///When the object is created we open the websocket connection and create a broadcast
  ///stream so that we can have multiple listeners providing responses to commands.
  ///[connectUrl] is in the format 'ws://host:port'.
  ObsWebSocket({required this.connectUrl, Function? onEvent})
      : channel = IOWebSocketChannel.connect(connectUrl) {
    broadcast = channel.stream.asBroadcastStream();

    if (onEvent != null) addListener(onEvent);

    broadcast.listen((jsonEvent) {
      final Map<String, dynamic> rawEvent = jsonDecode(jsonEvent);

      if (!rawEvent.containsKey('message-id') && listeners.isNotEmpty) {
        listeners.forEach((listener) async =>
            await listener(BaseEvent.fromJson(rawEvent), this));
      }
    });
  }

  /// Before execution finished the websocket needs to be closed
  Future<void> close() async {
    await channel.sink.close(status.goingAway);
  }

  void addListener(Function listener) {
    listeners.add(listener);
  }

  ///Returns an AuthRequiredResponse object that can be used to determine if authentication is
  ///required to connect to the server.  The AuthRequiredResponse object hods the 'salt' and
  ///'secret' that will be required for authentication in the case that it is required
  ///Throws an [Exception] if there is a problem or error returned by the server.
  Future<AuthRequiredResponse> getAuthRequired() async {
    AuthRequiredResponse authRequired = AuthRequiredResponse.init();

    String messageId = sendCommand({'request-type': 'GetAuthRequired'});

    await for (String message in broadcast) {
      authRequired = AuthRequiredResponse.fromJson(jsonDecode(message));

      if (!authRequired.status) {
        throw Exception(
            'Server returned error to GetAuthRequiredResponse request: ${message}');
      }

      if (authRequired.messageId == messageId) break;
    }

    return authRequired;
  }

  ///Returns a BaseResponse object, [requirements] are provided by the AuthRequiredResponse
  ///object and [passwd] is the password assigned in the OBS interface for websockets
  ///If OBS returns an error in the response, then an [Exception] will be thrown.
  Future<BaseResponse?> authenticate(
      AuthRequiredResponse requirements, String passwd) async {
    final String secret = base64Hash(passwd + requirements.salt!);
    final String auth_reponse = base64Hash(secret + requirements.challenge!);

    BaseResponse? response;

    String messageId =
        sendCommand({'request-type': 'Authenticate', 'auth': auth_reponse});

    await for (String message in broadcast) {
      response = BaseResponse.fromJson(jsonDecode(message));

      if (!response.status) {
        throw Exception(
            'Server returned error to Authenticate request: ${message}');
      }

      if (response.messageId == messageId) {
        break;
      }
    }

    return response;
  }

  ///This is a helper method for sending commands over the websocket.  A SimpleResponse
  ///is returned.  The function requires a [command] from the documented list of
  ///websocket and optionally [args] can be provided if rquired by the command.  If OBS
  ///returns an error in the response, then an [Exception] will be thrown.
  Future<BaseResponse?> command(String command,
      [Map<String, dynamic>? args]) async {
    BaseResponse? response;

    String messageId = sendCommand({'request-type': command}, args);

    await for (String message in broadcast) {
      response = BaseResponse.fromJson(jsonDecode(message));

      if (!response.status && response.messageId == messageId) {
        throw Exception(
            'Server returned error to ${command} request: ${message}');
      }

      if (response.messageId == messageId) break;
    }

    return response;
  }

  ///This is the lower level send that transmits the command supplied on the websocket,
  ///It requires a [payload], the command as a Map that will be json encoded in the
  ///format required by OBS, and the [args].  Both are combined into a single Map that
  ///is json encoded and transmitted over the websocket.
  String sendCommand(Map<String, dynamic> payload,
      [Map<String, dynamic>? args]) {
    message_id++;

    payload['message-id'] = message_id.toString();

    if (args != null) payload.addAll(args);

    final String requestPayload = jsonEncode(payload);

    channel.sink.add(requestPayload);

    return message_id.toString();
  }

  Future<StreamStatusResponse> getStreamStatus() async {
    var response = await command('GetStreamingStatus');

    if (response == null)
      throw Exception('Could not retrieve the stream status');

    return StreamStatusResponse.fromJson(response.rawResponse);
  }

  Future<void> stopStreaming() async {
    await command('StopStreaming');
  }

  Future<void> startStreaming() async {
    await command('StartStreaming');
  }

  Future<void> startStopStreaming() async {
    await command('StartStopStreaming');
  }

  Future<StreamSettingsResponse> getStreamSettings() async {
    final response = await command('GetStreamSettings');

    if (response == null) throw Exception('Problem getting stream settings');

    return StreamSettingsResponse.fromJson(response.rawResponse);
  }

  Future<void> setStreamSettings(StreamSetting streamSetting) async {
    await command('SetStreamSettings', streamSetting.toJson());
  }

  Future<void> enableStudioMode() async {
    await command('EnableStudioMode');
  }

  Future<StudioModeStatus> getStudioModeStatus() async {
    final response = await command('GetStudioModeStatus');

    if (response == null) throw Exception('Problem getting stream settings');

    return StudioModeStatus.fromJson(response.rawResponse);
  }

  Future<Scene> getCurrentScene() async {
    final response = await command('GetCurrentScene');

    if (response == null) throw Exception('Problem getting current scene');

    return Scene.fromJson(response.rawResponse);
  }

  Future<void> setCurrentScene(Map<String, dynamic> args) async {
    await command('SetCurrentScene', args);
  }

  Future<void> setSceneItemRender(Map<String, dynamic> args) async {
    await command('SetSceneItemRender', args);
  }

  // Future<List<Scene>> getSceneList([Map<String, dynamic>? args]) async {
  //   final response = await command('GetSceneList', args);

  //   return null;
  // }

  Future<void> playPauseMedia([Map<String, dynamic>? args]) async {
    await command('PlayPauseMedia', args);
  }

  Future<void> restartMedia([Map<String, dynamic>? args]) async {
    await command('RestartMedia', args);
  }

  Future<void> stopMedia([Map<String, dynamic>? args]) async {
    await command('StopMedia', args);
  }

  Future<MediaStateResponse> getMediaState([Map<String, dynamic>? args]) async {
    final response = await command('GetMediaState', args);

    if (response == null) throw Exception('Problem getting media state');

    return MediaStateResponse.fromJson(response.rawResponse);
  }

  ///A helper function that encrypts authentication info [data] for the purpose of
  ///authentication.
  String base64Hash(String data) {
    final Digest hash = sha256.convert(utf8.encode(data));

    final String secret = base64.encode(hash.bytes);

    return secret;
  }
}