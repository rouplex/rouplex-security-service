package org.rouplex.service.securityservice;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.glassfish.jersey.server.ResourceConfig;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.SecurityContext;
import java.util.*;

@Api(value = "/security", description = "SecurityService resource")
public class JerseySecurityServiceServer extends ResourceConfig implements SecurityService {
    @Context HttpServletRequest httpServletRequest;
    @Context HttpServletResponse httpServletResponse;
    @Context SecurityContext securityContext;

    @ApiOperation(value = "Responds back with HttpRequestResponse, providing routing and plexing info")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success"),
            @ApiResponse(code = 404, message = "Not found") })
    public HttpRequestResponse ping() {
        return buildHttpRequestResponse(null);
    }

    @ApiOperation(value = "Responds back with HttpRequestResponse, providing routing and plexing info")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success"),
            @ApiResponse(code = 400, message = "Invalid request"),
            @ApiResponse(code = 404, message = "Not found") })
    public HttpRequestResponse ping(String payload) {
        return buildHttpRequestResponse(payload);
    }

    private HttpRequestResponse buildHttpRequestResponse(String payload) {
        HttpRequestResponse httpRequestResponse = new HttpRequestResponse();
        httpRequestResponse.setHttpRequest(buildHttpRequest(httpServletRequest, payload));
        httpRequestResponse.setHttpResponse(buildHttpResponse(httpServletResponse));
        return httpRequestResponse;
    }

    private HttpRequest buildHttpRequest(HttpServletRequest httpServletRequest, String payload) {
        HttpRequest result = new HttpRequest();

        result.setAuthType(httpServletRequest.getAuthType());

        SortedMap<String, List<String>> headers = new TreeMap();
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

    private HttpResponse buildHttpResponse(HttpServletResponse httpServletResponse) {
        HttpResponse result = new HttpResponse();

        result.setCharacterEncoding(httpServletResponse.getCharacterEncoding());
        result.setContentType(httpServletResponse.getContentType());
        result.setLocale(httpServletResponse.getLocale().toString());

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