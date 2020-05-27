package com.mypieceofcode.helloapp.api;

import com.mypieceofcode.helloapp.model.HelloResponse;

public interface HelloApi {
    HelloResponse getHello();
    HelloResponse protectedHello();
}
