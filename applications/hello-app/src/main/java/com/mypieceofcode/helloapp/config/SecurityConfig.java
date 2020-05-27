package com.mypieceofcode.helloapp.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests((requests) ->
                requests.antMatchers("/api/hello").permitAll()
                .anyRequest().authenticated());
        http.oauth2Login(Customizer.withDefaults());
        http.oauth2Client();
    }
}