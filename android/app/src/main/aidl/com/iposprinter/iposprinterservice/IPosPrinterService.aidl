package com.iposprinter.iposprinterservice;
import  com.iposprinter.iposprinterservice.IPosPrinterCallback;
import  android.graphics.Bitmap;

interface IPosPrinterService {

    int getPrinterStatus();

    void printerInit(in IPosPrinterCallback callback);

    void setPrinterPrintDepth(int depth,in IPosPrinterCallback callback);

    void setPrinterPrintFontType(String typeface,in IPosPrinterCallback callback);

    void setPrinterPrintFontSize(int fontsize,in IPosPrinterCallback callback);

    void setPrinterPrintAlignment(int alignment, in IPosPrinterCallback callback);

    void printerFeedLines(int lines,in IPosPrinterCallback callback);

    void printBlankLines(int lines,int height,in IPosPrinterCallback callback);

    void printText(String text, in IPosPrinterCallback callback);

    void printSpecifiedTypeText(String text, String typeface,int fontsize,in IPosPrinterCallback callback);

    void PrintSpecFormatText(String text, String typeface, int fontsize, int alignment, IPosPrinterCallback callback);

	void printColumnsText(in String[] colsTextArr, in int[] colsWidthArr, in int[] colsAlign,int isContinuousPrint, in IPosPrinterCallback callback);

    void printBitmap(int alignment, int bitmapSize, in Bitmap mBitmap, in IPosPrinterCallback callback);

	void printBarCode(String data, int symbology, int height, int width, int textposition,  in IPosPrinterCallback callback);

	void printQRCode(String data, int modulesize, int mErrorCorrectionLevel, in IPosPrinterCallback callback);

	void printRawData(in byte[] rawPrintData, in IPosPrinterCallback callback);

	void sendUserCMDData(in byte[] data, in IPosPrinterCallback callback);

	void printerPerformPrint(int feedlines, in IPosPrinterCallback callback);
}
