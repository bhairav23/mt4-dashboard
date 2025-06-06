#property strict

input string UserFileName = "Cryptotic"; // Only show this to user
input int IntervalSeconds = 1;
input int RSI_Period = 14;
input int RSI_Timeframe = 0;  // 0 = current chart TF

int OnInit() {
   EventSetTimer(IntervalSeconds);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
   EventKillTimer();
}

void OnTimer() {
   datetime now = TimeCurrent();
   WriteDataToFile(now);
}

string FormatWithCommas(double number, int digits = 2) {
   string formatted = DoubleToString(number, digits);
   int dotPos = StringFind(formatted, ".");
   string intPart = StringSubstr(formatted, 0, dotPos);
   string decPart = StringSubstr(formatted, dotPos);
   string result = "";
   int len = StringLen(intPart);
   int count = 0;
   for (int i = len - 1; i >= 0; i--) {
      result = StringSubstr(intPart, i, 1) + result;
      count++;
      if (count % 3 == 0 && i != 0) result = "," + result;
   }
   return result + decPart;
}

string FormatTimestamp(datetime dt) {
   string ts = TimeToString(dt, TIME_DATE | TIME_MINUTES | TIME_SECONDS);
   string date = StringSubstr(ts, 0, 4) + StringSubstr(ts, 5, 2) + StringSubstr(ts, 8, 2);
   string time = StringSubstr(ts, 11, 8);
   return date + ":" + time;
}

void WriteDataToFile(datetime now) {
   string timestamp = FormatTimestamp(now);
   double bid = MarketInfo(Symbol(), MODE_BID);
   double ask = MarketInfo(Symbol(), MODE_ASK);
   double rsi = iRSI(Symbol(), RSI_Timeframe, RSI_Period, PRICE_CLOSE, 0);

   double dailyHigh = MarketInfo(Symbol(), MODE_HIGH);
   double dailyLow = MarketInfo(Symbol(), MODE_LOW);
   double distanceFromHigh = MathAbs(bid - dailyHigh);
   double distanceFromLow = MathAbs(bid - dailyLow);
   double pipMultiplier = (Digits == 3 || Digits == 5) ? 10 : 1;
   int distanceInPips = (int)(MathMax(distanceFromHigh, distanceFromLow) / Point / pipMultiplier);

   double totalBuyLots = 0, totalSellLots = 0;
   int totalBuyOrders = 0, totalSellOrders = 0;
   double floatingPnL = 0;

   for (int i = 0; i < OrdersTotal(); i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderType() == OP_BUY) {
            totalBuyOrders++;
            totalBuyLots += OrderLots();
            floatingPnL += OrderProfit() + OrderSwap() + OrderCommission();
         }
         if (OrderType() == OP_SELL) {
            totalSellOrders++;
            totalSellLots += OrderLots();
            floatingPnL += OrderProfit() + OrderSwap() + OrderCommission();
         }
      }
   }

   string json = "{";
   json += "\"timestamp\": \"" + timestamp + "\",";
   json += "\"account_id\": \"" + IntegerToString(AccountNumber()) + "\",";
   json += "\"symbol\": \"" + Symbol() + "\",";
   json += "\"bid\": " + DoubleToString(bid, Digits) + ",";
   json += "\"ask\": " + DoubleToString(ask, Digits) + ",";
   json += "\"rsi\": " + DoubleToString(rsi, 2) + ",";
   json += "\"distance_from_extreme\": " + IntegerToString(distanceInPips) + ",";
   json += "\"balance\": \"" + FormatWithCommas(AccountBalance(), 2) + "\",";
   json += "\"equity\": \"" + FormatWithCommas(AccountEquity(), 2) + "\",";
   json += "\"floating_pnl\": " + DoubleToString(floatingPnL, 2) + ",";
   json += "\"buy_orders\": " + totalBuyOrders + ",";
   json += "\"sell_orders\": " + totalSellOrders + ",";
   json += "\"buy_lots\": " + DoubleToString(totalBuyLots, 2) + ",";
   json += "\"sell_lots\": " + DoubleToString(totalSellLots, 2);
   json += "}";

   string fullFileName = UserFileName + ".json";
   int handle = FileOpen(fullFileName, FILE_WRITE | FILE_TXT | FILE_ANSI | FILE_READ);
   if (handle == INVALID_HANDLE) {
      handle = FileOpen(fullFileName, FILE_WRITE | FILE_TXT | FILE_ANSI);
   } else {
      FileSeek(handle, 0, SEEK_END);
   }

   if (handle != INVALID_HANDLE) {
      FileWrite(handle, json);
      FileClose(handle);
      Print("Wrote data to file: ", fullFileName);
   } else {
      Print("Error writing account data: ", GetLastError());
   }
}
