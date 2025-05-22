package dk.dataforsyningen.gsearch.mapper;

import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.io.ParseException;
import org.locationtech.jts.io.WKBReader;

/**
 * Taken from https://github.com/jdbi/jdbi/blob/master/postgis/src/main/java/org/jdbi/v3/postgis/PostgisCodec.java
 */
public class MapGeometryHelper {

  /**
   * Deserializes a geometry in the WKB format.
   *
   * @param bytes A byte array representing a {@link Geometry} in WKB format or null.
   * @return The deserialized object or null if the byte array was null.
   */
  public Geometry deserialize(byte[] bytes) {
    if (bytes == null) {
      return null;
    }
    try {
      WKBReader reader = new WKBReader(new GeometryFactory());
      return reader.read(bytes);
    } catch (ParseException e) {
      throw new IllegalArgumentException(e);
    }
  }

  public byte[] hexStringToByteArray(String s) {
    if (s == null) {
      return null;
    }
    int len = s.length();
    byte[] data = new byte[len / 2];
    for (int i = 0; i < len; i += 2) {
      data[i / 2] =
          (byte) ((Character.digit(s.charAt(i), 16) << 4) + Character.digit(s.charAt(i + 1), 16));
    }
    return data;
  }
}
