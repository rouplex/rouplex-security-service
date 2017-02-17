package org.rouplex.service.securityservice;

import org.rouplex.platform.jaxrs.security.RouplexSecurityContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

public class SecurityServiceServer implements SecurityService {
    HttpServletRequest httpServletRequest;
    RouplexSecurityContext rouplexSecurityContext;
    HttpServletResponse httpServletResponse;

    public SecurityServiceServer(HttpServletRequest httpServletRequest,
            RouplexSecurityContext rouplexSecurityContext, HttpServletResponse httpServletResponse) {
        this.httpServletRequest = httpServletRequest;
        this.rouplexSecurityContext = rouplexSecurityContext;
        this.httpServletResponse = httpServletResponse;
    }

    public PingResponse ping() {
        return buildHttpRequestResponse(null);
    }

    public PingResponse ping(String payload) {
        return buildHttpRequestResponse(payload);
    }

    private PingResponse buildHttpRequestResponse(String payload) {
        PingResponse pingResponse = new PingResponse();
        pingResponse.setHttpRequest(buildHttpRequest(payload));
        pingResponse.setSecurityContext(buildSecurityContext());
        pingResponse.setHttpResponse(buildHttpResponse());

        return pingResponse;
    }

    private HttpRequest buildHttpRequest(String payload) {
        HttpRequest result = new HttpRequest();

        result.setAuthType(httpServletRequest.getAuthType());

        SortedMap<String, List<String>> headers = new TreeMap<>();
        for (Enumeration<String> headerNames = httpServletRequest.getHeaderNames(); headerNames.hasMoreElements();) {
            String headerName = headerNames.nextElement();
            headers.put(headerName, Collections.list(httpServletRequest.getHeaders(headerName)));
        }

        result.setHeaders(headers);
        result.setMethod(httpServletRequest.getMethod());
        result.setPathInfo(httpServletRequest.getPathInfo());
        result.setPathTranslated(httpServletRequest.getPathTranslated());
        result.setContextPath(httpServletRequest.getContextPath());
        result.setQueryString(httpServletRequest.getQueryString());
        result.setRemoteUser(httpServletRequest.getRemoteUser());
        result.setUserPrincipal(buildPrincipal(httpServletRequest.getUserPrincipal()));
        result.setRequestedSessionId(httpServletRequest.getRequestedSessionId());
        result.setRequestURI(httpServletRequest.getRequestURI());
        result.setRequestURL(httpServletRequest.getRequestURL().toString());
        result.setServletPath(httpServletRequest.getServletPath());
        result.setRequestedSessionIdValid(httpServletRequest.isRequestedSessionIdValid());
        result.setRequestedSessionIdFromCookie(httpServletRequest.isRequestedSessionIdFromCookie());
        result.setRequestedSessionIdFromURL(httpServletRequest.isRequestedSessionIdFromURL());

        result.setPayload(payload);

        return result;
    }

    private HttpResponse buildHttpResponse() {
        HttpResponse result = new HttpResponse();

        result.setCharacterEncoding(httpServletResponse.getCharacterEncoding());
        result.setContentType(httpServletResponse.getContentType());
        result.setLocale(httpServletResponse.getLocale().toString());

        return result;
    }

    private SecurityContext buildSecurityContext() {
        SecurityContext result = new SecurityContext();

        result.setAuthenticated(rouplexSecurityContext.isAuthenticated());
        result.setAuthenticationScheme(rouplexSecurityContext.getAuthenticationScheme());
        result.setSecure(rouplexSecurityContext.isSecure());
        result.setUserPrincipal(buildPrincipal(rouplexSecurityContext.getUserPrincipal()));
        result.setUserX509Certificate(rouplexSecurityContext.getUserX509Certificate());

        return result;
    }

    private Principal buildPrincipal(java.security.Principal principal) {
        if (principal == null) {
            return null;
        }

        Principal result = new Principal();
        result.setName(principal.getName());
        return result;
    }
}