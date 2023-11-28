import 'dart:async';
import 'dart:convert';
import 'dart:io';

class HttpGetRequest {
  final HttpClient client = HttpClient();

  Future<String?> fetchUrl(String url, {int timeoutSeconds = 2}) async {
    try {
      final HttpClientRequest request = await client.getUrl(Uri.parse(url));

      final HttpClientResponse response = await request.close().timeout(
            Duration(seconds: timeoutSeconds),
          );

      if (response.statusCode == HttpStatus.ok) {
        final String responseBody =
            await response.transform(utf8.decoder).join();
        return responseBody;
      } else {
        return null;
      }
    } on TimeoutException {
      //Termina el tiempo de espera
      return "1";
    } catch (e) {
      // Manejar otras excepciones aquí
      return null;
    } finally {
      client.close(); // Cierra el cliente
    }
  }

  Future<String?> httpPost(
      final url, final jsonData, final String token) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(url);

      request.headers.set('Authorization', 'Bearer $token');

      // Define el cuerpo de la solicitud en formato JSON
      request.headers.add('Content-Type', 'application/json');
      request.write(jsonData);

      final response = await request.close();
      final status = response.statusCode;

      if (status == HttpStatus.ok) {
        // La solicitud fue exitosa
        final responseData = await response.transform(utf8.decoder).join();
        return responseData;
        //print('Respuesta del servidor: $responseData');
      } else {
        // La solicitud fallo
        return 'error';
        //print('Error en la solicitud POST: ${response.statusCode}');
      }
    } catch (e) {
      // Maneja cualquier excepción
      print(e);
      return 'error';
    } finally {
      client.close();
    }
  }

  Future<String?> httpPut(final url, final jsonData, final String token) async {
    final client = HttpClient();

    try {
      final request = await client.putUrl(url);

      // Configura las cabeceras de la solicitud, si es necesario
      if (token.isNotEmpty) {
        print("Llega aqui token");
        request.headers.set('Authorization', 'Bearer $token');
      }

      // Define el cuerpo de la solicitud en formato JSON
      request.headers.add('Content-Type', 'application/json');
      request.write(jsonData);

      final response = await request.close();
      final status = response.statusCode;

      if (status == HttpStatus.ok) {
        // La solicitud fue exitosa
        final responseData = await response.transform(utf8.decoder).join();
        print(responseData);
        return responseData;
        //print('Respuesta del servidor: $responseData');
      } else {
        // La solicitud fallo
        return 'error';
        //print('Error en la solicitud POST: ${response.statusCode}');
      }
    } catch (e) {
      // Maneja cualquier excepción
      print('Error');
      return 'error';
    } finally {
      client.close();
    }
  }
}
