package com.iposprinter.iposprinterservice;

interface IPosPrinterCallback {

	oneway void onRunResult(boolean isSuccess);

	oneway void onReturnString(String result);
}
