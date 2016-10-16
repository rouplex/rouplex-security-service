package org.rouplex.service.securityservice;

import org.glassfish.hk2.api.Factory;
import org.rouplex.jaxrs.security.RouplexSecurityContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.Context;

/**
 * @author Andi Mullaraj (andimullaraj at gmail.com)
 */
public class SecurityServiceServerFactory implements Factory<SecurityServiceServer> {
    @Context
    HttpServletRequest httpServletRequest;
    @Context
    RouplexSecurityContext rouplexSecurityContext;
    @Context
    HttpServletResponse httpServletResponse;

    @Override
    public SecurityServiceServer provide() {
        return new SecurityServiceServer(httpServletRequest, rouplexSecurityContext, httpServletResponse);
    }

    @Override
    public void dispose(SecurityServiceServer securityServiceServer) {
    }
}
