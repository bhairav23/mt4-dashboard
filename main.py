from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
import json
import os

app = FastAPI()
templates = Jinja2Templates(directory="templates")

# Full paths to your JSON files from multiple MT4 terminals
FILES = [
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\5D49F47D1EA1ECFC0DDC965B6D100AC5\MQL4\Files\EURUSDNR.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\6D8ED79B81D9D70041DDDF6786110ECE\MQL4\Files\EURUSDSS.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\704444BB97FFEAFF0FAD48FB79A73215\MQL4\Files\EURUSDHT.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\76F5A6AB6C9C072B94A014923F71D84B\MQL4\Files\EURUSDHG.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\349660BDC5434569AF7F02E030543070\MQL4\Files\EURUSDAG.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E12F3A14E347150B250E1402A9152A0F\MQL4\Files\GBPUSDNR.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\3180B5E116E0F562B6C7D5D65BE86282\MQL4\Files\GBPUSDSS.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\177D69421667C0D054D717B4BA1179DF\MQL4\Files\GBPUSDHT.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\8FC18F4CDCD4D41BB8774202824CB7B8\MQL4\Files\GBPUSDHG.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\5C4FC43F43DE4E49F5AB4ECD5B2988AC\MQL4\Files\USDJPYNR.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\7E3397ECF4F42954AC1976AD5CF50931\MQL4\Files\USDJPYSS.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\11D0BEBBEAA63FB82CB4040F79DEE8B3\MQL4\Files\USDJPYHT.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\55C1A8D08858E57EA6A080170A23C6D1\MQL4\Files\USDJPYHG.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\B686031306FA71A7EDC549C88C8E2CE7\MQL4\Files\USDCHFNR.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\BCDF3193997AF4A518724582ACF4E5D3\MQL4\Files\USDCHFSS.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\B686031306FA71A7EDC549C88C8E2CE7\MQL4\Files\AUDUSDNR.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\967EEDCA58CB61A2CE8359388E4C4EFB\MQL4\Files\AUDUSDSS.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\B686031306FA71A7EDC549C88C8E2CE7\MQL4\Files\USDCADNR.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\3445BE35A936A2EBEFE763C98ACCD25B\MQL4\Files\USDCADSS.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\B686031306FA71A7EDC549C88C8E2CE7\MQL4\Files\NZDUSDNR.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\A9819A759F3A19AA674A4E0383D4E24D\MQL4\Files\NZDUSDSS.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\A26EE4CBF3F654FE4025023D7A5FE743\MQL4\Files\Cryptoknight.json",
    r"C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\6A2F409B1AE6CC37A50A53CBBD33ED97\MQL4\Files\Cryptotic.json"
]

# Friendly display names for file labels
FRIENDLY_NAMES = {
"EURUSDNR.json": "EURUSD NR",
"EURUSDSS.json": "EURUSD SS",
"EURUSDHT.json": "EURUSD HT",
"EURUSDHG.json": "EURUSD HG",
"EURUSDAG.json": "EURUSD AG",
"GBPUSDNR.json": "GBPUSD NR",
"GBPUSDSS.json": "GBPUSD SS",
"GBPUSDHT.json": "GBPUSD HT",
"GBPUSDHG.json": "GBPUSD HG",
"USDJPYNR.json": "USDJPY NR",
"USDJPYSS.json": "USDJPY SS",
"USDJPYHT.json": "USDJPY HT",
"USDJPYHG.json": "USDJPY HG",
"USDCHFNR.json": "USDCHF NR",
"USDCHFSS.json": "USDCHF SS",
"AUDUSDNR.json": "AUDUSD NR",
"AUDUSDSS.json": "AUDUSD SS",
"USDCADNR.json": "USDCAD NR",
"USDCADSS.json": "USDCAD SS",
"NZDUSDNR.json": "NZDUSD NR",
"NZDUSDSS.json": "NZDUSD SS",
"Cryptoknight.json": "CryptoKnight",
"Cryptotic.json": "Cryptotic"
}

def read_latest_json(full_path):
    if not os.path.exists(full_path):
        return None
    with open(full_path, "r") as f:
        lines = f.readlines()
        if not lines:
            return None
        try:
            data = json.loads(lines[-1])

            # 🛡️ Set defaults for missing fields
            data.setdefault("label", FRIENDLY_NAMES.get(os.path.basename(full_path), "Unknown"))
            data.setdefault("timestamp", "N/A")
            data.setdefault("symbol", "N/A")
            data.setdefault("bid", "N/A")
            data.setdefault("ask", "N/A")
            data.setdefault("balance", "N/A")
            data.setdefault("equity", "N/A")
            data.setdefault("floating_pnl", "N/A")
            data.setdefault("rsi", None)
            data.setdefault("distance_from_extreme", None)
            data.setdefault("buy_orders", "N/A")
            data.setdefault("sell_orders", "N/A")
            data.setdefault("buy_lots", "N/A")
            data.setdefault("sell_lots", "N/A")

            return data
        except Exception as e:
            print(f"Error parsing {full_path}: {e}")
            return None

@app.get("/", response_class=HTMLResponse)
async def dashboard(request: Request):
    accounts = []
    for path in FILES:
        data = read_latest_json(path)
        if data:
            accounts.append(data)
    return templates.TemplateResponse("dashboard.html", {"request": request, "accounts": accounts})

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)


