package org.rouplex.service;

import org.rouplex.service.securityservice.JerseySecurityServiceServer;

import javax.servlet.ServletContext;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Context;
import java.util.Arrays;

@ApplicationPath(JerseyRouplexApplication.APP_PATH)
public class JerseyRouplexApplication extends RouplexResourceConfig {
    public JerseyRouplexApplication(@Context ServletContext servletContext) {
        super(servletContext, Arrays.asList(JerseySecurityServiceServer.class));
    }
}
