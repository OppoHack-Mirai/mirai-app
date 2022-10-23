package xyz.andrewtran.tf;

import android.content.res.AssetManager;
import android.graphics.Color;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.loader.FlutterLoader;
import xyz.andrewtran.tf.Config;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Vector;

/**
 * It is used to read names of the classes from the specified resource.
 * It also specifies a color for each classes.
 *
 * Created by Zoltan Szabo on 12/17/17.
 * URL: https://github.com/szaza/android-yolo-v2
 */

public final class ClassAttrProvider {
    private final Vector<String> labels = new Vector();
    private final Vector<Integer> colors = new Vector();
    private static ClassAttrProvider instance;

    private ClassAttrProvider(final InputStream labelInputStream) {
        init(labelInputStream);
    }

    public static ClassAttrProvider newInstance(final InputStream labelInputStream) {
        if (instance == null) {
            instance = new ClassAttrProvider(labelInputStream);
        }

        return instance;
    }

    private void init(final InputStream labelInputStream) {
        try (BufferedReader br = new BufferedReader(new InputStreamReader(labelInputStream))) {
            String line;
            while ((line = br.readLine()) != null) {
                labels.add(line);
                colors.add(convertClassNameToColor(line));
            }
        } catch (IOException ex) {
            throw new RuntimeException("Problem reading label file!", ex);
        }
    }

    private int convertClassNameToColor(String className) {
        byte[] rgb = new byte[3];
        byte[] name = className.getBytes();

        for (int i=0; i<name.length; i++) {
            rgb[i%3] += name[i];
        }

        // Hue saturation
        for (int i=0; i<rgb.length; i++) {
            if (rgb[i] < 120) {
                rgb[i] += 120;
            }
        }

        return Color.rgb(rgb[0], rgb[1], rgb[2]);
    }

    public Vector<String> getLabels() {
        return labels;
    }

    public Vector<Integer> getColors() {
        return colors;
    }
}