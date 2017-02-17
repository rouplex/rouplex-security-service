package org.rouplex.service;

import org.rouplex.platform.jersey.RouplexApplication;
import org.rouplex.service.securityservice.SecurityServiceResource;

import javax.servlet.ServletContext;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Context;

@ApplicationPath("/rouplex")
public class SecurityServiceApplication extends RouplexApplication {

    public SecurityServiceApplication(@Context ServletContext servletContext) {
        super(servletContext);

        bindResource(SecurityServiceResource.class, true);
    }
}
