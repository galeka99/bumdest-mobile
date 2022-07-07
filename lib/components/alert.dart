import 'package:flutter/material.dart';

// enum AlertType { error, info, success, warning }

class Alert extends SnackBar {
  final String? text;
  final bool isError;

  Alert(this.text, {this.isError = false})
      : super(
          backgroundColor:
              isError ? Colors.red[800] : Colors.green[800],
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                isError ? Icons.error : Icons.info,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: Text(
                  text ?? '',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
}
