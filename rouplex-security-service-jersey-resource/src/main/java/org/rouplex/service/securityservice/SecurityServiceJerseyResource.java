package org.rouplex.service.securityservice;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.glassfish.jersey.server.ResourceConfig;
import org.rouplex.platform.jaxrs.security.RouplexSecurityContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.Context;

@Api(value = "/security", description = "SecurityService resource")
public class SecurityServiceJerseyResource extends ResourceConfig implements SecurityService {
    @Context
    HttpServletRequest httpServletRequest;
    @Context
    RouplexSecurityContext rouplexSecurityContext;
    @Context
    HttpServletResponse httpServletResponse;

    @ApiOperation(value = "Responds back with PingResponse, providing routing and plexing info")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success"),
            @ApiResponse(code = 404, message = "Not found") })
    public PingResponse ping() {
        return getSecurityServiceServer().ping();
    }

    @ApiOperation(value = "Responds back with PingResponse, providing routing and plexing info")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success"),
            @ApiResponse(code = 400, message = "Invalid request"),
            @ApiResponse(code = 404, message = "Not found") })
    public PingResponse ping(String payload) {
        return getSecurityServiceServer().ping(payload);
    }

    private SecurityServiceServer getSecurityServiceServer() {
        return new SecurityServiceServer(httpServletRequest, rouplexSecurityContext, httpServletResponse);
    }
}