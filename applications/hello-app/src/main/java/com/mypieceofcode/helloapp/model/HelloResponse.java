package com.mypieceofcode.helloapp.model;

import lombok.Data;

@Data
public class HelloResponse {
    private final String message;
    private final int code;
}
