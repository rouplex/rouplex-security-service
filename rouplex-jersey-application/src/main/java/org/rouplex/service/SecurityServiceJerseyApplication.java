package org.rouplex.service;

import org.rouplex.service.securityservice.SecurityServiceJerseyResource;

import javax.servlet.ServletContext;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Context;

@ApplicationPath(SecurityServiceJerseyApplication.APP_PATH)
public class SecurityServiceJerseyApplication extends RouplexJerseyApplication {

    public SecurityServiceJerseyApplication(@Context ServletContext servletContext) {
        super(servletContext);

        registerRouplexResource(SecurityServiceJerseyResource.class, true);
    }
}
