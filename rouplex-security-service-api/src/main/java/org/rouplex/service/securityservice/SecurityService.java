package org.rouplex.service.securityservice;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;

@Path("/security")
public interface SecurityService {
    @GET
    @Path("/ping")
    PingResponse ping();

    @POST
    @Path("/ping")
    PingResponse ping(String payload);
}