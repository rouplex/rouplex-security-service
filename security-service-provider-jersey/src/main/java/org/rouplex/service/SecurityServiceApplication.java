package org.rouplex.service;

import org.rouplex.platform.jersey.RouplexApplication;
import org.rouplex.service.securityservice.SecurityServiceResource;

import javax.servlet.ServletContext;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Context;

/**
 * This is the webapp, or the main jersey {@link javax.ws.rs.core.Application} which binds all the jersey resources.
 * The container searches for the {@link ApplicationPath} annotation and instantiates an instance of this class. It is
 * only in the constructor that we can bind (or add) resources to it, the jersey API does not allow for anything else.
 */
@ApplicationPath("/rouplex")
public class SecurityServiceApplication extends RouplexApplication {

    public SecurityServiceApplication(@Context ServletContext servletContext) {
        super(servletContext);

        bindResource(SecurityServiceResource.class, true);
    }
}
