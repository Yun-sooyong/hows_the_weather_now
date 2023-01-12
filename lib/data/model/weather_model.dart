import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
  Weather({
    required this.response,
  });

  Response response;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
      };
}

class Response {
  Response({
    required this.header,
    required this.body,
  });

  Header header;
  Body body;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        header: Header.fromJson(json["header"]),
        body: Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "body": body.toJson(),
      };
}

class Body {
  Body({
    required this.dataType,
    required this.items,
    required this.pageNo,
    required this.numOfRows,
    required this.totalCount,
  });

  String dataType;
  Items items;
  int pageNo;
  int numOfRows;
  int totalCount;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        dataType: json["dataType"],
        items: Items.fromJson(json["items"]),
        pageNo: json["pageNo"],
        numOfRows: json["numOfRows"],
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "dataType": dataType,
        "items": items.toJson(),
        "pageNo": pageNo,
        "numOfRows": numOfRows,
        "totalCount": totalCount,
      };
}

class Items {
  Items({
    required this.item,
  });

  List<Item> item;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        item: List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "item": List<dynamic>.from(item.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.baseDate,
    required this.baseTime,
    required this.category,
    required this.nx,
    required this.ny,
    required this.obsrValue,
  });

  String baseDate;
  String baseTime;
  String category;
  int nx;
  int ny;
  String obsrValue;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        baseDate: json["baseDate"],
        baseTime: json["baseTime"],
        category: json["category"],
        nx: json["nx"],
        ny: json["ny"],
        obsrValue: json["obsrValue"],
      );

  Map<String, dynamic> toJson() => {
        "baseDate": baseDate,
        "baseTime": baseTime,
        "category": category,
        "nx": nx,
        "ny": ny,
        "obsrValue": obsrValue,
      };
}

class Header {
  Header({
    required this.resultCode,
    required this.resultMsg,
  });

  String resultCode;
  String resultMsg;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        resultCode: json["resultCode"],
        resultMsg: json["resultMsg"],
      );

  Map<String, dynamic> toJson() => {
        "resultCode": resultCode,
        "resultMsg": resultMsg,
      };
}
