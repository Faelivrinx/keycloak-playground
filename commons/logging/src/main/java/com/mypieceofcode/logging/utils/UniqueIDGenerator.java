package com.mypieceofcode.logging.utils;

import com.mypieceofcode.logging.services.HeaderNameProvider;
import com.mypieceofcode.logging.services.IDGenerator;
import org.slf4j.MDC;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.UUID;

@Service
public class UniqueIDGenerator implements IDGenerator {

    private final HeaderNameProvider provider;


    public UniqueIDGenerator(HeaderNameProvider provider) {
        this.provider = provider;
    }

    @Override
    public void setToCurrentThread(HttpServletRequest request) {
        MDC.clear();
        String requestId = request.getHeader(provider.getRequestIdName());
        if (requestId == null)
            requestId = UUID.randomUUID().toString();
        MDC.put(provider.getRequestIdName(), requestId);

        String correlationId = request.getHeader(provider.getCorrelationName());
        if (correlationId == null)
            correlationId = UUID.randomUUID().toString();
        MDC.put(provider.getCorrelationName(), correlationId);
    }
}
