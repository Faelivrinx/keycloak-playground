package com.mypieceofcode.helloapp.api.impl;

import com.mypieceofcode.helloapp.api.HelloApi;
import com.mypieceofcode.helloapp.model.HelloResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/hello")
public class HelloController implements HelloApi {

    @Override
    @GetMapping
    public HelloResponse getHello() {
        return new HelloResponse("Hello from unprotected HelloApp", 200);
    }

    @Override
    @GetMapping("/protected")
    public HelloResponse protectedHello() {
        return new HelloResponse("Hello form protected HelloApp", 200);

    }


}
