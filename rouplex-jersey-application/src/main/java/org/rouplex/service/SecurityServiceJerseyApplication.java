package org.rouplex.service;

import org.glassfish.hk2.utilities.binding.AbstractBinder;
import org.glassfish.jersey.process.internal.RequestScoped;
import org.rouplex.service.securityservice.SecurityServiceJerseyResource;
import org.rouplex.service.securityservice.SecurityServiceServer;
import org.rouplex.service.securityservice.SecurityServiceServerFactory;

import javax.servlet.ServletContext;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Context;
import java.util.Arrays;

@ApplicationPath(SecurityServiceJerseyApplication.APP_PATH)
public class SecurityServiceJerseyApplication extends RouplexJerseyApplication {
    public SecurityServiceJerseyApplication(@Context ServletContext servletContext) {
        super(servletContext, Arrays.asList(SecurityServiceJerseyResource.class));

        register(new AbstractBinder() {
            @Override
            protected void configure() {
                bindFactory(SecurityServiceServerFactory.class).to(SecurityServiceServer.class).in(RequestScoped.class);
            }
        });
    }
}
