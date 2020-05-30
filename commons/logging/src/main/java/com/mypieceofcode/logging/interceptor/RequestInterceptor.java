package com.mypieceofcode.logging.interceptor;

import com.mypieceofcode.logging.services.HeaderNameProvider;
import org.slf4j.MDC;
import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class RequestInterceptor implements ClientHttpRequestInterceptor {

    private final HeaderNameProvider headerNameProvider;

    public RequestInterceptor(HeaderNameProvider headerNameProvider) {
        this.headerNameProvider = headerNameProvider;
    }

    public ClientHttpResponse intercept(HttpRequest req, byte[] body, ClientHttpRequestExecution execution) throws IOException {
        req.getHeaders().add(headerNameProvider.getCorrelationName(), MDC.get(headerNameProvider.getCorrelationName()));
        req.getHeaders().add(headerNameProvider.getRequestIdName(), MDC.get(headerNameProvider.getRequestIdName()));
        return execution.execute(req, body);
    }
}
