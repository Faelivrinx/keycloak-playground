## Description

This folder stores applications which use keycloak as SSO system. 

## Spring Boot OIDC Security
To integrate spring boot app with Keycloak you have to import some important dependecy to project. 
```xml
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-oauth2-client</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-oauth2-jose</artifactId>
        </dependency>
```
They enable integration with spring boot security without any additional adapters. After import you will able to configure application properties with you keycloak client. 
```yml
keycloak-client:
  server-url: http://<your domain:port>/auth
  realm: <your realm>
spring:
  security:
    oauth2:
      client:
        registration:
          keycloak:
            client-id: <your client id>
            client-secret: <your client secret>
            client-name: <some client name>
            authorization-grant-type: authorization_code
            redirect-uri: '{baseUrl}/login/oauth2/code/{registrationId}'
            scope:
              - openid
              - profile
              - email
        provider:
          keycloak:
            token-uri: ${keycloak-client.server-url}/realms/${keycloak-client.realm}/protocol/openid-connect/token
            authorization-uri: ${keycloak-client.server-url}/realms/${keycloak-client.realm}/protocol/openid-connect/auth
            user-info-uri: ${keycloak-client.server-url}/realms/${keycloak-client.realm}/protocol/openid-connect/userinfo
            jwk-set-uri: ${keycloak-client.server-url}/realms/${keycloak-client.realm}/protocol/openid-connect/certs
            user-name-attribute: preferred_username

```

And that's it! Thanks to spring autoconfiguration all your resources will be protected by default! For example take a look at ```OAuth2WebSecurityConfiguration``` where is ```WebSecurityConfigurerAdapter```
To override you only have to add your custom configuration.
```java
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
```
