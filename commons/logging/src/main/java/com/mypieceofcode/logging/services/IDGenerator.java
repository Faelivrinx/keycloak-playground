package com.mypieceofcode.logging.services;

import javax.servlet.http.HttpServletRequest;

public interface IDGenerator {
    void setToCurrentThread(HttpServletRequest request);
}
