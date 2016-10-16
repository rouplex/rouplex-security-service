package org.rouplex.service.securityservice;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import org.glassfish.jersey.server.ResourceConfig;

import javax.ws.rs.core.Context;

@Api(value = "/security", description = "SecurityService resource")
public class SecurityServiceJerseyResource extends ResourceConfig implements SecurityService {
    @Context
    SecurityServiceServer securityServiceServer;

    @ApiOperation(value = "Responds back with PingResponse, providing routing and plexing info")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success"),
            @ApiResponse(code = 404, message = "Not found") })
    public PingResponse ping() {
        return securityServiceServer.ping();
    }

    @ApiOperation(value = "Responds back with PingResponse, providing routing and plexing info")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success"),
            @ApiResponse(code = 400, message = "Invalid request"),
            @ApiResponse(code = 404, message = "Not found") })
    public PingResponse ping(String payload) {
        return securityServiceServer.ping(payload);
    }
}