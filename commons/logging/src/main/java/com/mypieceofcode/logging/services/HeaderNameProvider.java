package com.mypieceofcode.logging.services;

public interface HeaderNameProvider {
    String getCorrelationName();
    String getRequestIdName();
}
