package xyz.andrewtran.tf;

import android.content.res.AssetManager;
import android.graphics.Bitmap;

import org.tensorflow.contrib.android.TensorFlowInferenceInterface;
import xyz.andrewtran.tf.PostProcessingOutcome;
import xyz.andrewtran.tf.ClassAttrProvider;

import java.io.IOException;
import java.io.InputStream;
import java.util.Vector;

import static xyz.andrewtran.tf.Config.IMAGE_MEAN;
import static xyz.andrewtran.tf.Config.IMAGE_STD;
import static xyz.andrewtran.tf.Config.INPUT_NAME;
import static xyz.andrewtran.tf.Config.INPUT_SIZE;
import static xyz.andrewtran.tf.Config.MODEL_FILE;
import static xyz.andrewtran.tf.Config.OUTPUT_NAME;

/**
 * A classifier specialized to label images using TensorFlow.
 * Modified by Zoltan Szabo
 */
public class TensorFlowImageRecognizer {
    private int outputSize;
    private Vector<String> labels;
    private TensorFlowInferenceInterface inferenceInterface;

    private TensorFlowImageRecognizer() {
    }

    /**
     * Initializes a native TensorFlow session for classifying images.
     *
     * @param assetManager The asset manager to be used to load assets.
     * @throws IOException
     */
    public static TensorFlowImageRecognizer create(AssetManager assetManager, InputStream labelInputStream) {
        TensorFlowImageRecognizer recognizer = new TensorFlowImageRecognizer();
        recognizer.labels = ClassAttrProvider.newInstance(labelInputStream).getLabels();
        recognizer.inferenceInterface = new TensorFlowInferenceInterface(assetManager,
                "file:///android_asset/flutter_assets/assets/tf/" + MODEL_FILE);
        recognizer.outputSize = YOLOClassifier.getInstance()
                .getOutputSizeByShape(recognizer.inferenceInterface.graphOperation(OUTPUT_NAME));
        return recognizer;
    }

    public PostProcessingOutcome recognizeImage(final Bitmap bitmap) {
        return YOLOClassifier.getInstance().classifyImage(runTensorFlow(bitmap), labels);
    }

    public String getStatString() {
        return inferenceInterface.getStatString();
    }

    public void close() {
        inferenceInterface.close();
    }

    private float[] runTensorFlow(final Bitmap bitmap) {
        final float[] tfOutput = new float[outputSize];
        // Copy the input data into TensorFlow.
        inferenceInterface.feed(INPUT_NAME, processBitmap(bitmap), 1, INPUT_SIZE, INPUT_SIZE, 3);

        // Run the inference call.
        inferenceInterface.run(new String[]{OUTPUT_NAME});

        // Copy the output Tensor back into the output array.
        inferenceInterface.fetch(OUTPUT_NAME, tfOutput);

        return tfOutput;
    }

    /**
     * Preprocess the image data from 0-255 int to normalized float based
     * on the provided parameters.
     *
     * @param bitmap
     */
    private float[] processBitmap(final Bitmap bitmap) {
        int[] intValues = new int[INPUT_SIZE * INPUT_SIZE];
        float[] floatValues = new float[INPUT_SIZE * INPUT_SIZE * 3];

        bitmap.getPixels(intValues, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight());
        for (int i = 0; i < intValues.length; ++i) {
            final int val = intValues[i];
            floatValues[i * 3 + 0] = (((val >> 16) & 0xFF) - IMAGE_MEAN) / IMAGE_STD;
            floatValues[i * 3 + 1] = (((val >> 8) & 0xFF) - IMAGE_MEAN) / IMAGE_STD;
            floatValues[i * 3 + 2] = ((val & 0xFF) - IMAGE_MEAN) / IMAGE_STD;
        }
        return floatValues;
    }
}