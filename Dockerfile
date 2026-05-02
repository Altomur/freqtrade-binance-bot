FROM freqtradeorg/freqtrade:stable

# Copy strategy and config into the image
COPY user_data/strategies/ /freqtrade/user_data/strategies/
COPY user_data/config.json /freqtrade/user_data/config.json

# Railway injects PORT env var - freqtrade REST API listens on 8080 by default
EXPOSE 8080

CMD ["trade", \
     "--logfile", "/freqtrade/user_data/logs/freqtrade.log", \
     "--db-url", "sqlite:////freqtrade/user_data/tradesv3.sqlite", \
     "--config", "/freqtrade/user_data/config.json", \
     "--strategy", "EMA_RSI_Strategy"]
