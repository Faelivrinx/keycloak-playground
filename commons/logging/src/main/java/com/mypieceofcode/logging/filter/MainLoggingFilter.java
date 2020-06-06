package com.mypieceofcode.logging.filter;

import com.mypieceofcode.logging.services.IDGenerator;
import com.mypieceofcode.logging.wrapper.SpringRequestWrapper;
import com.mypieceofcode.logging.wrapper.SpringResponseWrapper;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.core.annotation.Order;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerExecutionChain;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.Objects;

import static net.logstash.logback.argument.StructuredArguments.value;

@Order(value = 0)
public class MainLoggingFilter extends OncePerRequestFilter {

    private static final Logger LOGGER = LoggerFactory.getLogger(MainLoggingFilter.class);

    private String ignorePatterns;
    private boolean logHeaders;

    @Autowired IDGenerator generator;
    @Autowired ApplicationContext context;

    public MainLoggingFilter(String ignorePatterns, boolean logHeaders) {
        this.ignorePatterns = ignorePatterns;
        this.logHeaders = logHeaders;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain) throws ServletException, IOException {
        if (ignorePatterns != null && request.getRequestURI().matches(ignorePatterns)) {
            chain.doFilter(request, response);
        } else {
            generator.setToCurrentThread(request);
            try {
                getHandlerMethod(request);
            } catch (Exception e){
                LOGGER.trace("Cannot get handler method");
            }

            final long startTime = System.currentTimeMillis();
            final SpringRequestWrapper wrappedRequest = new SpringRequestWrapper(request);
            if(logHeaders){
                LOGGER.info("Request: method={}, uri={}, payload={}, headers={}, audit={}", wrappedRequest.getMethod(),
                        wrappedRequest.getRequestURI(), IOUtils.toString(wrappedRequest.getInputStream(),
                                wrappedRequest.getCharacterEncoding()), wrappedRequest.getAllHeaders(), value("audit", true));
            } else {
                LOGGER.info("Request: method={}, uri={}, payload={}, audit={}", wrappedRequest.getMethod(),
                        wrappedRequest.getRequestURI(), IOUtils.toString(wrappedRequest.getInputStream(),
                                wrappedRequest.getCharacterEncoding()), value("audit", true));
            }
            final SpringResponseWrapper wrappedResponse = new SpringResponseWrapper(response);
            wrappedResponse.setHeader("X-Request-ID", MDC.get("X-Request-ID"));
            wrappedResponse.setHeader("X-Correlation-ID", MDC.get("X-Correlation-ID"));

            try {
                chain.doFilter(wrappedRequest, wrappedResponse);
            } catch (Exception e) {
                logResponse(startTime, wrappedResponse, 500);
                throw e;
            }
            logResponse(startTime, wrappedResponse, wrappedResponse.getStatus());
        }
    }

    private void logResponse(long startTime, SpringResponseWrapper wrappedResponse, int overriddenStatus) throws IOException {
        final long duration = System.currentTimeMillis() - startTime;
        wrappedResponse.setCharacterEncoding("UTF-8");
        if (logHeaders)
            LOGGER.info("Response({} ms): status={}, payload={}, headers={}, audit={}", value("X-Response-Time", duration),
                    value("X-Response-Status", overriddenStatus), IOUtils.toString(wrappedResponse.getContentAsByteArray(),
                            wrappedResponse.getCharacterEncoding()), wrappedResponse.getAllHeaders(), value("audit", true));
        else
            LOGGER.info("Response({} ms): status={}, payload={}, audit={}", value("X-Response-Time", duration),
                    value("X-Response-Status", overriddenStatus),
                    IOUtils.toString(wrappedResponse.getContentAsByteArray(), wrappedResponse.getCharacterEncoding()), value("audit", true));
    }

    private void getHandlerMethod(HttpServletRequest request) throws Exception {
        RequestMappingHandlerMapping mappings1 = (RequestMappingHandlerMapping) context.getBean("requestMappingHandlerMapping");
        HandlerExecutionChain handler = mappings1.getHandler(request);
        if (Objects.nonNull(handler)) {
            HandlerMethod handler1 = (HandlerMethod) handler.getHandler();
            MDC.put("X-Operation-Name", handler1.getBeanType().getSimpleName() + "." + handler1.getMethod().getName());
        }
    }
}
