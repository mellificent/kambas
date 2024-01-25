package com.kambas.pos.kambas;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.icu.text.DateFormat;
import android.icu.text.SimpleDateFormat;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Message;
import android.os.RemoteException;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.kambas.pos.kambas.Utils.HandlerUtils;

import java.util.Calendar;
import java.util.Locale;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.iposprinter.iposprinterservice.*;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.methodchannel/test";
    private static final String METHOD = "printKambasReceipt";
    private static final String p_ticketNumber = "ticket_number";
    private static final String p_betNumber = "bet_number";
    private static final String p_stallName = "stall_name";
    private static final String p_drawSchedule = "draw_sched";
    private static final String p_betAmount = "bet_amount";
    private static final String p_priceAmount = "price_amount";

    private static final String p_initialDate = "initial_date";
    private static final String p_processedDate = "processed_date";

    /**printer status**/
    private final int PRINTER_NORMAL = 0;
    private final int PRINTER_PAPERLESS = 1;
    private final int PRINTER_THP_HIGH_TEMPERATURE = 2;
    private final int PRINTER_MOTOR_HIGH_TEMPERATURE = 3;
    private final int PRINTER_IS_BUSY = 4;
    private final int PRINTER_ERROR_UNKNOWN = 5;
    private int printerStatus = 0;

    /**status broadcasts**/
    private final String  PRINTER_NORMAL_ACTION = "com.iposprinter.iposprinterservice.NORMAL_ACTION";
    private final String  PRINTER_PAPERLESS_ACTION = "com.iposprinter.iposprinterservice.PAPERLESS_ACTION";
    private final String  PRINTER_PAPEREXISTS_ACTION = "com.iposprinter.iposprinterservice.PAPEREXISTS_ACTION";
    private final String  PRINTER_THP_HIGHTEMP_ACTION = "com.iposprinter.iposprinterservice.THP_HIGHTEMP_ACTION";
    private final String  PRINTER_THP_NORMALTEMP_ACTION = "com.iposprinter.iposprinterservice.THP_NORMALTEMP_ACTION";
    private final String  PRINTER_MOTOR_HIGHTEMP_ACTION = "com.iposprinter.iposprinterservice.MOTOR_HIGHTEMP_ACTION";
    private final String  PRINTER_BUSY_ACTION = "com.iposprinter.iposprinterservice.BUSY_ACTION";
    private final String  PRINTER_CURRENT_TASK_PRINT_COMPLETE_ACTION = "com.iposprinter.iposprinterservice.CURRENT_TASK_PRINT_COMPLETE_ACTION";

    /**messages**/
    private final int MSG_TEST                               = 1;
    private final int MSG_IS_NORMAL                          = 2;
    private final int MSG_IS_BUSY                            = 3;
    private final int MSG_PAPER_LESS                         = 4;
    private final int MSG_PAPER_EXISTS                       = 5;
    private final int MSG_THP_HIGH_TEMP                      = 6;
    private final int MSG_THP_TEMP_NORMAL                    = 7;
    private final int MSG_MOTOR_HIGH_TEMP                    = 8;
    private final int MSG_MOTOR_HIGH_TEMP_INIT_PRINTER       = 9;
    private final int MSG_CURRENT_TASK_PRINT_COMPLETE     = 10;

    /**print type**/
    private final int  MULTI_THREAD_LOOP_PRINT  = 1;
    private final int  INPUT_CONTENT_LOOP_PRINT = 2;
    private final int  DEMO_LOOP_PRINT          = 3;
    private final int  PRINT_DRIVER_ERROR_TEST  = 4;
    private final int  DEFAULT_LOOP_PRINT       = 0;

    /**printing of flags**/
    private       int  loopPrintFlag            = DEFAULT_LOOP_PRINT;
    private       byte loopContent              = 0x00;
    private       int  printDriverTestCount     = 0;


    private IPosPrinterService mIPosPrinterService;
    private HandlerUtils.MyHandler handler;
    private IPosPrinterCallback callback = null;

    private HandlerUtils.IHandlerIntent iHandlerIntent = new HandlerUtils.IHandlerIntent()
    {
        @Override
        public void handlerIntent(Message msg)
        {
            switch (msg.what)
            {
                case MSG_TEST:
                    break;
                case MSG_IS_NORMAL:
                    if(getPrinterStatus() == PRINTER_NORMAL)
                    {
//                        loopPrint(loopPrintFlag);
                    }
                    break;
                case MSG_IS_BUSY:
                    Toast.makeText(MainActivity.this, "printer is busy/working", Toast.LENGTH_SHORT).show();
                    break;
                case MSG_PAPER_LESS:
                    loopPrintFlag = DEFAULT_LOOP_PRINT;
                    Toast.makeText(MainActivity.this, "Out of paper", Toast.LENGTH_SHORT).show();
                    break;
                case MSG_PAPER_EXISTS:
                    Toast.makeText(MainActivity.this, "paper exist", Toast.LENGTH_SHORT).show();
                    break;
                case MSG_THP_HIGH_TEMP:
                    Toast.makeText(MainActivity.this, "printer high temp", Toast.LENGTH_SHORT).show();
                    break;
                case MSG_MOTOR_HIGH_TEMP:
                    loopPrintFlag = DEFAULT_LOOP_PRINT;
                    Toast.makeText(MainActivity.this, "printer motor high temp", Toast.LENGTH_SHORT).show();
                    handler.sendEmptyMessageDelayed(MSG_MOTOR_HIGH_TEMP_INIT_PRINTER, 180000);  //马达高温报警，等待3分钟后复位打印机
                    break;
                case MSG_MOTOR_HIGH_TEMP_INIT_PRINTER:
                    printerInit();
                    break;
                case MSG_CURRENT_TASK_PRINT_COMPLETE:
                    Toast.makeText(MainActivity.this, "printer_current_task_print_complete", Toast.LENGTH_SHORT).show();
                    break;
                default:
                    break;
            }
        }
    };


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_ipos_printer_test_demo);
//        //设置屏幕一直亮着，不进入休眠状态
//        getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        handler = new HandlerUtils.MyHandler(iHandlerIntent);
//        innitView();
        callback = new IPosPrinterCallback.Stub() {

            @Override
            public void onRunResult(final boolean isSuccess) throws RemoteException {
                Log.i(CHANNEL,"result:" + isSuccess + "\n");
            }

            @Override
            public void onReturnString(final String value) throws RemoteException {
                Log.i(CHANNEL,"result:" + value + "\n");
            }
        };

        //绑定服务
        Intent intent=new Intent();
        intent.setPackage("com.iposprinter.iposprinterservice");
        intent.setAction("com.iposprinter.iposprinterservice.IPosPrintService");
        //startService(intent);
        bindService(intent, connectService, Context.BIND_AUTO_CREATE);

//        //注册打印机状态接收器
//        IntentFilter printerStatusFilter = new IntentFilter();
//        printerStatusFilter.addAction(PRINTER_NORMAL_ACTION);
//        printerStatusFilter.addAction(PRINTER_PAPERLESS_ACTION);
//        printerStatusFilter.addAction(PRINTER_PAPEREXISTS_ACTION);
//        printerStatusFilter.addAction(PRINTER_THP_HIGHTEMP_ACTION);
//        printerStatusFilter.addAction(PRINTER_THP_NORMALTEMP_ACTION);
//        printerStatusFilter.addAction(PRINTER_MOTOR_HIGHTEMP_ACTION);
//        printerStatusFilter.addAction(PRINTER_BUSY_ACTION);
//
//        registerReceiver(IPosPrinterStatusListener,printerStatusFilter);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler(
                (methodCall, result) -> {
                    if (methodCall.method.equals(METHOD))
                    {
                        String initialDate = methodCall.argument(p_initialDate);
                        String datePlaced = methodCall.argument(p_processedDate);

                        String ticketNumber = methodCall.argument(p_ticketNumber);
                        String betNumber = methodCall.argument(p_betNumber);
                        String stallName = methodCall.argument(p_stallName);
                        String drawSched = methodCall.argument(p_drawSchedule);
                        String betAmount = methodCall.argument(p_betAmount);
                        String priceAmount = methodCall.argument(p_priceAmount);

                        if (ticketNumber != null && betNumber != null && stallName != null && drawSched != null && betAmount != null && priceAmount != null) {
                            printReceipt(initialDate, datePlaced, ticketNumber, betNumber, stallName, drawSched, betAmount, priceAmount);
                            result.success("printing");
                        } else {
                            result.error("UNAVAILABLE", "Error fetching data.", null);
                        }
                    }
                }
        );
    }

    @Override
    protected void onDestroy()
    {
//        Log.d(TAG, "activity onDestroy");
        super.onDestroy();
//        unregisterReceiver(IPosPrinterStatusListener);
        unbindService(connectService);
//        handler.removeCallbacksAndMessages(null);
    }



    private ServiceConnection connectService = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mIPosPrinterService = IPosPrinterService.Stub.asInterface(service);
//            setButtonEnable(true);
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            mIPosPrinterService = null;
        }
    };

    private String sendString(){
        String stringToSend = "Hello from Kotlin";
        return stringToSend;
    }

    private void printReceipt(String initialDate,String datePlaced, String ticketNumber, String betNumber, String stallName, String drawSched, String betAmount, String priceAmount){
        ThreadPoolManager.getInstance().executeTask(() -> {
            try {
                //font size: 16,24,32,48
//                    mIPosPrinterService.printSpecifiedTypeText(PrintContentsExamples.KambasFormat(""), "ST", 32, callback);

                mIPosPrinterService.setPrinterPrintAlignment(1,callback);
                mIPosPrinterService.printSpecifiedTypeText("Bem-vindo " + initialDate, "ST", 24, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);

                mIPosPrinterService.printQRCode(ticketNumber, 10, 1, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);

                mIPosPrinterService.printSpecifiedTypeText("Bilhete nº. " + ticketNumber, "ST", 32, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printSpecifiedTypeText("Apostar - " + betNumber, "ST", 32, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printSpecifiedTypeText("Processado " + datePlaced, "ST", 24, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printSpecifiedTypeText("Posto - " + stallName, "ST", 24, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printSpecifiedTypeText("Horário do sorteio - " + drawSched, "ST", 24, callback);

                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printSpecifiedTypeText("Aposta feita de " + betAmount + " kza", "ST", 24, callback);
                mIPosPrinterService.printBlankLines(1, 16, callback);
                mIPosPrinterService.printSpecifiedTypeText("Ganhas Possíveis - " + priceAmount + " kza", "ST", 24, callback);

                mIPosPrinterService.printerPerformPrint(160,  callback);
            }catch (RemoteException e){
                e.printStackTrace();
            }
        });
    }


    public void printerInit(){
        ThreadPoolManager.getInstance().executeTask(new Runnable() {
            @Override
            public void run() {
                try{
                    mIPosPrinterService.printerInit(callback);
                }catch (RemoteException e){
                    e.printStackTrace();
                }
            }
        });
    }

//    public void loopPrint(int flag)
//    {
//        switch (flag)
//        {
//            case MULTI_THREAD_LOOP_PRINT:
//                multiThreadLoopPrint();
//                break;
//            case DEMO_LOOP_PRINT:
//                demoLoopPrint();
//                break;
//            case INPUT_CONTENT_LOOP_PRINT:
//                bigDataPrintTest(127, loopContent);
//                break;
//            case PRINT_DRIVER_ERROR_TEST:
//                printDriverTest();
//                break;
//            default:
//                break;
//        }
//    }

    public int getPrinterStatus(){

        Log.i(CHANNEL,"***** printerStatus"+printerStatus);
        try{
            printerStatus = mIPosPrinterService.getPrinterStatus();
        }catch (RemoteException e){
            e.printStackTrace();
        }
        Log.i(CHANNEL,"#### printerStatus"+printerStatus);
        return  printerStatus;
    }

    public void printBitmap()
    {
        ThreadPoolManager.getInstance().executeTask(new Runnable() {
            @Override
            public void run() {
                Bitmap mBitmap = BitmapFactory.decodeResource(getResources(), R.mipmap.test);
                try{
                    mIPosPrinterService.printBitmap(0, 4, mBitmap, callback);
                    mIPosPrinterService.printBlankLines(1, 10, callback);

                    mIPosPrinterService.printBitmap(1, 6, mBitmap, callback);
                    mIPosPrinterService.printBlankLines(1, 10, callback);

                    mIPosPrinterService.printBitmap(2, 8, mBitmap, callback);
                    mIPosPrinterService.printBlankLines(1, 10, callback);

                    mIPosPrinterService.printBitmap(2, 10, mBitmap, callback);
                    mIPosPrinterService.printBlankLines(1, 10, callback);

                    mIPosPrinterService.printBitmap(1, 12, mBitmap, callback);
                    mIPosPrinterService.printBlankLines(1, 10, callback);

                    mIPosPrinterService.printBitmap(0, 14, mBitmap, callback);
                    mIPosPrinterService.printBlankLines(1, 10, callback);

                    mIPosPrinterService.printerPerformPrint(160,  callback);
                }catch (RemoteException e){
                    e.printStackTrace();
                }
            }
        });
    }

    public void printText()
    {
        ThreadPoolManager.getInstance().executeTask(new Runnable() {
            @Override
            public void run() {
//                Bitmap mBitmap = BitmapFactory.decodeResource(getResources(), R.mipmap.test);
                try {
                    mIPosPrinterService.printSpecifiedTypeText("    Kambas POS\n", "ST", 48, callback);
                    mIPosPrinterService.printSpecifiedTypeText("    Sample\n", "ST", 32, callback);
                    mIPosPrinterService.printBlankLines(1, 8, callback);
                    mIPosPrinterService.printSpecifiedTypeText("#POS POS ipos POS POS POS POS ipos POS POS ipos#\n", "ST", 16, callback);
                    mIPosPrinterService.printBlankLines(1, 16, callback);
//                    mIPosPrinterService.printBitmap(1, 12, mBitmap, callback);
                    mIPosPrinterService.printBlankLines(1, 16, callback);
                    mIPosPrinterService.printSpecifiedTypeText("********************************", "ST", 24, callback);
                    mIPosPrinterService.printSpecifiedTypeText("ABCDEFGHIJKLMNOPQRSTUVWXYZ01234\n", "ST", 16, callback);
                    mIPosPrinterService.printSpecifiedTypeText("abcdefghijklmnopqrstuvwxyz56789\n", "ST", 24, callback);
                    mIPosPrinterService.printSpecifiedTypeText("κρχκμνκλρκνκνμρτυφ\n", "ST", 24, callback);
                    mIPosPrinterService.printBlankLines(1, 16, callback);
                    mIPosPrinterService.printBlankLines(1, 16, callback);
                    mIPosPrinterService.PrintSpecFormatText("Kambas POS\n", "ST", 32, 1, callback);
                    mIPosPrinterService.printSpecifiedTypeText("**********END***********\n\n", "ST", 32, callback);
//                    bitmapRecycle(mBitmap);
                    mIPosPrinterService.printerPerformPrint(160,  callback);
                }catch (RemoteException e){
                    e.printStackTrace();
                }
            }
        });
    }

    public void printQRCode()
    {
        ThreadPoolManager.getInstance().executeTask(new Runnable() {
            @Override
            public void run() {
                try {
                    mIPosPrinterService.setPrinterPrintAlignment(0, callback);
                    mIPosPrinterService.printQRCode("sample1234563271237312797123\n", 2, 1, callback);
                    mIPosPrinterService.printBlankLines(1, 15, callback);

                    mIPosPrinterService.setPrinterPrintAlignment(1, callback);
                    mIPosPrinterService.printQRCode("ok\n", 3, 0, callback);
                    mIPosPrinterService.printBlankLines(1, 15, callback);

                    mIPosPrinterService.setPrinterPrintAlignment(2, callback);
                    mIPosPrinterService.printQRCode("wew\n", 4, 2, callback);
                    mIPosPrinterService.printBlankLines(1, 15, callback);

                    mIPosPrinterService.setPrinterPrintAlignment(0, callback);
                    mIPosPrinterService.printQRCode("123123\n", 5, 3, callback);
                    mIPosPrinterService.printBlankLines(1, 15, callback);

                    mIPosPrinterService.setPrinterPrintAlignment(1, callback);
                    mIPosPrinterService.printQRCode("######\n", 6, 2, callback);
                    mIPosPrinterService.printBlankLines(1, 15, callback);

                    mIPosPrinterService.setPrinterPrintAlignment(2, callback);
                    mIPosPrinterService.printQRCode("http://www.baidu.com\n", 7, 1, callback);
                    mIPosPrinterService.printBlankLines(1, 15, callback);

                    mIPosPrinterService.printerPerformPrint(160,  callback);
                }catch (RemoteException e){
                    e.printStackTrace();
                }
            }
        });
    }


}