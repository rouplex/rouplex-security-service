package org.rouplex.service;

import org.rouplex.platform.jersey.RouplexApplication;
import org.rouplex.service.securityservice.SecurityServiceJerseyResource;

import javax.servlet.ServletContext;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Context;

@ApplicationPath("/rouplex")
public class SecurityServiceJerseyApplication extends RouplexApplication {

    public SecurityServiceJerseyApplication(@Context ServletContext servletContext) {
        super(servletContext);

        bindResource(SecurityServiceJerseyResource.class, true);
    }
}
