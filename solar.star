load("render.star", "render")
load("http.star","http")
load("html.star","html")

DATALOGGER_URL = "http://192.168.1.146/status.html"
NOW = 'var webdata_now_p = "'
TODAY = 'var webdata_today_e = "'

def main():
    rep = http.get(DATALOGGER_URL,auth=('admin','admin'))
    if rep.status_code!=200:
        fail("Data Logger fail %d",rep.status_code)
    
    doc = html(rep.body())

    script = doc.find('script')

    start = script.text().find(NOW) + len(NOW)
    end = script.text().find('"',start)
    now_txt = script.text()[start:end]

    start = script.text().find(TODAY) + len(TODAY)
    end = script.text().find('"',start)
    today_txt = script.text()[start:end]

    return render.Root(
        child = render.Column(
            children = [
                render.Text("Solar Power",color="#880"),
                render.Text("Now: %sW" % now_txt),
                render.Text("Today: %skWh" % today_txt),
            ]
        )
    )

#var webdata_total_e = "221.0";