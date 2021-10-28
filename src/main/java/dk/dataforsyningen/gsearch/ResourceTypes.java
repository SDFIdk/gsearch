package dk.dataforsyningen.gsearch;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ResourceTypes {

    private Set<String> types = ConcurrentHashMap.newKeySet();

    public Set<String> getTypes() {
        return types;
    }
}