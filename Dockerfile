FROM python:2
WORKDIR /app

COPY ./ .  
RUN apt-get -q update && apt-get install -y --no-install-recommends gdal-bin postgis && apt-get clean
RUN pip install -r requirements.txt
VOLUME /data
VOLUME /logs
ENTRYPOINT [ "python", "-m", "Osmify" ]
