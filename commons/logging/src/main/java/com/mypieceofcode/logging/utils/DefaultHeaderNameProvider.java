package com.mypieceofcode.logging.utils;

import com.mypieceofcode.logging.services.HeaderNameProvider;

public class DefaultHeaderNameProvider implements HeaderNameProvider {

    @Override
    public String getCorrelationName() {
        return "X-Correlation-ID";
    }

    @Override
    public String getRequestIdName() {
        return "X-Request-ID";
    }
}
