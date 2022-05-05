package dk.dataforsyningen.gsearch;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Container for the types of functions and data available from the data source
 * <p>
 * NOTE: is based on ConcurrentHashMap to allow it to be updated out of band
 */
public class ResourceTypes {

    private Set<String> types = ConcurrentHashMap.newKeySet();

    public Set<String> getTypes() {
        return types;
    }
}