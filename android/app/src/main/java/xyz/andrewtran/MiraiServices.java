package xyz.andrewtran;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import com.example.mirai_app.MainActivity;
import com.googlecode.tesseract.android.TessBaseAPI;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import fi.iki.elonen.NanoHTTPD;
import fi.iki.elonen.router.RouterNanoHTTPD;
import io.flutter.FlutterInjector;
import xyz.andrewtran.tf.BoxPosition;
import xyz.andrewtran.tf.PostProcessingOutcome;
import xyz.andrewtran.tf.Recognition;
import xyz.andrewtran.tf.TensorFlowImageRecognizer;

public class MiraiServices extends RouterNanoHTTPD {
    public static File nodeFilesDirectory;

    public static void startServer() {
        MiraiServices server = new MiraiServices();
        try {
            server.start();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Log.d("ANDREW-T3", "Mirai services started..");
    }

    public MiraiServices() {
        super(10200);
        addMappings();
    }

    @Override
    public void addMappings() {
        super.addMappings();
        addRoute("/perform_service", Handler.class);
    }

    public static class ResponseInfo {
        public String mimeType = "";
        public byte[] bytes;
        public Map<String, String> headers = new HashMap<>();

        public ResponseInfo(String mimeType, byte[] bytes) {
            this.mimeType = mimeType;
            this.bytes = bytes;
        }

        public static ResponseInfo fromText(String text) {
            return new ResponseInfo("text/plain", text.getBytes(StandardCharsets.UTF_8));
        }

        public static ResponseInfo fromHTML(String html) {
            return new ResponseInfo("text/html", html.getBytes(StandardCharsets.UTF_8));
        }

        public static ResponseInfo fromFile(File file) {
            return fromFile(file, "application/octet-stream");
        }

        public static ResponseInfo fromFile(File file, String mimeType) {
            return fromFile(file, mimeType, true);
        }

        public static ResponseInfo fromFile(File file, String mimeType, boolean putFileName) {
            try {
                ResponseInfo info = new ResponseInfo(mimeType, Files.readAllBytes(file.toPath()));
                if (putFileName) {
                    info.headers.put("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
                }
                return info;
            } catch (IOException e) {
                return fromHTML("Failed to read file to return.");
            }
        }
    }

    private static final int BUFFER_SIZE = (int) 1e7;

    public static void zip( List<File> files, File zipFile) throws IOException {
        final int BUFFER_SIZE = 2048;

        BufferedInputStream origin = null;
        ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(zipFile)));

        try {
            byte data[] = new byte[BUFFER_SIZE];

            for ( File file : files ) {
                FileInputStream fileInputStream = new FileInputStream( file );

                origin = new BufferedInputStream(fileInputStream, BUFFER_SIZE);

                String filePath = file.getAbsolutePath();

                try {
                    ZipEntry entry = new ZipEntry( filePath.substring( filePath.lastIndexOf("/") + 1 ) );

                    out.putNextEntry(entry);

                    int count;
                    while ((count = origin.read(data, 0, BUFFER_SIZE)) != -1) {
                        out.write(data, 0, count);
                    }
                }
                finally {
                    origin.close();
                }
            }
        }
        finally {
            out.close();
        }
    }

    public static File getOCRDataFolder() {
        File tessdata = new File(nodeFilesDirectory, "tessdata");
        if (!tessdata.exists()) {
            tessdata.mkdirs();
        }
        return tessdata;
    }

    public static File getOCRDataFile() {
        return new File(getOCRDataFolder(), "eng.traineddata");
    }

    private static void downloadUsingStream(String urlStr, String file) throws IOException{
        URL url = new URL(urlStr);
        BufferedInputStream bis = new BufferedInputStream(url.openStream());
        FileOutputStream fis = new FileOutputStream(file);
        byte[] buffer = new byte[1024];
        int count=0;
        while((count = bis.read(buffer,0,1024)) != -1)
        {
            fis.write(buffer, 0, count);
        }
        fis.close();
        bis.close();
    }

    public static void prepareOCR() {
        if (!getOCRDataFile().exists()) {
            try {
                downloadUsingStream("https://andrewtran.xyz/eng.traineddata", getOCRDataFile().getAbsolutePath());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static class Handler extends DefaultHandler {

        @Override
        public String getText() {
            return "not implemented";
        }

        public ResponseInfo getText(Map<String, String> urlParams, IHTTPSession session) {
//            String text = "<html><body>User handler. Method: " + session.getMethod().toString() + "<br>";
//            text += "<h1>Uri parameters:</h1>";
//            for (Map.Entry<String, String> entry : urlParams.entrySet()) {
//                String key = entry.getKey();
//                String value = entry.getValue();
//                text += "<div> Param: " + key + "&nbsp;Value: " + value + "</div>";
//            }
//            text += "<h1>Query parameters:</h1>";
//            for (Map.Entry<String, String> entry : session.getParms().entrySet()) {
//                String key = entry.getKey();
//                String value = entry.getValue();
//                text += "<div> Query Param: " + key + "&nbsp;Value: " + value + "</div>";
//            }
//            text += "</body></html>";
            String text = "";

            String file_id = session.getParms().get("file_id");
            String service = session.getParms().get("service");

            File directory = new File(MiraiServices.nodeFilesDirectory, file_id + "/");
            text += "directory: " + directory + "\n";
            text += "exists: " + directory.exists() + "\n";
            if (!directory.exists()) {
                return ResponseInfo.fromHTML("File does not exist on node.");
            }
            @SuppressWarnings("ConstantConditions") File file = directory.listFiles()[0];
            text += "file: " + file.getAbsolutePath() + "\n";


            ResponseInfo info;
            switch (Objects.requireNonNull(service)) {
                case "echo":
                    info = ResponseInfo.fromFile(file);
                    break;

                case "zip":
                    File zipFile = new File(file.getAbsolutePath() + ".zip");
                    if (zipFile.exists()) {
                        zipFile.delete();
                    }
                    try {
                        zip(Collections.singletonList(file), zipFile);
                        info = ResponseInfo.fromFile(zipFile);
                        zipFile.delete();
                    } catch (IOException e) {
                        return ResponseInfo.fromHTML("Failed to zip file");
                    }
                    break;

                case "ocr":
                    prepareOCR();
                    TessBaseAPI tessBaseApi = new TessBaseAPI();
                    tessBaseApi.init(nodeFilesDirectory.getAbsolutePath(), "eng");
                    tessBaseApi.setImage(file);
                    String extracted = tessBaseApi.getUTF8Text();
                    info = ResponseInfo.fromText(extracted);
                    tessBaseApi.end();
                    break;

                case "image_recognition":
//                    Bitmap croppedBitmap = Bitmap.createBitmap(INPUT_SIZE, INPUT_SIZE, Bitmap.Config.ARGB_8888);
//                    Matrix frameToCropTransform = ImageUtils.getTransformationMatrix(previewWidth, previewHeight,
//                            INPUT_SIZE, INPUT_SIZE, sensorOrientation, MAINTAIN_ASPECT);

                    Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());
                    bitmap = bitmap.copy(Bitmap.Config.ARGB_8888, true);
                    Log.d("ANDREW-4", "Width: " + bitmap.getWidth());
                    Log.d("ANDREW-4", "Height: " + bitmap.getHeight());

                    String path = "assets/tf/tiny-yolo-voc-labels.txt";
                    String assetLookupKey =  FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(path);
                    InputStream inputStream;
                    try {
                        inputStream = MainActivity.assets_real.open(assetLookupKey);
                    } catch (IOException e) {
                        e.printStackTrace();
                        return ResponseInfo.fromHTML("Failed to open labels.");
                    }

                    TensorFlowImageRecognizer recognizer = TensorFlowImageRecognizer.create(MainActivity.assets_real, inputStream);
                    PostProcessingOutcome outcome = recognizer.recognizeImage(bitmap);
                    String result = "";
                    for (Recognition recognition : outcome.getRecognitions()) {
                        String type = recognition.getTitle();
                        BoxPosition position = recognition.getLocation();
                        float confidence = recognition.getConfidence();
                        result += String.format(Locale.US, "%s at (%.2f,%.2f) for size %.2fx%.2f with confidence %.2f\n",
                                type, position.getLeft(), position.getTop(), position.getWidth(), position.getHeight(), confidence);
                    }
                    info = ResponseInfo.fromText("Result: " + result);
                    recognizer.close();
                    break;

                default:
                    return ResponseInfo.fromHTML("Unknown service.");
            }

            return info;
        }

        @Override
        public String getMimeType() {
            return "text/html";
        }

        @Override
        public Response.IStatus getStatus() {
            return Response.Status.OK;
        }

        public Response get(UriResource uriResource, Map<String, String> urlParams, IHTTPSession session) {
            ResponseInfo info = getText(urlParams, session);
            ByteArrayInputStream inp = new ByteArrayInputStream(info.bytes);
            int size = info.bytes.length;

            Response response = NanoHTTPD.newFixedLengthResponse(getStatus(), info.mimeType, inp, size);
            for (Map.Entry<String, String> entry : info.headers.entrySet()) {
                response.addHeader(entry.getKey(), entry.getValue());
            }

            return response;
        }
    }
}
