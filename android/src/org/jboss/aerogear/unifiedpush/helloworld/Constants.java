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
package org.jboss.aerogear.unifiedpush.helloworld;

public interface Constants {

    /**
     * This is the URL of the UnifiedPush Server.
     *
     * For example (your IP/hostname will differ):
     * String UNIFIED_PUSH_URL = "http://192.168.1.157:8080/ag-push";
     *
     */
    String UNIFIED_PUSH_URL = "";

    /**
     * The variant id which was generated when registering the variant with
     * the UnifiedPush Server.
     */
    String VARIANT_ID = "";

    /**
     * The secret which was generated when registering the variant with
     * the UnifiedPush Server
     */
    String SECRET = "";

    /**
     * Is the project number given in Googles APIs Console.
     */
    String GCM_SENDER_ID = "";

}
