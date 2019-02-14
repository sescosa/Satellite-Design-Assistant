package com.backend.util;

import java.io.Serializable;

public class Pair implements Serializable
{
    private String entityName;
    private String value;
    
    public Pair(String entity, String aValue)
    {
        entityName   = entity;
        value = aValue;
    }
    
    public String entityName()   { return entityName; }
    public String value() { return value; }
}