/*
 * JBoss, Home of Professional Open Source
 * Copyright 2014, Red Hat, Inc. and/or its affiliates, and individual
 * contributors by the @authors tag. See the copyright.txt in the
 * distribution for a full listing of individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jboss.aerogear.quickstarts.contacts.util;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.IOException;

/**
 * A @{link Filter} that supresses BASIC Authentication challenges to
 * prevent a browser from automatically displaying a dialog for entering
 * credentials.
 */
public class AccessDeniedFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (response instanceof HttpServletResponse) {
            HttpServletResponse httpServletResponse = (HttpServletResponse) response;
            chain.doFilter(request, new HttpServletResponseWrapper(httpServletResponse) {

                /**
                 * Set all headers except 'WWW-Authenticate' to suppress the basic auth challenge which
                 * will cause a browser to pop up a credentials entry dialog.
                 *
                 * @param name the HTTP header name.
                 * @param value the headers value to set.
                 */
                @Override
                public void setHeader(String name, String value) {
                    if (!isHttpBasicChallenge(name)) {
                        super.setHeader(name, value);
                    }
                }

                /**
                 * Will add any header except an 'Access-Control-Allow-Origin' for which this
                 * method will call {@link #setHeader(String, String)} as can only be one value
                 * for this header.
                 *
                 * @param name the HTTP header name.
                 * @param value the headers value to add.
                 */
                @Override
                public void addHeader(String name, String value) {
                    if (isAccessControlAllowOrigin(name) || isAccessControlAllowCredentials(name)) {
                        super.setHeader(name, value);
                    } else {
                        super.addHeader(name, value);
                    }
                }
            });
        } else {
            chain.doFilter(request, response);
        }
    }

    private static boolean isHttpBasicChallenge(String headerName) {
        return "WWW-Authenticate".equalsIgnoreCase(headerName);
    }

    private static boolean isAccessControlAllowOrigin(String headerName) {
        return "Access-Control-Allow-Origin".equalsIgnoreCase(headerName);
    }

    private static boolean isAccessControlAllowCredentials(String headerName) {
        return "Access-Control-Allow-Credentials".equalsIgnoreCase(headerName);
    }

    @Override
    public void destroy() {
    }

}
